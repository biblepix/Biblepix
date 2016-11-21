# ~/Biblepix/prog/src/gui/setupSaveWin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 16nov2016

package require registry
set regfile install.reg

#################################
# Start coding                  #
# Windows handles TIF + BMP !   #
#################################

#Set Registry compatible paths
set wishpath [file nativename [auto_execok wish]]
#set wishpath [file nativename C:/Program\ Files\ (x86)]
set tclpath [file nativename $srcdir]
set imgpath [file nativename $imgdir]
set winpath [file nativename $windir]


# A)  N O N - R O O T   R E G I S T E R I N G S

#1a. Register Autorun always
set regpath_autorun [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\] 
#registry set $regpath_autorun Biblepix "$wishpath $tclpath\\biblepix.tcl"
set regtext "$wishpath [file nativename [file join $tclpath biblepix.tcl]]"
regsub -all {[\{\}]} $regtext {} regtext
registry set $regpath_autorun Biblepix $regtext

#1b. Register Fallback Wallpaper always (tends to be reset by system!)
set regpath_fallback_img [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
registry set $regpath_fallback_img Wallpaper "[file nativename $TwdBMP]"

#2. Register Desktop .theme always (system adds ID when run)
set themepath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Biblepix.theme]
	
if {$enablepic} { 
	set interval $slideshow

	#if slideshow=0, allow 3 min. for first pic shift
	if {$slideshow==0} {set interval 180}
	
	#part 1: fixed
	set theme1 {[Theme]
DisplayName=BiblePix

[Control Panel\Desktop]
Wallpaper=%USERPROFILE%\Biblepix\Image\theword.tif
TileWallpaper=0
WallpaperStyle=2

[VisualStyles]
Path=%SystemRoot%\resources\themes\Aero\Aero.msstyles
ColorStyle=NormalColor
Size=NormalSize
VisualStyleVersion=10

[MasterThemeSelector]
MTSM=DABJDKT

[Slideshow]
ImagesRootPath=%USERPROFILE%\Biblepix\Image
Shuffle=0}

	#part 2 with variable expansion:
	set theme2 "Interval=[expr 1000*$interval]"
	set chan [open $themepath w]
	puts $chan $theme1
	puts $chan $theme2
	close $chan

	#1.Save current theme once (never overwritten)
	set CustomThemePath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Custom.theme]
	catch {file copy $CustomThemePath $windir}

	#2.Execute Biblepix.theme
	tk_messageBox -type ok -title "BiblePix Installation" -message $winChangeDesktop
	
        if { [catch "exec cmd /c $themepath"] } {
		tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $winChangeDesktopProb
	}
}  ;#end  if $enablepic



# B) R O O T   R E G I S T E R I N G S

# Register Context Menu always
set regpath_desktop [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\] 

#amend paths for .reg file (double \\ needed)
regsub -all {\\} $wishpath {\\\\} wishpath
regsub -all {\\} $tclpath {\\\\} tclpath
set setuppath "$wishpath $tclpath\\\\biblepix-setup.tcl"
set regtext "Windows Registry Editor Version 5.00

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
\@=\"BiblePix Setup\"
\"Icon\"=\"%USERPROFILE%\\\\Biblepix\\\\prog\\\\win\\\\biblepix.ico\"
\"Position\"=\"Bottom\"

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\\Command\]
\@=\"$setuppath\"
"
#remove any {} from paths
regsub -all {[\{\}]} $regtext {} regtext

#Write regtext to install.reg, overwriting any old files
set chan [open $windir/$regfile w]
puts $chan $regtext
close $chan

tk_messageBox -type ok -title "BiblePix Installation" -icon info -message $winRegister
	
#Execute regfile
set regpath "[file nativename $windir]\\install.reg"
regsub -all {\\} $regpath {\\\\} regpath
if { [catch {exec cmd /c regedit.exe $regpath} ] } {
	tk_messageBox -type ok -title "BiblePix Installation" -icon error -message $winRegisterProb
	exit
} else {
	tk_messageBox -type ok -title "BiblePix Installation" -icon info -message $changeDesktopOk	
} 
