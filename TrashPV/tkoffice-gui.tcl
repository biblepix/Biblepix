# ~/TkOffice/prog/tkoffice-gui.tcl
# Salvaged: 1nov17
# Updated for use with SQlite: Sep22
# Updated 21mch23
		
set version 2.0
set px 5
set py 5

package require Tk
package require Img

#Initiate Sqlite DB
package require sqlite3
sqlite3 db $dbname

source [file join $progDir tkoffice-procs.tcl]
source [file join $progDir tkoffice-invoice.tcl]
source [file join $progDir tkoffice-report.tcl]
source [file join $progDir tkoffice-print.tcl]
source $confFile

#Create title font
font create TIT
font configure TIT -family Helvetica -size 16 -weight bold

#Create top & bottom frames with fix positions
pack [frame .topF -bg steelblue3] -fill x
pack [frame .botF -bg steelblue3] -fill x -side bottom

#Firmenname
label .firmaL -text "$myComp" -font "TkHeadingFont 20 bold" -fg silver -bg steelblue3 -anchor w
pack .firmaL -in .topF -side right -padx 10 -pady 3 -anchor e

#Create Notebook: (maxwidth+maxheight important to avoid overlapping of bottom frame)
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
. conf -bg steelblue3
ttk::notebook .n 

.n conf -width [expr round($screenX / 10) * 9] -height [expr round($screenY / 10) * 8]
.n add [frame .n.t1] -text "[mc adr+orders]"
.n add [frame .n.t2] -text "[mc newInv]"
.n add [frame .n.t3] -text "[mc reports]"
.n add [frame .n.t6] -text "[mc spesen]"
.n add [frame .n.t7] -text "[mc artikel]"
.n add [frame .n.t5] -text "[mc storni]"
.n add [frame .n.t4] -text "[mc settings]"

pack .n -anchor center -padx 15 -pady 15 -fill x

set winW [winfo width .n]

button .abbruchB -text "Programm beenden" -activebackground red -command {
	#catch {pg_disconnect $dbname}
	db close 
	exit
	}
pack .abbruchB -in .botF -side right -pady 3 -padx 10

#Pack all frames
createTkOfficeLogo
pack [frame .umsatzF] -in .n.t1 -side bottom  -fill x

#Tab 1
pack [frame .n.t1.mainF] -fill x -expand 0
pack [frame .n.t1.mainF.f2 -pady 10 -padx 10] -anchor nw -fill x
pack [frame .n.t1.mainF.f3 -borderwidth 0 -pady 10] -anchor nw -fill x

#Tab 2
pack [frame .n.t2.f1a -pady $py -padx $px -bd 5] -anchor nw -fill x
pack [frame .n.t2.f1 -pady $py -padx $px -bd 5] -anchor nw -fill x
pack [frame .n.t2.f2 -relief ridge -pady $py -padx $px -borderwidth 5] -anchor nw -fill x -padx 20 -pady 15
pack [frame .n.t2.f3 -pady $py -padx $px -borderwidth 5] -anchor nw -fill x
pack [frame .n.t2.bottomF] -anchor nw -padx 20 -pady 20 -fill both -expand 1

#Tab 3
pack [frame .n.t3.f1 -relief ridge -pady $py -padx 20 -borderwidth 5] -fill x
pack [frame .n.t3.bottomF] -anchor nw -padx 20 -pady 20 -fill x
#Tab 4
pack [frame .n.t4.f3 -pady $py -padx $px -borderwidth 5 -highlightbackground silver -highlightthickness 5] -anchor nw -fill x
pack [frame .n.t4.f2 -pady $py -padx $px -borderwidth 5 -highlightbackground silver -highlightthickness 5] -anchor nw -fill x
pack [frame .n.t4.f1 -pady $py -padx $px -borderwidth 5 -highlightbackground silver -highlightthickness 5] -anchor nw -fill x
pack [frame .n.t4.f5 -pady $py -padx $px -borderwidth 5 -highlightbackground silver -highlightthickness 5] -anchor nw -fill x -side left -expand 1


