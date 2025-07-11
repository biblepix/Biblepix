# OVERVIEW

BiblePix is a Tcl program developed for the **Bible 2.0** project. **Bible 2.0** aims to publish **The Word** in a growing number of languages. 
**The Word** consists of two selected Bible verses for each day of the year.

BiblePix can display **The Word** in various ways:

- in many languages
- as background image on Windows & Linux Desktops
- slideshow with personal photo collection
- as e-mail signature
- in the Linux terminal

## Operating systems:
Linux, Windows

## System requirements:
Tcl/Tk library, including additional packages: tcllib, tls, tDom, tkimg

# INSTALLATION

Before installing BiblePix, make sure Tcl/Tk as well as the above-mentioned extra packages are present on your PC. Tcl/Tk is a system independent platform for many operating systems.

BiblePix Installer (see below) should be executed only once for first installation, since it overwrites all files. After that it is enough to run BiblePix Setup for updating.

BiblePix automatically chooses your "Home Directory" for installation, as this is the recommended standard (see further down, "Place of Installation").

## WINDOWS

### A) The hard way:

1. Download and run Tcl/Tk from ActiveState: **https://www.activestate.com/products/tcl/**

This package contain all required Tcl programs.
NOTE: Before the next step, restart computer to make sure Tcl is properly registered!

2. Download the BiblePix Installer from **https://biblepix.vollmar.ch** and right-click to install (for option 'Open with...' choose 'Wish' or 'Tcl' application).

### B) The easy way:

Download the "BiblePix Windows Installer" from **https://biblepix.vollmar.ch** . It will install everything automatically :-)

## LINUX

1. Installing Tcl/Tk: 
Most Linux distributions already contain Tcl/Tk, including the afore-mentioned extra packages. If any of it is missing you can easily install it before installing BiblePix. Installation is possible through the package manager of your system, or by entering a short command in your terminal. [^1]

2. Download the BiblePix Installer from **https://biblepix.vollmar.ch** and double-click to install. [^2]

## GIT

