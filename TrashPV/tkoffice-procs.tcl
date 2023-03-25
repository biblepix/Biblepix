# ~/TkOffice/prog/tkoffice-procs.tcl
# called by tkoffice-gui.tcl
# Salvaged: 1nov17
# Updated: 11mch23

###############################################################
### G E N E R A L   &&   A D D R E S S  P R O C S
###############################################################

# roundDecimal
##rounds any sum to $sum.$dp
##called by various output progs
proc roundDecimal {sum} {
  set dp 2 ;#no. of decimal places
  set rounded [format "%.${dp}f" $sum]
  return $rounded
}

# createTkOfficeLogo
##called by tkoffice-gui.tcl
proc createTkOfficeLogo {} {
#Bitmap should work, but donno why it doesn't
#$invF.$n.invshowB conf -bitmap $::verbucht::bmdata -command "showInvoice $invno"

  set bildschirmbreite [winfo screenwidth .]
  set fensterbreite [winfo width .]
  set blau lightblue2
  set dunkelblau steelblue3

  canvas .logoC -width 500 -height 45 -bg $dunkelblau -highlightthickness 0
  pack .logoC -in .topF -side left -anchor w

  set kreis [.logoC create oval 3 3 40 40]
  .logoC itemconf $kreis -fill orange -outline gold -width 1

  set schrift0 [.logoC create text 17 18]	
  .logoC itemconf $schrift0 -font "TkHeadingFont 18 bold" -fill $dunkelblau -text "T"
  set schrift1 [.logoC create text 28 26]
  .logoC itemconf $schrift1 -font "TkCaptionFont 18 bold" -fill $dunkelblau -text "k"

  set schrift2 [.logoC create text 105 25]
  .logoC itemconf $schrift2 -font "TkHeadingFont 20 bold" -fill orange -text {f  f  i  c  e}

#  set schrift3 [.logoC create text [expr $bildschirmbreite - 100] 30 -anchor e]
 # .logoC itemconf $schrift3 -font "TkCaptionFont 18 bold" -fill $blau -text "TkOffice [mc auftragsverw]" -justify right

#  set schrift4 [.logoC create text 0 110 -anchor w]
#  .logoC itemconf $schrift4 -font "TkHeadingFont 50 bold" -fill red -text "Auftragsverwaltung" -angle 4.
#  .logoC lower $schrift4

#  set schrift5 [.logoC create text 900 128 -justify right -text TkOffice.vollmar.ch]
#  .logoC itemconf $schrift5 -fill $blau -font "TkCaptionFont 14 bold"
}

#Create small bitmap ::verbucht::im
##called by fillAdrInvWin
#for printInvButton
#Bitmap should work, but donno why it doesn't:
# $invF.$n.invshowB conf -bitmap $::verbucht::bmdata -command "showInvoice $invno"
proc createPrintBitmap {} {
    set bmdata {
      #define printInvB_width 7
      #define printInvB_height 7
      static unsigned char printInvB_bits[] = {
      0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f};
    }
    set ::verbucht::printBM [image create bitmap -data $bmdata]
    $::verbucht::printBM conf -foreground red -background red
}

#############################################################################################
###  A D D R E S S  P R O C S
#############################################################################################

proc setAdrList {} {
  global db adrSpin
  $adrSpin config -bg lightblue
	set IDlist [db eval "SELECT objectid FROM address ORDER BY objectid DESC"]
	$adrSpin conf -values $IDlist

	$adrSpin conf -command {
		fillAdrWin %s
		fillAdrInvWin %s
	} -validate key -vcmd {
  	fillAdrWin %s
  	after idle {%W config -validate %v}
  	return 1
	} -invcmd {}

	#set last entry at start
  fillAdrWin [$adrSpin get]
  catch {pack forget .adrClearSelB}
}