###############################################
# T A B 1. : A D R E S S F E N S T E R
###############################################

#Pack 3 top frames seitwärts
#Create "Adressen" title
label .adrTitel -text "Adressverwaltung" -font TIT -pady 5 -padx 5 -anchor w -fg steelblue -bg silver
pack .adrTitel -in .n.t1.mainF.f2 -anchor w -fill x

##obere Frames in .n.t1.f2
pack [frame .adrF2 -bd 3 -relief flat -bg lightblue -pady $py -padx $px] -anchor nw -in .n.t1.mainF.f2 -side left
pack [frame .adrF4 -bd 3 -relief flat -bg lightblue -pady $py -padx $px] -anchor nw -in .n.t1.mainF.f2 -side left
pack [frame .adrF1] -anchor nw -in .n.t1.mainF.f2 -side left
pack [frame .adrF3] -anchor se -in .n.t1.mainF.f2 -expand 1 -side left

##create Address number 
set adrSpin [spinbox .adrSB -takefocus 1 -width 15 -bg lightblue -justify right -textvar adrNo]
focus $adrSpin

##Create search field
set adrSearch [entry .adrsearchE -width 25 -borderwidth 3 -bg beige -fg grey]
resetAdrSearch

#Create address entries, to be packed when 'changeAddress' or 'newAddress' are invoked
entry .name1E -width 50 -textvar name1 -justify left
entry .name2E -width 50 -textvar name2 -justify left
entry .streetE -width 50 -textvar street -justify left
entry .zipE -width 7 -textvar zip -justify left
entry .cityE -width 43 -textvar city -justify left
entry .tel1E -width 25 -textvar tel1 -justify right
entry .tel2E -width 25 -textvar tel2 -justify right
#entry .faxE -width 25 -textvar fax -justify right
entry .mailE -width 25 -textvar mail -justify right
entry .wwwE -width 25 -textvar www -justify right

#create Address buttons
button .adrNewBtn -text [mc adrNew] -width 20 -command {
  #clearAddressWin
  newAddress
  }
  
button .adrChgBtn -text [mc adrChange] -width 20 -command {changeAddress $adrNo}
button .adrDelBtn -text [mc adrDelete] -width 20 -command {deleteAddress $adrNo} -activebackground red

#Pack adrF1 spinbox
pack $adrSpin -in .adrF1 -anchor nw
#Pack adrF3 buttons
pack $adrSearch .adrNewBtn .adrChgBtn .adrDelBtn -in .adrF3 -anchor ne


#########################################################################################
# T A B 1 :  I N V O I C E   L I S T
#########################################################################################
#pack [frame .umsatzF] -in .n.t1 -fill x -side bottom
.umsatzF conf -bd 2 -relief sunken

#TODO pack all into canvas w/ scrollbar!
#main prog is fillAdrInvWin, but it may not have to be changed...

#Create "Rechnungen" Titel
label .adrInvTitel -justify center -text "Verbuchte Rechnungen" -font TIT -pady 5 -padx 5 -anchor w -fg steelblue -bg silver
label .adrInvInfo -padx 5 -pady 0 -anchor w -fg steelblue -bg silver -text "Double-click on number to view"

label .creditL -text "Kundenguthaben: $currency " -font "TkCaptionFont"
label .credit2L -text "\u2196 wird bei Zahlungseingang aktualisiert" -font "TkIconFont" -fg grey
message .creditM -textvar credit -relief sunken -width 50
label .umsatzL -text "Kundenumsatz: $currency " -font "TkCaptionFont"
message .umsatzM -textvar umsatz -relief sunken -bg lightblue -width 50

pack .adrInvTitel -in .n.t1.mainF.f3 -anchor w -fill x -padx 10 -pady 5
pack .adrInvInfo -in .n.t1.mainF.f3 -anchor w -padx 10 -pady 0

#Umsatz unten
pack .creditL .creditM .credit2L -in .umsatzF -side left -anchor w
pack .umsatzM .umsatzL -in .umsatzF -side right -anchor e

