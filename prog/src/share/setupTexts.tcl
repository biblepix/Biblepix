# ~/Biblepix/prog/src/gui/setupTexts.tcl
# sourced by setupGUI.tcl & error messages
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7jan17

proc setReadmeText {lang} {
#Isolates Readme text from <de> to </de> usw.
global readmetext
	set BEG [string first "\<$lang" $readmetext]
	set END [string first "\<\/$lang" $readmetext]
	set readmeLang [string range $readmetext $BEG $END]   
	.n.f5.man replace 1.1 end $readmeLang 
	return $readmeLang
}

proc findSetupIcon {lang} {
#called by setTexts
	global platform
	if {$platform=="windows"} {
		set findSetup(en) "by right-clicking on your Desktop"
		set findSetup(de) "indem Sie auf Ihrer Arbeitsfläche rechtsklicken"
	} else {
		set findSetup(en) "by going to your System's program menu"
		set findSetup(de) "indem Sie zum Programm-Menü Ihres Systems gehen"
	}
	return $findSetup($lang)
}

proc setTexts {lang} {
#exports text variables for current language
global jahr TwdTIF TwdBMP TwdPNG imgdir sigdir unixdir windir

#### G E N E R A L ###############################
set DW(de) {'Das Wort'}
set DW(en) {'The Word'}
set dw $DW($lang)
set ::dw $dw

set BP(en) BiblePix
set BP(de) BibelPix
set bp $BP($lang)
set ::bp $bp
               
#### M I S S I N G   P A C K A G E  ############                              

set packageRequireImg(all) "\n* apt-get install libtk-img (Debian/Ubuntu)\n* emerge tkimg (Gentoo)\n* zypper install tkimg (openSUSE)\n* yum install tkimg (Fedora)\n* urpmi tkimg (Mandriva)"
set packageRequireTDom(all) "\n* apt-get install tdom (Debian/Ubuntu)\n* emerge tdom (Gentoo)\n* zypper install tdom (openSUSE)\n* yum install tdom (Fedora)\n* urpmi tdom (Mandriva)" 
set packageRequireImg(en) "$bp needs the Tcl 'tkimg' extension.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo):\n$packageRequireImg(all)"
set packageRequireImg(de) "$bp benötigt die Tcl-Erweiterung 'tkimg'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n$packageRequireImg(all)"
set ::packageRequireImg $packageRequireImg($lang)

set packageRequireTDom(en) "$bp needs the Tcl 'tDom' extension.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo):\n$packageRequireTDom(all)"
set packageRequireTDom(de) "$bp benötigt die Tcl-Erweiterung 'tDom'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n$packageRequireTDom(all)"
set ::packageRequireTDom $packageRequireTDom($lang)


#### S E T U P   G U I ################################

set downloadingHttp(en) "Downloading $bp program files..."
set downloadingHttp(de) "Lade $bp-Programmdateien herunter..."
set ::downloadingHttp $downloadingHttp($lang)

set updatingHttp(en) "Updating $bp program files..."
set updatingHttp(de) "Aktualisiere $bp-Programmdateien..."
set ::updatingHttp $updatingHttp($lang)

set uptodateHTTP(en) "Your program files are up-to-date."
set uptodateHTTP(de) "Ihre Programmdateien sind auf dem neusten Stand."
set ::uptodateHttp $uptodateHTTP($lang)

set noConnHTTP(en) "No Internet connection for program update, please try later."
set noConnHTTP(de) "Keine Internetverbindung für Programmaktualisierung, bitte versuchen Sie es später."
set ::noConnHttp $noConnHTTP($lang)

set gettingTwd(en) "Fetching current list of Bible text files from bible2.net..."
set gettingTwd(de) "Hole aktuelle Bibeltext-Liste von bible2.net..."
set ::gettingTwd $gettingTwd($lang)

set noTwdFilesFound(en) "Auf Ihrem PC sind noch keine Bibeltextdateien installiert.\nBitte wählen Sie im Register 'International' des Setup-Programms\nmindestens 1 Sprachdatei aus."
set noTwdFilesFound(de) "No Bible text files have been installed yet on your PC.\nPlease choose at least one language text file\nfrom the 'International' section of the Setup program."
set ::noTWDFilesFound $noTwdFilesFound($lang)

set connTwd(en) "Connection to bible2.net established."
set connTwd(de) "Verbindung zu bible2.net hergestellt."
set ::connTwd $connTwd($lang)

set noConnTwd(en) "No connection to bible2.net. Try later."
set noConnTwd(de) "Keine Verbindung zu bible2.net. Versuchen Sie es später."
set ::noConnTwd $noConnTwd($lang)

set ::bpsetup "$bp Setup"

set refresh(en) "Update"
set refresh(de) "Aktualisieren"
set ::refresh $refresh($lang)

set delete(en) "Delete file"
set delete(de) "Datei löschen"
set ::delete $delete($lang)

set textpos(en) "Text position"
set textpos(de) "Textposition"
set ::textpos $textpos($lang)

set welcTit(en) "Welcome to the $bp setup program!"
set welcTit(de) "Willkommen beim Installationsprogramm von $bp!"
set ::welc.tit $welcTit($lang)      ;#verträgt keinen Punkt im 2. Teil!

set welcSubtit1(en) "What is $bp?"
set welcSubtit1(de) "Was ist $bp?"
set ::welc.subtit1 $welcSubtit1($lang)

set welcTxt1(en) "* $bp is a Tcl program developed for the 'Bible 2.0' project\n* 'Bible 2.0' aims to publish $dw in a growing number of languages\n* $dw consists of two selected Bible verses for each day of the year\n* $bp can display $dw in various ways on your computer"
set welcTxt1(de) "* $bp ist ein Tcl-Programm, das für das Projekt 'Bibel 2.0' geschrieben wurde\n* 'Bibel 2.0' will $dw in einer wachsenden Anzahl Sprachen verbreiten \n* $dw besteht aus 2 ausgewählten Bibelsprüchen für jeden Tag des Jahres\n* $bp kann $dw in vielfältiger Weise auf Ihrem PC anzeigen"
set ::welc.txt1 $welcTxt1($lang)

set welcSubtit2(en) "What are your options?"
set welcSubtit2(de) "Was sind Ihre Möglichkeiten?"
set ::welc.subtit2 $welcSubtit2($lang)

set welcTxt2(en) "* INTERNATIONAL: Choose one or several Bible text languages for $dw
* DESKTOP: Get $dw on your personal background pictures, incl. slide show
* PHOTOS: Organise your background pictures for $bp
* E-MAIL: Get $dw added to your e-mail signatures each day"
set welcTxt2(de) "* INTERNATIONAL: Wählen Sie eine oder mehrere Sprachen für den Bibeltext
* DESKTOP: Betrachten Sie $dw auf Ihren persönlichen Hintergrundbildern
* PHOTOS: Wählen Sie eigene Hintergrundbilder für $bp aus
* E-MAIL: Fügen Sie $dw an Ihre E-Mails an"
set ::welc.txt2 $welcTxt2($lang)

set welcTxt3(en) "* TERMINAL: Show $dw in your Linux/Mac terminals"
set welcTxt3(de) "* TERMINAL: Betrachten Sie $dw in Ihren Linux/Mac-Konsolen"
set ::welc.txt3 $welcTxt3($lang)

set welcTxt4(de) "* MANUAL: Studieren Sie das komplette Handbuch von $bp"
set welcTxt4(en) "* MANUAL: Study the Complete Guide to the $bp program"
set ::welc.txt4 $welcTxt4($lang)

set uninst(en) "Uninstall $bp"
set uninst(de) "$bp deinstallieren"	
set ::uninst $uninst($lang)

set f1Tit(en) "Current list of languages for $dw"
set f1Tit(de) "Aktuelle Sprachliste für $dw"
set ::f1.tit $f1Tit($lang)

set TwdLocalTit(en) "Bible text files installed for $jahr"
set TwdLocalTit(de) "Für $jahr installierte Bibeltextdateien"
set ::f1.twdlocaltit $TwdLocalTit($lang)

set TwdRemoteTit(en) "Bible text files for download"
set TwdRemoteTit(de) "Bibeltextdateien zum Herunterladen"
set ::f1.twdremotetit $TwdRemoteTit($lang)

set TwdRemoteTit2(en) "Language\tYear\t\tBible Version"
set TwdRemoteTit2(de) "Sprache\tJahr\t\tBibelausgabe"
set ::f1.twdremotetit2 $TwdRemoteTit2($lang)

set f1Txt(en) "$bp will create $dw in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select (see below) will be downloaded after you click OK. Pay attention to the year (current or next)!"
set f1Txt(de) "$bp stellt $dw in allen Sprachen und Bibelausgaben bereit, die auf Ihrem Computer installiert sind. Sind mehrere Bibeltextdateien installiert, wählt $bp jeweils zufällig eine aus. Wenn Sie neue Bibeltextdateien auswählen (s. unten), werden diese heruntergeladen, sobald Sie OK drücken. Achten Sie auf den Jahrgang (laufendes oder nächstes Jahr)!"	
set ::f1.txt $f1Txt($lang)

set f2Tit(en) "Put $dw on your background images"
set f2Tit(de) "$dw auf Desktop-Hintergrundbild"
set ::f2.tit $f2Tit($lang)

set f2Box(en) "Create background image"
set f2Box(de) "Hintergrundbild aktivieren"
set ::f2.box $f2Box($lang)	
        
set f2Farbe(en) "Font colour"
set f2Farbe(de) "Schriftfarbe"
set ::f2.farbe $f2Farbe($lang)

set f2Slideshow(en) "Enable slide show"
set f2Slideshow(de) "Diaschau einrichten"
set ::f2.slideshow $f2Slideshow($lang)

set f2Interval(en) "Slide show interval: "
set f2Interval(de) "Bildwechsel alle "
set ::f2.int $f2Interval($lang)

set f2Introline(en) "Show date"
set f2Introline(de) "Datum anzeigen"
set ::f2.introline $f2Introline($lang)

set f2Fontsize(en) "Font size"
set f2Fontsize(de) "Schriftgrösse"
set ::f2.fontsizetext $f2Fontsize($lang)

set f2Fontweight(en) "bold"
set f2Fontweight(de) "fett"
set ::f2.fontweight $f2Fontweight($lang)

set f2Fontfamily(en) "Font family"
set f2Fontfamily(de) "Schriftart"
set ::f2.fontfamilytext $f2Fontfamily($lang)

set f2Fontexpl(en) "Font example"
set f2Fontexpl(de) "Schriftbeispiel"
set ::f2.fontexpl $f2Fontexpl($lang)

set ::f2ar_txt "\ufe8d\ufedf\ufedc\ufee0\ufee4\ufe94"
set ::f2he_txt "הדבר"
set ::f2ltr_txt "The Word 每日金句 Калом"
set ::f2thai_txt "พระคำสำหรับวันศุกร์"

set f2Txt(en) "\nIf activated, $bp will put $dw on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see Photos section), and three identical new background images, '[file tail $TwdBMP]', '[file tail $TwdTIF]' and '[file tail $TwdPNG]' will be put in \n\n\t\t [file nativename $imgdir] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\nThe font size is set automatically on the basis of the screen height. You may however change it by adding a plus or minus value above.\n\nIf the new background image fails to appear automatically, be sure to find a solution in the \"Manual\" section of this Setup program."
set f2Txt(de) "\nWenn aktiviert, zaubert $bp $dw auf ein Hintergrundbild. Das Foto wird im Zufallsprinzip aus der $bp-Fotosammlung ausgewählt (s. Abschnitt Photos). Ein neues Hintergrundbild in 3 Formaten, '[file tail $TwdBMP]' / '[file tail $TwdTIF]' / '[file tail $TwdPNG]' steht jeweils in \n\n\t\t [file nativename $imgdir] \n\nzur Anzeige für den Desktop-Manager bereit. \n\nSofern mehrere Bibeltextdateien installiert sind, wechselt bei jedem Bildwechsel auch die Sprache bzw. Bibelversion im Zufallsprinzip.\n\nDie Schriftgrösse wird automatisch aufgrund der Bildschirmhöhe gesetzt. Sie haben jedoch oben die Möglichkeit, einen Minus- oder Pluswert zu setzen.\n\nFalls das neue Hintergrundbild nicht automatisch erscheint, finden Sie sicher in der Rubrik \"Manual\" eine Lösung."
set ::f2.txt $f2Txt($lang)

set f6Tit(en) "Manage your photos for $bp"
set f6Tit(de) "Fotos für $bp organisieren"
set ::f6.tit $f6Tit($lang)

set f6Txt(en) "Here you can add any suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. The photos should ideally be in landscape format and have a plain-colour surface (e.g. sky) in the top-left area. \n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory."
set f6Txt(de) "Im nebenstehenden Dialog können Sie beliebig viele Fotos aus Ihrem persönlichen Bildordner in die $bp-Fotosammlung ziehen. Die Fotos sollten im Querformat aufgenommen sein und eine möglichst ebenfarbige Fläche für den Text im oberen Drittel aufweisen (z.B. Himmel). \n\nFalls die Bildgrösse nicht mit der Bildschirmgrösse übereinstimmt, speichert $bp das Foto im passenden Format im $bp-Fotoordner ab."
set ::f6.txt $f6Txt($lang)	

set f6Add(en) "Add to $bp Photo Collection:"
set f6Add(de) "Zur $bp-Fotosammlung hinzufügen:"
set ::f6.add $f6Add($lang)

set f6Show(en) "Show $bp Photo Collection"
set f6Show(de) "$bp-Fotosammlung anzeigen"
set ::f6.show $f6Show($lang)

set f6Find(en) "Find new photos"
set f6Find(de) "Neue Fotos suchen"
set ::f6.find $f6Find($lang)	

set f6Del(en) "Delete from $bp Photo Collection:"
set f6Del(de) "Aus der $bp-Fotosammlung löschen:"
set ::f6.del $f6Del($lang)

set f3Tit(en) "Add $dw to your e-mail signatures"
set f3Tit(de) "$dw auf Ihren E-Mail-Signaturen"
set ::f3.tit  $f3Tit($lang)

set f3Btn(en) "Create e-mail signature"
set f3Btn(de) "E-Mail-Signatur aktivieren"
set ::f3.btn $f3Btn($lang)

set f3Txt(en) "If activated, $bp will add $dw at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en) in the directory \n\n\t [file nativename $sigdir] \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures)."
set f3Txt(de) "Wenn aktiviert, fügt $bp einmal täglich für jede installierte Bibeltextdatei $dw an Ihre E-Mail-Signaturen an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schl) im folgenden Ordner gespeichert: \n\n\t [file nativename $sigdir] \n\nSie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie ==== bleibt beim Wechsel von $dw unbehelligt. \n\nDamit $dw künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen>Signatur)."
set ::f3.txt $f3Txt($lang)

set f3Expl(en) "
Yours faithfully,
Peter Vollmar
Homepage: www.vollmar.ch
The Word: www.biblepix.vollmar.ch
	
===== The Word for Wednesday, December 10, 2014 =====
\tBy faith the people crossed the Red Sea as on dry land,
\tbut the Egyptians, when they attempted
\tto do the same, were drowned.
\t\t\t~ Hebrews 11:29 
\tPonder the path of your feet;
\tthen all your ways will be sure.
\tDo not swerve to the right or to the left;
\tturn your foot away from evil.
\t\t\t~ Proverbs 4:26-27 
"

set f3Expl(de) "
Mit freundlichem Gruss
Peter Vollmar
Homepage: www.vollmar.ch
Das Wort: www.biblepix.vollmar.ch

===== Das Word für Mittwoch, 10. Dezember 2014 =====
\tAufgrund des Glaubens zogen die Israeliten durchs Rote Meer
\twie durch trockenes Land;
\tals die Ägypter dasselbe versuchten,
\twurden sie vom Meer verschlungen.
\t\t\t~ Hebräer 11:29 
\tEbne die Strasse für deinen Fuß,
\tund alle deine Wege seien geordnet.
\tBieg nicht ab, weder rechts noch links,
\thalt deinen Fuß vom Bösen zurück.
\t\t\t~ Sprüche 4:26-27 
"	
set ::f3.ex $f3Expl($lang)

set f4Tit(en)  "Display $dw in your Linux/Mac terminals"
set f4Tit(de)  "$dw in Ihren Linux/Mac -Terminals"
set ::f4.tit $f4Tit($lang)

set f4Txt(en) "$bp automatically creates $dw for your Unix consoles. The pertaining shell script is updated on a regular basis and can be found in \n\n\t$unixdir/term.sh \n\nIf more than one Bible text files are present, the text will alternate randomly whenever a shell is opened. \n\nFor $dw to be displayed automatically in your terminals, the following entry in ~/.bashrc is required (paste and copy into a shell):"
set f4Txt(de) "$bp stellt $dw automatisch für die Unix-Konsole zur Verfügung. Das zuständige Shell-Skript wird laufend aktualisiert und befindet sich in \n\n\t$unixdir/term.sh \n\nWenn mehrere Bibeltextdateien vorhanden sind, wechselt der Text bei jedem Öffnen eines Terminals. \n\nDamit $dw automatisch in Ihren Konsolen angezeigt wird, ist ein Eintrag in ~/.bashrc nötig. Geben Sie dazu den folgenden Befehl in einem Terminal ein:"
set ::f4.txt $f4Txt($lang)

set ::f4.ex  "
Beispiel:"

set ::f4.ex  "
Example:"
	

######## S E T U P S A V E   T E X T S  ################################

set linChangeDesktop(de) "BiblePix versucht nun, Ihre Desktop-Einstellungen zu ändern."
set linChangeDesktop(en) "BiblePix will now try to register with your Desktop Background."
set ::linChangeDesktop $linChangeDesktop($lang)

set linChangeDesktopProb(de) "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nBitte rechtsklicken Sie auf Ihrem Desktop und wählen Sie den Dialog  'Hintergrund-Einstellungen'."	
set linChangeDesktopProb(en) "We are having a problem changing your  Desktop background.\nPlease right-click on your Desktop and select 'Background Settings'."
set ::linChangeDesktopProb $linChangeDesktopProb($lang)

set winChangeDesktop(de) "$linChangeDesktop($lang) \nKlicken Sie im Dialogfenster auf das BibelPix-Thema und schliessen Sie dann das Fenster."
set winChangeDesktop(en) "$linChangeDesktop($lang)\nIn the Desktop dialogue box, choose the BiblePix theme and then close the window."
set ::winChangeDesktop $winChangeDesktop($lang)

set winChangeDesktopProb(de) "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nBitte rechtsklicken Sie auf Ihrem Desktop und wählen Sie \"Anpassen\"', dort finden Sie das BibelPix-Thema.\nKlicken Sie darauf, um es zu aktivieren, dann schliessen Sie das Fenster."	
set winChangeDesktopProb(en) "We are having a problem changing your  Desktop background.\nPlease right-click on your Desktop and select \"Customize\".\nFind the BiblePix theme, click on it and then close the window."
set ::winChangeDesktopProb $winChangeDesktopProb($lang)

set changeDesktopOk(en) "$bp has been configured successfully and will start shortly.\n\nYou can run BiblePix Setup anytime [findSetupIcon en] and selecting the \"BiblePix Setup\" icon."
set changeDesktopOk(de) "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas BibelPix-Setup können Sie jederzeit ausführen, [findSetupIcon de] und das Symbol \"BibelPix Setup\" anklicken."
set ::changeDesktopOk $changeDesktopOk($lang)

set winRegister(en) "BiblePix will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
set winRegister(de) "BiblePix muss nun auf Ihrem System registriert werden.\nBitte bestätigen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\"!"
set ::winRegister $winRegister($lang)

set winRegisterProb(en) "BiblePix has not been registered properly on your computer.\nPlease find the location $windir and execute $windir/install.reg by double-clicking on it, or restart Setup."
set winRegisterProb(de) "BibelPix ist auf Ihrem Computer noch nicht korrekt installiert.\nBitte gehen Sie nach $windir und führen Sie die Datei $windir/install.reg durch Doppelklick aus, oder starten Sie das Setup nochmals.."
set ::winRegisterProb $winRegisterProb($lang)

set KDErestart(en) "Any changes to the KDE desktop will take effect after restart. Shall we restart KDE now?"
set KDErestart(de) "Änderungen am KDE-Desktop treten erst nach Neustart in Kraft. Möchten Sie jetzt KDE neustarten?"
set ::KDErestart $KDErestart($lang)

} ;#END setTexts