proc fillAdrWin {adrId} {
  global adrSpin db adrWin1 adrWin2 adrWin3 adrWin4 adrWin5
	
  #set variables
	set name1 [db eval "SELECT name1 FROM address WHERE objectid=$adrId"]
	set name2 [db eval "SELECT name2 FROM address WHERE objectid=$adrId"]
	set street [db eval "SELECT street FROM address WHERE objectid=$adrId"]
	set city [db eval "SELECT city FROM address WHERE objectid=$adrId"]
	set ::zip  [db eval "SELECT zip FROM address WHERE objectid=$adrId"]

  #Export if not empty
  set tel1 [db eval "SELECT telephone FROM address WHERE objectid=$adrId"]
  set tel2 [db eval "SELECT mobile FROM address WHERE objectid=$adrId"]
  #set fax  [db eval "SELECT telefax FROM address WHERE objectid=$adrId"]
  set mail [db eval "SELECT email FROM address WHERE objectid=$adrId"]
  set www  [db eval "SELECT www FROM address WHERE objectid=$adrId"]

  regsub {({)(.*)(})} $name1 {\2} ::name1
  regsub {({)(.*)(})} $name2 {\2} ::name2
  regsub {({)(.*)(})} $street {\2} ::street
  regsub {({)(.*)(})} $city {\2} ::city
  regsub {({)(.*)(})} $tel1 {\2} ::tel1
  regsub {({)(.*)(})} $tel2 {\2} ::tel2

  if {[string is punct $tel1] || $tel1==""} {set ::tel1 "Telefon1" ; .tel1E conf -fg silver} {set ::tel1 $tel1}
  if {[string is punct $tel2] || $tel2==""} {set ::tel2 "Telefon2" ; .tel2E conf -fg silver} {set ::tel2 $tel2}
  if {[string is punct $mail] || $mail==""} {set ::mail "Mail" ; .mailE conf -fg silver} {set ::mail $mail}
  if {[string is punct $www] || $www==""} {set ::www "Internet" ; .wwwE conf -fg silver} {set ::www $www}
 
  $adrSpin set $adrId

  #Hide .adrDelBtn if address has invoices attached
  set token [db eval "SELECT objectid FROM invoice WHERE customeroid=$adrId"]
  if {$token != ""} {
    .adrDelBtn conf -state disabled
  } else {
    .adrDelBtn conf -state normal
  }
  
} ;#END fillAdrWin

