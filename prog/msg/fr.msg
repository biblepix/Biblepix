# ~/Biblepix/prog/msg/de.msg
# German texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
#INFO: Textmenge - 100 mcset * 3 W. = 300 W.
# Updated: 14aug21 pv

# U N T R A N S L A T A B L E S
mcset {} packageRequire {
* apt-get install [PACKAGE NAME] (Debian/Ubuntu)
* emerge [PACKAGE NAME] (Gentoo)
}

# G E N E R A L
set bp "BiblePix"
set dw {'La Parole'}
mcset fr bpsetup "$bp Einrichtungsprogramm"
mcset fr refresh "Aktualisieren"
mcset fr delete "Datei löschen"
mcset fr ok "Ok"
mcset fr cancel "Abbruch"
mcset fr close "Schliessen"
mcset fr save "Speichern"
mcset fr saveSettings "Einstellungen speichern"
mcset fr random "zufällig"
mcset fr uninst "$bp deinstallieren"
mcset fr welcome "Willkommen"
mcset fr bibletexts "Bibeltexte"
mcset fr desktop "Hintergrundbild"
mcset fr photos "Fotos"
mcset fr email "E-Mail-Signatur"
mcset fr terminal "Terminal/Konsole"
mcset fr manual "Handbuch"
mcset fr packageRequireMissing "$bp benötigt die Tcl-Erweiterung '%s'. Bitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in eine Konsole (als root oder sudo): [mc packageRequire]"
##untranslatable
mcset fr dw $dw
mcset fr bp $bp

# W E L C O M E 
mcset fr next "Nächstes \u25bc"
mcset fr welcTit "Willkommen beim Einrichtungsprogramm von $bp!"
mcset fr welcSubtit1 "Was ist $bp?"
mcset fr welcTxt1 "$bp ist ein Tcl-Programm, das für das Projekt 'Bibel 2.0' entwickelt wird.\n\n'Bibel 2.0' setzt sich zum Ziel, $dw in einer wachsenden Anzahl von Sprachen zu verbreiten.\n$dw besteht aus 2 ausgewählten Bibelsprüchen für jeden Tag des Jahres.\n\n$bp kann $dw in vielfältiger Weise auf Ihrem PC anzeigen."
mcset fr welcSubtit2 "Was sind Ihre Möglichkeiten?"
mcset fr welcTxt2 "\u27a4 [mc bibletexts]: Wählen Sie beliebig viele Bibelausgaben und -sprachen für $dw
\u27a4 [mc desktop]: Betrachten Sie $dw auf Ihren persönlichen Fotos
\u27a4 [mc photos]: Wählen Sie eigene Hintergrundbilder für $bp aus
\u27a4 [mc email]: Fügen Sie $dw an Ihre E-Mails an
\u27a4 [mc manual]: Studieren Sie das komplette Handbuch von $bp
\u27a4 [mc terminal]: Betrachten Sie $dw in Ihren Linux-Konsolen
"
# U N I N S T A L L
mcset fr uninstall "Wollen Sie wirklich $bp von Ihrem Computer entfernen?"
mcset fr uninstalling "BiblePix wird nun deinstalliert. Zum Löschen der Systemeinstellungen müssen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\" beantworten!"
mcset fr uninstalled "$bp ist sicher von Ihrem System entfernt worden. Um es neu zu installieren, besuchen Sie uns auf [mc www] und laden Sie den $bp Installer herunter."

