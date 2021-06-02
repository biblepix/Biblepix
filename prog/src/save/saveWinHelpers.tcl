# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2jun21 pv
#package require registry

#Set Registry compatible paths
set wishpath "[file nativename [auto_execok wish]]"
set srcpath "[file nativename $srcdir]"
set winpath "[file nativename $windir]"
##non-root
set regpath_autorun         [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\]
set regpath_backgroundtype  [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
##root privileges needed
set regpath_desktopbackground [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
set regpath_policies          [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Policies System} \\]

# regWinAutorun 
##(un)registers BiblePix Autorun (with args=unset)
##no admin rights required
##called by SaveWin
proc regAutorun args {
  global wishpath srcpath regpath_autorun

#puts [info level 0]

  ##extra "0022" must be since Tcl can't read paths with spaces!
  append execpath \u0022 $srcpath \\ biblepix.tcl \u0022

  #with args = delete
  if {$args != ""} {
    catch {registry delete "$regpath_autorun" "Biblepix"}
    return
  }

  registry set "$regpath_autorun" "Biblepix" "$execstring" 
}

# regWinContextMenu
##(un)registers BiblePix Context Menu
##ADMIN RIGHTS REQUIRED!
##removes any "Policies\System Wallpaper" key (blocks user intervention)
##called by SaveWin
proc regContextMenu args {
  global wishpath Setup winpath windir WinIcon
  global regpath_desktopbackground regpath_policies 
  
  set setupPath "[file nativename $Setup]"
  append iconPath  "[file nativename $winpath]" \\ biblepix.ico
  append commandPath "[file nativename $regpath_desktopbackground]" \\ Command

  ##setupCommand must have \\ usw. because of \" inside string, exactly like this:
  ## ...TODO get from $windir/install.reg !
  set wishpathRegfile [string map {\u005c \u005c\u005c} $wishpath]
  set setuppathRegfile [string map {\u005c \u005c\u005c} $setupPath]
  append setupCommand \u0022 $wishpathRegfile { } \\ \u0022 $setuppathRegfile \\ \u0022 \u0022
  
  #A) Check if path installed & all values correct (no admin rights required)
  ##check if key "Command" is present
  if ![catch {registry keys $regpath_desktopbackground}] {
  
    #B) Check command values
    ##1.Command value ##2. Icon value     ##3 Position value
    catch {registry get $commandPath ""} val1
    catch {registry get $regpath_desktopbackground Icon} val2
    catch {registry get $regpath_desktopbackground Position} val3

puts $val1
#puts $setupCommand
#puts $val2
#puts $iconPath
#puts $val3
#append setupCommandforCheck $wishpath { } \" $setupPath \"

#puts $setupCommandforCheck
  
    #C) Compare values with defaults 
    ##NOTE full paths are never matched!
    if {
      [string match "*[file tail $Setup]" $val1] &&
      [string match "*[file tail $WinIcon]" $val2] &&
      [string match "Bottom" $val3]
    } {
    #no reinstall needed
      return 0
    }
  }
  


  #B) Prepare reg file for execution as Admin  
  ##set obligatory intro line
  set regintro "Windows Registry Editor Version 5.00"
      
  #with args: prepare deletion
  if {$args != ""} {
    append regtext $regintro \n\n
    append regtext {[-HKEY_CLASSES_ROOT\DesktopBackground\Shell\Biblepix]}
  
  #else set values to add to Registry
  ##NOTE: to get proper values for *.reg files, have Regedit export some correct entry!
  } else {

    append regtext $regintro \n\n 

    ##add Biblepix Description + Iconpath + Position
    append regtext {[HKEY_CLASSES_ROOT\DesktopBackground\Shell\Biblepix]} \n
    append regtext {@="BiblePix Setup"} \n
    append regtext {"Icon"=} \u0022 "$iconPath" \u0022 \n
    append regtext {"Position"="Bottom"} \n\n
    ##add Biblepix command
    append regtext {[HKEY_CLASSES_ROOT\DesktopBackground\Shell\Biblepix\Command]} \n
    append regtext {@=} "$setupCommand" \n\n
    ##remove Wallpaper value from System policies
    append regtext {[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System]} \n
    append regtext {"Wallpaper"=-}
  }

  #Write regtext to install.reg, overwriting any old files
  set chan [open $windir/install.reg w]
  puts $chan $regtext
  close $chan

  #Execute regfile
  set regpath "[file nativename $windir]\\install.reg"
  catch {exec cmd /c regedit.exe $regpath}

} ;#END regContextMenu

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
  if !$error {
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

  #1.Save current theme to $windir for Uninstall
  set CustomThemePath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Custom.theme]
  catch {file copy $CustomThemePath $windir}

  #2.Write & execute BP theme
  set chan [open $themepath w]
  puts $chan $themetext
  close $chan
  
  exec cmd /c $themepath
} ;#END setWinTheme

# registerTcl
##registers run_? and .tcl extension
##Magicsplat registers different extension!
##called by ...
proc registerTcl {} {


}	
