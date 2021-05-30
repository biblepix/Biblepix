# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30may21 pv
package require registry

#Set Registry compatible paths
set wishpath "[file nativename [auto_execok wish]]"
set srcpath "[file nativename $srcdir]"
set winpath "[file nativename $windir]"
set regpath_autorun [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\]
set regpath_backgroundtype [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
set regpath_desktopbackground [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
set regpath_policies [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Policies System} \\]

# regWinAutorun 
##(un)registers BiblePix Autorun (with args=unset)
##no admin rights required
##called by SaveWin
proc regWinAutorun args {
  global wishpath srcpath regpath_autorun

  ##extra "" must be since Tcl can't read paths with spaces!
  append execpath \" $srcpath \\ biblepix.tcl \"

  #with args = delete
  if {$args != ""} {
    catch {registry delete "$regpath_autorun" "Biblepix"}
    return
  }
  #Check if already installed
  set installedkey [registry get "$regpath_autorun" "Biblepix"]
  append execstring $wishpath { } $execpath 
  if ![string match "$installedkey" "$execstring"] {
    registry set "$regpath_autorun" "Biblepix" "$execstring" 
  }
}



# regWinContextMenu
##(un)registers BiblePix Context Menu
##ADMIN RIGHTS REQUIRED!
##removes any "Policies\System Wallpaper" key (blocks user intervention)
##called by ...
proc regWinContextMenu args {
  global wishpath Setup winpath windir
  global regpath_desktopbackground regpath_policies
  
  append SetupPath "[file nativename $Setup]"

#amend paths for .reg file (double \\ needed)
#  regsub -all {\\} $wishpath {\\\\} wishpath
#  regsub -all {\\} $SetupPath {\\\\} SetupPath
#  regsub -all {\\} $winpath {\\\\} winpath

  append setupCommand $wishpath { } \" $SetupPath \"
  
  #detect if "unset"
  if {$args != ""} {
  
  
  	
#    set regtext "Windows Registry Editor Version 5.00

#\[\-HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
#"
#TODO how about this instead:
registry delete "$regpath_desktopbackground"
return 
 }

#registry set $regpath_desktopbackground "BiblePix Setup"
registry set "$regpath_desktopbackground" "Icon" "$winpath\\biblepix.ico"
registry set "$regpath_desktopbackground" "Position" "Bottom"
registry set "$regpath_desktopbackground\\Command" "$setupCommand"
registry delete "$regpath_policies" "Wallpaper"




#    set regtext "Windows Registry Editor Version 5.00

#\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
#\@=\"BiblePix Setup\"
#\"Icon\"=\"$winpath\\\\biblepix.ico\"
#\"Position\"=\"Bottom\"

#\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\\Command\]
#\@=\"$setupCommand\"

#\[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\]
#\"Wallpaper\"=-
#"
  


  #remove any {} from paths
  #regsub -all {[\{\}]} $regtext {} regtext

  #Write regtext to install.reg, overwriting any old files
#  set chan [open $windir/install.reg w]
#  puts $chan $regtext
#  close $chan

#  #Execute regfile
#  set regpath "[file nativename $windir]\\install.reg"
#  regsub -all {\\} $regpath {\\\\} regpath

#TODO move to main process  
#  catch {exec cmd /c regedit.exe $regpath}

} ;#END setWinContextMenu

# getBackgroundType
##Detect running slideshow 
##no admin rights required (entry reset by Windows when user sets bg)
##Types: 0=Einzelbild / 2=Diaschau / 1=Volltonfarbe
##called by SaveWin
proc getBackgroundType {} {
  global winChangingDesktop regpath_backgroundtype
  
  set error [catch {set BackgroundType [registry get $regpath_backgroundtype BackgroundType]}]
  if {!$error && $BackgroundType == 0} {
    return
  }
  if {!$error} {
    tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winChangingDesktop
    setWinTheme
  }
}

# setWinTheme
##sets & runs 'single pic' .theme file if running slideshow detected
##called by getBackgroundType
proc setWinTheme {} {
  global env TwdTIF windir

  set themepath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Biblepix.theme]
  set themetext "\[Theme\]
DisplayName=BiblePix

\[Control Panel\\Desktop\]
Wallpaper=[file normalize $TwdTIF]
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
} ;#END setWinTheme

#TODO use 1 .REG file for all procs!

# registerTcl
##registers run_? and .tcl extension
##(Magicsplat registers different extension!)
##called by ...
proc registerTcl {} {


}