#SETUP INTERNATIONAL
mcset fr download "Download"
mcset fr downloadingHttp "Lade $bp-Programmdateien herunter..."
mcset fr updatingHttp "Aktualisiere $bp-Programmdateien..."
mcset fr uptodateHTTP "Ihre Programmdateien sind auf dem neusten Stand."
mcset fr noConnHTTP "Keine Internetverbindung für Programmaktualisierung, bitte versuchen Sie es später."
mcset fr gettingTwd "Hole aktuelle Bibeltext-Liste von bible2.net..."
mcset fr noTwdFilesFound "Es sind keine aktuellen Bibeltextdateien installiert.\nBitte wählen Sie im $bp-Setup mindestens \n1 Sprachdatei aus der Rubrik 'International'."
mcset fr connTwd "Verbindung zu bible2.net hergestellt."
mcset fr noConnTwd "Keine Verbindung zu bible2.net. Versuchen Sie es später."
mcset fr f1Tit "Aktuelle Bibeltextliste für $dw"
mcset fr TwdLocalTit "Für $jahr installierte Bibeltextdateien"
mcset fr TwdRemoteTit "Bibeltextdateien zum Herunterladen"
mcset fr language "Sprache"
mcset fr year "Jahr"
mcset fr bibleversion "Bibelausgabe"
mcset fr biblename "Bibelname"
mcset fr f1Txt "$bp stellt $dw in allen Sprachen und Bibelausgaben bereit, die auf Ihrem Computer installiert sind. Sind mehrere Bibeltextdateien installiert, wählt $bp jeweils zufällig eine aus. Wenn Sie neue Bibeltextdateien zum Download markieren (s. unten), werden diese heruntergeladen, sobald Sie die Taste '[mc download]' drücken. Achten Sie auf den Jahrgang (laufendes oder nächstes Jahr)!"  
#SETUP DESKTOP
mcset fr f2Tit "$dw auf Desktop-Hintergrundbild"
mcset fr f2Box "Hintergrundbild erzeugen"
mcset fr f2Farbe "Schriftfarbe: "
mcset fr f2Slideshow "Diaschau aktivieren"
mcset fr f2Interval "Bildwechsel alle "
mcset fr sec "Sekunden"
mcset fr f2Introline "Datum anzeigen"
mcset fr f2Fontsize "Schriftgrösse: "
mcset fr f2Fontweight "fett"
mcset fr f2Fontfamily "Schriftart: "
mcset fr f2Fontexpl "Schrift anpassen"
mcset fr f2Txt "\nWenn aktiviert, zaubert $bp $dw auf ein Hintergrundbild. Das Foto wird im Zufallsprinzip aus der $bp-Fotosammlung ausgewählt (s. Rubrik Photos). Ein neues Hintergrundbild steht jeweils in \n\n\t [file nativename $imgdir] \n\nzur Anzeige für den Desktop-Manager bereit. \n\nSofern mehrere Bibeltextdateien installiert sind, wechselt bei jedem Bildwechsel auch die Sprache bzw. Bibelversion im Zufallsprinzip.\n\n$bp richtet standardmässig eine DIASCHAU mit Wechselbild ein. Soll nur 1 Bild pro Tag angezeigt werden, kann die Diaschau deaktiviert werden (s.o.).\n\nIm Fenster TEXTPOSITION können Sie $dw an die gewünschte Stelle auf dem Bildschirm verschieben. Beim Hinzufügen von Bildern kan die Textposition auch individuell bestimmt werden. \n\nDie SCHRIFTGRÖSSE wird automatisch aufgrund der Bildschirmhöhe gesetzt. Sie haben jedoch die Möglichkeit, Grösse und Dicke anzupassen (grössere Buchstaben = besserer Kontrast).\n\nDie SCHRIFTFARBE können Sie fest bestimmen oder dem Zufall überlassen. $bp kann zusätzlich eine Farbanpassung anhand der Hintergrundhelligkeit vornehmen. Dieser Effekt kommt erst nach Speichern neuer Fotos zum Tragen.\n\nFalls das neue Hintergrundbild nicht automatisch erscheint, finden Sie im Manual eine Lösung."
# S E T U P   P H O T O S 
mcset fr textposlabel "Textposition bestimmen"
mcset fr textposAdjust "Wollen Sie vor dem Speichern die Textposition für dieses Bild ändern?"
mcset fr f6Tit "Fotos für $bp organisieren"
mcset fr f6Txt "Hier können Sie beliebig viele Fotos aus Ihrem persönlichen Bildordner in die $bp-Fotosammlung ziehen. Die Fotos sollten im Querformat aufgenommen sein und möglichst eine ebenfarbige Fläche für gute Lesbarkeit des Bibelspruchs aufweisen.\n\n$bp speichert eine Kopie des Bildes im $bp-Fotoordner ab und ändert das Bildformat sowie die Grösse, falls es nicht mit den Bildschirmdimensionen übereinstimmt. Sie haben in diesem Fall die Möglichkeit, den passenden Bildausschnitt sowie die künftige Position des Bibeltextes selber zu bestimmen.\n\nDas Originalbild bleibt in jedem Fall unverändert."
mcset fr f6numPhotosTxt "Anzahl Bilder: "
mcset fr f6Add "Zur $bp-Fotosammlung hinzufügen:"
mcset fr f6Show "$bp-Fotosammlung anzeigen"
mcset fr f6Find "Neue Fotos suchen"
mcset fr f6Del "Aus der $bp-Fotosammlung löschen:"
#RESIZING
mcset fr movePicToResize "Verschieben Sie den Bildausschnitt nach Wunsch und bestätigen Sie mit Ok zum Speichern."
mcset fr resizeF_txt "Ihr Foto passt nicht zur Bildschirmgrösse und muss zugeschnitten werden. [mc movePicToResize]"

