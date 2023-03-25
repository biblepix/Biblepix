# ~/TkOffice/prog/tkoffice-invoice.tcl
# called by tkoffice-gui.tcl
# Salvaged: 2nov17
# Updated for use with SQLite: 9sep22
# Updated 25mch23

source $confFile
################################################################################################################
################# N E W   I N V O I C E   P R O C S ############################################################
################################################################################################################

set dataFile [file join $texDir invdata.tex]
set itemFile [file join $texDir invitems.tex]
 
# resetNewInvDialog
##called by Main + "Abbruch Rechnung"
proc resetNewInvDialog {} {
  global heute cond1
  
  #Cleanup
  catch {namespace delete rows}
  foreach w [winfo children .newInvoiceF] {
    destroy $w
  }

  #Set vars to 0
  namespace eval rows {
    set bill 0
    set buch 0
    set auslage 0
  }
  
  updateArticleList
  #TODO anpassen
#  .invartnumSB invoke buttondown
  
  #Configure message labels & pack
  .subtotalM conf -textvar rows::bill
  .abzugM conf -textvar rows::auslage
  .totalM conf -textvar rows::buch
  pack .subtotalL .subtotalM .abzugL .abzugM .totalL .totalM -side left -in .n.t2.bottomF

  #create Addrow button w/dynamic width - funzt mit '-expand 1' bestens!
  catch {button .addrowB}
  .addrowB conf -text "Posten hinzufügen" -command {addInvRow}
  catch {message .einheit -textvariable unit}
  catch {message .einzel -textvariable einzel}

  pack .invcondL .invcondSB .invauftrdatL .invauftrdatE .invrefL .invrefE .invcomL .invcomE -in .n.t2.f1 -side left -fill x 
  #Empty entry widgets
  .invrefE delete 0 end
  .invcomE delete 0 end
  .invcomE delete 0 end
  
  #Set back global vars
  set ::cond $cond1
  set ::auftrDat $heute
 
  pack .invartlistMB -in .n.t2.f1 -before .n.t2.f2 -anchor w -padx 20 -pady 5 
 
 #TODO anpassen
 # pack .invartnumSB .mengeE .invartunitL .invartnameL .invartpriceL -in .n.t2.f2 -side left -fill x
pack .mengeE .invartunitL .invartnameL .invartpriceL -in .n.t2.f2 -side left -fill x
  pack .addrowB -in .n.t2.f2 -side right -expand 1 -fill x
  
  #Reset Buttons
##TODO testing
#  .abbruchinvB conf -state disabled
 # .abbruchinvB conf -activebackground red -state normal
  .invSaveBtn conf -state disabled -command "
    .invSaveBtn conf -activebackground #ececec -state normal
    doSaveInv
  "
} ;#END resetNewInvDialog

