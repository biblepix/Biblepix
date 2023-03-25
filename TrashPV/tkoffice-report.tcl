# ~/TkOffice/prog/tkoffice-report.tcl
# called by tkoffice-gui.tcl
# Updated: 13mch23

#sSrced by .repPrintB button & ?

################################################################################
### A B S C H L Ü S S E  &  E X P E N S E S
################################################################################

# setAbschlussjahrSB
##configures Abschlussjahr spinbox ('select distinct' shows only 1 per year)
##includes actual business years up till now
##called by manageExpenses & createAbschluss
proc setAbschlussjahrSB {} {
  global db
  set heuer [clock format [clock seconds] -format %Y]
 	set jahresliste [lsort -unique [db eval "SELECT strftime('%Y', f_date) FROM invoice"]]
  lappend jahresliste $heuer

  .repJahrSB conf -values [lsort -decreasing $jahresliste]
  .repJahrSB set [expr $heuer - 1]
}

# setReportPsPath
##adds year to reportName & gives out PS path
##called by various Abschluss procs
proc setReportPsPath {jahr} {
  global reportDir
  
  #TODO Mc
  append reportName report _ $jahr . ps
  set reportPath [file join $reportDir $reportName] 
  
  return $reportPath
}

#################################
#  J A H R E S S P E S E N
#################################

# manageExpenses
##shows general expenses (Auslagen) from DB
##shows Add + Delete buttons for managing
##called by createAbschluss
proc manageExpenses {} {
  global db
  .expnameE conf -bg beige -fg grey -width 60 -textvar ::expname
  .expvalueE conf -bg beige -fg grey -width 7 -textvar ::expval

  #pack Listbox & buttons
  pack forget .repM .spesenAbbruchB .reportT .repScr .expnameE .expvalueE .spesenB
  pack .spesenM -side left
  pack .spesenAddB .spesenDeleteB -in .n.t6 -side right -anchor se
  pack .spesenLB -in .n.t6 -fill y -pady 50
  
  .spesenAddB conf -text "Eintrag hinzufügen" -command {addExpenses}
  .spesenLB delete 0 end
  
  #get listbox values from DB
  set numL  [db eval "Select ROW_NUMBER() OVER() from spesen"]
  #db eval "SELECT count() from spesen" - for num of entries
  
  foreach num $numL {
    set row [db eval "select * FROM (                            
      select ROW_NUMBER() OVER() as row_num,name,value from spesen ) t 
      where row_num=$num" ]

    .spesenLB insert end $row
  }
}

proc addExpenses {} {
  pack .spesenAbbruchB .spesenAddB .expvalueE .expnameE -in .n.t6 -side right -anchor se
  pack forget .spesenDeleteB
  .spesenAddB conf -text "[mc save]" -command {saveExpenses}
  set ::expname "[mc description]"
  set ::expval "[mc betrag]"
  .expnameE conf -fg grey -validate focusin -vcmd {%W delete 0 end;%W conf -fg black;return 0}
  .expvalueE conf -fg grey -validate focusin -vcmd {%W delete 0 end; %W conf -fg black; return 0}

#  manageExpenses
}

proc saveExpenses {} {
  global db

  set name [.expnameE get]
  set value [.expvalueE get]
 
  db eval "INSERT INTO spesen (name,value) VALUES ('$name',$value)"

	if [db errorcode] {
	  NewsHandler::QueryNews "Ging nicht..." red
	} else {
  	NewsHandler::QueryNews "Eintrag gespeichert." green
  }
  manageExpenses
}

proc deleteExpenses {} {
  global db

  #1 delete from DB
  set value [lindex [.spesenLB get active] end]
  set token [db eval "DELETE FROM spesen WHERE value=$value"]
 
 #TODO check errorcode, s.o. 
 #NewsHandler::QueryNews $token "Eintrag gelöscht" green

  #2 update LB
  manageExpenses
#  return 0
}


############################
# A B S C H L U S S
############################