#Create Rechnungen Kopfdaten
label .invNoH -text "Nr."  -font TkCaptionFont -justify left -anchor w -width 9
label .invDatH -text "Datum"  -font TkCaptionFont -justify left -anchor w -width 13
label .invartH -text "Artikel" -font TkCaptionFont -justify left -anchor w -width 47
label .invSumH -text "Betrag $currency" -font TkCaptionFont -justify right -anchor w -width 11
label .invPayedH -text "Bezahlt $currency" -font TkCaptionFont -justify right -anchor w -width 10
label .invcommH -text "Anmerkung" -font TkCaptionFont -justify right -anchor w -width 20

#label .invShowH -text "Rechnung anzeigen" -font TkCaptionFont -fg steelblue3 -justify right -anchor e -justify right -width 20

pack [frame .n.t1.mainF.headF -padx $px] -anchor nw -fill x -padx 10
pack [frame .n.t1.mainF.invF -padx $px] -anchor nw -fill x -padx 10
set invF .n.t1.mainF.invF
set headF .n.t1.mainF.headF
pack .invNoH .invDatH .invartH .invSumH .invPayedH .invcommH -in $headF -side left
#pack .invShowH -in $headF -side right


########################################################################################
# T A B  2 :   N E W   I N V O I C E
########################################################################################

#Main Title with customer name
label .titel3 -text "[mc invCreate]" -font TIT -anchor w -pady 5 -padx 5 -fg steelblue -bg silver
label .titel3name -textvar name2 -font TIT -anchor w -pady 5 -padx 5 -fg steelblue -bg silver
pack .titel3 .titel3name -in .n.t2.f1a -fill x -anchor w -side left

#Get Zahlungsbedingungen from config
set condList ""
label .invcondL -text "Zahlungsbedingung:" -pady 10
foreach cond [list $cond1 $cond2 $cond3] { 
  if {$cond != ""} {
    lappend condList $cond
  }
} 
#Insert into spinbox
spinbox .invcondSB -width 20 -values $condList -textvar cond -bg beige
#Auftragsdatum: set to heute
label .invauftrdatL -text "\tAuftragsdatum:"
entry .invauftrdatE -width 9 -textvar auftrDat -bg beige
set auftrDat [clock format [clock seconds] -format %d.%m.%Y]
set heute $auftrDat

#Referenz
label .invrefL -text "\tIhre Referenz:"
entry .invrefE -width 20 -bg beige -textvar ref
#Int. Kommentar
label .invcomL -text "\tInterne Bemerkung:"
entry .invcomE -width 30 -bg beige -textvar comm

#Packed later by resetNewInvoiceDialog
entry .mengeE -width 7 -bg yellow -fg grey
label .subtotalL -text "Rechnungssumme: "
message .subtotalM -width 70 -bg lightblue -padx 20 -anchor w
label .abzugL -text "Auslagen: "
message .abzugM -width 70 -bg orange -padx 20 -anchor w
label .totalL -text "Buchungssumme: "
message .totalM -width 70 -bg lightgreen -padx 20 -anchor w


#Set up Artikelliste, fill later when connected to DB
menubutton .invartlistMB -text [mc artSelect] -direction below -relief raised -menu .invartlistMB.menu

menu .invartlistMB.menu -tearoff 0 ;# -postcommand {setArticleLine TAB2}

label .arttitL -text "Artikel Nr."

#TODO replace with tk_optionMenu????
#spinbox .invartnumSB -width 2 -command {setArticleLine TAB2}

#pack [label .artLabel -text Artikel]

#menu .artMenu -tearoff 0 -title Artikel
#bind .artLabel <1> {tk_popup .artMenu post %X %Y}
# bind .artmenuBtn <1> {tk_popup .artMenu %X %Y}
 #createArtMenu

#Make invoiceFrame
#catch {frame .invoiceFrame}
pack [frame .newInvoiceF] -in .n.t2.f3 -side bottom -fill both