proc searchAddress {} {
  global db adrSpin adrSearch
  set s [$adrSearch get]

  if {$s == ""} {return 0}

  #Search names/city/zip (with %...% for fuzzy matches)
  set adrNumL [db eval "SELECT objectid FROM address WHERE
	  name1 LIKE '%$s%' OR
	  name2 LIKE '%$s%' OR
    zip LIKE '%$s%' OR
	  city LIKE '%$s%'
  "]

  set numTuples [llength $adrNumL]
#puts $adrNumList
#puts $numTuples

  if {$numTuples == 0} {
    NewsHandler::QueryNews "Suchergebnis leer!" red
    after 5000 {resetAdrSearch}
    return 1
  }

  #A: open address if only 1 found
  if {$numTuples == 1} {
    $adrSpin set $adrNumL
	  fillAdrWin $adrNumL
	  fillAdrInvWin $adrNumL

  #B: fill adrSB spinbox to choose from selection
  } elseif {$numTuples > 1} {

    $adrSpin config -bg beige -values "$adrNumL"
    fillAdrWin [$adrSpin get]
    fillAdrInvWin [$adrSpin get]
    catch {button .adrClearSelB -width 13 -text "^ Auswahl löschen" -command setAdrList}
    pack .adrClearSelB -in .adrF1
  }

  #Reset adrSearch widget & address list (called by .adrClearSelB)
  after 5000 {resetAdrSearch}
  return 0
} ;# END searchAddress


# resetAdrSearch
##called by GUI + searchAddress
proc resetAdrSearch {} {
  global adrSearch
  $adrSearch delete 0 end
  $adrSearch insert 0 "Adresssuche (+Tab)"
  $adrSearch config -fg grey -validate focusin -vcmd {
    %W delete 0 end
    %W conf -fg black
    after idle {
    	%W conf -validate focusout -vcmd searchAddress
		}
    return 0
  }
}

# resetAdrWin
##what does it do?
##called by GUI (first fill) + Abbruch btn + aveAddress
proc resetAdrWin {} {
  global adrSpin adrNo adrSearch

  pack .name1E .name2E .streetE -in .adrF2 -anchor nw
  pack .zipE .cityE -anchor nw -in .adrF2 -side left
  pack .tel1E .tel2E .mailE .wwwE -in .adrF4

  foreach e "[pack slaves .adrF2] [pack slaves .adrF4]" {
    $e conf -bg lightblue -validate none -fg black -state readonly -readonlybackground lightblue -relief flat -bd 0
  }

  .adrNewBtn config -activebackground silver
  .adrChgBtn config -text "Anschrift ändern" -command {changeAddress $adrNo} -activebackground silver
  .adrDelBtn config -text "Anschrift löschen" -command {deleteAddress $adrNo} -activebackground red
  pack .adrChgBtn .adrDelBtn .adrNewBtn -in .adrF3 -anchor se

  $adrSpin conf -state normal -bg lightblue
  $adrSearch conf -state normal
  .adrF2 conf -bg lightblue
  catch {pack forget .adrClearSelB}

  #Set address to spinbox or, if just changed, to changed address
  setAdrList  
  fillAdrWin [$adrSpin get]
  fillAdrInvWin [$adrSpin get]
}

proc newAddress {} {
  global adrSpin
  
  #disable adrSpin & upvar adress vars
  $adrSpin delete 0 end
  $adrSpin conf -bg #d9d9d9
	$adrSpin conf -state disabled
	
	#clear Invoices
	clearAdrInvWin
	  
  upvar name1 name1 name2 name2 street street zip zip city city tel1 tel1 tel2 tel2 www www mail mail
  
  #reset address vars
  set name2 [mc name2]
  set name1 [mc name1]
  set street [mc street]
  set zip [mc zip]
  set city [mc city]
  set tel1 [mc tel1]
  set tel2 [mc tel2]
  set www [mc www]
  set mail [mc mail]

  #configure entry widgets
  foreach e "[pack slaves .adrF2] [pack slaves .adrF4]" {
    $e conf -bg beige -fg silver -state normal -validate focusin -vcmd {
      %W delete 0 end
      %W conf -fg blue -bg orange	
      return 0	
    }
#     -validate focusout -vcmd {
#      %W conf -fg black -bg lightblue
#      return 0	
#    }
  }

  #reconfigure buttons
  .adrChgBtn configure -text "Anschrift speichern" -activebackground lightgreen -command {saveAddress}
  .adrDelBtn configure -text "Abbruch" -activebackground red -command {resetAdrWin new}
  pack forget .adrNewBtn

	#clear adrInvWin
	
	
	
}

# clearAddressWin
##called by [newAddress] & [changeAddress] buttons
proc clearAddressWin args {
  global adrSpin adrSearch
 
  if {$args == "new"} {

 #TODO why does this work only when hand typed? 
 
 ##TODO what is this supposed to do? where is it? 
#    resetAddressVars
    
  } else {
  
    foreach e "[pack slaves .adrF2] [pack slaves .adrF4]" {

      $e conf -bg orange -fg blue -state normal -validate focusin -vcmd {
        %W delete 0 end
        %W conf -bg lightblue
        return 0
      }
    }
  }
    
  catch {pack forget .adrClearSelB}
  $adrSearch conf -state disabled
  .adrF2 conf -bg #d9d9d9

}

# newAddress - OLD???????????
##clears address win & button names
##called by .adrChgBtn
proc newAddress-OLD {} {
  global adrSpin

  clearAddressWin new

#  set ::name1 "Anrede/Firma"
#  set ::name2 "Name"
#  set ::street "Strasse"
#  set ::zip "PLZ"
#  set ::city "Ortschaft"
#  set ::tel1 "Telefon"
#  set ::tel2 "Telefon"
#  set ::www "Internet"
#  set ::mail "E-Mail"
  
  $adrSpin delete 0 end
  $adrSpin conf -bg #d9d9d9

  .adrChgBtn configure -text "Anschrift speichern" -activebackground lightgreen -command {saveAddress}
  .adrDelBtn configure -text "Abbruch" -activebackground red -command {resetAdrWin}
  pack forget .adrNewBtn

  return 0
}

# changeAddress
##clears address win & button names
##called by .adrDelBtn
proc changeAddress {adrNo} {
  clearAddressWin change
  
  .adrChgBtn configure -text "Anschrift speichern" -activebackground lightgreen -command {saveAddress}
  .adrDelBtn configure -text "Abbruch" -activebackground red -command {resetAdrWin}
  pack forget .adrNewBtn
  return 0
}

# saveAddress
##saves existing or new address
##called by "Anschrift speichern" button
proc saveAddress {} {
  global db adrSpin

  #get new values from entery widgets
	set adrno [$adrSpin get]
	set name1 [.name1E get]
	set name2 [.name2E get]
	set street [.streetE get]
	set zip [.zipE get]
	set city [.cityE get]
	set tel1 [.tel1E get]
  #set tel2 [.tel2E get]
 # set mail [.mailE get]
  set www [.wwwE get]
set mail $::mail
set tel2 $::tel2

	#A: save new
	if {$adrno == ""} {
		set newNo [createNewNumber address]
		set token [db eval "INSERT INTO address (
      objectid,
      ts,
      name1,
      name2,
      street,
      zip,
      city,
      telephone,
      mobile,
      email,
      www
      )
		VALUES (
      $newNo,
      $newNo,
      '$name1',
      '$name2',
      '$street',
      '$zip',
      '$city',
      '$tel1',
      '$tel2',
      '$mail',
      '$www'
      )"
    ]
    set adrno $newNo

	#B: change old
	} else {

	set token [db eval "UPDATE address SET
		name1='$name1',
		name2='$name2',
		street='$street',
		zip='$zip',
		city='$city',
    telephone='$tel1',
    mobile='$tel2',
    email='$mail',
    www='$www'
  WHERE objectid=$adrno"
    ]
	}

  if [db errorcode] {
  	NewsHandler::QueryNews "$token" red
  } else {
   	NewsHandler::QueryNews "Anschrift Nr. $adrno gespeichert" lightgreen
	  #Update Address list
	  catch setAdrList
  }

  #reset address win & go back
  resetAdrWin
  $adrSpin set $adrno
  fillAdrWin $adrno
  fillAdrInvWin $adrno 
  
} ;#END saveAddress