mcset fr resizingPic "Passe Bildgrösse dem Bildschirm an \u2014 bitte haben Sie einen Augenblick Geduld..."
mcset fr movePic "Bildausschnitt verschieben \u21CA"
mcset fr picSchonDa "Foto bereits im $bp-Bildordner"
# S E T U P   S I G N A T U R E
mcset fr f3Tit "$dw auf Ihren E-Mail-Signaturen"
mcset fr f3Btn "E-Mail-Signatur erzeugen"
mcset fr f3Sprachen "Gewünschte Sprachen für meine Signaturen"
mcset fr f3Txt "Wenn aktiviert, fügt $bp einmal täglich für jede installierte Bibeltextdatei $dw an Ihre E-Mail-Signaturen an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schlac.txt) im folgenden Ordner gespeichert: \n\n\t$sigdir \n\nSie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie ==== bleibt beim Wechsel von $dw unbehelligt. \n\nVielleicht möchten Sie nicht, dass Ihre Mail-Empfänger $dw in allen Sprachen lesen, die Sie installiert haben. Wählen Sie oben rechts die gewünschte(n) Sprache(n) aus.\n\nDamit $dw künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen>Signatur).\n\nGewisse Programme wie Seamonkey Mail, Evolution oder Trojitá verwalten Signaturen intern. $bp kann darunter vorläufig Trojitá und Evolution  berücksichtigen."
#SETUP TERMINAL
mcset fr f4Tit  "$dw in Ihren Linux-Terminals"
mcset fr f4Btn "$dw zur Anzeige im Terminal erzeugen"
mcset fr f4Txt "Wenn aktiviert, erzeugt $bp $dw für die Anzeige in Ihren Konsolen. Sind mehrere Bibeltextdateien vorhanden, wechselt der Text bei jedem Öffnen eines Terminals. \n\nDarstellung und Farben können in \n\n\t $confdir/term.conf \n\ngeändert werden.\n\nFür die Darstellung in hebräischer oder arabischer Schrift kommen nur Terminals wie 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' oder 'Konsole' (KDE) in Frage, welche bidirektionellen Text korrekt anzeigen. \n\nDamit $dw automatisch im Terminal angezeigt wird, macht das $bp-Setup einen Eintrag in ~/.bashrc."

# S E T U P S A V E   T E X T S
mcset fr linChangingDesktop "$bp versucht nun, Ihre Desktop-Einstellungen zu ändern. Falls Sie danach kein neues Hintergrundbild sehen, finden Sie eine Lösung im Manual."
mcset fr winIgnorePopup "Schliessen Sie bitte aufspringende Fenster ohne Änderung, damit $bp die Registrierung abschliessen kann!"
mcset fr winChangingDesktop "$bp versucht nun, Ihren Desktop-Hintergrund zu ändern"
mcset fr winChangeDesktopProb "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nRechtsklicken Sie auf ein leeres Feld auf Ihrem Desktop und \"Anpassen\". Unter \"Hintergrund\" setzen Sie als Hintergrund-Einzelbild $TwdBMP oder \n$TwdPNG \noder für Slidesho\n$imgdir ."
mcset fr linChangeDesktopProb "Wir hatten ein Problem mit der Änderung der Desktopeinstellungen.\nBitte rechtsklicken Sie auf Ihrer Arbeitsfläche und finden Sie den Dialog für 'Hintergrundbild'. Dort geben Sie $imgdir als Bildpfad an."
mcset fr linNoDesktopFound "Kein Linux-Desktop gefunden! Suchen Sie im Manual eine Lösung zum manuellen Einrichten des $bp-Hintergrundbilds."
mcset fr linReloadingDesktop "Wir versuchen nun, Ihre Arbeitsfläche neu einzulesen. Falls dies fehlschlägt, müssen Sie sich kurz ab- und wieder anmelden, damit die $bp-Einstellungen wirksam werden."
mcset fr changeDesktopOk "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas ${bp}-Einrichtungsprogramm können Sie jederzeit starten, indem Sie im Programmmenü das ${bp}-Symbol wählen (Linux) bzw. auf Ihrer Arbeitsoberfläche rechtsklicken und das ${bp}-Symbol wählen (Windows)."
mcset fr winRegister "$bp muss nun auf Ihrem System registriert werden.\nBitte bestätigen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\"!"
mcset fr winRegisterProb "$bp ist auf Ihrem Computer noch nicht korrekt installiert.\nStarten Sie das Setup nochmals oder fügen Sie \n$Biblepix\n in \"Automatisch gestartete Programme\" an."
#PHOTOS
mcset fr reposSaved "Bild mit Info gespeichert."
mcset fr reposNotSaved "Bild nicht gespeichert."
mcset fr noPhotosFound "Im $bp-Fotoordner wurden keine Fotos gefunden. Kopieren Sie bitte einige Bilder in den Ordner."
mcset fr rotatePic "Bild drehen"
mcset fr preview90 "\u21B7 Vorschau 90° Drehung"
mcset fr preview180 "\u21BB Vorschau 180° Drehung"
mcset fr computePreview "\u21B6 \u21B7 Vorschau beliebige Drehung"
mcset fr rotateWait "Bitte haben Sie eine Weile Geduld, bis die Drehung am Originalbild abgeschlossen ist..."
mcset fr rotateInfo "Achtung: durch Abspeichern und Neuladen kann ein Bild in mehreren Schritten gedreht werden!"
mcset fr deletedPicMsg "Bild aus $bp-Fotoalbum gelöscht:"
mcset fr copiedPicMsg "Neues Bild nach $bp-Fotoalbum kopiert:"
