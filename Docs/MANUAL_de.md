# ÜBERBLICK

BibelPix ist ein **Tcl**-Programm, das für das Projekt **Bibel 2.0** entwickelt wird. **Bibel 2.0** setzt sich zum Ziel, **Das Wort** — 2 ausgewählte Bibelsprüche für jeden Tag des Jahres — in einer wachsenden Anzahl von Sprachen zu verbreiten.

BibelPix kann **Das Wort** auf vielfältige Weise anzeigen:

- in vielen Sprachen
- als Hintergrundbild auf Windows & Linux Desktops
- Diaschau mit persönlicher Fotosammlung
- als E-Mail-Signatur
- im Linux-Terminal

## Betriebssysteme:
Linux, Windows

## Systemvoraussetzungen: 
Tcl/Tk-Bibliothek, Zusatzpakete tcllib, tls, tDom und tkimg


# INSTALLATION

Vor der Installation von BibelPix müssen Tcl/Tk sowie die angegebenen Zusatzpakete installiert sein. Tcl/Tk ist eine systemübergreifende Plattform für viele Betriebssysteme.

Der BiblePix-Installer (s.u.) sollte nur 1x bei der Erstinstallation ausgeführt werden, da dadurch alle Dateien überschrieben werden. Danach sorgt die automatische Aktualisierungsfunktion des Einrichtungsprogramms für die nötigen Programm-Updates.

Als Installationsort wählt BibelPix automatisch den empfohlenen Standard, nämlich Ihren "Heimordner" (Genaueres s.u.).


## WINDOWS

### A) Der schwere Weg:

1. Das aktuelle **Tcl/Tk**-Paket herunterladen und ausführen: **https://www.activestate.com/products/tcl/**

Dieses Paket enthält alle nötigen Tcl-Programme.
Wichtig: vor dem nächsten Schritt Computer neu starten, damit Tcl registriert wird!

2. Den BibelPix-Installer von **https://biblepix.vollmar.ch** herunterladen und ausführen (Rechtsklick auf die Datei > öffnen mit 'Wish' oder 'Tcl' application).


### B) Der leichte Weg:

- Laden Sie den "BiblePix Windows Installer" von **biblepix.vollmar.ch** herunter. Er installiert alles automatisch :-)

## LINUX

1. Tcl/Tk installieren:
Die meisten Linux-Distributionen enthalten Tcl/Tk bereits, ebenso die erwähnten Zusatzpakete. Sollte etwas davon fehlen, können Sie es leicht nachinstallieren, bevor Sie BibelPix einrichten. Die Installation erfolgt entweder über die Paketverwaltung Ihres Systems oder per Kurzkommando in der Konsole. [^1]

2. Den BibelPix-Installer von **biblepix.vollmar.ch** herunterladen und ausführen mit Doppelklick auf die Datei. [^2]

## GIT

Die Git-Installationsmethode ist systemunabhängig und funktioniert auf allen Plattformen, die über eine Version von Git verfügen. Die Git-Installation sollte in einem Unterordner des Heimordners (s.u. "Installationsort") erfolgen, damit Schreibrechte garantiert sind.

In dieses Verzeichnis wechseln und BibelPix herunterladen (klonen) mit dem Kommando:

> git clone https://github.com/Biblepix/Biblepix.git

Danach ins BibelPix-Verzeichnis wechseln und mit Doppelklick auf die Datei

> ~/Biblepix/biblepix-setup.tcl

das Einrichtungsprogramm starten.

## INSTALLATIONSORT

Empfohlener Standard bei Linux:

> /home/[MEINNAME]/Biblepix/

und bei Windows:

> C:\Users\[MEINNAME]\AppData\Local\Biblepix\

- Der "Heimordner" hat im folgenden das Symbol:     ~
- Windows-Dateipfade im folgenden mit normalen Schrägstrichen:  /
- Pfad zum Einrichtungsprogramm: ~/Biblepix/biblepix-setup.tcl
- Pfad zum Hauptprogramm: ~/Biblepix/prog/src/biblepix.tcl
- Pfad zur Konfigurationsdatei: ~/Biblepix/prog/conf/biblepix.conf [^3]


# FUNKTIONEN

### EINRICHTUNGSROGRAMM

Durch Betätigung des Programms 'BibelPix-Setup' können alle Funktionen bequem bestimmt werden. Das Programm lässt sich wie folgt starten:

- aus dem Programm-Menü Ihres Systems
- per Rechtsklick auf dem Desktop (Windows)
- per Rechtsklick im Dateimanager (Linux Konqueror)