# deleteAddress
##only funcional if no invoices attached
##called by .adrDelBtn (visibility controlled by fillAdrWin)
proc deleteAddress {adrNo} {
  global db
  set res [tk_messageBox -message "Wollen Sie die Adresse $adrNo wirklich löschen?" -type yesno -icon warning]
  if {!$res} {return 1}

   db eval "DELETE FROM address WHERE objectid=$adrNo"
   NewsHandler::QueryNews "Adresse $addrNo gelöscht" green
   resetAdrWin
}



##################################################################################
#### A R T I K E L V E R W A L T U N G
##################################################################################

# resetArticleWin
##called by ... in Artikel verwalten
proc resetArticleWin {} {
  pack .confartM -in .n.t7 -anchor nw
  pack .artL -in .n.t7 -anchor nw
  pack .confartL .confartnumSB .confartunitL .confartpriceL .confartnameL .confarttypeL -in .n.t7 -side left -anchor nw
  pack .confartdeleteB .confartcreateB -in .n.t7 -side right -anchor ne
  pack forget .confartsaveB .confarttypeACB .confarttypeRCB
  pack forget .confartnameE .confartunitE .confartpriceE
  .confartdeleteB conf -text "Artikel löschen" -command {deleteArticle}
  .confartcreateB conf -text "Artikel erfassen" -command {createArticle}
}

proc createArtMenu {} {
	global db
	set token [db eval "SELECT artnum,artname FROM artikel"]
	array set artArr $token


	#TODO extract artNum from string
	foreach artNum [array names artArr] {
		set s [array get artArr $artNum]
	#set artNo $artNum
		
	puts $artNum			
	puts $s
		#set artNum  [lindex $s 0]
#		set artName [lindex $s end]
		set artName $artArr($artNum)
		
		.invartlistMB.menu add radiobutton -label $artName -value $artNum -command {setArticleLine TAB2}
	}
}
	
