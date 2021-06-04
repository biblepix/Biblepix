# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 4jun21 pv

# regWinAutorun 
##(un)registers BiblePix Autorun (with args=unset)
##no admin rights required
##NOTE: Windows "Designs" program is run if 'registry set' fails!
##called by SaveWin
proc regAutorun args {
  global wishpath srcpath regpath_autorun

  ##NOTE: extra "0022" needed since Tcl can't read paths with spaces!
  append commandpath \u0022 $srcpath \\ biblepix.tcl \u0022

  #A) with args: delete
  if {$args != ""} {
    catch {registry delete "$regpath_autorun" "Biblepix"}
    return
  }
  #B) register only if missing
  if { 
    [catch {registry get "$regpath_autorun" "Biblepix"} res] || 
    $res != "$commandpath"
  } {
    puts "Registering Autorun for Biblepix..."
    registry set "$regpath_autorun" "Biblepix" "$commandpath" 
  }
}

# regWinContextMenu
##(un)registers BiblePix Context Menu
##ADMIN RIGHTS REQUIRED!
##removes any "Policies\System Wallpaper" key (blocks user intervention)
##called by SaveWin
proc regContextMenu args {
  global wishpath setuppath windir winpath WinIcon
  global regpath_desktop regpath_policies iconKeyValue posKeyValue 
  
  ##setupCommand must have double \\ because of \" inside string, exactly like this:
  ## ...TODO get from $windir/install.reg !
  set wishpathRegfile [string map {\u005c \u005c\u005c} $wishpath]
  set setuppathRegfile [string map {\u005c \u005c\u005c} $setuppath]
  append setupCommandRegfile \u0022 $wishpathRegfile { } \\ \u0022 $setuppathRegfile \\ \u0022 \u0022
  
  #Prepare reg file for execution as Admin  
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
    append regtext {"Icon"=} \u0022 "$iconKeyValue" \u0022 \n
    append regtext {"Position"="Bottom"} \n\n
    ##add Biblepix command
    append regtext {[HKEY_CLASSES_ROOT\DesktopBackground\Shell\Biblepix\Command]} \n
    append regtext {@=} "$setupCommandRegfile" \n\n
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
#TODO müssen wir set backgroundtype ausführen?????##falsche frage, das Problem ist mit setWinTheme!

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
  catch {file copy "$CustomThemePath" $windir}

  #2.Write & execute BP theme
  set chan [open $themepath w]
  puts $chan $themetext
  close $chan
  
  #TODO this opens the Designs window!
  tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message "If the 'Designs' window pops up, just click on the X (exit) symbol so BiblePix can finish installation!"
  exec cmd /c $themepath
} ;#END setWinTheme

# registerTcl
##registers run_? and .tcl extension
##Magicsplat registers different extension!
##called by ...?
proc registerTcl {} {


}	
