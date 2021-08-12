# ~/Biblepix/prog/msg/de.msg
# German texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
#INFO: Textmenge - 100 mcset * 3 W. = 300 W.
# Updated: 11aug21 pv
set bp {BibelPix}
set dw {'Das Wort'}

mcset es dw $dw
mcset es bp $bp
mcset es bpsetup "$bp Einrichtungsprogramm"
mcset es refresh "Aktualisieren"
mcset es delete "Datei löschen"
#Buttons
mcset es ok "Ok"
mcset es cancel "Abbruch"
mcset es close "Schliessen"
mcset es save "Speichern"
mcset es saveSettings "Einstellungen speichern"
mcset es random "zufällig"
mcset es uninst "$bp deinstallieren"
mcset es welcome "Willkommen"
mcset es bibletexts "Bibeltexte"
mcset es desktop "Hintergrundbild"
mcset es photos "Fotos"
mcset es email "E-Mail-Signatur"
mcset es terminal "Terminal/Konsole"
mcset es manual "Handbuch"
# W E L C O M E 
mcset es next "Nächstes \u25bc"
mcset es welcTit "Willkommen beim Einrichtungsprogramm von $bp!"
mcset es welcSubtit1 "Was ist $bp?"
mcset es welcTxt1 "$bp ist ein Tcl-Programm, das für das Projekt 'Bibel 2.0' entwickelt wird.\n\n'Bibel 2.0' setzt sich zum Ziel, $dw in einer wachsenden Anzahl von Sprachen zu verbreiten.\n$dw besteht aus 2 ausgewählten Bibelsprüchen für jeden Tag des Jahres.\n\n$bp kann $dw in vielfältiger Weise auf Ihrem PC anzeigen."
mcset es welcSubtit2 "Was sind Ihre Möglichkeiten?"
mcset es welcTxt2 "\u27a4 [mc bibletexts]: Wählen Sie beliebig viele Bibelausgaben und -sprachen für $dw
\u27a4 [mc desktop]: Betrachten Sie $dw auf Ihren persönlichen Fotos
\u27a4 [mc photos]: Wählen Sie eigene Hintergrundbilder für $bp aus
\u27a4 [mc email]: Fügen Sie $dw an Ihre E-Mails an
\u27a4 [mc manual]: Studieren Sie das komplette Handbuch von $bp
\u27a4 [mc terminal]: Betrachten Sie $dw in Ihren Linux-Konsolen
"
# U N I N S T A L L
mcset es uninstall "Wollen Sie wirklich $bp von Ihrem Computer entfernen?"
mcset es uninstalling "BiblePix wird nun deinstalliert. Zum Löschen der Systemeinstellungen müssen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\" beantworten!"
mcset es uninstalled "$bp ist sicher von Ihrem System entfernt worden. Um es neu zu installieren, besuchen Sie uns auf [mc www] und laden Sie den $bp Installer herunter."
#  M I S S I N G   P A C K A G E
mcset es packageRequireImg "$bp benötigt die Tcl-Erweiterung 'tkimg'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n [mc packageRequireImg_fix]"
mcset es packageRequireTDom "$bp benötigt die Tcl-Erweiterung 'tDom'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n [mc packageRequireTDom_fix]"
mcset es packageRequireTls "$bp benötigt die Tcl-Erweiterung 'TLS'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n [mc packageRequireTls_fix]"
mcset es packageRequireLibtcl "$bp benötigt die Tcl-Erweiterung 'libtcl'.\nBitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in einer Konsole (als root oder sudo):\n [mc packageRequireLibtcl_fix]"
#SETUP INTERNATIONAL
mcset es download "Download"
mcset es downloadingHttp "Lade $bp-Programmdateien herunter..."
mcset es updatingHttp "Aktualisiere $bp-Programmdateien..."
mcset es uptodateHTTP "Ihre Programmdateien sind auf dem neusten Stand."
mcset es noConnHTTP "Keine Internetverbindung für Programmaktualisierung, bitte versuchen Sie es später."
mcset es gettingTwd "Hole aktuelle Bibeltext-Liste von bible2.net..."
mcset es noTwdFilesFound "Es sind keine aktuellen Bibeltextdateien installiert.\nBitte wählen Sie im $bp-Setup mindestens \n1 Sprachdatei aus der Rubrik 'International'."
mcset es connTwd "Verbindung zu bible2.net hergestellt."
mcset es noConnTwd "Keine Verbindung zu bible2.net. Versuchen Sie es später."
mcset es f1Tit "Aktuelle Bibeltextliste für $dw"
mcset es TwdLocalTit "Für $jahr installierte Bibeltextdateien"
mcset es TwdRemoteTit "Bibeltextdateien zum Herunterladen"
mcset es language "Sprache"
mcset es year "Jahr"
mcset es bibleversion "Bibelausgabe"
mcset es biblename "Bibelname"
mcset es f1Txt "$bp stellt $dw in allen Sprachen und Bibelausgaben bereit, die auf Ihrem Computer installiert sind. Sind mehrere Bibeltextdateien installiert, wählt $bp jeweils zufällig eine aus. Wenn Sie neue Bibeltextdateien zum Download markieren (s. unten), werden diese heruntergeladen, sobald Sie die Taste '[mc download]' drücken. Achten Sie auf den Jahrgang (laufendes oder nächstes Jahr)!"  
#SETUP DESKTOP
mcset es f2Tit "$dw auf Desktop-Hintergrundbild"
mcset es f2Box "Hintergrundbild erzeugen"
mcset es f2Farbe "Schriftfarbe: "
mcset es f2Slideshow "Diaschau aktivieren"
mcset es f2Interval "Bildwechsel alle "
mcset es sec "Sekunden"
mcset es f2Introline "Datum anzeigen"
mcset es f2Fontsize "Schriftgrösse: "
mcset es f2Fontweight "fett"
mcset es f2Fontfamily "Schriftart: "
mcset es f2Fontexpl "Schrift anpassen"
mcset es f2Txt "\nWenn aktiviert, zaubert $bp $dw auf ein Hintergrundbild. Das Foto wird im Zufallsprinzip aus der $bp-Fotosammlung ausgewählt (s. Rubrik Photos). Ein neues Hintergrundbild steht jeweils in \n\n\t [file nativename $imgdir] \n\nzur Anzeige für den Desktop-Manager bereit. \n\nSofern mehrere Bibeltextdateien installiert sind, wechselt bei jedem Bildwechsel auch die Sprache bzw. Bibelversion im Zufallsprinzip.\n\n$bp richtet standardmässig eine DIASCHAU mit Wechselbild ein. Soll nur 1 Bild pro Tag angezeigt werden, kann die Diaschau deaktiviert werden (s.o.).\n\nIm Fenster TEXTPOSITION können Sie $dw an die gewünschte Stelle auf dem Bildschirm verschieben. Beim Hinzufügen von Bildern kan die Textposition auch individuell bestimmt werden. \n\nDie SCHRIFTGRÖSSE wird automatisch aufgrund der Bildschirmhöhe gesetzt. Sie haben jedoch die Möglichkeit, Grösse und Dicke anzupassen (grössere Buchstaben = besserer Kontrast).\n\nDie SCHRIFTFARBE können Sie fest bestimmen oder dem Zufall überlassen. $bp kann zusätzlich eine Farbanpassung anhand der Hintergrundhelligkeit vornehmen. Dieser Effekt kommt erst nach Speichern neuer Fotos zum Tragen.\n\nFalls das neue Hintergrundbild nicht automatisch erscheint, finden Sie im Manual eine Lösung."
# S E T U P   P H O T O S 
mcset es textposlabel "Textposition bestimmen"
mcset es textposAdjust "Wollen Sie vor dem Speichern die Textposition für dieses Bild ändern?"
mcset es f6Tit "Fotos für $bp organisieren"
mcset es f6Txt "Hier können Sie beliebig viele Fotos aus Ihrem persönlichen Bildordner in die $bp-Fotosammlung ziehen. Die Fotos sollten im Querformat aufgenommen sein und möglichst eine ebenfarbige Fläche für gute Lesbarkeit des Bibelspruchs aufweisen.\n\n$bp speichert eine Kopie des Bildes im $bp-Fotoordner ab und ändert das Bildformat sowie die Grösse, falls es nicht mit den Bildschirmdimensionen übereinstimmt. Sie haben in diesem Fall die Möglichkeit, den passenden Bildausschnitt sowie die künftige Position des Bibeltextes selber zu bestimmen.\n\nDas Originalbild bleibt in jedem Fall unverändert."
mcset es f6numPhotosTxt "Anzahl Bilder: "
mcset es f6Add "Zur $bp-Fotosammlung hinzufügen:"
mcset es f6Show "$bp-Fotosammlung anzeigen"
mcset es f6Find "Neue Fotos suchen"
mcset es f6Del "Aus der $bp-Fotosammlung löschen:"
#RESIZING
mcset es resizeF_txt "Ihr Foto passt nicht zur Bildschirmgrösse und muss zugeschnitten werden. [mc movePicToResize]"
mcset es movePicToResize "Verschieben Sie den Bildausschnitt nach Wunsch und bestätigen Sie mit Ok zum Speichern."
mcset es resizingPic "Passe Bildgrösse dem Bildschirm an \u2014 bitte haben Sie einen Augenblick Geduld..."
mcset es movePic "Bildausschnitt verschieben \u21CA"
mcset es picSchonDa "Foto bereits im $bp-Bildordner"
# S E T U P   S I G N A T U R E
mcset es f3Tit "$dw auf Ihren E-Mail-Signaturen"
mcset es f3Btn "E-Mail-Signatur erzeugen"
mcset es f3Sprachen "Gewünschte Sprachen für meine Signaturen"
mcset es f3Txt "Wenn aktiviert, fügt $bp einmal täglich für jede installierte Bibeltextdatei $dw an Ihre E-Mail-Signaturen an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schlac.txt) im folgenden Ordner gespeichert: \n\n\t$sigdir \n\nSie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie ==== bleibt beim Wechsel von $dw unbehelligt. \n\nVielleicht möchten Sie nicht, dass Ihre Mail-Empfänger $dw in allen Sprachen lesen, die Sie installiert haben. Wählen Sie oben rechts die gewünschte(n) Sprache(n) aus.\n\nDamit $dw künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen>Signatur).\n\nGewisse Programme wie Seamonkey Mail, Evolution oder Trojitá verwalten Signaturen intern. $bp kann darunter vorläufig Trojitá und Evolution  berücksichtigen."
#SETUP TERMINAL
mcset es f4Tit  "$dw in Ihren Linux-Terminals"
mcset es f4Btn "$dw zur Anzeige im Terminal erzeugen"
mcset es f4Txt "Wenn aktiviert, erzeugt $bp $dw für die Anzeige in Ihren Konsolen. Sind mehrere Bibeltextdateien vorhanden, wechselt der Text bei jedem Öffnen eines Terminals. \n\nDarstellung und Farben können in \n\n\t $confdir/term.conf \n\ngeändert werden.\n\nFür die Darstellung in hebräischer oder arabischer Schrift kommen nur Terminals wie 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' oder 'Konsole' (KDE) in Frage, welche bidirektionellen Text korrekt anzeigen. \n\nDamit $dw automatisch im Terminal angezeigt wird, macht das $bp-Setup einen Eintrag in ~/.bashrc."

