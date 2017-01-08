# ~/Biblepix/prog/src/gui/setupSaveWin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 21dec2016

#Windows handles TIF + BMP
package require registry
source $SetupSaveWinHelpers

#Set Registry compatible paths
set regfile install.reg
set wishpath [file nativename [auto_execok wish]]
set srcpath [file nativename $srcdir]
set imgpath [file nativename $imgdir]
set winpath [file nativename $windir]


# A)  N O N - A D M I N   R E G I S T E R I N G S

#1a. Register Autorun always
set autorunError [catch setWinAutorun]
if {$autorunError} {
       	tk_messageBox -type ok -icon error -title "BiblePix Autorun Installation" -message $winChangeDesktopProb
}

#1b. Execute single pic theme if running slideshow detected
if {$enablepic} {
	#Detect running slideshow (entry reset by Windows when user sets bg)
	set regpathExplorer [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
	set BackgroundType [registry get $regpathExplorer BackgroundType]
        #BackgroundType: 0 = Einzelbild, 1 = Farbe, 2 = SlideShow
        if {$BackgroundType == 2} {
		tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winChangeDesktop
              	set themeError [catch setWinTheme]
        	if {$themeError} {
       			tk_messageBox -type ok -icon error -title "BiblePix Theme installation" -message $winChangeDesktopProb
		}
        }
}



# B)  A D M I N   R E G I S T E R I N G S

# Register Context Menu IF values differ
set regpath_desktop [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
set regpathStandardKeyValue "BiblePix Setup"
set iconKeyValue "$WinIcon"
set posKeyValue "Bottom"
set commandPath "$regpath_desktop\\Command"
set commandPathStandardKeyValue "$wishpath $Setup"

#1. Prüfe Grundeintrag
if { [catch {registry get $regpath_desktop $regpathStandardKeyValue} ]  } {
	tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $winRegister
        set regError [catch setWinContextMenu]

#2. Prüfe keys
} elseif {	[registry get $regpath_desktop Icon] != $iconKeyValue ||
		[registry get $regpath_desktop Position] != $posKeyValue ||
		[registry get $commandPath {}] != $commandPathStandardKeyValue
} {
	tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $winRegister
	set regError [catch setWinContextMenu]

	if {$regError} {
		tk_messageBox -type ok -title "BiblePix Registry Installation" -icon error -message $winRegisterProb
	}
}

#Final message if no errors
if { $autorunError==0 } {
	set ok 1
} 
if { [info exists regError] && $regError==0 } {
	set ok 1
}
if { [info exists themeError] && $themeError==0 } {
	set ok 1
}
if {$ok} {
	tk_messageBox -type ok -title "BiblePix Installation" -icon info -message $changeDesktopOk
}