The Git installation method is system independent and works on all platforms where a version of Git is installed. The 'git' command should be issued in a subfolder of the Home directory, so as to guarantee write access (see below under "Place of Installation). Change to that directory and download (clone) BiblePix with the command:

> git clone https://github.com/Biblepix/Biblepix.git

Then start the Setup program by running

> ~/Biblepix/biblepix-setup.tcl


## PLACE OF INSTALLATION

Recommended standard for Linux:

> /home/[USERNAME]/Biblepix/

and for Windows:

> C:\Users\[USERNAME]\AppData\Local\Biblepix\

- The Home Directory is represented hereunder by the symbol **~**
- Windows file paths are represented hereunder by normal shlashes  **/**
- Path to Setup program: ~/Biblepix/biblepix-setup.tcl
- Path to main program: ~/Biblepix/prog/src/biblepix.tcl
- Path to configuration file: ~/Biblepix/prog/conf/biblepix.conf [^3]


# FUNCTIONS

### SETUP PROGRAM

By running the BiblePix Setup program you can set all functions with ease. The program can be started as follows:

- from the program menu of your system
- by right-click on the Desktop (Windows)
- by right-click in the file manager (Linux Konqueror)

In case of problems:
- Linux & Windows: double click the program file **~/Biblepix/biblepix-setup.tcl** from the file manager (full path see above)
- Linux: execute the shell script **~/bin/biblepix-setup.sh** from the file manager or a terminal

In the 'Welcome' section you can view **The Word** in any installed language (to switch click on arrow sign). By pressing the OK button the BiblePix configuration as well as the system settings for Autostart and background picture are saved. [^4] BiblePix is restarted.

### DOWNLOADING BIBLE TEXTS

The functioning of BiblePix depends on the presence of Bible text files with the ending **.TWD**, which can be downloaded from our server each year in many languages and Bible versions. Downloading is up to the user and should be done through the Setup programm when a year comes to a close. This funcion is not automatic. The text files are kept in the folder

> ~/Biblepix/BibleTexts/

Any redundent text files from past years are deleted automatically by the Setup program.

### PROGRAM UPDATES

BiblePix has an automatic update mechanism. If an Internet connection is present, both the main program and the Setup program will check for any program updates and install them automatically. Thus your BiblePix is always up-to-date, re-installation is hardly ever needed.

### PHOTO MANAGEMENT

BiblePix provides a few sample pictures which are scaled to screen size and copied to the BiblePix Photo directory at first installation. However in the Setup program you can add your own photos. These too are resized, if necessary, and copied over. Original photos remain untouched. From version 3.3, both the desired text position and the luminance of the text colour are registered when adding a photo.

### THE WORD ON A BACKGROUND PICTURE

The centre-piece of BiblePix is projecting The Word onto a background image. If the feature "Background Image" is activated in the Setup, BiblePix will take a picture from the photo collection and adorn it with **The Word** from an available Bible text file by random selection. If the funcion "Slideshow" is activated too, this takes place at the given interval. Depending on the operating system, one or two identical pictures of the formats:

> theword.tif
> theword.bmp
> theword.png

are saved to the picture folder:

> ~/Biblepix/TodaysPicture/

The Bible text is written directly onto the picture with nice, readable shadow fonts. The size, colour and type of fonts as well as the text position can be set in the Setup program. [^5]
Displaying the background image as well switching images (in case of slideshow activated) are managed by the BiblePix main program.

BiblePix Setup will try to automatically change the background picture of your Desktop; all Windows and most common Linux Desktops have been taken into account. If you encounter problems you can easily set up your background picture manually by right-clicking on your
Desktop and instructing your system to use the above image path from now on.

It shouldn't be necessary to set up a SLIDESHOW via your system desktop control, since BiblePix takes care of changing the picture at a given interval. [^6]

### EMAIL SIGNATURE

BiblePix has an extended feature called "Add The Word to your e-mail signatures". If this is activated in the Setup, BiblePix will add The Word to your signature(s) once a day on the basis of any installed Bible text files. The signature files are stored by language shortcuts (e.g. signature-en_Englis.txt) in the directory:

> ~/Biblepix/TodaysSignature/

You can edit these files from your e-mail program or in a text editor and add any personal information (greetings, address etc.) at the top. Any text above the separating line **======** remains untouched when The Word changes. Finally you must instruct your e-mail program to use these files when sending an e-mail (usually under Settings > Identities > Signatures).

For e-mail programs that manage signatures only internally (i.e. that cannot load external files), BiblePix can handle Trojitá and Evolution for now. First time users should go to 'IMAP > Settings > General' (Trojitá) / 'Settings > Editor > Signatures' (Evolution) and edit the desired identity. If there are no signatures yet, create one as 'plain text'. Then, in the 'Edit' dialog reopen any signature files you want to have The Word added, and add a new line saying

> www.bible2.net

Henceforth BiblePix will insert 'The Word' in its place, while your original signature remains untouched.

### LINUX TERMINAL

Thanks to this extra feature BiblePix can display The Word in your Linux terminals. If activated (only possible on Linux computers) BiblePix will create a shell script from any available Bible text file, to reside in:

> ~/Biblepix/prog/unix/term.sh

The script is executed whenever you open a terminal. Display and colours can be customised by editing:

> ~/Biblepix/prog/conf/term.conf

For term.sh to be executed automatically, the Setup program makes an entry in ~/.bashrc.


## ADDENDA

### WINDOWS

AUTOSTART: in Explorer go to the Autostart directory:

> C:\Users\[MYNAME]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

and create a link to 

> ~\Biblepix\prog\src\biblepix.tcl

BACKGROUND: Settings > Customization and Display > Background (or right-cklick on 
Desktop > Customizing), there enter exact path to image:

> ~\Biblepix\TodaysPic\theword.tif

Important: select the 'Single Picture' option! If you have chosen 'Slideshow' in the 
BiblePix Setup, it is BiblePix that will execute a system program which sees that changed
background pictures will be read and displayed anew each time.

### LINUX DESKTOPS

Path to single picture: PNG or BMP (exact paths see above "The Word on Picture")
Path for slideshow: ~/Biblepix/TodaysPic/
Path for Autostart: s.a. "Place of installation" (path to main prog)

#### KDE Plasma
Autostart: Program menu > System settings > Autostart
Background: right-cklick on Desktop > Customize Desktop: choose between Single pic / Slideshow

#### GNOME
Autostart: Activities > "Tweak Tool" > Startup
Background: Activities > "Tweak Tool" > Desktop > Place: path to single pic!
If Tweak Tool is missing you can install it by entering in a terminal:
> sudo apt-get install gnome-tweak-tool

#### XFCE4
Autostart: Applications > Settings > Session & Startup > Automatically started applications
Background: Right-click on Desktop > Customize Desktop > Background > Directory
Important: select either single pic or slideshow!


### NOTE ON LINUX DESKTOPS

From the plentitude of Linux Desktops, BiblePix has considered the most common ones as follows:

a) X11: KDE/GNOME/XFCE4 : Autostart + Background change fully automatic, in case of problems s.a. 

b) X11: DWM and hopefully many other exotics: 
	Autostart: not automatic, in ~/.xinitrc or ~/.xsession add path to main prog
	Background change: automatic by BiblePix if 'xloadimage' or 'display' (ImageMagick) is installed 

c) Wayland: (very experimental!)
**Sway**
- Autostart: automatic (entry in ~/.config/sway/config)
- Background: automatic by BiblePix
**Weston**
- Autostart: unknown
- Background: not automatic, following entry in ~/.config/weston.ini possible:
> [shell]
> background-image=[IMAGEPATH]/theword.png
> background-type=scale-crop

### NOTE ON LINUX LOGIN MANAGERS

If you log in by password you are probably using one of the below Login Managers.
You have the possibility to see the BiblePix image right at Login. (This is beyond the scope of the Biblepix Setup program.)
Since these settings require root rights you'll have to make the changes yourself, either as root or using 'sudo' before the commands (NO LINE BREAKS!).

**XDM** (general Linux)
A. Entry in /etc/X11/xdm/Xsetup:
> xsetbg /home/YOURNAME/Biblepix/Image/theword.tif &
B. Optional entry in /etx/X11/xdm/Xresources to move login window down right:
> xlogin*geometry: 1000x350-20-20

The program 'xloadimage' must be installed.

**KDM** (KDE Plasma)
A. Entry in /etc/kde4/kdm/kdmrc, below [X-*-Core]:
> UseBackground=true
> UseTheme=false
> BackgroundCfg=/etc/kde4/kdm/backgroundrc
> GreeterPos=75,75
B. Entry in /etc/kde4/kdm/backgroundrc:
> [Desktop0]
> BackgroundMode=Wallpaper
> WallpaperMode=Tiled
> Wallpaper=/home/YOURNAME/Biblepix/Image/theword.*

**GDM** (Gnome)
The following command has proven successful (no line breaks!):
> sudo -u gdm gsettings set org.gnome.desktop.background picture-uri file:///home/YOURNAME/Biblepix/Image/theword.bmp

**Lightdm** (Gnome, Ubuntu)
Enter the following command as an ordinary user (no line breaks!):
> dbus-send --system --print-reply --dest=org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User.SetBackgroundFile string:/home/YOURNAME/Biblepix/Image/theword.png

# FOOTNOTES

[^1]: short command for complete installation, including extra packages:
> sudo apt-get install tcl-tls tdom libtk-img (Debian/Ubuntu)
> sudo emerge dev-tcltk/tls tdom tkimg (Gentoo)
> sudo yum install tdom tkimg (Fedora)
> sudo yast -i tkimg tdom (OpenSuse)
> sudo urpmi tkimg tdom (Mandriva)

[^2]: or in a terminal: **tclsh /home/[MYNAME]/Biblepix/biblepix-setup.tcl**

[^3]: The configuration file is written by Setup and should not normally be touched by users. If however after an update the Setup should no longer run, you can try deleting the file and then restart the Setup. The configuration file allows the so-called "debug modus", to detect program errors. To achieve this, set the value 'debug' to 1 and restart the Setup.

[^4]: Setup makes entries in some system files for BiblePix to be run at system start (Autostart) and for the background image to change. If this fails you can make the necessary changes manually (see above: ADDENDA).

[^5]: Arabic and Hebrew text is positioned automatically on the opposite side. To display such texts in terminals you need programs like 'mlterm', 'gnome-terminal', 'xfce4-terminal' or 'Konsole' (KDE) which can display bidirectional text correctly.

[^6]: Attention Windows users: if the picture doesn't change on time, right-click on your Desktop and choose "Personalize > Wallpaper". There you can set up a slide show easily with the above. picture path. The interval is taken automatically from the BiblePix Setup settings. You may have to rerun Setup for this to take effect.