# createReport
##Creates yearly report for display in text window
##called by .repCreateBtn
proc createReport {} {
  global db myComp currency vat texDir reportDir
  
  set jahr [.repJahrSB get]
  set einnahmenTexFile [file join $texDir abschlussEinnahmen.tex]
  set auslagenTexFile  [file join $texDir abschlussAuslagen.tex]
  set h [expr [winfo height .n.t3] - 100]
  set w [expr int(1.5 * $h)]
  
  # Prepare canvas & textwin dimensions
  set t .repT
  $t delete 1.0 end
  .repC conf -width $w -height $h -bg blue
  .repC create window 0 0 -tags repwin -window .repT -anchor nw -width $w -height $h
  .repC itemconf repwin -width $w -height $h

  #Get annual invoice & expenditure data from DB
  ## invoice data stored in report${jahr} namespace
  listInvoices $jahr
  listExpenses
  
	#Textwin dimensions Tk scaling factor:
	##requires no of LETTERS as height + no. of LETTER as width!
	#TODO conflicts with [winfo height/width ...] for proper A4-dimensions
	#TODO A4 = 210 x 297 mm
	set scaling [tk scaling]
	set winLetH 35
  set winLetW [expr round(3.5 * $winLetH)]
	set winLetY [expr round($winLetH * $scaling)]
 	set winLetX [expr round($winLetW * $scaling)]

  #Configure widgets & scroll bar
  $t conf -bg lightblue -bd 0 
    
  
 	# F i l l   t e x t w i n

  #Compute tabs for landscape layout (c=cm m=mm)
	$t configure -tabs {
	1.5c
	4.0c
	11c numeric
	14c numeric
	17c numeric
  }

  #Configure font tags
  $t tag conf T1 -font "TkHeadingFont 20"
  $t tag conf T2 -font "TkCaptionFont 16"
  $t tag conf T3 -font "TkSmallCaptionFont 10 bold"

  #B u i l d   w i n d o w
	$t insert 1.0 "$myComp\n" T1
	$t insert end "Erfolgsrechnung $jahr\n\n" T1
  $t insert end "Einnahmen\n" T2

  # E I N N A H M E N
  
  ##Titel
  $t insert end "Rch.Nr.\tDatum\tAnschrift\tNetto ${currency}\tMwst. ${vat}%\tSpesen\tEingänge ${currency}\n" T3
puts $currency


#TODO  'finalsum' is exclusive vat & Auslagen - list Auslagen anyway because payedsum may differ


  #compute sum total & insert text lines
 

  namespace eval report {

    variable sumtotal 0
    
    foreach n $invL {
   
      #set vars from array
      set payedsum [lindex [array get $n payedsum] 1]
      set invDat [lindex [array get $n invDat] 1]
      set invAdr [lindex [array get $n invAdr] 1]
      set netto [lindex [array get $n netto] 1]
      set vat [lindex [array get $n VAT] 1]
      set auslage [lindex [array get $n auslage] 1]
      
      #Update sum total
      set sumtotal [roundDecimal [expr $sumtotal + $payedsum]]
	    
      if ![ string is double $auslage ] {
        set auslage ""
      }

      #Insert row in text window
	    .repT insert end "\n${n}\t${invDat}\t${invAdr}\t${netto}\t${vat}\t ${auslage}\t${payedsum}"

    }
	  
	  .repT insert end "\n\nEinnahmen total\t\t\t\t\t\t\t $sumtotal" T3

  } ;# END report ns
	
	$t insert end "\n\nAuslagen\n" T2
	$t insert end $report::spesenList

  ##compute Reingewinn
  set sumtotal $report::sumtotal
  set spesenTotal $report::spesenTotal
  set netProfit [roundDecimal [expr $sumtotal - $spesenTotal]]
  if {$netProfit < 0} {
    set netProfit 0.00
  }

  $t insert end "\nAuslagen total\t\t\t\t\t\t\t-${spesenTotal} \n\n" T3
  $t insert end "Reingewinn\t\t\t\t\t\t\t$netProfit" T2

  #Pack & configure print button
  pack .repPrintBtn -in .n.t3.rightF -side bottom -anchor sw
  
#TODO implement in printReport!
.repPrintBtn conf -command "printReport $jahr"
.repT conf -borderwidth 3 -padx 7 -pady 7
   
  namespace delete report
  
} ;#END createReport