# S E T U P S A V E   T E X T S
#Changing Desktops Info
mcset es linChangingDesktop "$bp versucht nun, Ihre Desktop-Einstellungen zu ändern. Falls Sie danach kein neues Hintergrundbild sehen, finden Sie eine Lösung im Manual."
mcset es winIgnorePopup "Schliessen Sie bitte aufspringende Fenster ohne Änderung, damit $bp die Registrierung abschliessen kann!"
mcset es winChangingDesktop "$bp versucht nun, Ihren Desktop-Hintergrund zu ändern"
mcset es winChangeDesktopProb "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nRechtsklicken Sie auf ein leeres Feld auf Ihrem Desktop und \"Anpassen\". Unter \"Hintergrund\" setzen Sie als Hintergrund-Einzelbild $TwdBMP oder \n$TwdPNG \noder für Slidesho\n$imgdir ."
mcset es linChangeDesktopProb "Wir hatten ein Problem mit der Änderung der Desktopeinstellungen.\nBitte rechtsklicken Sie auf Ihrer Arbeitsfläche und finden Sie den Dialog für 'Hintergrundbild'. Dort geben Sie $imgdir als Bildpfad an."
mcset es linNoDesktopFound "Kein Linux-Desktop gefunden! Suchen Sie im Manual eine Lösung zum manuellen Einrichten des $bp-Hintergrundbilds."
mcset es linReloadingDesktop "Wir versuchen nun, Ihre Arbeitsfläche neu einzulesen. Falls dies fehlschlägt, müssen Sie sich kurz ab- und wieder anmelden, damit die $bp-Einstellungen wirksam werden."
mcset es changeDesktopOk "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas ${bp}-Einrichtungsprogramm können Sie jederzeit starten, indem Sie im Programmmenü das ${bp}-Symbol wählen (Linux) bzw. auf Ihrer Arbeitsoberfläche rechtsklicken und das ${bp}-Symbol wählen (Windows)."
mcset es winRegister "$bp muss nun auf Ihrem System registriert werden.\nBitte bestätigen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\"!"
mcset es winRegisterProb "$bp ist auf Ihrem Computer noch nicht korrekt installiert.\nStarten Sie das Setup nochmals oder fügen Sie \n$Biblepix\n in \"Automatisch gestartete Programme\" an."
#PHOTOS
mcset es reposSaved "Bild mit Info gespeichert."
mcset es reposNotSaved "Bild nicht gespeichert."
mcset es noPhotosFound "Im $bp-Fotoordner wurden keine Fotos gefunden. Kopieren Sie bitte einige Bilder in den Ordner."
mcset es rotatePic "Bild drehen"
mcset es preview90 "\u21B7 Vorschau 90° Drehung"
mcset es preview180 "\u21BB Vorschau 180° Drehung"
mcset es computePreview "\u21B6 \u21B7 Vorschau beliebige Drehung"
mcset es rotateWait "Bitte haben Sie eine Weile Geduld, bis die Drehung am Originalbild abgeschlossen ist..."
mcset es rotateInfo "Achtung: durch Abspeichern und Neuladen kann ein Bild in mehreren Schritten gedreht werden!"
mcset es deletedPicMsg "Bild aus $bp-Fotoalbum gelöscht:"
mcset es copiedPicMsg "Neues Bild nach $bp-Fotoalbum kopiert:"