Bei Problemen:
- Linux & Windows: im Dateimanager Doppelklick auf **~/Biblepix/biblepix-setup.tcl** (vollständiger Pfad s.o.)
- Linux: Shell-Skript **~/bin/biblepix-setup.sh** ausführen (aus der Konsole oder im Dateimanager)

In der Rubrik **Willkommen** können Sie das aktuelle Tageswort in allen installierten Sprachen lesen (zum Wechsel auf Pfeilsymbol klicken).
Durch Betätigung der OK-Taste werden die BibelPix-Konfiguration sowie die Systemeinstellungen für Autostart und Hintergrundbild gespeichert. [^4] 
BibelPix wird neu gestartet.

### BIBELTEXTE HERUNTERLADEN

Die Funktion von BibelPix stützt sich auf das Vorhandensein von Bibeltext-Dateien mit der Endung **.TWD**, welche jährlich in vielen Sprachen und Bibelversionen von unserem Server heruntergeladen werden können. Der Download geschieht durch den User über das Einrichtungsprogramm. Beim Jahreswechsel werden die bereits installierten Dateien automatisch aktualisiert. Die Dateien befinden sich im Ordner

> ~/Biblepix/BibleTexts

Alte Jahrgänge werden automatisch gelöscht.

### PROGRAMM-AKTUALISIERUNG

BibelPix verfügt über einen automatischen Update-Mechanismus. Das Hauptprogramm sowie das Einrichtungsprogramm suchen bei vorhandener Internetverbindung jeweils nach Programm-Updates und Upgrades und installiert diese automatisch. Somit ist Ihr BibelPix stets auf dem neusten Stand, eine Neuinstallation ist kaum je nötig.

### FOTOVERWALTUNG

BibelPix liefert einige Musterbilder mit, die bei der Erstinstallation auf die Bildschirmgrösse zugeschnitten und in den BibelPix-Fotoordner kopiert werden. Das Einrichtungsprogramm bietet jedoch die Möglichkeit, eigene Fotos hinzuzufügen. Diese werden, wenn nötig, ebenfalls skaliert und kopiert. Die Originalfotos bleiben unberührt. Ab Version 3.3 wird beim Hinzufügen eines Bildes die gewünschte Textposition sowie die Helligkeit der Schriftfarbe mit gespeichert.

### WORT AUF BILD

Das Kernstück von BibelPix ist die Projektion des täglichen Bibelspruchs auf ein Hintergrundbild. Wenn im Einrichtungsprogramm die Funktion "Hintergrundbild" aktiviert ist, nimmt BibelPix ein neues Bild aus der Fotosammlung und versieht es mit dem Tageswort aus einer vorhandenen Textdatei; die Auswahl geschieht im Zufallsprinzip. Wenn zusätzlich die Funktion "Diaschau" aktiviert ist, geschieht dies im gewünschten Minuten-Rhythmus. Je nach Betriebssystem werden 1 oder 2 identische Bilder in  den Formaten:

> theword.tif
> theword.bmp
> theword.png

im Bildpfad-Ordner:

> ~/Biblepix/TodaysPicture/

gespeichert.

Der Bibeltext wird in leserlicher Schattenschrift direkt aufs Bild geschrieben. Grösse, Farbe und Art der Schrift können im Einrichtungsprogramm festgelegt werden, ebenso die Position des Textes auf dem Bild. [^5]

Die Darstellung als Desktop-Hintergrundbild sowie der Bildwechsel (bei Diaschau) werden vom BibelPix-Hauptprogramm automatisch gesteuert.

Das BibelPix-Einrichtungsprogramm versucht, das neue Hintergrundbild für Ihr Desktop automatisch einzurichten; berücksichtigt sind all Windows- und gängige Linux-Desktops. Sollten dabei Probleme entstehen, können Sie das leicht manuell nachholen, indem Sie auf Ihrer Arbeitsfläche rechtsklicken und Ihr System anweisen, künftig den obigen Bildpfad als Hintergrundbild zu verwenden.

Die Einrichtung einer **Diaschau** übers System sollte nicht nötig sein, da BibelPix selbsttätig das Bild im gewünschten Minutentakt ändert. [^6]

### EMAIL-SIGNATUR

BibelPix bietet die Zusatzfunktion **Das Wort als E-Mail-Signatur**. Diese Funktion kann im Einrichtungsprogramm aktiviert werden. Dann fügt BibelPix einmal täglich für die als mailtauglich markierten Sprachen das Tageswort an Ihre Signatur(en) an. Die erstellten Signaturdateien werden nach Sprachkürzeln sortiert (z.B. signature-de_Schlac.txt) im folgenden Ordner gespeichert:

> ~/Biblepix/TodaysSignature/

