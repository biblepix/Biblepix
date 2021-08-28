# ~/Biblepix/prog/msg/ru.msg
# Russian texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
#INFO: Textmenge Reintext ca. 1500 Wörter
# Updated: 27aug21 pv

############################################################################################################
## T R A N S L A T O R S : O N L Y   T R A N S L A T E   P H R A S E S   W I T H I N  Q U O T E S   "......"
## e.g.:  of  
##    'mcset yourlanguage code "PHRASE" '    - only replace quoted text in "PHRASE"
############################################################################################################

################################################################################
## U  N  T  R  A  N  S  L  A  T  A  B  L  E  S
## P L E A S E   D O N 'T  T O U C H : 
## - ANY PHRASE STARTING WITH #
## - ANY WORD STARTING WITH $
## - ANY PHRASE WITHIN SQUARE BRACKETS [...]
## - ANY FORMATTING MARKERS LIKE \n \n\n \t \u... etc.
## - ANY PHRASE STARTING WITH 'set'
## - ANY WORD STARTING WITH %
################################################################################

# U N T R A N S L A T A B L E S
set bp "BiblePix"
mcset ru dw 'Слово'
mcset ru bp $bp

# G E N E R A L
mcset ru bpsetup "$bp einrichten"
mcset ru refresh "Aktualisieren"
mcset ru delete "Datei löschen"
mcset ru ok "Ok"
mcset ru cancel "Abbruch"
mcset ru close "Schliessen"
mcset ru save "Speichern"
mcset ru saveSettings "Einstellungen speichern"
mcset ru random "zufällig"
mcset ru uninst "$bp deinstallieren"
mcset ru welcome "Willkommen"
mcset ru bibletexts "Bibeltexte"
mcset ru desktop "Hintergrundbild"
mcset ru photos "Fotos"
mcset ru email "E-Mail-Signatur"
mcset ru terminal "Terminal/Konsole"
mcset ru manual "Handbuch"
mcset ru packageRequireMissing "$bp benötigt die Tcl-Erweiterung '%s'. Bitte installieren Sie sie über Ihre Systemsteuerung oder tippen Sie eines der folgenden Kommandos in eine Konsole (als root oder sudo): [mc packageRequire]"
# W E L C O M E 
mcset ru next "Nächstes \u25bc"
mcset ru welcTit "Willkommen beim Einrichtungsprogramm von $bp!"
mcset ru welcSubtit1 "Что такое $bp?"
mcset ru welcTxt1 "$bp это программа Tcl разработанная для проекта 'Библия 2.0', цель которого: публиковать 'Слово' на все большем количестве языков.\n'Слово' состоит из двух избранных библейских стихов на каждый день года.\n\n$bp может отображать 'Слово' на вашем персональном компьютере разными способами:"
mcset ru welcSubtit2 "Was sind Ihre Möglichkeiten?"

##Achtung: diesen Textblock als Ganzes behandeln (alles zwischen "..." ist der Text)
mcset ru welcTxt2 "\u27a4 [mc bibletexts] : Wählen Sie beliebig viele Bibelausgaben und -sprachen für 'Слово'
\u27a4 [mc desktop]: Betrachten Sie 'Слово' auf Ihren persönlichen Fotos
\u27a4 [mc photos]: Wählen Sie eigene Hintergrundbilder für $bp aus
\u27a4 [mc email]: Fügen Sie 'Слово' an Ihre E-Mails an
\u27a4 [mc manual]: Studieren Sie das komplette Handbuch von $bp
\u27a4 [mc terminal]: Betrachten Sie 'Слово' in Ihren Linux-Konsolen
"

# U N I N S T A L L
mcset ru uninstall "Wollen Sie wirklich $bp von Ihrem Computer entfernen?"
mcset ru uninstalling "BiblePix wird nun deinstalliert. Zum Löschen der Systemeinstellungen müssen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\" beantworten!"
mcset ru uninstalled "$bp ist sicher von Ihrem System entfernt worden. Um es neu zu installieren, besuchen Sie uns auf [mc www] und laden Sie den $bp Installer herunter."