# listInvoices
##extracts all data from invoice for $jahr into ::report ns
##called by createReport
proc listInvoices {jahr} { 
 
  namespace eval report {}
  set report::jahr $jahr
  
  namespace eval report {

    
#TODO: WHAT ABOUT payeddate vs. f_date ?????????????????????
##is this still functional?
    
	  #get data from $jahr's invoices + 'payeddate = $jahr' from any previous invoices
	  
	  set res [db eval "SELECT
	  f_number,
	  f_date,
	  addressheader,
	  finalsum,
	  vatlesssum,
	  payedsum,
	  auslage 
	  FROM invoice 
	  WHERE strftime('%Y', payeddate) = '$jahr'
	  OR strftime('%Y', f_date) = '$jahr'
	  ORDER BY f_number ASC"]

	  #set num. of entries for textwin & put values into arrays per No.
	  set invL [db eval	"SELECT f_number FROM invoice WHERE strftime('%Y', f_date) = '$jahr'"]
	  
	  foreach invNo $invL {
	  
		  # f_date currency vatlesssum finalsum payedsum auslage
		  set date [db eval "SELECT f_date FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "invDat $date" 
	  
		  set adr [db eval "SELECT addressheader FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "invAdr $adr" 
	  
		  set netto [db eval "SELECT vatlesssum FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "netto $netto"
	   	
		  set currency [db eval "SELECT currency FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "currency $currency"
			   	
		  set finalsum [db eval "SELECT finalsum FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "finalsum $finalsum"
		  
		  set payedsum [db eval "SELECT payedsum FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "payedsum $payedsum"
	   	
		  set auslage [db eval "SELECT auslage FROM invoice WHERE f_number = $invNo"] 
		  array set $invNo "auslage $auslage" 
	  
		  ##compute finalsum on basis of $vat from config
		  if {! $vat > 0} {
    		array set $invNo {VAT 0}
    		array set $invNo "netto $finalsum"
		  } else {
			  array	set $invNo "VAT [expr $finalsum - $netto]"
    	}
    	
	  }
	  
  } ;#END ns report
  	
} ;#END listInvoices


### A U S G A B E N
##Note: code copied from manageExpenses

# listExpenses
##called by createReport
##extracts expenses as text block into ::report ns 
proc listExpenses {} {

  set numL [db eval "Select ROW_NUMBER() OVER() from spesen"] 
 
  foreach num $numL {
 
    set row [db eval "select * FROM (                            
      select ROW_NUMBER() OVER() as row_num,name,value from spesen ) t 
      where row_num=$num" ]
    
    ##1.prepare for text window
    set row [linsert $row 2 "          "]
    append report::spesenList $row \n
  }
  
  set report::spesenTotal [db eval "SELECT SUM(value) FROM spesen"]

} ;#END listExpenses





# O B S O L E T E ###########################################################

## canvas2ps
# # Capture a window into an image
# # Author: David Easton
###called by .reportPrintBtn
#proc canvas2ps {canv jahr} {
#  global reportDir tmpDir
#  set win .reportT
#  set origCanvHeight [winfo height $canv]
#    
#  #1. move win to top position + make first PS page
#    raise $win
#    update
#    $win yview moveto 0.0 
#    raise $win
#    update

#  set pageNo 1

#  #A) Für 1st page 
#  set file [file join $tmpDir abschluss_$pageNo.ps]
#  $canv postscript -colormode mono -file $file 
#  #exec ps2pdf $file
#   
#  #move 1 page for multiple pages
#  set visFraction [$win yview]
#  set begVisible [lindex $visFraction 0] 
#  set endVisible [lindex $visFraction 1]
#  $win yview moveto $endVisible


#set lastVisible $endVisible

#  while {$endVisible < 1.0} {

#    incr pageNo
#        
#    set lastVisible $endVisible
#    raise $win
#    update
#    
#    set file [file join $tmpDir abschluss_$pageNo.ps]
#    $canv postscript -colormode gray -file $file
#    #exec ps2pdf $file

#    #move 1 page
#    set visFraction [$win yview]
#    set begVisible $endVisible
#    set endVisible [lindex $visFraction 1]
#    $win yview moveto $endVisible      
#    
#	}

##puts $endVisible
##puts $lastVisible	

#	#3. Compute remaining page height & adapt window dimension
#    if {$begVisible < $lastVisible} {
#        set cutoutPercent [expr $begVisible - $lastVisible]
#        set hiddenHeight [expr round($cutoutPercent * $origCanvHeight)]
#        set visHeight [expr $origCanvHeight - $hiddenHeight]
#        $canv itemconf repwin -height $visHeight
#        $canv conf -height $visHeight 
#    }

#  incr pageNo
#  
#  #4. Make last page  ????
#  raise $win
#  update
#    $canv postscript -colormode gray -rotate 1 -file $reportPath
#    
#    #5. Make full report ????
#  append reportName report . $jahr _ $pageNo . ps
#  set reportPath [file join $tmpDir $reportName]
#  
##Postscript all *ps in landscape format to *.ps in one batch:  
#exec gs -dNOPAUSE -dAutoRotatePages=/None -sDEVICE=pdfwrite -sOUTPUTFILE=ABSCHLUSS.pdf -dBATCH $tmpDir/abschluss*.ps
## -c "<</Orientation 3>> setpagedevice" - seems unnecessary

#  #Join postscript files
##  lappend fileL [glob $tmpDir/abschluss_*]
##  exec psjoin $tmpDir/abschluss_1.ps $tmpDir/abschluss_2.ps > $tmpDir/ABSCHLUSS.ps
#  
#  
#  exec xdg-open $tmpDir/ABSCHLUSS.pdf
# 
#  
#  #5. Restore original dimensions
#  $canv itemconf textwin -height $origCanvHeight
#  $canv conf -height $origCanvHeight 

#} ;#END canvas2ps


# latexReport
##recreates (abschlussEinnahmen.tex) + (abschlussAuslagen.tex) > Abschluss.tex
##called by printAbschluss
#proc latexReport {jahr} {
#  global db myComp currency vat texDir reportDir reportTexFile
#  set reportTexPath [file join $texDir $reportTexFile]

##  set jahr [.repJahrSB get]
#  set einnahmenTexFile [file join $texDir abschlussEinnahmen.tex]
#  set auslagenTexFile  [file join $texDir abschlussAuslagen.tex]
#  set einnahmenTex [read [open $einnahmenTexFile]]
#  set auslagenTex  [read [open $auslagenTexFile]]

#  #get netTot vatTot spesTot from DB
#  ##TODO? Bedingung 'year = payeddate' könnte dazu führen, dass Gesamtbetrag in 2 Jahren aufgeführt wird, wenn Teilzahlung vorhanden!
#  set token [pg_exec $db "SELECT sum(vatlesssum),sum(finalsum),sum(auslage),sum(payedsum)
#    FROM invoice AS total
#    WHERE EXTRACT(YEAR from f_date) = $jahr OR
#          EXTRACT(YEAR from payeddate) = $jahr
#  "]

#  set yearlyExpTot [pg_result [pg_exec $db "SELECT sum(value) from spesen"] -list]

#  ##compute all values for Abschluss
#  set vatlessTot [lindex [pg_result $token -list] 0]
#  set bruTot [roundDecimal [lindex [pg_result $token -list] 1]]
#  set custExpTot [lindex [pg_result $token -list] 2]
#  set payTot [lindex [pg_result $token -list] 3]
#  set vatTot [roundDecimal [expr $bruTot - $vatlessTot]]
#  set netTot [roundDecimal [expr $payTot - $vatTot - $custExpTot]]

#  set netProfit [roundDecimal [expr $netTot - $yearlyExpTot]]
#  if {$netProfit < 0} {
#    set netProfit 0.00
#  }

#  #R E C R E A T E   A B S C H L U S S . T E X
#  ##header data
#  append abschlTex {\documentclass[10pt,a4paper]{article}
#\usepackage[utf8]{inputenc}
#\usepackage{german}
#\usepackage{longtable}
#\author{}
#}
#append abschlTex {\title} \{ $myComp {\\} Erfolgsrechnung { } $jahr \}
#append abschlTex {
#\begin{document}
#\maketitle
#\begin{small}
#\begin{longtable}{ll p{0.4\textwidth} rrrr}
#%1. Einnahmen
#\caption{\textbf{EINNAHMEN}} \\
#\textbf{R.Nr} & \textbf{Datum} & \textbf{Adresse} &
#\textbf{Netto} &
#\textbf{Mwst.} &
#\textbf{Spesen} &
#\textbf{Bezahlt} \\
#\endhead
#}
#  ##1.Einnahmen
#  append abschlTex $einnahmenTex
#  append abschlTex {\multicolumn{3}{l}{\textbf{Einnahmen total}}} &
#  append abschlTex {\textbf} \{ $bruTot \} &
#  append abschlTex {\textbf} \{ $vatTot \} &
#  append abschlTex {\textbf} \{ $custExpTot \} &

#  append abschlTex [expr $bruTot - ($vatTot - $custExpTot)] {\\} \n
#  append abschlTex {&&abzügl. Mehrwertsteuer&&&} \{ \$ \- $vatTot \$ \} {\\} \n
#  append abschlTex {&&abzügl. Spesen&&&} \{ \$ \- $custExpTot \$ \} {\\} \n
#  append abschlTex {\multicolumn{3}{l}{\textbf{EINNAHMEN TOTAL NETTO}}&&&&\textbf} \{ $netTot \} {\\} \n
#  ##2.Auslagen
#  append abschlTex {\caption{\textbf{AUSLAGEN}} \\} \n
#  append abschlTex $auslagenTex
#  append abschlTex {\multicolumn{3}{l}{\textbf{AUSLAGEN TOTAL}} &&&& \textbf} \{ \- $yearlyExpTot \} {\\\\} \n
#  ##3. Reingewinn
#  append abschlTex {\multicolumn{3}{l}{\textbf{REINGEWINN}} &&&& \textbf} \{ $netProfit \} {\\} \n
#  ##4. End
#  append abschlTex {
#\end{longtable}
#\end{small}
#\end{document}
#  }

##puts $abschlTex
##puts $reportTexPath

#  #Save to file
#  set chan [open $reportTexPath w]
#  puts $chan $abschlTex
#  close $chan

##Latex2pdf
##latex2pdf $jahr rep

##TODO: latex catches don't work!!!!!!!!!!!!!!!!!!!!!!!!!!! - check all progs + find better solution.
##  if [catch {latex2pdf $jahr rep}] {

##    NewsHandler::QueryNews "$reportTexFile konnte nicht nach PDF umgewandelt werden." red
##    return 1
##  }

#  return 0
#} ;#END latexReport


