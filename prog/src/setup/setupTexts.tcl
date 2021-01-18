# ~/Biblepix/prog/src/setup/setupTexts.tcl
# Provides German & English text snippets
# sourced by setupGUI.tcl & error messages
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7jan21 pv

proc setTexts {lang} {
  global BdfBidi platform jahr TwdTIF TwdBMP TwdPNG dirlist
  set ::lang $lang
  
  #### G E N E R A L ###############################
  set DW(de) {'Das Wort'}
  set DW(en) {'The Word'}
  set dw $DW($lang)
  set ::dw $dw

  set BP(en) BiblePix
  set BP(de) BibelPix
  set bp $BP($lang)
  set ::bp $bp

  #Buttons
  set cancel(de) "Abbruch"
  set cancel(en) "Cancel"
  set ::cancel $cancel($lang)

  set save(de) "Speichern"
  set save(en) "Save"
  set ::save $save($lang)

  set saveSettings(de) "Einstellungen speichern"
  set saveSettings(en) "Save settings"
  set ::saveSettings $saveSettings($lang)

  # # # #  M I S S I N G   P A C K A G E  # # # # # # # # # # # #                               

set packageRequireImg(all) "\n* apt-get install libtk-img (Debian/Ubuntu)\n* emerge tkimg (Gentoo)\n* zypper install tkimg (openSUSE)\n* yum install tkimg (Fedora)\n* urpmi tkimg (Mandriva)"
set packageRequireImg(en) "$bp needs the Tcl 'tkimg' extension.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo):\n$packageRequireImg(all)"
set packageRequireImg(de) "$bp benötigt die Tcl-Erweiterung 'tkimg'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n$packageRequireImg(all)"
set ::packageRequireImg $packageRequireImg($lang)

set packageRequireTDom(all) "\n* apt-get install tdom (Debian/Ubuntu)\n* emerge tdom (Gentoo)\n* zypper install tdom (openSUSE)\n* yum install tdom (Fedora)\n* urpmi tdom (Mandriva)" 
set packageRequireTDom(en) "$bp needs the Tcl 'tDom' extension.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo):\n$packageRequireTDom(all)"
set packageRequireTDom(de) "$bp benötigt die Tcl-Erweiterung 'tDom'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n$packageRequireTDom(all)"
set ::packageRequireTDom $packageRequireTDom($lang)

set packageRequireTls(all) "\n* apt-get install tcl-tls (Debian/Ubuntu)\n* emerge dev-tcltk/tls (Gentoo)"
set packageRequireTls(en) "$bp needs the Tcl 'TLS' extension.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo):\n$packageRequireTls(all)"
set packageRequireTls(de) "$bp benötigt die Tcl-Erweiterung 'TLS'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n$packageRequireTls(all)"
set ::packageRequireTls $packageRequireTls($lang)

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

  set noTwdFilesFound(en) "Es sind keine aktuellen Bibeltextdateien installiert.\nBitte wählen Sie im BibelPix-Setup mindestens \n1 Sprachdatei aus der Rubrik 'International'."
  set noTwdFilesFound(de) "No current Bible text files are installed.\nIn the BiblePix Setup, choose at least \n one language text file from the 'International' section."
  set ::noTwdFilesFound $noTwdFilesFound($lang)

  set connTwd(en) "Connection to bible2.net established."
  set connTwd(de) "Verbindung zu bible2.net hergestellt."
  set ::connTwd $connTwd($lang)

  set noConnTwd(en) "No connection to bible2.net. Try later."
  set noConnTwd(de) "Keine Verbindung zu bible2.net. Versuchen Sie es später."
  set ::noConnTwd $noConnTwd($lang)

  set bpsetup(de) "$bp Einrichtungsprogramm"
  set bpsetup(en) "$bp Setup"
  set ::bpsetup $bpsetup($lang)

  set refresh(en) "Update"
  set refresh(de) "Aktualisieren"
  set ::refresh $refresh($lang)

  set delete(en) "Delete file"
  set delete(de) "Datei löschen"
  set ::delete $delete($lang)

  #Create RtL info on text positioning
  set RtlInfo ""
  ##Hebrew
  if {! [catch "glob $dirlist(twdDir)/he_*"]} {
    set RtlHe "טקסט בכתב עברי יוזז לצד הנגדי באופן אוטומטי."
    if {$platform=="unix"} {
      set RtlHe [string reverse $RtlHe]
    }
    append RtlInfo $RtlHe
  }
  ##Arabic
  if {! [catch "glob $dirlist(twdDir)/ar_*"]} {
    set RtlAr "النص باللغة العربية ينتقل تلقائياً للجهة المقابلة."
    if {$platform=="unix"} {
      source $BdfBidi
      set RtlAr [bidi $RtlAr ar revert]
      #set RtlInfo [bidi $RtlInfo ar]
    }
    append RtlInfo $RtlAr
  }

  set textpos(en) "Adjust text position *"
  set textpos(de) "Textposition anpassen *"
  set ::textpos $textpos($lang)

  set textposFN(en) "* Text positioning can be corrected for individual pictures when adding to the $bp photo collection.\n$RtlInfo"
  set textposFN(de) "* Beim Hinzufügen von Bildern zur $bp-Fotosammlung kann die Textposition individuell angepasst werden.\n$RtlInfo"
  set ::textposFN $textposFN($lang)
  
  set textposWait(en) "Please wait a moment while computing ideal text position and luminance..." 
  set textposWait(de) "Warten Sie einen Augenblick, bis wir die ideale Textposition und -helligkeit berechnet haben..."
  set ::textpos.wait $textposWait($lang)
  
  set welcTit(en) "Welcome to the $bp setup program!"
  set welcTit(de) "Willkommen beim Einrichtungsprogramm von $bp!"
  set ::welc.tit $welcTit($lang)

  set welcSubtit1(en) "What is $bp?"
  set welcSubtit1(de) "Was ist $bp?"
  set ::welc.subtit1 $welcSubtit1($lang)

  set welcTxt1(en) "$bp is a Tcl program developed for the 'Bible 2.0' project which aims to publish $dw\nin a growing number of languages.\n$dw consists of two selected Bible verses for each day of the year.\n\n$bp can display $dw in various ways on your computer."
  set welcTxt1(de) "$bp ist ein Tcl-Programm, das für das Projekt 'Bibel 2.0' geschrieben wurde.\n'Bibel 2.0' setzt sich zum Ziel, $dw \u2014 2 ausgewählte Bibelsprüche für jeden Tag des Jahres \u2014 in einer wachsenden Anzahl von Sprachen zu verbreiten.\n\n$bp kann $dw in vielfältiger Weise auf Ihrem PC anzeigen."
  set ::welc.txt1 $welcTxt1($lang)

  set welcSubtit2(en) "What are your options?"
  set welcSubtit2(de) "Was sind Ihre Möglichkeiten?"
  set ::welc.subtit2 $welcSubtit2($lang)

  set welcTxt2(en) "° INTERNATIONAL:\tChoose one or several Bible text languages for $dw\n° DESKTOP:\t\tGet $dw on your personal background pictures, incl. slide show\n° PHOTOS:\t\tOrganise your background pictures for $bp\n° E-MAIL:\t\t\tGet $dw added to your e-mail signatures each day"
  set welcTxt2(de) "° INTERNATIONAL:\tWählen Sie eine oder mehrere Sprachen für den Bibeltext\n° DESKTOP:\t\tBetrachten Sie $dw auf Ihren persönlichen Hintergrundbildern\n° PHOTOS:\t\tWählen Sie eigene Hintergrundbilder für $bp aus\n° E-MAIL:\t\t\tFügen Sie $dw an Ihre E-Mails an"
  set ::welc.txt2 $welcTxt2($lang)

  set welcTxt3(en) "° TERMINAL:\t\tShow $dw in your Linux terminals"
  set welcTxt3(de) "° TERMINAL:\t\tBetrachten Sie $dw in Ihren Linux-Konsolen"
  set ::welc.txt3 $welcTxt3($lang)

  set welcTxt4(de) "° MANUAL:\t\tStudieren Sie das komplette Handbuch von $bp"
  set welcTxt4(en) "° MANUAL:\t\tStudy the Complete Guide to the $bp program"
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

  set language(en) "Language"
  set language(de) "Sprache"
  set ::language $language($lang)

  set year(en) "Year"
  set year(de) "Jahr"
  set ::year $year($lang)

  set bibleversion(en) "Bible version"
  set bibleversion(de) "Bibelausgabe"
  set ::bibleversion $bibleversion($lang)

  set f1Txt(en) "$bp will create $dw in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select for download (see below) will be downloaded upon clicking the 'Download' button. Pay attention to the year (current or next)!"
  set f1Txt(de) "$bp stellt $dw in allen Sprachen und Bibelausgaben bereit, die auf Ihrem Computer installiert sind. Sind mehrere Bibeltextdateien installiert, wählt $bp jeweils zufällig eine aus. Wenn Sie neue Bibeltextdateien zum Download markieren (s. unten), werden diese heruntergeladen, sobald Sie die Taste 'Download' drücken. Achten Sie auf den Jahrgang (laufendes oder nächstes Jahr)!"  
  set ::f1.txt $f1Txt($lang)

  set f2Tit(en) "Put $dw on your background images"
  set f2Tit(de) "$dw auf Desktop-Hintergrundbild"
  set ::f2.tit $f2Tit($lang)

  set f2Box(en) "Create background image"
  set f2Box(de) "Hintergrundbild erzeugen"
  set ::f2.box $f2Box($lang)  
          
  set f2Farbe(en) "Font colour: "
  set f2Farbe(de) "Schriftfarbe: "
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

  set f2Fontsize(en) "Font size: "
  set f2Fontsize(de) "Schriftgrösse: "
  set ::f2.fontsizetext $f2Fontsize($lang)

  set f2Fontweight(en) "bold"
  set f2Fontweight(de) "fett"
  set ::f2.fontweight $f2Fontweight($lang)

  set f2Fontfamily(en) "Font family: "
  set f2Fontfamily(de) "Schriftart: "
  set ::f2.fontfamilytext $f2Fontfamily($lang)

  set f2Fontexpl(en) "Adjust Font"
  set f2Fontexpl(de) "Schrift anpassen"
  set ::f2.fontexpl $f2Fontexpl($lang)

  set ::f2ar_txt "\ufe8d\ufedf\ufedc\ufee0\ufee4\ufe94"
  #set ::f2ar_txt "كَلاَمك"
  set ::f2he_txt "הדבר"
  set ::f2ltr_txt "The Word 每日金句 Калом"
  set ::f2thai_txt "พระคำสำหรับวันศุกร์ Слово"

  if {$platform=="unix"} {
  #unix needs BMP+PNG
    set formats "'[file tail $TwdBMP]' & '[file tail $TwdPNG]'"
    set picN(de) "in 2 Formaten: $formats"
    set picN(en) "in 2 formats: $formats"
    set picNo $picN($lang)
  } else {
  #win has only TIF
    set picNo ": '[file tail $TwdTIF]'"
  }

  set f2Txt(en) "\nIf activated, $bp will put $dw on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see Photos section), and a new background image $picNo will be put in \n\n\t [file nativename $dirlist(imgdir)] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\n$bp will set up a Slide Show with alternating pictures at a given interval. For only 1 picture per day, unset this feature (see above).\n\nThe Text Position window allows you to put $dw wherever you like on your screen. \n\nThe font size is set automatically on the basis of the screen height. You may however change letter size and weight to taste (bigger letters = better contrast).\n\nIf the new background image fails to appear automatically, please consult the Manual page for a solution."
  set f2Txt(de) "\nWenn aktiviert, zaubert $bp $dw auf ein Hintergrundbild. Das Foto wird im Zufallsprinzip aus der $bp-Fotosammlung ausgewählt (s. Rubrik Photos). Ein neues Hintergrundbild $picNo steht jeweils in \n\n\t [file nativename $dirlist(imgdir)] \n\nzur Anzeige für den Desktop-Manager bereit. \n\nSofern mehrere Bibeltextdateien installiert sind, wechselt bei jedem Bildwechsel auch die Sprache bzw. Bibelversion im Zufallsprinzip.\n\n$bp richtet standardmässig eine 'Diaschau' mit Wechselbild ein. Soll nur 1 Bild pro Tag angezeigt werden, kann die Diaschau deaktiviert werden (s.o.).\n\nIm Fenster 'Textposition' können Sie $dw an die gewünschte Stelle auf dem Bildschirm verschieben. \n\nDie Schriftgrösse wird automatisch aufgrund der Bildschirmhöhe gesetzt. Sie haben jedoch die Möglichkeit, Grösse und Dicke anzupassen (grössere Buchstaben = besserer Kontrast).\n\nFalls das neue Hintergrundbild nicht automatisch erscheint, finden Sie im Manual eine Lösung."
  set ::f2.txt $f2Txt($lang)

  ### S E T U P   P H O T O S ##############################
  set f6Tit(en) "Manage your photos for $bp"
  set f6Tit(de) "Fotos für $bp organisieren"
  set ::f6.tit $f6Tit($lang)

  set f6Txt(en) "Here you can add any suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. Photos should ideally be in landscape format and have some plain-colour surface for good visibility of the Bible text.\n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory. If refitting is required, you will be asked to choose the desired section of the photo as well as the position of future Bible texts.\n\nAt any rate, the original photo remains unchanged."
  set f6Txt(de) "Hier können Sie beliebig viele Fotos aus Ihrem persönlichen Bildordner in die $bp-Fotosammlung ziehen. Die Fotos sollten im Querformat aufgenommen sein und möglichst eine ebenfarbige Fläche für gute Lesbarkeit des Bibelspruchs aufweisen.\n\n$bp speichert eine Kopie des Bildes im $bp-Fotoordner ab und ändert das Bildformat sowie die Grösse, falls es nicht mit den Bildschirmdimensionen übereinstimmt. Sie haben in diesem Fall die Möglichkeit, den passenden Bildausschnitt sowie die künftige Position des Bibeltextes selber zu bestimmen.\n\nDas Originalbild bleibt in jedem Fall unverändert."
  set ::f6.txt $f6Txt($lang)  

  set f6numPhotosTxt(de) "Anzahl Bilder: "
  set f6numPhotosTxt(en) "Number of Pictures: "
  set ::numPhotosTxt $f6numPhotosTxt($lang) 

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

  #RESIZING
  set resizeF_txt(de) "Ihr Foto passt nicht zur Bildschirmgrösse und muss zugeschnitten werden. Verschieben Sie den Bildausschnitt nach Wunsch und drücken Sie Ok zum Speichern."
  set resizeF_txt(en) "The size of your photo does not correspond to the screen size and has to be trimmed. Move to select the desired section and press Ok to save."
  set ::resizeF_txt $resizeF_txt($lang)

  set movePicToResize(en) "Move picure section to desired position and press Ok to resize."
  set movePicToResize(de) "Verschieben Sie den Bildausschnitt nach Wunsch und bestätigen Sie mit Ok zum Speichern."
  set ::movePicToResize $movePicToResize($lang)

  set resizingPic(en) "Resizing photo to fit screen \u2014 please wait a moment..."
  set resizingPic(de) "Passe Bildgrösse dem Bildschirm an \u2014 bitte haben Sie einen Augenblick Geduld..."
  set ::resizingPic $resizingPic($lang) 

  set movePic(de) "Bildausschnitt verschieben \u21CA"
  set movePic(en) "Move picture section \u21CA"
  set ::movePic $movePic($lang)

  set picSchonDa(en) "Photo already in $bp Photos folder"
  set picSchonDa(de) "Foto bereits im $bp-Bildordner"
  set ::picSchonDa $picSchonDa($lang)

  ### S E T U P   S I G N A T U R E  #######################
  set f3Tit(en) "Add $dw to your e-mail signatures"

  set f3Tit(de) "$dw auf Ihren E-Mail-Signaturen"
  set ::f3.tit  $f3Tit($lang)

  set f3Btn(en) "Create e-mail signature"
  set f3Btn(de) "E-Mail-Signatur erzeugen"
  set ::f3.btn $f3Btn($lang)

  set f3Sprachen(de) "Gewünschte Sprachen: "
  set f3Sprachen(en) "Desired languages: "
  set ::f3.sprachen $f3Sprachen($lang)
  
  set f3Txt(en) "If activated, $bp will add $dw at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en_Englis.txt) in the directory \n\n\t$dirlist(sigdir) \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \n\nYou may not desire $dw to appear in your mails in all languages installed. In the checkboxes top right, please choose those languages you deem appropriate for your mail recipients.\n\nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures).\n\nCertain programs like Seamonkey Mail, Evolution or Trojitá manage signatures internally. Among these $bp can handle Trojitá and Evolution for now."
  set f3Txt(de) "Wenn aktiviert, fügt $bp einmal täglich für jede installierte Bibeltextdatei $dw an Ihre E-Mail-Signaturen an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schlac.txt) im folgenden Ordner gespeichert: \n\n\t$dirlist(sigdir) \n\nSie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie ==== bleibt beim Wechsel von $dw unbehelligt. \n\nVielleicht möchten Sie nicht, dass Ihre Mail-Empfänger $dw in allen Sprachen lesen, die Sie installiert haben. Wählen Sie oben rechts die gewünschte(n) Sprache(n) aus.\n\nDamit $dw künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen>Signatur).\n\nGewisse Programme wie Seamonkey Mail, Evolution oder Trojitá verwalten Signaturen intern. $bp kann darunter vorläufig Trojitá und Evolution  berücksichtigen."
  set ::f3.txt $f3Txt($lang)

  set f3Expl(en) "
Yours faithfully,
Peter Vollmar
Homepage: www.vollmar.ch
The Word: www.biblepix.vollmar.ch
"

  set f3Expl(de) "
Mit freundlichem Gruss
Peter Vollmar
Homepage: www.vollmar.ch
Das Wort: www.biblepix.vollmar.ch
"  
  set ::f3dw $f3Expl($lang)

  set f4Tit(en)  "Display $dw in your Linux terminals"
  set f4Tit(de)  "$dw in Ihren Linux-Terminals"
  set ::f4.tit $f4Tit($lang)

  set f4Btn(en) "Create $dw for display in terminal"
  set f4Btn(de) "$dw zur Anzeige im Terminal erzeugen"
  set ::f4Btn $f4Btn($lang)

  set f4Txt(en) "If activated, $bp will create $dw to be displayed at the top of your terminals. If more than one language file are present, Bible text will alternate randomly whenever a new shell is opened. \n\nColours for display etc. may be changed in \n\n\t $dirlist(confdir)/term.conf \n\nNote that for Arabic or Hebrew display, 'mlterm', 'gnome-terminal', 'Konsole' (KDE) or 'xfce4-terminal' are known to work with bidirectional text.\n\nFor $dw to be displayed automatically in your terminals, $bp Setup makes an entry in ~/.bashrc for your convenience."
  set f4Txt(de) "Wenn aktiviert, erzeugt $bp $dw für die Anzeige in Ihren Konsolen. Sind mehrere Bibeltextdateien vorhanden, wechselt der Text bei jedem Öffnen eines Terminals. \n\nDarstellung und Farben können in \n\n\t $dirlist(confdir)/term.conf \n\ngeändert werden.\n\nFür die Darstellung von Hebräisch oder Arabisch kommen nur Terminals wie 'mlterm', 'gnome-terminal', 'xfce4-terminal' oder 'Konsole' (KDE) in Frage, die bidirektionellen Text korrekt anzeigen. \n\nDamit $dw automatisch im Terminal angezeigt wird, macht das $bp-Setup einen Eintrag in ~/.bashrc."
  set ::f4.txt $f4Txt($lang)

  set ::f4.ex  "
Beispiel:"

  set ::f4.ex  "
Example:"
  

  ######## S E T U P S A V E   T E X T S  ################################

  #Changing Desktops Info
  set linChangingDesktop(de) "BibelPix versucht nun, Ihre Desktop-Einstellungen zu ändern. Falls Sie danach kein neues Hintergrundbild sehen, finden Sie eine Lösung im Manual."
  set linChangingDesktop(en) "BiblePix will now try to register with your Desktop Background. If you can't see a new background picture after that, find a solution in the Manual."
  set ::linChangingDesktop $linChangingDesktop($lang)

  set winChangingDesktop(de) "$linChangingDesktop($lang) \nKlicken Sie im Dialogfenster auf das BibelPix-Thema und schliessen Sie dann das Fenster."
  set winChangingDesktop(en) "$linChangingDesktop($lang)\nIn the Desktop dialogue box, choose the BiblePix theme and then close the window."
  set ::winChangingDesktop $winChangingDesktop($lang)

  set winChangeDesktopProb(de) "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nBitte rechtsklicken Sie auf Ihrem Desktop und wählen Sie \"Anpassen\"', dort finden Sie das BibelPix-Thema.\nKlicken Sie darauf, um es zu aktivieren, dann schliessen Sie das Fenster."
  set winChangeDesktopProb(en) "We are having a problem changing your Desktop background.\nPlease right-click on your Desktop and select \"Customize\".\nFind the BiblePix theme, click on it and then close the window."
  set ::winChangeDesktopProb $winChangeDesktopProb($lang)

  set linChangeDesktopProb(de) "Wir hatten ein Problem mit der Änderung der Desktopeinstellungen.\nBitte rechtsklicken Sie auf Ihrer Arbeitsfläche und finden Sie den Dialog für 'Hintergrundbild'. Dort geben Sie $dirlist(imgdir) als Bildpfad an."
  set linChangeDesktopProb(en) "We are having a problem changing your Desktop settings.\nPlease right-click on your Desktop and find the dialogue for 'Background picture'. There indicate $dirlist(imgdir) as new image path."
  set ::linChangeDesktopProb $linChangeDesktopProb($lang)

  set linSetAutostartProb(de) "Wir hatten ein Problem mit der Einrichtung des Autostarts.\nDamit $bp beim PC-Start ausgeführt wird, ist ein Eintrag im Autostart-Menü Ihres PCs nötig. Finden Sie den Dialog 'Automatisch ausgeführte Programme'. Dort geben Sie '$::Biblepix' als neuen Programmpfad ein.\nWeitere Lösungen finden Sie im Manual."
  set linSetAutostartProb(en) "We had a problem configuring $bp Autostart.\n In order for $bp to run at computer boot time, you must make an entry in the Autostart menu of your PC. Find the dialog 'Automatically executed programs'. There enter '$::Biblepix' as the new program path.\nFor other solutions consult the Manual."
  set ::linSetAutostartProb $linSetAutostartProb($lang)

  set linReloadingDesktop(en) "We shall now try to reload your Desktop. If this fails, please log out and in again for the BiblePix settings to take effect."
  set linReloadingDesktop(de) "Wir versuchen nun, Ihre Arbeitsfläche neu einzulesen. Falls dies fehlschlägt, müssen Sie sich kurz ab- und wieder anmelden, damit die BibelPix-Einstellungen wirksam werden."
  set ::linReloadingDesktop $linReloadingDesktop($lang)

  set changeDesktopOk(en) "$bp has been configured successfully and will start shortly.\nYou can run the BiblePix Setup program anytime by selecting the \"BiblePix Setup\" icon in the Program Menu."
  set changeDesktopOk(de) "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\nDas BibelPix-Einrichtungsprogramm können Sie jederzeit aus dem Programmmenü starten."
  set ::changeDesktopOk $changeDesktopOk($lang)

  set winRegister(en) "BiblePix will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
  set winRegister(de) "BiblePix muss nun auf Ihrem System registriert werden.\nBitte bestätigen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\"!"
  set ::winRegister $winRegister($lang)

  set winRegisterProb(en) "BiblePix has not been registered properly on your computer.\nPlease find the location $dirlist(windir) and execute $dirlist(windir)/install.reg by double-clicking on it, or restart Setup."
  set winRegisterProb(de) "BibelPix ist auf Ihrem Computer noch nicht korrekt installiert.\nBitte gehen Sie nach $dirlist(windir) und führen Sie die Datei $dirlist(windir)/install.reg durch Doppelklick aus, oder starten Sie das Setup nochmals."
  set ::winRegisterProb $winRegisterProb($lang)

  #PHOTOS
  set reposSaved(de) "Bild mit Positionsinfo gespeichert."
  set reposSaved(en) "Picture saved with text position info."
  set ::reposSaved $reposSaved($lang) 

  set reposNotSaved(de) "Bild nicht gespeichert."
  set reposNotSaved(en) "Picture not saved."
  set ::reposNotSaved $reposNotSaved($lang)

  set noPhotosFound(de) "Im $bp-Fotoordner wurden keine Fotos gefunden. Kopieren Sie bitte einige Bilder in den Ordner."
  set noPhotosFound(en) "No photos were found in the $bp Photos folder. Please copy some pictures into the folder."
  set ::noPhotosFound $noPhotosFound($lang)

  set rotatePic(de) "Bild drehen"
  set rotatePic(en) "Rotate picture"
  set ::rotatePic $rotatePic($lang)
  
  set preview90(de) "\u21B7 Vorschau 90° Drehung"
  set preview90(en) "\u21B7 Preview 90° rotation"
  set ::preview90 $preview90($lang)

  set preview180(de) "\u21BB Vorschau 180° Drehung"
  set preview180(en) "\u21BB Preview 180° rotation"
  set ::preview180 $preview180($lang)
  
  set computePreview(de) "\u21B6 \u21B7 Vorschau beliebige Drehung"
  set computePreview(en) "\u21B6 \u21B7 Preview any rotation"
  set ::computePreview $computePreview($lang)
  
  set rotateWait(de) "Bitte haben Sie eine Weile Geduld, bis die Drehung am Originalbild abgeschlossen ist..."
  set rotateWait(en) "Please wait patiently while rotating original picture..."
  set ::rotateWait $rotateWait($lang)
  
} ;#END setTexts

proc copiedPicMsg {picPath} {
  global dirlist lang
  if {$lang == "en"} {
    return "Copied [file tail $picPath] to [file nativename $dirlist(photosDir)]"
  } elseif {$lang == "de"} {
    return "[file tail $picPath] nach [file nativename $dirlist(photosDir)] kopiert"
  }
}

proc deletedPicMsg {picPath} {
  global dirlist lang
  if {$lang == "en"} {
    return "Deleted [file tail $picPath] from [file nativename $dirlist(photosDir)]"
  } elseif {$lang == "de"} {
    return "[file tail $picPath] aus [file nativename $dirlist(photosDir)] gelöscht"
  }
}