Sie können diese Dateien aus Ihrem E-Mail-Programm oder in einem Texteditor bearbeiten und persönliche Grussformeln, Adressen usw. oben einfügen. Text oberhalb der Trennlinie **=====** bleibt beim Wechsel des Tageswortes unbehelligt. Damit **Das Wort** künftig auf Ihren Mails erscheint, müssen Sie Ihrem Mail-Programm beibringen, die oben beschriebenen Dateien zu verwenden (meist unter Einstellungen > Konten/Identitäten > Signatur).

Für E-Mail-Programme, welche Signaturen nur intern verwalten (also keine externen Dateien laden können), sind vorläufig Trojitá und Evolution berücksichtigt. Nutzer dieser Programme müssen das erste Mal unter 'IMAP > Settings > General' (Trojitá) bzw. Einstellungen > Editor > Signaturen' (Evolution [^7] ) die gewünschte Identität markieren und im Dialog 'Edit' eine neue Zeile hinzufügen mit dem Ausdruck

> www.bibel2.net

Dort wird künftig **Das Wort** automatisch eingesetzt.

### LINUX-TERMINAL

Dank diesem Zusatz-Feature ermöglicht BibelPix die Darstellung des Tageswortes in Unix-Konsolen. Falls aktiviert (nur bei Linux möglich), erzeugt BibelPix aufgrund vorhandener Bibeltextdateien ein Shell-Skript, welches beim Öffnen eines Terminals ausgeführt wird:

> ~/Biblepix/prog/unix/term.sh

Darstellung und Farben können in

> ~/Biblepix/prog/conf/term.conf

geändert werden. Damit term.sh automatisch ausgeführt wird, macht das Einrichtungsprogramm einen Eintrag in ~/.bashrc.

_________________________________________________________________


## ERGÄNZUNGEN

### WINDOWS

AUTOSTART: im Explorer zum Autostart-Ordner wechseln:

> C:\Users\[MEINNAME]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

und Verknüpfung auf 

> ~\Biblepix\prog\src\biblepix.tcl

erstellen (vollständiger Pfad s.o.).

HINTERGRUND: Einstellungen > Anpassungen und Darstellung > Hintergrund (oder Rechtsklick auf Desktop > Anpassungen), dort genauen Bildpfad angeben:

> ~\Biblepix\TodaysPic\theword.tif (vollständiger Pfad s.o.)

Wichtig: geben Sie die Anzeigeoption als 'Einzelbild' an! Falls Sie im Einrichtungsprogramm die Option 'Diaschau' gewählt haben, betätigt BibelPix im angegebenen Intervall ein Systemprogramm, welches dafür sorgt, dass geänderte Hintergrundbilder immer wieder neu eingelesen und angezeigt werden.

### LINUX-DESKTOPS

- Bildpfad für Einzelbild: PNG oder BMP (genaue Pfade s.o. "Wort auf Bild")
- Bildpfad für Diaschau: ~/Biblepix/TodaysPic/
- Pfad für Autostart: s.o. "Installationsort" (Pfad zum Hauptprogramm)

#### KDE Plasma
- Autostart: Programmenü > Systemeinstellungen > Autostart
- Hintergrund: Rechtsklick auf Desktop > Arbeitsfläche einrichten > "Bild" od. "Diaschau" wählen

#### GNOME
- Autostart: Aktivitäten > Optimierungswerkzeug "Tweak Tool" > Startprogramme
- Hintergrund: Aktivitäten > Optimierungswerkzeug "Tweak Tool" > Arbeitsoberfläche > Ort: Pfad zu Einzelbild!
Falls das Optimierungswerkzeug fehlt, im Terminal mit folgendem Kommando installieren:

> sudo apt-get install gnome-tweak-tool

#### XFCE4
- Autostart: Anwendungen > Einstellungen > Sitzung - Startverhalten > Automatisch gestartete Anwendungen
- Hintergrund: Rechtsklick auf Desktop > Schreibtisch einrichten > Hintergrund > Ordner 
Wichtig: Einzelbild oder Diaschau wählen!

### ANMERKUNGEN ZU LINUX-DESKTOPS

BibelPix hat aus der Vielfalt der Linux-Desktops die wichtigsten wie folgt berücksichtigt:

a) X11: KDE/GNOME/XFCE4 : Autostart - Hintergrundwechsel vollautomatisch, bei Problemen s.o. 

b) X11: DWM und hoffentlich viele andere Exoten:
- Autostart: nicht automatisch, in ~/.xinitrc oder ~/.xsession Pfad zum Hauptprogramm anfügen
- Hintergrundwechsel: automatisch durch BibelPix, falls 'xloadimage' oder 'display' (ImageMagick) installiert ist 

