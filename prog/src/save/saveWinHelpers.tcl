# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15may19

package require registry

#Set Registry compatible paths
set wishpath [file nativename [auto_execok wish]]
set srcpath [file nativename $srcdir]
set winpath [file nativename $dirlist(windir)]

#sets/unsets BiblePix Autorun
#no admin rights required
proc setWinAutorun args {
  global wishpath srcpath

  set regpath_autorun [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\]

  if {$args == ""} {
    set regtext "$wishpath [file nativename [file join $srcpath biblepix.tcl]]"
    regsub -all {[\{\}]} $regtext {} regtext
    
    registry set $regpath_autorun Biblepix $regtext
  } else {
    catch {registry delete $regpath_autorun Biblepix}
  }
}

#Detect running slideshow (entry reset by Windows when user sets bg)
#no admin rights required
proc setBackgroundType {} {
  global winChangingDesktop

  set regpathExplorer [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
  set regpathExplorerOld [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]

  set error [catch {set BackgroundType [registry get $regpathExplorer BackgroundType]}]

  if {!$error && $BackgroundType == 0} {
    return
  }

  set error [catch {set BackgroundType [registry get $regpathExplorerOld BackgroundType]}]
  if {!$error && $BackgroundType == 0} {
    return
  }

  if {!$error} {
    tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winChangingDesktop
    setWinTheme
  }
}

#sets/unsets BiblePix Context Menu
#ADMIN RIGHTS REQUIRED
#adds context menu & icon
#removes any "Policies\System Wallpaper" key (blocks user intervention)
proc setWinContextMenu args {
  global wishpath Setup winpath dirlist
  
  set SetupPath [file nativename $Setup]

  #amend paths for .reg file (double \\ needed)
  regsub -all {\\} $wishpath {\\\\} wishpath
  regsub -all {\\} $SetupPath {\\\\} SetupPath
  regsub -all {\\} $winpath {\\\\} winpath

  set setupCommand "$wishpath $SetupPath"
  
  #detect if "unset"
  if {$args != ""} {
    set regtext "Windows Registry Editor Version 5.00

\[\-HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
"
  } else {
    set regtext "Windows Registry Editor Version 5.00

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\]
\@=\"BiblePix Setup\"
\"Icon\"=\"$winpath\\\\biblepix.ico\"
\"Position\"=\"Bottom\"

\[HKEY_CLASSES_ROOT\\DesktopBackground\\Shell\\Biblepix\\Command\]
\@=\"$setupCommand\"

\[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\]
\"Wallpaper\"=-
"
  }
  
  #remove any {} from paths
  regsub -all {[\{\}]} $regtext {} regtext

  #Write regtext to install.reg, overwriting any old files
  set chan [open $dirlist(windir)/install.reg w]
  puts $chan $regtext
  close $chan

  #Execute regfile
  set regpath "[file nativename $dirlist(windir)]\\install.reg"
  regsub -all {\\} $regpath {\\\\} regpath
  
  catch {exec cmd /c regedit.exe $regpath}

} ;#END setWinContextMenu


#Runs 'single pic' theme if running slideshow detected
proc setWinTheme {} {
  global env TwdTIF

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
  catch {file copy $CustomThemePath $dirlist(windir)}

  #2.Write & execute BP theme
  set chan [open $themepath w]
  puts $chan $themetext
  close $chan
  
  exec cmd /c $themepath
} ;#END setWinTheme