#Set KundenName in Invoice window
#label .clientL -text "Kunde:" -font "TkCaptionFont" -bg lightblue
#label .clientnameL -textvariable name2 -font "TkCaptionFont"
#pack .clientnameL .clientL -in .n.t2.f1 -side right

label .invartpriceL -textvar artPrice -padx 20
entry .invartpriceE -textvar artPrice
label .invartnameL -textvar artName -padx 50
label .invartunitL -textvar artUnit -padx 20
label .invarttypeL -textvar artType -padx 20

button .invSaveBtn -text [mc invEnter]
button .invCancelBtn -text [mc cancel] -command {resetNewInvDialog} -activebackground red
pack .invCancelBtn .invSaveBtn -in .n.t2.bottomF -side right


######################################################################################
# T A B  3 :  A B S C H L Ü S S E
######################################################################################
#Main Title
label .titel4 -text "Jahresabschlüsse" -font TIT -anchor nw -pady 5 -padx 5 -fg steelblue -bg silver
pack .titel4 -in .n.t3 -fill x -anchor nw

message .repM -justify left -width 300 -text [mc reportTxt]
button .repCreateBtn -text [mc reportCreate] -command {createReport}

spinbox .repJahrSB -width 4

message .news -textvar news -pady 10 -padx 10 -bd 3 -relief sunken -justify center -width 1000 -anchor n -bg steelblue3

pack [frame .n.t3.topF -padx 15 -pady 15] -fill x
pack [frame .n.t3.mainF -padx 15 -pady 15] -fill both -anchor nw
pack [frame .n.t3.botF] -fill x

pack [frame .n.t3.leftF] -in .n.t3.mainF -side right -expand 1 -fill both -anchor nw
pack [frame .n.t3.rightF] -in .n.t3.mainF -side left -fill y 

pack [frame .n.t3.rightF.saichF] -fill x
pack .repCreateBtn -in .n.t3.rightF.saichF -side left
pack .repJahrSB -in .n.t3.rightF.saichF -side left -padx 20
pack .repM -in .n.t3.rightF -anchor nw -pady 20
  
  #Create canvas, text window & scrollbar - height & width will be set by createReport
  canvas .repC -bg beige -height 500 -width 750
  text .repT

  scrollbar .repSB -orient vertical
  .repT conf -yscrollcommand {.repSB set}
  .repSB conf -command {.repT yview}
  
  #Print button - packed later by canvasReport
  button .repPrintBtn -text "[mc reportPrint]" -bg lightgreen
  pack .repSB -in .n.t3.leftF -side right -fill y
  pack .repC -in .n.t3.leftF -side right -fill both
  pack .news -in .botF -side left -anchor center -expand 1 -fill x

######################################################################################
# T A B 4 :  C O N F I G U R A T I O N
######################################################################################


#DATENBANK ERSTELLEN & SICHERN
label .dumpdbT -text "Datenbank verwalten" -font "TkHeadingFont"
message .dumpdbM -width 800 -text "Es ist ratsam, die Datenbank regelmässig zu sichern. Durch Betätigen des Knopfs 'Datenbank sichern' wird jeweils eine Tagessicherung der gesamten Datenbank im Ordner $dumpDir abgelegt. Bei Problemen kann später der jeweilige Stand der Datenbank mit dem Kommando \n\tsu postgres -c 'psql $dbname < $dbname-\[DATUM\].sql' \n wieder eingelesen werden. Das Kommando 'psql' (Linux) muss durch den Datenbank-Nutzer in einer Konsole erfolgen."
button .dumpdbB -text "Datenbank sichern" -command {dumpdb}
pack .dumpdbT -in .n.t4.f2 -anchor nw
pack .dumpdbM -in .n.t4.f2 -anchor nw -side left
pack .dumpdbB -in .n.t4.f2 -anchor se -side right

