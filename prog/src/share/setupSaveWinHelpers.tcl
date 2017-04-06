# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6apr17

proc setWinAutorun args {
#sets/unsets BiblePix Autorun
#no admin rights required
       global wishpath srcpath

        set regpath_autorun [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\]
        set regtext "$wishpath [file nativename [file join $srcpath biblepix.tcl]]"
        regsub -all {[\{\}]} $regtext {} regtext

	if {[info exists args]} {
		registry delete $regpath_autorun Biblepix
	} else {
		registry set $regpath_autorun Biblepix $regtext
	}
}

proc setWinContextMenu args {
#sets/unsets BiblePix Context Menu
#ADMIN RIGHTS REQUIRED
#adds context menu & icon
#removes any "Policies\System Wallpaper" key (blocks user intervention)
global wishpath Setup srcpath winpath winRegister windir

	#amend paths for .reg file (double \\ needed)
	regsub -all {\\} $wishpath {\\\\} wishpath
	regsub -all {\\} $srcpath {\\\\} srcpath
	regsub -all {\\} $winpath {\\\\} winpath

	set setuppath "$wishpath $srcpath\\\\biblepix-setup.tcl"
	#detect if "unset"
	if {[info exists args]} {
	set regtext "Windows Registry Editor Version 5.00

\-\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
"

	} else {

	set regtext "Windows Registry Editor Version 5.00

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
\@=\"BiblePix Setup\"
\"Icon\"=\"$winpath\\\\biblepix.ico\"
\"Position\"=\"Bottom\"

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\\Command\]
\@=\"$setuppath\"

\[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\]
\"Wallpaper\"=-
"
	}
	#remove any {} from paths
	regsub -all {[\{\}]} $regtext {} regtext

	#Write regtext to install.reg, overwriting any old files
	set chan [open $windir/install.reg w]
	puts $chan $regtext
	close $chan

	#Execute regfile
	set regpath "[file nativename $windir]\\install.reg"
	regsub -all {\\} $regpath {\\\\} regpath
	exec cmd /c regedit.exe $regpath

}  ;#END setWinContextMenu


proc setWinTheme args {
#Runs /Deletes 'single pic' theme if running slideshow detected
global env enablepic slideshow TwdTIF

	#Detect running slideshow (entry reset by Windows when user sets bg)
	set regpathExplorer [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
	set BackgroundType [registry get $regpathExplorer BackgroundType]
        
        if {$BackgroundType != 0} {
        
	        set themepath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Biblepix.theme]
		set themetext "\[Theme\]
DisplayName=BiblePix

\[Control Panel\\Desktop\]
Wallpaper=[file nativename $TwdTIF]
TileWallpaper=0
WallpaperStyle=2

\[VisualStyles\]
Path=%SystemRoot%\\resources\\themes\\Aero\\Aero.msstyles
ColorStyle=NormalColor
Size=NormalSize
VisualStyleVersion=10

\[MasterThemeSelector\]
MTSM=DABJDKT"

		#1.Save current theme to $windir (for Uninstall)
		set CustomThemePath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Custom.theme]
		catch {file copy $CustomThemePath $windir}

		#2.Write & execute BP theme
		set chan [open $themepath w]
		puts $chan $themetext
		close $chan
        	exec cmd /c $themepath
	}

}  ;#END setWinTheme