# setArticleLine
##sets Artikel line in New Invoice window + Artikelverwaltung
##needs TAB2 / TAB4 args
##called by GUI + spinboxes .confartnumSB/.invartnumSB
proc setArticleLine {tab args} {
  global db
  .confarttypeL conf -bg #c3c3c3

  if {$tab == "TAB4"} {
    set artNum [.confartnumSB get]

  } elseif {$tab == "TAB2"} {
    .mengeE delete 0 end
    .mengeE conf -bg beige
    .mengeE conf -insertbackground orange -insertwidth 10 -insertborderwidth 5 -insertofftime 500 -insertontime 1000
    .mengeE conf -state normal -validate key -vcmd {string is double %P} -invcmd {%W conf -bg red; after 2000 ; %W conf -bg beige}
#    set artNum [.invartnumSB get]
#    focus .invartnumSB
  }

  #Read spinboxes
  if {$tab == "TAB2"} {
    namespace eval artikel {
#      set artNum [.invartnumSB get]
  	set artNum [.invartlistMB.menu entrycget active -value]
    }


  } else {
    namespace eval artikel {
      set artNum [.confartnumSB get]
    }
  }

  #Get DB data per line
  namespace eval artikel {
  
    set token [db eval "SELECT artname,artprice,artunit,arttype FROM artikel WHERE artnum=$artNum"]
    set artName  [lindex $token 0]
    set artPrice [lindex $token 1]
    set artUnit  [lindex $token 2]
    set artType  [lindex $token 3]

    if {$artType == "R"} {
      .mengeE delete 0 end
      .mengeE insert 0 "1"
      .mengeE conf -bg grey -fg silver -state readonly
      .confarttypeL conf -bg yellow
    } elseif {$artType == "A"} {
      .confarttypeL conf -bg orange
    }
  }

  if {$tab == "TAB4"} {
    return 0
  }

#TODO get order right!
  namespace eval artikel {
    if {$artPrice == 0} {
      set artPrice [.invartpriceE get]
      pack forget .invartpriceL
      pack .invartunitL .invartnameL .invartpriceE .invarttypeL -in .n.t2.f2 -side left
    } else {
      pack forget .invartpriceE
      pack .invartunitL .invartnameL .invartpriceL .invarttypeL -in .n.t2.f2 -side left
    }
  }

  return 0

} ;#END setArticleLine

proc createArticle {} {
  global db

 #clear previous entries & add .confArtSaveB
  .confartnumSB set ""
  .confartnumSB conf -bg lightgrey
  pack .confartsaveB -in .n.t7 -side right

#TODO:move to GUI?
  .confarttypeRCB conf -variable rabattselected -command {
    if [.confarttypeRCB instate selected] {
      set rabatt %
      .confartunitE conf -state readonly
      set ::artPrice "Abzug in %"
    } else {
      set rabatt ""
      .confartunitE conf -state normal
      set ::artPrice "Preis"
    }
  }

  .confartnameE delete 0 end
  .confartunitE delete 0 end
  .confartpriceE delete 0 end
  .confartpriceE conf -validate key -vcmd {%W conf -bg beige ; string is double %P} -invcmd {%W conf -bg red}
  #Rename list entries to headers
  set ::artName "Bezeichnung"
  set ::artPrice "Preis"
  set ::artUnit "Einheit"
  pack .confartnameL .confartnameE .confartunitL .confartunitE .confartpriceL .confartpriceE .confarttypeACB .confarttypeRCB -in .n.t7 -side left
  pack forget .confartdeleteB

  #Rename Button
  .confartcreateB conf -text "Abbruch" -activebackground red -command {resetArticleWin}

#TODO: articleWin is not reset after saving!!!
} ;#END createArticle

proc saveArticle {} {
  global db

  set artName [.confartnameE get]
  set artUnit [.confartunitE get]

  #check if type "Auslage"
  if [.confarttypeACB instate selected] {
    set artType A
  #check if type "Rabatt"
  } elseif [.confarttypeRCB instate selected] {
      set artType R
  } else {
    set artType ""
  }

  #Allow for empty article price
  set artPrice [.confartpriceE get]
  if {$artPrice == ""} {set artPrice 0}

  set token [db eval "INSERT INTO artikel (
    artname,
    artunit,
    artprice,
    arttype
    )
    VALUES (
      '$artName',
      '$artUnit',
      $artPrice,
      '$artType'
    )"]

  #Reset original mask
  foreach w [pack slaves .n.t7] {
    pack forget $w
  }

pack .confartL .confartnumSB .confartunitL .confartpriceL .confartnameL .confarttypeL -in .n.t7 -side left

  #Recreate article list
  updateArticleList
  resetArticleWin
  setArticleLine TAB4
  NewsHandler::QueryNews "Artikel $artName gespeichert" green

} ;#END saveArticle

# deleteArticle
proc deleteArticle {} {
  global db
  set artNo [.confartnumSB get]
  set res [tk_messageBox -message "Wollen Sie Artikel $artNo wirklich löschen?" -type yesno]
  
  if {$res == "yes"} {
    db eval "DELETE FROM artikel WHERE artnum=$artNo"
    NewsHandler::QueryNews "Artikel $artNo gelöscht." green
    updateArticleList
    setArticleLine TAB4
  }
}