#SETUP INTERNATIONAL
mcset ru download "Download"
mcset ru downloadingHttp "Lade $bp-Programmdateien herunter..."
mcset ru updatingHttp "Aktualisiere $bp-Programmdateien..."
mcset ru uptodateHTTP "Ihre Programmdateien sind auf dem neusten Stand."
mcset ru noConnHTTP "Keine Internetverbindung für Programmaktualisierung, bitte versuchen Sie es später."
mcset ru gettingTwd "Hole aktuelle Bibeltext-Liste von bible2.net..."
mcset ru noTwdFilesFound "Es sind keine aktuellen Bibeltextdateien installiert.\nBitte wählen Sie im $bp-Setup mindestens \n1 Sprachdatei aus der Rubrik 'International'."
mcset ru connTwd "Verbindung zu bible2.net hergestellt."
mcset ru noConnTwd "Keine Verbindung zu bible2.net. Versuchen Sie es später."
mcset ru f1Tit "Aktuelle Bibeltextliste für 'Слово'"
mcset ru TwdLocalTit "Für $jahr installierte Bibeltextdateien"
mcset ru TwdRemoteTit "Bibeltextdateien zum Herunterladen"
mcset ru language "Sprache"
mcset ru year "Jahr"
mcset ru bibleversion "Bibelausgabe"
mcset ru biblename "Bibelname"
mcset ru f1Txt "$bp stellt 'Слово' in allen Sprachen und Bibelausgaben bereit, die auf Ihrem Computer installiert sind. Sind mehrere Bibeltextdateien installiert, wählt $bp jeweils zufällig eine aus. Wenn Sie neue Bibeltextdateien zum Download markieren (s. unten), werden diese heruntergeladen, sobald Sie die Taste '[mc download]' drücken. Achten Sie auf den Jahrgang (laufendes oder nächstes Jahr)!"  
#SETUP DESKTOP
mcset ru f2Tit "'Слово' auf Desktop-Hintergrundbild"
mcset ru f2Box "Hintergrundbild erzeugen"
mcset ru f2Farbe "Schriftfarbe: "
mcset ru f2Slideshow "Diaschau aktivieren"
mcset ru f2Interval "Bildwechsel alle "
mcset ru sec "Sekunden"
mcset ru f2Introline "Datum anzeigen"
mcset ru f2Fontsize "Schriftgrösse: "
mcset ru f2Fontweight "fett"
mcset ru f2Fontfamily "Schriftart: "
mcset ru f2Fontexpl "Schrift anpassen"
mcset ru f2Txt "\nWenn aktiviert, zaubert $bp 'Слово' auf ein Hintergrundbild. Das Foto wird im Zufallsprinzip aus der $bp-Fotosammlung ausgewählt (s. Rubrik [mc photos]). Ein neues Hintergrundbild steht jeweils in \n\n\t [file nativename $imgdir] \n\nzur Anzeige für den Desktop-Manager bereit. \n\nSofern mehrere Bibeltextdateien installiert sind, wechselt bei jedem Bildwechsel auch die Sprache bzw. Bibelversion im Zufallsprinzip.\n\n$bp richtet standardmässig eine DIASCHAU mit Wechselbild ein. Soll nur 1 Bild pro Tag angezeigt werden, kann die Diaschau deaktiviert werden (s.o.).\n\nIm Fenster TEXTPOSITION können Sie 'Слово' an die gewünschte Stelle auf dem Bildschirm verschieben. Beim Hinzufügen von Bildern kan die Textposition auch individuell bestimmt werden. \n\nDie SCHRIFTGRÖSSE wird automatisch aufgrund der Bildschirmhöhe gesetzt. Sie haben jedoch die Möglichkeit, Grösse und Dicke anzupassen (grössere Buchstaben = besserer Kontrast).\n\nDie SCHRIFTFARBE können Sie fest bestimmen oder dem Zufall überlassen. $bp kann zusätzlich eine Farbanpassung anhand der Hintergrundhelligkeit vornehmen. Dieser Effekt kommt erst nach Speichern neuer Fotos zum Tragen.\n\nFalls das neue Hintergrundbild nicht automatisch erscheint, finden Sie im Manual eine Lösung."
# S E T U P   P H O T O S 
mcset ru textposlabel "Textposition bestimmen"
mcset ru textposAdjust "Wollen Sie vor dem Speichern die Textposition für dieses Bild ändern?"
mcset ru f6Tit "Fotos für $bp organisieren"
mcset ru f6Txt "Hier können Sie beliebig viele Fotos aus Ihrem persönlichen Bildordner in die $bp-Fotosammlung ziehen. Die Fotos sollten im Querformat aufgenommen sein und möglichst eine ebenfarbige Fläche für gute Lesbarkeit des Bibelspruchs aufweisen.\n\n$bp speichert eine Kopie des Bildes im $bp-Fotoordner ab und ändert das Bildformat sowie die Grösse, falls es nicht mit den Bildschirmdimensionen übereinstimmt. Sie haben in diesem Fall die Möglichkeit, den passenden Bildausschnitt sowie die künftige Position des Bibeltextes selber zu bestimmen.\n\nDas Originalbild bleibt in jedem Fall unverändert."
mcset ru f6numPhotosTxt "Anzahl Bilder: "
mcset ru f6Add "Zur $bp-Fotosammlung hinzufügen:"
mcset ru f6Show "$bp-Fotosammlung anzeigen"
mcset ru f6Find "Neue Fotos suchen"
mcset ru f6Del "Aus der $bp-Fotosammlung löschen:"
#RESIZING
mcset ru movePicToResize "Verschieben Sie den Bildausschnitt nach Wunsch und bestätigen Sie mit Ok zum Speichern."
mcset ru resizeF_txt "Ihr Foto passt nicht zur Bildschirmgrösse und muss zugeschnitten werden. [mc movePicToResize]"