#DATENBANK EINRICHTEN
label .confdbT -text "Datenbank einrichten" -font "TkHeadingFont"
message .confdbM -width 800 -text "Fürs Einrichten der PostgreSQL-Datenbank sind folgende Schritte nötig:\n1. Das Programm PostgreSQL über die Systemsteuerung installieren.\n2. (optional) Einen Nutzernamen für PostgreSQL einrichten, welcher von TkOffice auf die Datenbank zugreifen darf. Normalerweise wird der privilegierte Nutzer 'postgres' automatisch erstellt. Sonst in einer Konsole als root (su oder sudo) folgendes Kommando eingeben: \n\t sudo useradd postgres \n3. Den Nutzernamen und einen beliebigen Namen für die TkOffice-Datenbank hier eingeben (z.B. tkofficedb).\n4. Den Knopf 'Datenbank erstellen' betätigen, um die Datenbank und die von TkOffice benötigten Tabellen einzurichten.\n5. TkOffice neu starten und hier weitermachen (Artikel erfassen, Angaben für die Rechnungsstellung)."
label .confdbnameL -text "Name der Datenbank" -font "TKSmallCaptionFont"
label .confdbUserL -text "Benutzer" -font "TkSmallCaptionFont"
entry .confdbnameE -textvar dbname
entry .confdbUserE -textvar dbuser -validate focusin -validatecommand {%W conf -bg beige -fg grey ; return 0}
button .initdbB -text "Datenbank erstellen" -command {initdb}

#TODO testing
#pack .confdbT -in .n2.dbF -anchor nw 
#pack .confdbM -in .n2.dbF -anchor ne -side left
pack .initdbB -in .n.t4.f2 -anchor se -side right


#RECHNUNGSSTELLUNG
pack [frame .billing2F] -in .n.t4.f5 -side right -anchor ne -fill x -expand 1
label .billingT -text "Rechnungsstellung" -font "TkHeadingFont"
message .billingM -width 800 -text "Nachdem unter 'Neue Rechnung' neue Posten für den Kunden erfasst sind, wird der Auftrag in der Datenbank gespeichert (Button 'Rechnung speichern'). Danach kann eine Rechnung ausgedruckt werden (Button 'Rechnung drucken'). Dazu ist eine Vorinstallation von TeX/LaTeX erforderlich. Die neue Rechnung wird im Ordner $spoolDir als PDF gespeichert und wird (falls PostScript vorhanden?) an den Drucker geschickt. Das PDF kann per E-Mail versandt werden. Gleichzeitig wird eine Kopie im DVI-Format in der Datenbank gespeichert. Die Rechnung kann somit später (z.B. als Mahnung) nochmals ausgedruckt werden (Button: 'Rechnung nachdrucken').\n\nDie Felder rechts betreffen die Absenderinformationen in der Rechnung.\nDer Mehrwertsteuersatz ist obligatorisch (z.B. 0 (erscheint nicht) / 0.0 (erscheint)) / 7.5 usw.).\nIn den Feldern 'Zahlungskondition 1-3' können verschiedene Zahlungsbedingungen erfasst werden, welche bei der Rechnungserstellung jeweils zur Auswahl stehen (z.B. 10 Tage / 30 Tage / bar). Ein Eintrag 'bar' steht für Barzahlung und markiert die Rechnung als bezahlt. Ohne Voreinträge muss die Kondition von Hand eingegeben werden.\n\nDie in $spoolDir befindlichen PDFs können nach dem Ausdruck/Versand gelöscht werden."

radiobutton .billformatlinksRB -text "Adressfenster links (International)" -value Links -variable adrpos
radiobutton .billformatrechtsRB -text "Adressfenster rechts (Schweiz)" -value Rechts -variable adrpos
.billformatrechtsRB select

spinbox .billcurrencySB -width 5 -text Währung -values {€ £ $ CHF}

entry .billvatE
entry .billownerE
entry .billcompE
entry .billstreetE
entry .billcityE
entry .billphoneE
entry .billbankE -width 50
entry .billcond1E
entry .billcond2E
entry .billcond3E
button .billcomplogoB -text "Firmenlogo hinzufügen" -command {
  set ::logoPath [tk_getOpenFile]
  return 0
}