# addInvRow
##called by setupNewInvDialog
proc addInvRow {} {
  
  #Exit if menge empty
  set menge [.mengeE get]
  if {$menge == ""} {
    NewsHandler::QueryNews "Bitte Menge eingeben!" red
    .mengeE conf -bg red
    focus .mengeE
    after 7000 {.mengeE conf -bg beige}
    return 1
  }

  #Configure Abbruch button
  pack .invCancelBtn .invSaveBtn -in .n.t2.bottomF -side right
  .invSaveBtn conf -activebackground skyblue -state normal
  .invCancelBtn conf -activebackground red -state normal -command {resetNewInvDialog}


  ##get last namespace no.
  if [catch {namespace children rows}] {
    set lastrow 0
  }  else {
    set lastrow [namespace tail [lindex [namespace children rows] end]]
  }

  ##add new namespace no.
  namespace eval rows {
    variable rowtot
    variable rabatt
    set rowNo [incr lastrow 1]

    # new row namespace
    namespace eval $rowNo  {

      set artName [.invartnameL cget -text]
      set menge [.mengeE get]
      set artPrice [.invartpriceL cget -text]
      set artUnit [.invartunitL cget -text]
      set artType [.invarttypeL cget -text]
      
      set rowNo $::rows::rowNo
      set rowtot [expr $menge * $artPrice]

      #Create row frame
#      catch {frame .newInvoiceF}
      set F [frame .newInvoiceF.invF${rowNo}]
      pack $F -fill x -anchor w    

      #Create labels per row
      catch {label $F.mengeL -text $menge -bg lightblue -width 20 -justify left -anchor w}
      catch {label $F.artnameL -text $artName -bg lightblue -width 53 -justify left -anchor w}
      catch {label $F.artpriceL -text $artPrice -bg lightblue -width 10 -justify right -anchor w}
      catch {label $F.artunitL -text $artUnit -bg lightblue -width 5 -justify left -anchor w}
      catch {label $F.arttypeL -text $artType -bg lightblue -width 20 -justify right -anchor e}
      catch {label $F.rowtotL -text $rowtot -bg lightblue  -width 50 -justify left -anchor w}
      #Get current values from GUI
      set bill $rows::bill
      set buch $rows::buch
      set auslage $rows::auslage

      # H a n d l e   t y p e s
              
      #Exit if rebate doubled
      if {$artType == "R" && [info exists ::rows::rabatt]} {
        NewsHandler::QueryNews "Nur 1 Rabatt zulässig" red
        namespace delete [namespace current]
        return 1
      }
       
      ##a) Type normal     
      if {$artType == ""} {
      
        ##deduce any existing rabattProzent from rowtot
        if [info exists ::rows::rabattProzent] {
          
          set rabattProzent $::rows::rabattProzent

          #compute this row's rebate
          set bill [expr $bill + $rowtot]
          set newrabatt [expr ($rabattProzent * $rowtot) / 100]
          set oldrabatt $::rows::rabatt

          #update global rebate
          #TODO zis isnt working yet!
          set ::rows::rabatt [expr $oldrabatt + $newrabatt]
          set ::rows::bill [expr $bill + $rowtot - $newrabatt]
          set ::rows::buch [expr $bill + $rowtot - $newrabatt]
         
        } else {
        
          set ::rows::bill [expr $bill + $rowtot]
          set ::rows::buch [expr $buch + $rowtot]
        }
        
      ##b) Type is "Rabatt" - compute from $buch (abzgl. Spesen)
      } elseif {$artType == "R"} {
        
        $F.artnameL conf -text "abzüglich $artName"
        $F.artpriceL conf -bg yellow -textvar ::rows::rabatt

        set ::rows::rabattProzent $artPrice
      
        set rabatt [expr ($buch * $artPrice / 100)]
        set ::rows::buch [expr $buch - $rabatt]
        set ::rows::bill [expr $bill - $rabatt]

        set ::rows::rabatt $rabatt

        $F.arttypeL conf -bg yellow
        .mengeE conf -state disabled
        set menge 1
      
                  
      ##c) "Auslage" types - add to $bill, not to $buch     
      } elseif {$artType == "A"} {
        
          set ::rows::auslage [expr $auslage + $rowtot]
          set ::rows::bill [expr $bill + $rowtot]
          set ::rows::buch [expr $bill - $auslage]
          $F.arttypeL conf -bg orange
          $F.rowtotL conf -bg orange
      }

      pack $F.artnameL $F.artpriceL $F.mengeL -anchor w -fill x -side left
      pack $F.artunitL $F.rowtotL $F.arttypeL -anchor w -fill x -side left

      #Reduce amounts to 2 decimal points -TODO better use
      set ::rows::bill [expr {double(round(100*$rows::bill))/100}]
      set ::rows::buch [expr {double(round(100*$rows::buch))/100}]
      if [info exists ::rows::rabatt] {
        set ::rows::rabatt [expr {double(round(100*$rows::rabatt))/100}]
      }
  
      #Export beschr cumulatively for use in saveInv2DB & fillAdrInvWin
      set separator {}
      if [info exists ::rows::beschr] {
        set separator { /}
      }
      append ::rows::beschr $separator ${menge} { } $artName
    }
  }
} ;#END addInvRow

# doSaveInv
##coordinates invoice saving + printing progs
##evaluates exit codes
##called by .saveinvB button
proc doSaveInv {} {
  
  #1.Save to DB
  if [catch saveInv2DB res] {
    NewsHandler::QueryNews $res red
    return 1
  } 
  
  #2. LatexInvoice -NOTE: invNo put into ::Latex by saveInv2DB
	catch {latexInvoice $::Latex::invNo}
  
  return 0

} ;#END doSaveInv