# updateArticleList
##gets articles from DB + updates spinboxes
##called by saveArticle / ...
proc updateArticleList {} {
  global db
  set token [db eval "SELECT artnum FROM artikel"]
  
  
  #TODO replace?
  #.invartnumSB conf -values $token
  #.invartOM artNo $token
  .confartnumSB conf -values $token
}


################################################################################
### G E N E R A L   P R O C S
################################################################################

namespace eval NewsHandler {
	namespace export QueryNews
  source $::progDir/JList.tcl

	variable queryTextJList ""
	variable queryColorJList ""
	variable counter 0
	variable isShowing 0

	proc QueryNews {text color} {
		variable queryTextJList
		variable queryColorJList
		variable counter

		set queryTextJList [jappend $queryTextJList $text]
		set queryColorJList [jappend $queryColorJList $color]

		incr counter

		ShowNews
	}

	proc ShowNews {} {
		variable queryTextJList
		variable queryColorJList
		variable counter
		variable isShowing

		if {$counter > 0} {
			if {!$isShowing} {
				set isShowing 1

				set text [jlfirst $queryTextJList]
				set queryTextJList [jlremovefirst $queryTextJList]

				set color [jlfirst $queryColorJList]
				set queryColorJList [jlremovefirst $queryColorJList]

				incr counter -1

				.news configure -bg $color
				set ::news $text

				after 7000 {
					NewsHandler::FinishShowing
				}
			}
		}
	}

	proc FinishShowing {} {
		variable isShowing

		.news configure -bg steelblue3 -fg white
		set ::news "TkOffice $::version"
		set isShowing 0

		ShowNews
	}
} ;#END NewsHandler

#2.Create new f_number -
#NOTE this MAY BE unnecessary now, since SQLite automatically creates a new 'rowid' for new entries
#INSTEAD OF 'f_number' & 'objectid' USE this in future!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#But how do I identify 2 rowid's, and how does 'ts' come in?

proc createNewNumber {objectKind} {

#use new no. for all "integer not null" DB fields! (ref. saveAdress + saveInvoice)
	if {$objectKind=="address"} {
		set object "objectid"
	} elseif {$objectKind=="invoice"} {
		set object "f_number"
	}
	set lastNo [db eval "SELECT $object FROM $objectKind ORDER BY $object DESC LIMIT 1"]
	set objectNo $lastNo
	incr objectNo
	return $objectNo
}



#TODO - adapt for SQLIGHT!
proc initialiseDB {dbname} {
  global ?db?
  #1. Create DB

  #2. Create tables

    ##1. Article table
    set token [db eval "CREATE TABLE artikel (
      artnum SERIAL,
      artname text NOT NULL,
      artunit text NOT NULL,
      artprice NUMERIC
    )"
    ]
  ##2. Spesen
  set token [db eval "CREATE TABLE spesen (
    num SERIAL,
    name text NOT NULL,
    value NUMERIC NOT NULL
  )"
  ]
  ##3. Invoice
  #Invoice with yearly changing numbers!
  set token [db eval "CREATE TABLE invoice (
    ?f_number? SERIAL,
    ...
    ...
    ...
  )"
  ]
  #include this command somewhere in tkoffice for future Jahreswechsel!!
  ALTER SEQUENCE [get correct serial name from above, prob. invoice_num_sec ] RESTART WITH "(GET CURRENT YEAR...)0001";

  } ;#END initialiseDB


# dumpDB
##called by 'Datenbank sichern' button
proc dumpDB {} {

  global dbname
  
  file mkdir $dumpDir

  set date [clock format [clock seconds] -format %d-%m-%Y]
  set dumpfile $dbname_backup-${date}.sql
  set dumppath [file join $dumpDir $dumpfile]
  
	set err [db backup $dumppath]
 
  if [db errorcode] {
    NewsHandler::QueryNews "Datenbank konnte nicht gesichert werden;\n$err" red
  } else {
    NewsHandler::QueryNews "Datenbank erfolgreich gesichert in $dumppath" lightgreen
  }
  
#TODO: Add "Datenbank wiederherstellen" Btn in TAB4! & write proc
#Achtung: vor "Wiederherstellen" unbedingt automatische Tagessicherung machen!
 
}