pack .billingT .billingM -in .n.t4.f5 -anchor nw
pack .billformatlinksRB .billformatrechtsRB -in .n.t4.f5 -anchor se -side bottom
pack .billcomplogoB .billcurrencySB .billvatE .billownerE .billcompE .billstreetE .billcityE .billphoneE .billbankE .billcond1E .billcond2E .billcond3E -in .billing2F

#Configure all entries to change colour & be emptied when focused
foreach e [pack slaves .billing2F] {
  catch {$e config -fg grey -bg beige -width 30 -validate focusin -validatecommand "
    %W delete 0 end
    $e config -bg beige -fg black -state normal
    return 0
    "
  }
}

#Configure vat entry to accept only numbers like 0 / 1.0 / 7.5
#.billvatE conf -validate key -vcmd {%W conf -bg beige ; string is double %P} -invcmd {%W conf -bg red}

button .billingSaveB -text [mc saveConf] -command {source $makeConfig ; makeConfig}
#pack .billingSaveB -in .billing2F -side bottom -anchor se

#Check if vars in config
if {[info exists vat] && $vat != ""} {.billvatE insert 0 $vat; .billvatE conf -bg "#d9d9d9"} {.billvatE conf -bg beige ; .billvatE insert 0 "Mehrwertsteuersatz %"}
if {[info exists myName] && $myName != ""} {.billownerE insert 0 $myName; .billownerE conf -bg "#d9d9d9"} {.billownerE insert 0 "Name"}
if {[info exists myComp] && $myComp != ""} {.billcompE insert 0 $myComp; .billcompE conf -bg "#d9d9d9"} {.billcompE insert 0 "Firmenname"}
if {[info exists myAdr] && $myAdr != ""} {.billstreetE insert 0 $myAdr; .billstreetE conf -bg "#d9d9d9"} {.billstreetE insert 0 "Strasse"}
if {[info exists myCity] && $myCity != ""} {.billcityE insert 0 $myCity; .billcityE conf -bg "#d9d9d9"} {.billcityE insert 0 "PLZ & Ortschaft"}
if {[info exists myPhone] && $myPhone != ""} {.billphoneE insert 0 $myPhone; .billphoneE conf -bg "#d9d9d9"} {.billphoneE insert 0 "Telefon"}
if {[info exists myBank] && $myBank != ""} {.billbankE insert 0 $myBank; .billbankE conf -bg "#d9d9d9"} {.billphoneE insert 0 "Bankverbindung"}

if {[info exists cond1] && $cond1!=""} {.billcond1E insert 0 $cond1; .billcond1E conf -bg "#d9d9d9"} {.billcond1E insert 0 "Zahlungskondition 1"}
if {[info exists cond2] && $cond2!=""} {.billcond2E insert 0 $cond2; .billcond2E conf -bg "#d9d9d9"} {.billcond2E insert 0 "Zahlungskondition 2"}
if {[info exists cond3] && $cond3!=""} {.billcond3E insert 0 $cond3; .billcond3E conf -bg "#d9d9d9"} {.billcond3E insert 0 "Zahlungskondition 3"}
if [info exists currency] {.billcurrencySB conf -bg "#d9d9d9" -width 5; .billcurrencySB set $currency}


########################################################
# T A B  5  - S P E S E N
########################################################

label .titel6 -text "[mc spesen]" -font TIT -anchor nw -fg steelblue -bg silver 
message .spesenM -width 400 -anchor nw -justify left -text "[mc spesenTxt]" 
listbox .spesenLB -width 100 -height 40 -bg lightblue

#TODO? listboxes have no yview concept, but are still scrollable!
#scrollbar .spesenSB -orient vertical
#.spesenLB conf -yscrollcommand {.spesenSB set}
#.spesenSB conf -command {.spesenSB yview}

button .spesenB -text "Jahresspesen verwalten" -command {manageExpenses}
button .spesenDeleteB -text "Eintrag löschen" -command {deleteExpenses}
button .spesenAbbruchB -text [mc cancel] -command {manageExpenses}
button .spesenAddB -text "Eintrag hinzufügen" -command {addExpenses}