mcset ru resizingPic "Passe Bildgrösse dem Bildschirm an \u2014 bitte haben Sie einen Augenblick Geduld..."
mcset ru movePic "Bildausschnitt verschieben \u21CA"
mcset ru picSchonDa "Foto bereits im $bp-Bildordner"
# S E T U P   S I G N A T U R E
mcset ru f3Tit "'Слово' auf Ihren E-Mail-Signaturen"
mcset ru f3Btn "E-Mail-Signatur erzeugen"
mcset ru f3Sprachen "Gewünschte Sprachen für meine Signaturen"
mcset ru f3Txt "Wenn aktiviert, fügt $bp einmal täglich für jede installierte Bibeltextdatei 'Слово' an Ihre E-Mail-Signaturen an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schlac.txt) im folgenden Ordner gespeichert: \n\n\t$sigdir \n\nSie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie ==== bleibt beim Wechsel von 'Слово' unbehelligt. \n\nVielleicht möchten Sie nicht, dass Ihre Mail-Empfänger 'Слово' in allen Sprachen lesen, die Sie installiert haben. Wählen Sie oben rechts die gewünschte(n) Sprache(n) aus.\n\nDamit 'Слово' künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen>Signatur).\n\nGewisse Programme wie Seamonkey Mail, Evolution oder Trojitá verwalten Signaturen intern. $bp kann darunter vorläufig Trojitá und Evolution  berücksichtigen."
#SETUP TERMINAL
mcset ru f4Tit  "'Слово' in Ihren Linux-Terminals"
mcset ru f4Btn "'Слово' zur Anzeige im Terminal erzeugen"
mcset ru f4Txt "Wenn aktiviert, erzeugt $bp 'Слово' für die Anzeige in Ihren Konsolen. Sind mehrere Bibeltextdateien vorhanden, wechselt der Text bei jedem Öffnen eines Terminals. \n\nDarstellung und Farben können in \n\n\t $confdir/term.conf \n\ngeändert werden.\n\nFür die Darstellung in hebräischer oder arabischer Schrift kommen nur Terminals wie 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' oder 'Konsole' (KDE) in Frage, welche bidirektionellen Text korrekt anzeigen. \n\nDamit 'Слово' automatisch im Terminal angezeigt wird, macht das $bp-Setup einen Eintrag in ~/.bashrc."

