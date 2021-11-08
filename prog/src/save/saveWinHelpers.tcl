# ~/Biblepix/prog/src/save/saveWinHelpers.tcl
# Sourced by SetupSaveWin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 8nov21 pv

#set basic paths
set rootpath "[file nativename $rootdir]"
set srcpath "[file nativename $srcdir]"
set winpath "[file nativename $windir]"
set setuppath "[file nativename $Setup]"
set wishpath "[file nativename $wishpath]"

set LADpath $env(localappdata)
set LADsearchstring {AppData.Local}
set reg_rootpath [string map { \u007B {} \u007D {} } $rootpath]
set reg_wishpath [string map { \u007B {} \u007D {} } $wishpath]

#REGify wishpath (ActiveTcl, Magicsplat or any), checking if within %LOCALAPPDATA%
##probably: %LOCALAPPDATA%\Apps\Tcl86\bin\wish.EXE
if [regexp $LADsearchstring $wishpath] {
  set reg_wishpath [string replace $reg_wishpath 0 [string length $LADpath] %LOCALAPPDATA%\\]
}
##REGify rootpath (standard or git), checking if within %LOCALAPPDATA%
if [regexp $LADsearchstring $rootpath] {
  #set reg_rootpath [string replace $rootpath 0 [string length $LAD] %LOCALAPPDATA%\\]
  set reg_rootpath %LOCALAPPDATA%\\Biblepix\\
}

#REGify all paths
append reg_srcpath "$reg_rootpath" \\ prog \\ src
append reg_setuppath "$reg_rootpath" \\ biblepix-setup.tcl
append reg_bppath "$reg_srcpath" \\ biblepix.tcl
append reg_imgdir "$reg_rootpath" \\ TodaysPicture

#set Registry paths
set regpath_autorun         [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Run} \\]
set regpath_policies        [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Policies System} \\]
set regpath_wallpapers      [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
set regpath_desktop         [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
set regpath_controlpanel    [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
set regpath_slideshow       [join {HKEY_CURRENT_USER {Control Panel} Personalization {Desktop Slideshow}} \\]

append setupCmdpath "$reg_wishpath" { } \u0022 "$reg_setuppath" \u0022
append bpCmdpath "$reg_wishpath" { } \u0022 "$reg_bppath" \u0022


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


# regInitialWallpaper
##sets initial paths, later to be renewed by setWinBg
##this is for completeness only, effects not documented!
##called by SaveWin
proc regInitialWallpaper args {
  global reg_imgdir regpath_controlpanel regpath_slideshow slideshow
  
  #A) with args: delete
  if {$args != ""} {
    registry delete $regpath_controlpanel Wallpaper
    registry delete $regpath_slideshow Interval 0 dword
    return
  }
  
  #B) Set wallpaper path & style & interval

  ##path renewed by setWinBg at each run / style set to 0 (=zentriert)
  registry set $regpath_controlpanel Wallpaper $reg_imgdir expand_sz
  registry set $regpath_controlpanel WallpaperStyle 0

  #Set Registry slideshow interval 
  ##this is respected by Windows even if user sets background to the standard (1/10/30 mins.)
  ##however after user intervention this setting must be reset by Biblepix Setup (see Manual)
  ##only useful if Windows slideshow is activated
  registry set $regpath_slideshow Interval [expr $slideshow * 1000] dword

  #These settings may be redundent
  catch {registry set $regpath_slideshow Shuffle 0 dword}
  catch {registry set $regpath_wallpapers SlideshowSourceDirectoriesSet 0 dword}
}

# regBackgroundType
##Runs Win Theme if running slideshow detected
##types: 0=singlepic 1=colour 2=slideshow
##types usually set by user action in Settings>Wallpaper, with right-click on Desktop >Customize/Anpassen
##called by SaveWin
proc regBackgroundType {} {
  global regpath_wallpapers regpath_slideshow slideshow
  
  set error [catch {set BackgroundType [registry get $regpath_wallpapers BackgroundType]}]
  
  if {!$error && $BackgroundType == 0} {
    return
  }

  #O B S O L E T E D ! ! !
  #  setWinTheme

  #Set registry background type to 0 = single pic
  registry set $regpath_wallpapers BackgroundType 0 dword
  
  #Nützts nüt, so schadts nüt!
  exec RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
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
    ##NOTE: 'reg_expand_sz' for %LOCALAPPDATA% would require comma-separated hex(2)
    ##which produces a line longer than what we have now!
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

# setWinTheme - O B S O L E T E !
##sets & runs single pic theme
#####################################################################
## opens Settings>Theme window!
## Note: Settings>Background window is only opened by user action and
## only latter resets Background (see getBackgroundType)
## NOTE: .theme file required here TO ACTIVATE above Wallpaper settings!
## run only if Initial OR if slideshow settings have changed
###############################################################################
##-NOTE : AFTER A DAY'S TESTING THIS PROC DOES NOT SEEM TO MAKE ANY DIFFERENCE
## TO THE BUGGY WAY WINDOWS RESPECTS INTERVALS - !!!
## i.e. simple change by Setup also does the job !!!!!
###############################################################################
##called by RegBackgroundType
proc setWinTheme {} {
  global env TwdBMP windir winIgnorePopup
  set themepath [file join $env(LOCALAPPDATA) Microsoft Windows Themes Biblepix.theme]

  #Warn of Designs window popping up
  tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $msgbox::winIgnorePopup

  set themetext "\[Theme\]
DisplayName=BiblePix

\[Control Panel\\Desktop\]
Wallpaper=[file normalize $TwdBMP]
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

#TODO re-register interval after this!

  #Register slideshow, interval & pipaths
  #regDesktopBg

} ;#END setWinTheme