c) Wayland: (very experimental!)
**Sway**:
- Autostart: automatisch (mit Eintrag in ~/.config/sway/config)
- Hintergrund: automatisch durch BibelPix
**Weston**:
- Autostart: nicht bekannt
- Hintergrund: nicht automatisch, folgender Eintrag in ~/.config/weston.ini möglich:
> [shell]
> background-image=[BILDPFAD]/theword.png
> background-type=scale-crop

### LINUX LOGIN-MANAGER FÜR *DAS WORT* KONFIGURIEREN

Wenn Sie sich mit Passwort anmelden, benutzen Sie wahrscheinlich einen der untenstehenden Login-Manager. Sie können schon bei der Anmeldung das Bild mit dem Tageswort sehen. Dieses Feature sprengt den Rahmen der BibelPix-Installationsroutine und kann nur manuell und mit Root-Rechten eingerichtet werden (Systempasswort oder sudo).

Kopieren Sie die Kommandos OHNE ZEILENUMBRÜCHE in Ihr Terminal.

**XDM** (Linux X standard):
1. Eintrag in /etc/X11/xdm/Xsetup:
> xsetbg [BILDPFAD]/theword.* &
2. Empfohlener Eintrag in /etx/X11/xdm/Xresources, um das Loginfenster nach rechts unten zu versetzen:
> xlogin*geometry: 1000x350-20-20 

wobei sich die ersten 2 Zahlen auf Breite und Höhe beziehen und anpassbar sind. Das Programm 'xloadimage' muss installiert sein.

**KDM** (KDE Standard):
1. Eintrag in /etc/kde4/kdm/kdmrc, unterhalb [X-*-Core]:
> UseBackground=true
> UseTheme=false
> BackgroundCfg=/etc/kde4/kdm/backgroundrc
> GreeterPos=75,75
2. Eintrag in /etc/kde4/kdm/backgroundrc:
> [Desktop0]
> BackgroundMode=Wallpaper
> WallpaperMode=Tiled
> Wallpaper=[BILDPFAD]/theword.*

**GDM** (Gnome Standard)
> sudo -u gdm gsettings set org.gnome.desktop.background picture-uri file://[BILDPFAD]/theword.*

**Lightdm** (Gnome, Ubuntu):
Folgendes Kommando als gewöhnlicher User eingeben (keine Zeilenumbrüche!):
> dbus-send --system --print-reply --dest=org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User.SetBackgroundFile string:[BILDPFAD]/theword.*


# FUSSNOTEN

[^1]: Kurzkommando für Gesamtinstallation inkl. Zusatzpakete:
- sudo apt-get install tcl-tls tdom libtk-img (Debian/Ubuntu)
- sudo emerge dev-tcltk/tls tdom tkimg (Gentoo)
- sudo yum install tdom tkimg (Fedora)
- sudo yast -i tkimg tdom (OpenSuse)
- sudo urpmi tkimg tdom (Mandriva)

[^2]: oder in Konsole eingeben: **tclsh /home/[MEINNAME]/Biblepix/biblepix-setup.tcl**

[^3]: Die Konfigurationsdatei wird vom Einrichtungsprogramm geschrieben und ist nicht für Usereingriffe bestimmt. Falls nach einem Update das Setup nicht mehr laufen sollte, können Sie die Datei löschen und dann das Einrichtungsprogramm neu starten. Die Konfigurationsdatei erlaubt auch den sog. "Debug-Modus", um Programmfehler aufzuspüren. Dazu setzen Sie den Wert 'Debug' auf 1 und starten das Einrichtungsprogramm neu.

[^4]: Das Einrichtungsprogramm macht Einträge in Systemdateien, damit BibelPix künftig automatisch ausgeführt wird (Autostart) und damit das Hintergrundbild wechselt (Desktop).
Falls dies fehlschlägt, können Sie die nötigen Einstellungen manuell nachholen: (s.o. ERGÄNZUNGEN)

[^5]: Arabischer und hebräischer Text wird automatisch auf der Gegenseite positioniert. Für die Darstellung im Terminal kommen nur Terminals wie 'mlterm', 'Konsole' (KDE), 'gnome-terminal' oder 'xfce4-terminal' in Frage, welche bidirektionellen Text richtig anzeigen.

[^6]: Achtung Windows: falls der Bildwechsel nicht richtig funktioniert, rechtsklicken Sie auf dem Desktop und wählen Sie "Anpassen > Hintergrund". Dort können Sie mit dem obigen Bildpfad leicht eine Diaschau einrichten. Das Intervall wird automatisch aus dem BibelPix-Setup übernommen. Ev. müssen Sie es danach nochmals laufen lassen, um das gewünschte Intervall zu registrieren.

[^7]: Evolution Mail client: Signatur als HTML abspeichern!