# S E T U P S A V E   T E X T S
mcset ru linChangingDesktop "$bp versucht nun, Ihre Desktop-Einstellungen zu ändern. Falls Sie danach kein neues Hintergrundbild sehen, finden Sie eine Lösung im Manual."
mcset ru winIgnorePopup "Schliessen Sie bitte aufspringende Fenster ohne Änderung, damit $bp die Registrierung abschliessen kann!"
mcset ru winChangingDesktop "$bp versucht nun, Ihren Desktop-Hintergrund zu ändern"
mcset ru winChangeDesktopProb "Wir hatten ein Problem mit der Änderung des Desktophintergrunds.\nRechtsklicken Sie auf ein leeres Feld auf Ihrem Desktop und \"Anpassen\". Unter \"Hintergrund\" setzen Sie als Hintergrund-Einzelbild $TwdBMP oder \n$TwdPNG \noder für Slidesho\n$imgdir ."
mcset ru linChangeDesktopProb "Wir hatten ein Problem mit der Änderung der Desktopeinstellungen.\nBitte rechtsklicken Sie auf Ihrer Arbeitsfläche und finden Sie den Dialog für 'Hintergrundbild'. Dort geben Sie $imgdir als Bildpfad an."
mcset ru linNoDesktopFound "Kein Linux-Desktop gefunden! Suchen Sie im Manual eine Lösung zum manuellen Einrichten des $bp-Hintergrundbilds."
mcset ru linReloadingDesktop "Wir versuchen nun, Ihre Arbeitsfläche neu einzulesen. Falls dies fehlschlägt, müssen Sie sich kurz ab- und wieder anmelden, damit die $bp-Einstellungen wirksam werden."

if {$os=="Linux"} {
  mcset ru changeDesktopOk "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas ${bp}-Einrichtungsprogramm können Sie jederzeit starten, indem Sie im Programmmenü das ${bp}-Symbol wählen."
} else {
  mcset ru changeDesktopOk "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas ${bp}-Einrichtungsprogramm können Sie jederzeit starten, indem Sie auf Ihrer Arbeitsoberfläche rechtsklicken und das ${bp}-Symbol wählen."
}

mcset ru changeDesktopOk "$bp ist auf Ihrem Computer eingerichtet und wird jetzt gestartet.\n\nDas ${bp}-Einrichtungsprogramm können Sie jederzeit starten, indem Sie im Programmmenü das ${bp}-Symbol wählen (Linux) bzw. auf Ihrer Arbeitsoberfläche rechtsklicken und das ${bp}-Symbol wählen (Windows)."
mcset ru winRegister "$bp muss nun auf Ihrem System registriert werden.\nBitte bestätigen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\"!"
mcset ru winRegisterProb "$bp ist auf Ihrem Computer noch nicht korrekt installiert.\nStarten Sie das Setup nochmals oder fügen Sie \n$Biblepix\n in \"Automatisch gestartete Programme\" an."
#PHOTOS
mcset ru reposSaved "Bild mit Info gespeichert."
mcset ru reposNotSaved "Bild nicht gespeichert."
mcset ru noPhotosFound "Im $bp-Fotoordner wurden keine Fotos gefunden. Kopieren Sie bitte einige Bilder in den Ordner."
mcset ru rotatePic "Bild drehen"
mcset ru preview90 "\u21B7 Vorschau 90° Drehung"
mcset ru preview180 "\u21BB Vorschau 180° Drehung"
mcset ru computePreview "\u21B6 \u21B7 Vorschau beliebige Drehung"
mcset ru rotateWait "Bitte haben Sie eine Weile Geduld, bis die Drehung am Originalbild abgeschlossen ist..."
mcset ru rotateInfo "Achtung: durch Abspeichern und Neuladen kann ein Bild in mehreren Schritten gedreht werden!"
mcset ru deletedPicMsg "Bild aus $bp-Fotoalbum gelöscht:"
mcset ru copiedPicMsg "Neues Bild nach $bp-Fotoalbum kopiert:"