entry .expnameE
entry .expvalueE

#TODO Spesenverwaltung buggy, needs exit button & must be cleared at the end!
##moved to EINSTELLUNGEN tab!
pack .titel6 -in .n.t6 -fill x -padx 20 -pady 20
pack .spesenM .spesenB -in .n.t6 -anchor nw -padx 20 -pady 20 

####################################################
# T A B  6 - S T O R N I
#####################################################
label .titel5 -text "[mc storni]" -font TIT -anchor nw -fg steelblue -bg silver 
message .storniM -width 400 -anchor nw -justify left -text "[mc storniTxt]" 

entry .stornoE -bg beige -justify left -validate focusout -vcmd {storno %s;return 0}

pack .titel5 -in .n.t5 -anchor nw -pady 25 -padx 25 -fill x
pack .storniM .stornoE -in .n.t5 -pady 25 -padx 25 -side left -anchor nw


#####################################################
# T A B  7  -  A R T I K E L 
#####################################################
label .titel7 -text "[mc artManage]" -font TIT -anchor nw -fg steelblue -bg silver 
pack .titel7 -in .n.t7 -fill x
#label .confartT -text "[mc artManage]" -font "TkHeadingFont"

message .confartM -width 800 -text "[mc artTxt]"
label .artL -text "Artikelliste" -font "TkHeadingFont"

#pack .titel7 .confartM .artL -in .n.t7 -anchor nw -pady 20 -padx 20


#These are packed/unpacked later by article procs
label .confartL -text "Artikel Nr."

namespace eval artikel {
  label .confartnameL -padx 7 -width 25 -textvar artName -anchor w
  label .confartpriceL -padx 10 -width 7 -textvar artPrice -anchor w
  label .confartunitL -padx 10 -width 7 -textvar artUnit -anchor w
  label .confarttypeL -padx 10 -width 1 -textvar artType -anchor w
}
spinbox .confartnumSB -width 5 -command {setArticleLine TAB4}
button .confartsaveB -text [mc artSave] -command {saveArticle}
button .confartdeleteB -text [mc artDelete] -command {deleteArticle} -activebackground red
button .confartcreateB -text [mc artCreate] -command {createArticle}
entry .confartnameE -bg beige
entry .confartunitE -bg beige -textvar artikel::rabatt
entry .confartpriceE -bg beige
ttk::checkbutton .confarttypeACB -text "Auslage"
ttk::checkbutton .confarttypeRCB -text "Rabatt"

#TODO
#pack .confartcreateB -in .n.t7






#######################################################################
## F i n a l   a 	c t i o n s :    detect Fehlermeldung bzw. socket no.
#######################################################################
proc gerekmi {} {
if {[string length $res] >20} {
  NewsHandler::News $res red 
  .confdbnameE conf -text "Datenbankname eingeben" -validate focusin -validatecommand {%W conf -bg beige -fg grey ; return 0}
  .confdbUserE conf -text "Datenbanknutzer eingeben" -validate focusin -validatecommand {%W conf -text "Name eingeben" -bg beige -fg grey ; return 0}
  return 1
}

#Verify DB state
NewsHandler::QueryNews "Mit Datenbank verbunden" lightgreen
set db $res
.confdbnameE conf -state disabled
.confdbUserE conf -state disabled
.initdbB conf -state disabled

}

#TODO try below - separating "New invoice" procs from "Show old invoice" procs in tkoffice-invoice.tcl
#source [file join $progDir tkoffice-invoice.tcl]


# E x e c u t e   p r o g s
setAdrList
resetAdrWin
resetNewInvDialog
updateArticleList
resetArticleWin

#setArticleLine TAB2
setArticleLine TAB4

#Execute once when specific TAB opened
bind .n <<NotebookTabChanged>> {
  set selected [.n select]
  if {$selected == ".n.t3"} {
    set t3 1
  }
}

resetNewInvDialog
#resetArticleWin
setAbschlussjahrSB
createArtMenu