# saveInv2DB
##saves new invoice to DB
##called by doSaveInv
proc saveInv2DB {} {
  global db env msg texDir itemFile
  global cond ref comm auftrDat vat
  set adrNo [.adrSB get]

  #1. Get invNo & export to ::Latex 
	set invNo [createNewNumber invoice]
	namespace eval Latex {}
	set ::Latex::invNo $invNo
	
	#Get current vars from GUI
  set shortAdr "$::name1 $::name2, $::city"
  set shortDesc $rows::beschr
 # set subtot $rows::buch
  set invTotal $rows::bill
  set auslage $rows::auslage
    
  #Create itemList for itemFile (needed for LaTeX)
  foreach rowNo [namespace children rows] {
    set rowNo [namespace tail $rowNo]
    set F .newInvoiceF.invF${rowNo}
    
    set artUnit [$F.artunitL cget -text]
    set artPrice [$F.artpriceL cget -text]
    set artType [$F.arttypeL cget -text]
    set artName [$F.artnameL cget -text]
    set menge [$F.mengeL cget -text]
    #Check if Discount
    if {$artType==""} {
      append itemList \\Fee\{ $artName { } \( pro { } $artUnit \) \} \{ $artPrice \} \{ $menge \} \n
    } elseif {$artType=="R"} {
      append itemList \\Discount\{ $artName \} \{ $rows::rabatt \} \n
    #Check if Auslage
    } elseif {$artType=="A"} {
      append itemList \\EBC\{ $artName \} \{ $artPrice \} \n
    }
    
  } ;#END foreach w

  #1. Save itemList to ItemFile & convert to Hex for DB
  set chan [open $itemFile w]
  puts $chan $itemList
  close $chan
  set itemListHex [binary encode hex $itemList]

  #2. Set payedsum=finalsum and ts=3 if cond="bar"
	if {$cond=="bar"} {
    set ts 3
    set payedsum $invTotal
  } else {
    set ts 1
    set payedsum 0
  }	

  #3. Make entry for vatlesssum if different from finalsum
  set vatlesssum $invTotal
  if {$vat < 0} {
    set vatlesssum [expr ($vat * $finalsum)/100]
  }

	#3. reformat auftrDat for DB date function
	set rawdate [clock scan "$auftrDat" -format "%d.%m.%Y"]
	set dbdate  [clock format $rawdate  -format "%Y-%m-%d"]
	
  #4. Save new invoice to DB
  set token [db eval "INSERT INTO invoice 
    (
    objectid,
    ts,
    customeroid, 
    addressheader, 
    shortdescription, 
    finalsum, 
    payedsum,
    vatlesssum,
    auslage,
    f_number,
    f_date,
    f_comment,
    ref,
    cond,
    items
    ) 
  VALUES 
    (
    $invNo,
    $ts,
    $adrNo,
    '$shortAdr',
    '$shortDesc',
    $invTotal,
    $payedsum,
    $vatlesssum,
    $auslage,
    $invNo,
    date('$dbdate'),
    '$comm',
    '$ref',
    '$cond',
    '$itemListHex'
    )"]
  
#TODO does this belong here?
  if [db errorcode] {
  
  #TODO how to get error message from SQLite?????????????????
    #NewsHandler::QueryNews "[mc invNotsaved $invNo]:\n[pg_result $token -error ]" red
     NewsHandler::QueryNews "[mc invNotsaved $invNo]:\n $token ]" red
     
    return 1
  
  } else {
   	NewsHandler::QueryNews "[mc invSaved $invNo]" green
    fillAdrInvWin $adrNo
    .invSaveBtn conf -text [mc printInv] -command "printInvoice $invNo" -bg orange

    return 0
  } 

} ;#END saveInv2DB



# clearAdrInvWin
##called by fillAdrInvWin & newAddress
proc clearAdrInvWin {} {
	global invF
  set slaveList [pack slaves $invF]
  foreach  w $slaveList {
    foreach w [pack slaves $w] {
      pack forget $w
    }
  }
}

# fillAdrInvWin
##called by .adrSB 
##Note: ts=customerOID in 'address', now identical with objectid,needed for identification with 'invoice'
proc fillAdrInvWin {adrId} {
  global invF db

  #Delete previous frames
  clearAdrInvWin
  
  #Clear old window+namespace
  if [namespace exists verbucht] {
    namespace delete verbucht
  }

  #Add new namespace no.
  namespace eval verbucht {

    createPrintBitmap
    ##set ::verbucht vars to manipulate header visibility
    set eingabe 0
    set anzeige 0

    set adrId [.adrSB get]
    set custId [db eval "SELECT ts FROM address WHERE objectid = $adrId"]

    set invNoT [db eval "SELECT f_number FROM invoice WHERE customeroid = $custId"]
    set nTuples [llength $invNoT]

  	#exit if no invoices found
  	if {$nTuples == -1} {return 1}

		#NOTE: these are no more tokens, but single items or lists! 
    set invDatT   [db eval "SELECT f_date FROM invoice WHERE customeroid = $custId"]
	  set beschrT   [db eval "SELECT shortdescription FROM invoice WHERE customeroid = $custId"]
	  set sumtotalT [db eval "SELECT finalsum FROM invoice WHERE customeroid = $custId"]
	  set payedsumT [db eval "SELECT payedsum FROM invoice WHERE customeroid = $custId"]
	  set statusT   [db eval "SELECT ts FROM invoice WHERE customeroid = $custId"]	
    set itemsT    [db eval "SELECT items FROM invoice WHERE items IS NOT NULL AND customeroid = $custId"]
    set commT     [db eval "SELECT f_comment FROM invoice WHERE customeroid = $custId"]
    set auslageT  [db eval "SELECT auslage FROM invoice WHERE customeroid = $custId"]

    #Show client turnover, including 'auslagen'
    set umsatzL [db eval "SELECT sum(finalsum),sum(auslage) AS total from invoice WHERE customeroid = $custId"]
    set verbucht [lindex $umsatzL 0]
    set auslage [lindex $umsatzL 1]
    if {![string is double $auslage] || $auslage == ""} {
      set auslage 0.00
    }
    set ::umsatz [roundDecimal [expr $verbucht + $auslage]]
        
        #set modulo initial vars
        set wechselfarbe #d9d9d9
        set normal $wechselfarbe

    #Create row per invoice
    for {set n 0} {$n<$nTuples} {incr n} {
    
      namespace eval $n {

        set n [namespace tail [namespace current]]
        set invF $::invF
        
        #compute Rechnungsbetrag from sumtotal+auslage
			  set sumtotal [lindex $::verbucht::sumtotalT $n]
			  set auslage [lindex $::verbucht::auslageT $n]

			  if {[string is double $auslage] && $auslage >0} {
  			  set invTotal [expr $sumtotal + $auslage]
			  } else {
			    set invTotal $sumtotal
			  } 
			  
			  set ts [lindex $::verbucht::statusT $n]
			  set invNo [lindex $::verbucht::invNoT $n]
        set invdat [lindex $::verbucht::invDatT $n]
			  set beschr [lindex $::verbucht::beschrT $n]
        set comment [lindex $::verbucht::commT $n]

			  #increase but don't overwrite frames per line	
			  catch {frame $invF.$n}
			  pack $invF.$n -anchor nw -side top -fill x -expand 0

    		#create entries per line, or refill present entries
			  catch {label $invF.$n.invNoL -width 10 -anchor w}
			  $invF.$n.invNoL conf -text $invNo
        catch {label $invF.$n.invDatL -width 15 -anchor w -justify left}
        $invF.$n.invDatL conf -text $invdat
			  catch {label $invF.$n.beschr -width 50 -justify left -anchor w}
			  $invF.$n.beschr conf -text $beschr
			  catch {label $invF.$n.sumL -width 10 -justify right -anchor e}
			  $invF.$n.sumL conf -text $invTotal

        #create label/entry for Bezahlt, packed later
        set bezahlt [lindex $::verbucht::payedsumT $n]
        catch {label $invF.$n.payedL -width 13 -justify right -anchor e}
        $invF.$n.payedL conf -text $bezahlt

        ##create showInvoice button, to show up only if inv not empty
        #catch {button $invF.$n.invshowB}
        
        #create comment btn
			  catch {label $invF.$n.commM -width 50 -justify left -anchor w -padx 35}

			  if {$ts==3} {
			  
			    $invF.$n.payedL conf -fg green
				  $invF.$n.commM conf -fg grey -text $comment -textvar {}
          pack $invF.$n.invNoL $invF.$n.invDatL $invF.$n.beschr $invF.$n.sumL $invF.$n.payedL $invF.$n.commM -side left
			  
        #If 1 or 2 make entry widget
			  } else {
		  
          $invF.$n.payedL conf -fg red    
          catch {entry $invF.$n.zahlenE -bg beige -fg black -width 7 -justify left}
  
  #TODO was stimmt hier nicht?        
          $invF.$n.zahlenE conf -validate focusout -vcmd "savePaymentEntry %P %W $n"

			    set ::verbucht::eingabe 1
          set restbetrag "Restbetrag eingeben und mit Tab-Taste quittieren"
          set gesamtbetrag "Zahlbetrag eingeben und mit Tab-Taste quittieren"
          $invF.$n.commM conf -fg red -textvar gesamtbetrag
				  pack $invF.$n.invNoL $invF.$n.invDatL $invF.$n.beschr $invF.$n.sumL $invF.$n.payedL $invF.$n.zahlenE $invF.$n.commM -side left
        #if 2 (Teilzahlung) include payed amount
				  if {$ts==2} {

					  $invF.$n.commM conf -fg maroon -textvar restbetrag
					  $invF.$n.payedL conf -fg maroon
				  }
			  }

        #Create Show button if items not empty
        set itemsT $::verbucht::itemsT
        catch {set itemlist [lindex $itemsT $n] }
        
        
        
  #TODO change for SQLite! ??????????????????
   #     if {[pg_result $itemsT -error] == "" && [info exists itemlist]} {
          set ::verbucht::anzeige 1
          #$invF.$n.invshowB conf -width 40 -padx 40 -image $::verbucht::printBM -command "printDocument $invNo inv"
          #pack $invF.$n.invshowB -anchor e -side right
   #     }

			
        #Modulo: colour lines alternately if more than 5 lines
        if [expr $n % 2] {set wechselfarbe silver} {set wechselfarbe $normal}
        foreach w [winfo children $invF.$n] {$w conf -bg $wechselfarbe}
        
        #Bind invNo labels to highlighting on hover & command on double-click
			  bind $invF.$n.invNoL <Enter> "%W conf -bg lightblue"
			  bind $invF.$n.invNoL <Leave> "%W conf -bg $wechselfarbe"
			  bind $invF.$n.invNoL <Double-1> "printInvoice $invNo"
 		
  		} ;#END ns $n

    } ;#END for loop
 
    #Recolour lines to normal if only few
    if {$n < 5} {
      foreach f [winfo children $invF] {
        foreach w [winfo children $f] {
          $w conf -bg $normal
        }
      }
    }

    
    #TODO what's the gig now (see above) ;;;;;;;;;;;;;::::::::::::::::::::
    #what does the ::verbucht::anzeige var do????????????????????????????
    #if {$anzeige} {.invShowH conf -state normal} {.invShowH conf -state disabled -bg #d9d9d9}
    
  } ;#END ns verbucht

  set ::credit [updateCredit $adrId]
  
} ;#END fillAdrInvWin


# setInvPath
##composes invoice name from company short name & invoice number
##returns invoice path with required ending: TEX + PDF
##required types: tex / pdf / pdftmp
##called by printDocument
proc setInvPath {invNo type} {
  global spoolDir myComp vorlageTex tmpDir
  
  set compShortname [lindex $myComp 0]
  append invName invoice _ $compShortname - $invNo

  if {$type == "tex"} {
    append invTexName $invName . tex
    set invPath [file join $tmpDir $invTexName]
  
    file copy -force $vorlageTex $invPath
  
  } elseif {$type == "pdf" || $type == "pdftmp"} {
    
    append invPdfName $invName . pdf
    
    if {$type == "pdftmp"} {
	    set invPath [file join $tmpDir $invPdfName]
  	} elseif {$type == "pdf"} {  
    	set invPath [file join $spoolDir $invPdfName]
  	}
  
  }
  
  return $invPath

} ;#END setInvPath




# missing operand at _@_
#in expression "0.00 + _@_"
#missing operand at _@_
#in expression "0.00 + _@_"
#    (parsing expression "0.00 + ")
#    invoked from within
#"expr $oldPayedsum + $newPayedsum"
#    (procedure "savePaymentEntry" line 32)
#
# savePaymentEntry #TODO see error above!!!!
#passiert beim Eintreten/Austreten? wenn keine Zahl angegeben
##called by fillAdrInvWin by $invF.$n.zahlenE entry widget
proc savePaymentEntry {newPayedsum curEName ns} {
  global db invF
  set curNS "verbucht::${ns}"
  set rowNo [namespace tail $curNS]

	#1)get invoice details
  set invNo [$invF.$rowNo.invNoL cget -text]
  set newPayedsum [$curEName get]

  #avoid non-digit amounts
  if ![string is double $newPayedsum] {
    $curEName delete 0 end
    $curEName conf -validate focusout -vcmd "savePaymentEntry %P %W $ns"
    NewsHandler::QueryNews "Fehler: Konnte Zahlbetrag nicht speichern." red
    return 1
  }
  
  set invT [db eval "SELECT payedsum,finalsum,auslage,customeroid FROM invoice WHERE f_number=$invNo"]
  set oldPayedsum [lindex $invT 0]
  set buchungssumme [lindex $invT 1]
  set auslage [lindex $invT 2]
  set adrNo [lindex $invT 3]
  
  if {[string is double $auslage] && $auslage >0} {
    set finalsum [expr $buchungssumme + $auslage]
  } else {
    set finalsum $buchungssumme
  }
  
    
  #Compute total payedsum:
  set totalPayedsum [expr $oldPayedsum + $newPayedsum] 
  set newCredit [expr $totalPayedsum - $finalsum]
  
  #compute remaining credit + set status
  if {$newCredit >= 0} {
    set status 3
    
  } else {
    set status 2
#    set totalPayedsum ?
  }

#puts "OldCredit $oldCredit"
puts "NewCredit $newCredit"
puts "OldPS $oldPayedsum"
puts "NewPS $newPayedsum"
puts "status $status"
#puts "diff $diff"

	# S a v e  totalPayedsum  to 'invoice' 
  set token1 [db eval "UPDATE invoice 
    SET payedsum = $totalPayedsum, 
    ts = $status,
    payeddate = (SELECT date())
    WHERE f_number=$invNo
    "]

  #Update GUI    
  NewsHandler::QueryNews "Betrag CHF $newPayedsum verbucht" green

  ##delete OR reset zahlen entry
  if {$status == 3} {
    pack forget $curEName
 		$invF.$rowNo.payedL conf -text $totalPayedsum -fg green
    pack forget $invF.$rowNo.commM
    
  } else {
  
    $curEName delete 0 end
    $curEName conf -validate focusout -vcmd "savePaymentEntry %P %W $ns"
 		$invF.$rowNo.payedL conf -text $totalPayedsum -fg maroon
  }
    
  set ::credit [updateCredit $adrNo]
  NewsHandler::QueryNews "Das aktuelle Kundenguthaben beträgt $newCredit" green
  return 0
} ;#END savePaymentEntry

# updateCredit
##calculates total credit per customer
##called by fillAdrInvWin + ?savePaymentEntry
proc updateCredit {adrNo} {
  global db
  
  set invoicesT [db eval "SELECT 
    sum(finalsum),
    sum(payedsum),
    sum(auslage) AS total from invoice WHERE customeroid = $adrNo"
    ]
  
  set verbuchtTotal [lindex $invoicesT 0]
  set gezahltTotal  [lindex $invoicesT 1]
  set auslagenTotal [lindex $invoicesT 2]
  
  if {![string is double $verbuchtTotal]  || $auslagenTotal == ""} {
    set verbuchtTotal 0.00
  }
  if {![string is double $gezahltTotal]  || $auslagenTotal == ""} {
    set gezahltTotal 0.00
  }
  if {![string is double $auslagenTotal] || $auslagenTotal == ""} {
    set auslagenTotal 0.00
  }
  
  set billedTotal [expr $verbuchtTotal + $auslagenTotal]
  set totalCredit [expr $gezahltTotal - $billedTotal]

  #Configure .creditM widget
  if {$totalCredit >0} {
    .creditM conf -bg lightgreen
  } elseif {$totalCredit <0} {
    .creditM conf -bg red
  } else { 
    .creditM conf -bg silver
  }
  
  return [roundDecimal $totalCredit]
}
   
# storno
##removes given item from database if confirmed in messageBox
##called by .stornoE   
proc storno {id} {
	global db

	#Switch back to main page & create pop-up window to verify deletion
	.n select 0
	set res [tk_messageBox -title "Buchung stornieren" -message "Wollen Sie Buchung $id wirklich dauerhaft entfernen?" -icon warning -type yesno]	

	#Exit if "No"
	if {$res == "no"} {
		NewsHandler::QueryNews "Buchung Nr. $id wurde nicht storniert." red
		return 1
	}
	
	#Avoid error of empty item (wrong number - sqlite has no proper error handling!!!)
	set code "FROM invoice WHERE objectid=$id"
	set res [db eval "SELECT * $code"]
	if {$res == ""} {
		NewsHandler::QueryNews "Kein Auftrag mit Nr. $id vorhanden. Abbruch." red
		return 1
	}
	
	#Proecess deletion & update GUI
	db eval "DELETE $code"
	NewsHandler::QueryNews "Buchung Nr. $id erfolgreich storniert." green
	fillAdrInvWin $id
}

# fetchInvData
##1.retrieves invoice data from DB
##2.gets some vars from Config
##3.saves dataFile & itemFile to $texDir for Latex processing
##called by printDocument if invoice not found in spooldir
proc fetchInvData {invNo} {
  global db texDir confFile itemFile dataFile tkoDir
  
  #1.get some vars from config
  source $confFile
  if {![string is digit $vat]} {set vat 0.0}
  if {$currency=="$"} {set currency \\textdollar}
  if {$currency=="£"} {set currency \\textsterling}
  if {$currency=="€"} {set currency \\texteuro}
  
#TODO what's the deal with Swiss Francs?!
  if {$currency=="CHF"} {set currency {Fr.}}

  #2.Get invoice data from DB
  set invToken [db eval "SELECT 
    ref,
    cond,
    f_date,
    items,
    customeroid
  FROM invoice WHERE f_number = $invNo"
  ]

  if [db errorcode] {
    NewsHandler::QueryNews "[mc invRecovErr $invNo]\n$invToken" red
    return 1
  }
  
  set ref       [lindex $invToken 0]
  set cond      [lindex $invToken 1]
  set auftrDat  [lindex $invToken 2]
  set itemsHex  [lindex $invToken 3]
  set adrNo     [lindex $invToken 4]

  #3.Get address data from DB & format for Latex
  set adrToken [db eval "SELECT 
    name1,
    name2,
    street,
    zip,
    city 
  FROM address WHERE ts=$adrNo"
  ]
  
#make sure below signs are escaped since they interfere with LaTex commands
  lappend custAdr [lindex $adrToken 0] {\\}
  lappend custAdr [lindex $adrToken 1] {\\}
  lappend custAdr [lindex $adrToken 2] {\\}
  lappend custAdr [lindex $adrToken 3] { }
  lappend custAdr [lindex $adrToken 4]
    
  #4.set dataList for usepackage letter
  append dataList \\newcommand\{\\referenz\} \{ $ref \} \n
  append dataList \\newcommand\{\\cond\} \{ $cond \} \n
  append dataList \\newcommand\{\\dat\} \{ $auftrDat \} \n
  append dataList \\newcommand\{\\invNo\} \{ $invNo \} \n
  append dataList \\newcommand\{\\custAdr\} \{ $custAdr \} \n
  append dataList \\newcommand\{\\myBank\} \{ $myBank \} \n
  append dataList \\newcommand\{\\myName\} \{ $myComp \} \n
  append dataList \\newcommand\{\\myAddress\} \{ $myAdr \} \n
  append dataList \\newcommand\{\\myPhone\} \{ $myPhone \} \n
  append dataList \\newcommand\{\\vat\} \{ $vat \} \n
  append dataList \\newcommand\{\\currency\} \{ $currency \} \n

  ##save dataList to dataFile
  set chan [open $dataFile w] 
  puts $chan $dataList
  close $chan

  #save itemList to itemFile  
  set itemList [binary decode hex $itemsHex]
  if {$itemList == ""} {
    NewsHandler::QueryNews "Keine Posten für Rechnung $invNo gefunden. Kann Rechnung nicht anzeigen oder ausdrucken." red 
    return 1
  }
  #get rid of Latex code signs
  regsub -all {%} $itemList {\%} itemList
  regsub -all {&} $itemList {\&} itemList
  regsub -all {$} $itemList {\$} itemList
  regsub -all {#} $itemList {\#} itemList
  regsub -all {_} $itemList {\_} itemList
  
  set chan [open $itemFile w]
  puts $chan $itemList
  close $chan

  #Cleanup
  unset invToken adrToken
	
  return 0
  
} ;#END fetchInvData
