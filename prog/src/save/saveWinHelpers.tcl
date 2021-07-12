# ~/Biblepix/prog/src/share/setupSaveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 12jul21 pv

#set paths for SaveWin & Uninstall
#TODO these all include %LOCALAPPDATA% ....!!!!!!!!!!!
#set wishpath "[file nativename $wishpath]"
set srcpath "[file nativename $srcdir]"
set winpath "[file nativename $windir]"
set setuppath "[file nativename $Setup]"
set wishpath "[file nativename [auto_execok wish]]"

#NOTE these vars are to be used by TCL!
append regpath_root %LOCALAPPDATA% \\ Biblepix
append regpath_src "$regpath_root" \\ prog \\ src
append regpath_setup "$regpath_root" \\ biblepix-setup.tcl
append regpath_bp "$regpath_src" \\ biblepix.tcl
append regpath_imgdir "$regpath_root" \\ TodaysPicture

#Registry paths
set regpath_autorun         [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Run} \\]
set regpath_policies        [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Policies System} \\]
set regpath_backgroundtype  [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
##TODO testing
set regpath_Wallpapers $regpath_backgroundtype
set regpath_DesktopSlideshow [join {HKEY_CURRENT_USER {Control Panel} Personalization {Desktop Slideshow}} \\]

##admin privileges needed for this one (therefore need install.reg, commandline doesn't work)
set regpath_desktop         [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]

#Check wishpath (Magicsplat or any)
##Magicsplat
if [regexp AppData $wishpath] {
  set regpath_wish {%LOCALAPPDATA%\Apps\Tcl86\bin\wish.EXE}
##ActiveTcl or any
} else {
  set regpath_wish "[file nativename $wishpath]"
}

#REGify path to Biblepix Setup
append setupCmdpath "$regpath_wish" { } \u0022 "$regpath_setup" \u0022
set setupCmdpath [string map { \u007B {} \u007D {} } $setupCmdpath] 

#REGify path to Biblepix executable
append bpCmdpath "$regpath_wish" { } \u0022 "$regpath_bp" \u0022
set bpCmdpath [string map { \u007B {} \u007D {} } $bpCmdpath]


###########################################################
# A)  P R O C S   W I T H O U T   A D M I N   R I G H T S  
################### TO BE RUN AT EACH SETUP ###############

# regAutorun 
##(un)registers BiblePix Autorun (with args=unset)
##no admin rights required
##NOTE: Windows "Designs" program is run if 'registry set' fails!
##called by SaveWin
proc regAutorun args {
  global regpath_autorun bpCmdpath

  #A) with args: delete
  if {$args != ""} {
    catch {registry delete "$regpath_autorun" "Biblepix"}
    return
  }
  
  #B) Register
  puts "Registering BiblePix Autorun..."
  registry set "$regpath_autorun" "Biblepix" "$bpCmdpath" expand_sz
} ;#END regAutorun

# regDesktopBg
##needs 2 pictures to work!
##called by setWinTheme
proc regDesktopBg args {
  global regpath_Wallpapers regpath_DesktopSlideshow regpath_imgdir
  global slideshow imgdir
  
  #A) with args: delete
  if {$args != ""} {
    catch {registry delete "$regpath_Wallpapers" CurrentWallpaperPath}
    return
  }
  
  #B) Register
  puts "Registering BiblePix desktop background..."
  
  ##1. set slideshow
  registry set $regpath_DesktopSlideshow Interval [expr $slideshow * 1000] sz
  registry set $regpath_DesktopSlideshow Shuffle 0 dword
  ##2. set wallpaper: type=2 (slideshow) |
  registry set $regpath_Wallpapers BackgroundType 2 dword
  registry set $regpath_Wallpapers CurrentWallpaperPath "$regpath_imgdir" expand_sz
  ##3. Not sure what this does (set lockscreen?)
  registry set $regpath_Wallpapers SlideshowSourceDirectoriesSet 1 dword

  exec RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True
}

##################################################################
# B)  P R O C S   W I T H   A D M I N   R I G H T S 
# User action required - to be run only if parameters have changed
################################################################## 

# regContextMenu
##(un)registers BiblePix Context Menu
##removes any "Policies\System Wallpaper" key (blocks user intervention)
##called by SaveWin
proc regContextMenu args {
  global wishpath setuppath windir winpath WinIcon
  global regpath_desktop regpath_policies posKeyValue 
  
  puts "Registering BiblePix context menu..."
  ##setupCommand must have double \\ because of \" inside string, exactly like this (from $windir/install.reg):
  ## "C:\\Users\\USER NAME\\AppData\\Local\\Apüs\\Tcl86\\bin\\wish.EXE \"C:\\Users ... biblepix-setup.tcl\""
  ##TODO?: variable expansion EXPAND_SZ (here needed for %%LOCALAPPDATA%) cannot be set easily via a REG file, for now leave paths as they are! 
  #double \\ (=\u005c)
  set wishpathRegfile [string map {\u005c \u005c\u005c \u007B {} \u007D {} } $wishpath]
  set setuppathRegfile [string map {\u005c \u005c\u005c} $setuppath]
  set iconpath [file nativename $WinIcon]
  set iconpathRegfile [string map {\u005c \u005c\u005c} $iconpath]
  
  append setupCommandRegfile \u0022 $wishpathRegfile { } \\ \u0022 $setuppathRegfile \\ \u0022 \u0022
  append iconPathRegfile \u0022 $iconpathRegfile \u0022
  
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
    append regtext {"Icon"=} "$iconPathRegfile" \n
    append regtext {"Position"="Bottom"} \n\n
    ##add Biblepix command
    append regtext {[HKEY_CLASSES_ROOT\DesktopBackground\Shell\Biblepix\Command]} \n
    append regtext {@=} "$setupCommandRegfile" \n\n
    ##remove Wallpaper value from System policies (needs to be done by regfile)
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

# setWinTheme
##sets & runs ?single pic? theme 
##NOTE: .theme file required here TO ACTIVATE above Wallpaper settings!
##run only if Initial OR if slideshow settings have changed
##called by SaveWin
proc setWinTheme {} {
  global env TwdTIF windir winIgnorePopup
  set themepath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Biblepix.theme]

  #Warn of Designs window popping up
  tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winIgnorePopup

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
  
  exec cmd /c $themepath

  #Register slideshow, interval & pipaths
  regDesktopBg
} ;#END setWinTheme

