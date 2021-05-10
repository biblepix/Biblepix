#~/Biblepix/prog/src/save/saveLinHelpers.tcl
# Sourced by SetupSaveLin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 10may21 pv

################################################################################################
# A)  A U T O S T A R T : KDE / GNOME / XFCE4 all respect the Linux Desktop Autostart mechanism
#   more exotic Desktops NEED CONFIGURING via CRONTAB (see below)
#
# B)  D E S K T O P   M E N U : (Rightclick for Setup) works with KDE / GNOME / XFCE4 
#   other desktops can't be configured, hence information about Setup path is important >Manual
################################################################################################

#Set & create general Linux Desktop dirs
##recognised by alle Desktops, including KDE5
set LinConfDir [file join $HOME .config]
set LinDesktopFilesDir [file join $HOME .local share applications]
file mkdir $LinDesktopFilesDir
set Kde4ConfFile "plasma-desktop-appletsrc"
set Kde5ConfFile "plasma-org.kde.plasma.desktop-appletsrc"
  
proc getKdeVersion {} {
  global HOME Kde4ConfFile
  set plasmaSnippet "desktop-appletsrc"
    
  cd $HOME
  set KdeConfFilepath [glob -nocomplain *$plasmaSnippet]
  ##work with names only - paths may change!
  set KdeVersion 5
  if {$KdeConfFilepath != ""} {
    if { [file tail $KdeConfFilepath] == "$Kde4ConfFile" } {
    set KdeVersion 4
  }
  
  return "$KdeVersion $KdeConfFilepath"
}

##Set KDE dirs / Create ~/.kde if missing
#TODO this may not be needed, se below!
#set KdeDir [glob -nocomplain $HOME/.kde*]
#if {$KdeDir == ""} {
#  file mkdir $HOME/.kde
#}
#according to some KDE plasma files can be in either : .kde/.config OR .config
#TODO need to distinguish Plasma 4 and Plasma 5 conf files!


#TODO do we need this?= 
set KdeConfDir [file join $KdeDir share config]
file mkdir $KdeConfDir

#Determine KDE config files - TODO This was determined above!!!!!!!!!!!!!!!!!!!
#set Kde4ConfFile $KdeConfDir/plasma-desktop-appletsrc
#set Kde5ConfFile $LinConfDir/plasma-org.kde.plasma.desktop-appletsrc

set KdeConf [getKdeVersion]
set KdeVersion [lindex $KdeConf 0]
set KdeConfFilepath [lindex $KdeConf 1]

##KDE4 deprecated service path - only respected if KdeVersion=4
set Kde4ServiceDir ~/.kde/share/kde4/services


#Wayland/Sway
set SwayConfFile $LinConfDir/sway/config
#XFCE4
set Xfce4ConfFile $LinConfDir/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

# 1  M E N U   E N T R Y   .DESKTOP   F I L E 

## A) GNOME/XFCE/KDE5
set LinDesktopFile $LinDesktopFilesDir/biblepixSetup.desktop

## B) KDE4
set Kde4DesktopFile $KdeConfDir/share/kde4/services/biblepixSetup.desktop

## C) MENU ENTRY RIGHTCLICK FILE (works only for some Plasma 5 versions of Konqueror/Dolphin?)
set Kde5DesktopActionFile $LinDesktopFilesDir/biblepixSetupAction.desktop

# 3 Autostart files
##this is obsolete:
set Kde4AutostartDir $KdeDir/Autostart
set Kde4AutostartFile $Kde4AutostartDir/biblepix.desktop
set LinAutostartDir $LinConfDir/autostart
file mkdir $LinAutostartDir
set LinAutostartFile $LinAutostartDir/biblepix.desktop

# formatLinuxExecutables
## 1 Check first line of Linux executables for correct 'env' path
#### Standard env path as in Ubuntu/Debian/Gentoois /usr/bin/env
## 2 Make files executable
## 3 make ~/bin/biblepix-setup.sh
## 4 Add ~/bin to PATH in .bashrc
## Called by SaveLin
proc formatLinuxExecutables {} {
  global Setup Biblepix env
  set standardEnvPath {/usr/bin/env}
  set currentEnvPath [auto_execok env]

  #1. Set permissions to executable
  file attributes $Biblepix -permissions +x
  file attributes $Setup -permissions +x
  
  #2. Reset 1st Line if not standard
  if {$currentEnvPath != $standardEnvPath} {
    setShebangLine $currentEnvPath
  }

  # 3. Put Setup bash script in $HOME/bin (precaution in case it can't be found in menus)
  set homeBin $env(HOME)/bin
  set homeBinFile $homeBin/biblepix-setup.sh
  
  if { ![file exists $homeBin] } {
    file mkdir $homeBin
    file attributes $homeBin -permissions +x
  }
  #Create script text and save
  set chan [open $homeBinFile w]
  append t #!/bin/sh \n exec { } $Setup
  puts $chan $t
  close $chan
  
  # 4. Add ~/bin to $PATH in .bashrc
  set bashrc "$env(HOME)/.bashrc"
  set PATH $env(PATH)

  ##check PATH & make entry text
  if {![regexp $homeBin $PATH]} {
    set homeBinText "
if \[ -d $env(HOME)/bin \] ; then
export PATH=\$HOME/bin:\$PATH
fi"
    #read out existing .bashrc
    if [file exists $bashrc] {
      set chan [open $bashrc r]
      set t [read $chan]
      close $chan
    } {
      set t ""
    }
    
    #append text if missing
    if {![regexp $homeBin $t]} {
      puts "Adding path entry to .bashrc..."
      set chan [open $bashrc a]
      puts $chan $homeBinText
      close $chan
    }
  }

  #Clean up & make file executable
  catch {unset shBangLine $t}
  file attributes $homeBinFile -permissions +x

} ;#END formatLinuxExecutables


# setShebangLine
## changes 1st line of executables (Biblepix+Setup) if wrong
## called by formatLinuxExecutables
proc setShebangLine {currentEnvPath} {
    global Biblepix Setup
    append shBangLine #! $currentEnvPath { } tclsh

    ##read out Biblepix & Setup texts
    set chan1 [open $Biblepix r]
    set chan2 [open $Setup r]
    set text1 [read $chan1]
    set text2 [read $chan2]
    close $chan1
    close $chan2

    ##replace 1st line with current sh-bang
    regsub -line {^#!.*$} $text1 $shBangLine text1
    set chan [open $Biblepix w]
    puts $chan $text1
    close $chan
    regsub -line {^#!.*$} $text2 $shBangLine text2
    set chan [open $Setup w]
    puts $chan $text2
    close $chan

    #Cleanup
    catch {unset $text1 $text2}

} ;#END setShebangLine


####################################
# A U T O S T A R T   S E T T E R S
####################################

# setupLinAutostart
## makes Autostart entries for Linux Desktops: GNOME, XFCE4, KDE4, KDE5, Wayland/Sway
## args == delete
## called by SetupSaveLin
proc setupLinAutostart args {
  global Biblepix Setup LinIcon bp LinAutostartFile Kde4AutostartDir Kde4AutostartFile SwayConfFile
  #set Err 0
  
  #If args exists, delete any autostart files and exit
  if  {$args != ""} {
    file delete $LinAutostartFile $Kde4AutostartFile
    catch {setSwayConfig delete}
    return 0
  }
  
  #Delete any previous crontab entry
  catch {setupLinCrontab delete}

  #set Texts
  set desktopText "\[Desktop Entry\]
Name=$bp
Type=Application
Icon=$LinIcon
Comment=Runs BiblePix at System boot
StartupNotify=false
X-KDE-StartupNotify=False
Exec=$Biblepix
"
  #Make .desktop file for KDE4 Autostart (obsolete)
  if [file exists $Kde4AutostartDir] {
    set chan [open $Kde4AutostartFile w]
    puts $chan $desktopText
    close $chan
    file attributes $Kde4AutostartFile -permissions +x
  }

  #Make .desktop file for GNOME/XFCE/KDE5 Autostart
  set chan [open $LinAutostartFile w]
  puts $chan $desktopText
  close $chan
  file attributes $LinAutostartFile -permissions +x
  
  
  #Set up Sway if conf file found
  if [file exists $SwayConfFile] {
    if [catch setupSwayBackground] {
      puts "Having problem setting up Sway background"
      return 1
    }
  }
    return 0
  
} ;#END setupLinAutostart

# setupSwayBackground
## makes entries for BP autostart and initial background pic
## args==delete entry
## called by setupLinAutostart
proc setupSwayBackground args {
  global LinConfDir SwayConfFile Biblepix env

  #Read out text
  set chan [open $SwayConfFile r]
  set configText [read $chan]
  close $chan

  #Check previous entries
  set entryFound 0
  if [regexp {[Bb]ible[Pp]ix} $configText] {
    set entryFound 1
  }

  #Delete any entry if "args"
  if {$args != "" && $entryFound} {
    set chan [open $SwayConfFile w]
    regsub -all -line {^.*ible[Pp]ix.*$} $configText {} configText
    puts $chan $configText
    close $chan
    puts "Deleted BiblePix entry from $SwayConfFile"
    return 0
  }
  
  #Skip if entry found
  if {$entryFound} {
    puts "Sway config: Nothing to do."
    return 0
  }
  #Append entry
  append autostartLine \n # {BiblePix: this runs BiblePix & sets initial background picture} \n exec { } $Biblepix
  set outputList [getSwayOutputName]

  #append lines at end of file
  set chan [open $SwayConfFile a]
  puts $chan $autostartLine
  foreach outputName $outputList {
    puts $chan "exec swaymsg output $outputName bg $::TwdBMP center"
  }
  close $chan

  puts "Made BiblePix entry in $SwayConfFile"
  return 0
}

#TESTING WESTON (if running): 
##THIS WONT WORK WITHOUT Weston providing an Autostart mechanism!
#TODO: implemented in detectRunningLinuxDesktop
proc setupWestonBackground {} {
	global TwdPNG env

	if [info exists env(WESTON_CONFIG_FILE)] {
		set westonConfFile $env(WESTON_CONFIG_FILE)
	} elseif [file exists .config/weston.ini] {
		set westonConfFile .config/weston.ini
	}
	set chan [file open $westonConfFile r]
	set fileText [read $chan]
	close $chan

	if [regexp iblepix $newfileileText] {
	puts "Nothing to do"		
	return 1
	}
	
	set chan [file open $westonConfFile w]
	
	if [regexp background-image $newfileileText] {
		regsub -line {(background-image=)(.*$) $newfileileText \2$TwdPNG} fileText
	} elseif [regexp Shell $newfileileText] {
		regsub -line {^\[Shell\].*$} $newfileileText {[Shell]
background-image=$TwdPNG} fileText
	} else {
		append fileText \n \[Shell\] \n background-image=$TwdPNG \n background-type=scale-crop
	}

	puts $chan $newfileileText
	close $chan
	return 0
}


################################################################################
#  M E N U  E N T R Y   C R E A T E R   F O R   L I N U X   D E S K T O P S
################################################################################

# setupLinMenu
## Makes .desktop files for Linux Program Menu entries 
## Works on KDE / GNOME / XFCE4
## called by SetupSaveLin

########################################################
## Possible paths:
#
## General Linux & KDE5: 
# ~/.local/share/applications
#
## KDE4 - deprecated, used if dirs exist:
## ~/.kde/share/kde4/services
## KDE5 - ignored (see general Linux):
## ~/.local/share/applications/kservices5/ServiceMenus
## ~/.local/share/kservices5/ServiceMenus
########################################################
proc setupLinMenu {} {
  global LinIcon srcdir Setup bp LinDesktopFilesDir KdeVersion Kde4ServiceDir
  set filename "biblepixSetup.desktop"
  set categories "Settings;Utility;Education;DesktopSettings;Core"
  
  #set Texts
  set desktopText "\[Desktop Entry\]
Name=$bp Setup
Type=Application
Icon=$LinIcon
Categories=$categories
Comment=Runs & configures $bp
Exec=$Setup
"

  #make .desktop file for GNOME & KDE prog menu
  set chan [open $LinDesktopFilesDir/$newfileilename w]
  puts $chan $desktopText
  close $chan
  
  #make .desktop file for KDE4, if dir exists
  if {$KdeVersion==4} {
    set categories "Education;Graphics"
    set chan [open $Kde4ServiceDir/$newfileilename w]
    puts $chan $desktopText
    close $chan
  }
  return 0
  
} ;#END setupLinMenu

# setupKdeActionMenu
## Produces right-click action menu in Konqueror (and possibly Dolphin?)
## seen to work only in some versions of KDE5 - very buggy!
## Called by SetupSaveLin ?if KDE detected?

########################################################
#Below proved to work sometimes:
#  reference Text:
#[Desktop Entry]
#Type=Service
#ServiceTypes=KonqPopupMenu/Plugin
#MimeType=all/all;
#Actions=countlines;
#X-KDE-Submenu=Count
#X-KDE-StartupNotify=false
#X-KDE-Priority=TopLevel

#[Desktop Action countlines]
#Name=Count lines
#Exec=kdialog --msgbox "$(wc -l %F)"
############################################################

#This works with Konqueror and Dolphin (only KDE4?)
proc setupKdeActionMenu {} {
  global bp LinIcon Setup Kde5DesktopActionFile
  set desktopFilename "biblepixSetupAction.desktop"
  set desktopText "\[Desktop Entry\]
Type=Service
MimeType=all/all;
Actions=BPSetup;
X-KDE-ServiceTypes=KonqPopupMenu/Plugin
X-KDE-StartupNotify=true
X-KDE-Priority=TopLevel
OnlyShowIn=Old;

\[Desktop Action BPSetup\]
Name=$bp Setup
Icon=$LinIcon
Exec=$Setup
"
  set chan [open $Kde5DesktopActionFile w]
  puts $chan $desktopText
  close $chan
  
  return 0
}


################################################
# B A C K G R O U N D   P I C   S E T T E R S
################################################

# setupKdeBackground
## Configures KDE4 or KDE5 Plasma for single pic or slideshow
# TODO: > Anleitung in Manpage für andere KDE-Versionen/andere Desktops (Rechtsklick > Desktop-Einstellungen >Einzelbild/Diaschau)

proc setupKdeBackground {} {
  global KdeVersion Kde4ConfFile Kde5ConfFile TwdPNG slideshow dirlist

  #check kread/kwrite executables
  if {[auto_execok kreadconfig5] != "" && 
      [auto_execok kwriteconfig5] != ""} {
    set kread kreadconfig5
    set kwrite kwriteconfig5

  } elseif { [auto_execok kreadconfig] != "" && 
      [auto_execok kwriteconfig] != ""} {
    set kread kreadconfig
    set kwrite kwriteconfig

puts $kwrite
puts $kread
  } else {

    return 1
  }

  #set KDE4 if detected
  set errCode4 ""
  if {$KdeVersion==4} {
    catch {setupKde4Bg $Kde4ConfFile $kread $kwrite} errCode4
puts $errCode4

  }

  #set KDE5 always
  catch {setupKde5Bg $Kde5ConfFile $kread $kwrite} errCode5
puts $errCode5

  if {$errCode4=="" && $errCode5==""} {
    return 0
  } else {
    return "KDE4: $errCode4 / \nKDE5: $errCode5"
  }
  
} ;#END setKdeBackground

# setupKde4Bg
# called by setKdeBackground if KDE4 rcfile found
proc setupKde4Bg {Kde4ConfFile kread kwrite} {
  global slideshow dirlist
  set rcfile [file tail $Kde4ConfFile]
  puts "Setting up KDE4 background..."
  
  if {!$slideshow} {
    set interval 3600
  } else {
    set interval $slideshow
  }
  
  set slidepaths $dirlist(imgDir)
  set mode Slideshow
        
  for {set g 1} {$g<200} {incr g} {

    if {[exec $kread --file $rcfile --group Containments --group $g --key wallpaperplugin] != ""} {
    
      puts "Changing KDE $rcfile Containments $g ..."

      #1. [Containments][$g]
      ##this is always 'image'
      exec $kwrite --file $rcfile --group Containments --group $g --key wallpaperplugin image
      exec $kwrite --file $rcfile --group Containments --group $g --key wallpaperpluginmode $mode

      #2. [Containments][$g][Wallpaper][image]
      ##this is in seconds:
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group image --key slideTimer $interval
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group image --key slidepaths $slidepaths
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group image --key wallpaper $::TwdPNG
      ##position: 1 seems to be 'centered'
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group image --key wallpaperposition 1
    }
  }
  return 0
} ;#END setKde4Bg

# setupKde5Bg
## called by setKdeBackground if KdeVersion==5
## expects rcfile [file join $env(HOME) .config plasma-org.kde.plasma.desktop-appletsrc]
## expects correct version of kreadconfig(?5) kwriteconfig(?5)
## must be set to slideshow even if single picture, otherwise it is never renewed at boot
#

###This was produced by KDE5 upon choosing slideshow: #########################
# [Containments][1][Wallpaper][General]
# Image=file:///usr/share/desktop-base/joy-inksplat-theme/wallpaper/contents/images/1280x1024.svg
# SlidePaths=/usr/share/images

#(We don't (re)produce this section)
# [Containments][1][Wallpaper][org.kde.image][General]
# Image=file:///usr/share/desktop-base/joy-inksplat-theme/wallpaper/contents/images/1280x1024.svg
# height=1024
# width=1280

# [Containments][1][Wallpaper][org.kde.slideshow][General]
# SlideInterval=30
# SlidePaths=/home/pv/Biblepix/Image
# height=1024
# width=1280
################################################################################3
proc setupKde5Bg {Kde5ConfFile kread kwrite} {
  global slideshow TwdPNG dirlist
  set rcfile $Kde5ConfFile
  
  puts "Setting up KDE5 background..."
  
  #Always set wallpaperplugin=slideshow, set single pic hourly (else never renewed!)
  set oks "org.kde.slideshow"
  if {!$slideshow} {
    set interval 3600
  } else {
    set interval $slideshow
  }
  
  for {set g 1} {$g<200} {incr g} {
        
    if {[exec $kread --file $rcfile --group Containments --group $g --key activityId] != ""} {
    
      puts "Changing KDE $rcfile Containments $g ..."
      
      ##1. [Containments][$g] : Set wallpaperplugin
      exec $kwrite --file $rcfile --group Containments --group $g --key wallpaperplugin $oks
      
      ##2.[Containments][$g][Wallpaper][General] - General settings (not sure if needed)
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group General --key Image file://$TwdPNG
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group General --key SlidePaths $dirlist(imgDir)
      
      ##3. [Containments][$g][Wallpaper][org.kde.slideshow][General]: Set SlideInterval+SlidePaths+height+width
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlidePaths $dirlist(imgDir)
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlideInterval $interval
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key height [winfo screenheight .]
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key width [winfo screenwidth .]
      #FillMode 6=centered
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key FillMode 6
  
    }
  }
  return 0
} ;#END setupKde5Bg

# setupXfceBackground
##Change settings with tDom parser
##called by SaveLin
proc setupXfce4Background {} {
  global Xfce4ConfFile TwdPNG
  package require tdom
  
  puts "Changing Xfce4 background picture..."
  
  #Exit if XML not found
  if ![file exists $Xfce4ConfFile] {
    return 1
  }
  
  #Parse config XML
  set chan [open $Xfce4ConfFile]
  set txt [read $chan]
  close $chan
  set root [dom parse $txt]
  set doc [$root documentElement]

  #List required property nodes
  set lastimgL [$doc selectNodes //property\[@name='last-image'\]]
  set styleL [$doc selectNodes //property\[@name='image-style'\]]

##################################################################################################
#WICHTIG: these may not be present, but ARE UNNECESSARY - Xfce4 reloads picture when changed by BP
#  set cycleL [$doc selectNodes //property\[@name='backdrop-cycle-enable'\]]
#  set timerL [$doc selectNodes //property\[@name='backdrop-cycle-timer'\]]
#  set randomL [$doc selectNodes //property\[@name='backdrop-cycle-random-order'\]]
##################################################################################################

  #Set required parameters
  foreach node $lastimgL {
    $node setAttribute value $TwdPNG
  }
  ##styles: 1=centered / 5=scaled
  foreach node $styleL {
    $node setAttribute value 1
  }

  #Save changed config XML
  set chan [open $Xfce4ConfFile w]
  puts $chan [$root asXML]
  close $chan
  
} ;#END setupXfce4Background

# setupGnomeBackground - TODO: das funktioniert nicht mit return!
##configures Gnome single pic
##setting up slideshow not needed because Gnome detects picture change automatically
proc setupGnomeBackground {} {
  #Gnome2
  if {[auto_execok gconftool-2] != ""} {
    catch {exec gconftool-2 --type=string --set /desktop/gnome/background/picture_filename $::TwdPNG} errCode
  #Gnome3
  } elseif {[auto_execok gsettings] != ""} {
    catch {exec gsettings set org.gnome.desktop.background picture-uri file:///$::TwdBMP} errCode
  #no Gnome
  } else {
    return 1
  }
  
  if {$errCode==""} {
    return 0
  } else {
  return $errCode
  }
} ;#END setGnomeBackground


########## R E L O A D   D E S K T O P S  ##########################

# reloadKdeDesktop - TODO: DONT BOZER!!
##Rereads all .desktop and XML files
##Called by SetupSaveLin after changing config files
proc reloadKdeDesktop {} {
  set k4 [auto_execok kbuildsycoca4]
  set k5 [auto_execok kbuildsycoca5]
  if {$k5 != ""} {
    set command $k5
  } elseif {$k4 != ""} {
    set command $k4
  }
#  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "TODO:MUSTRELOADDESKTOP"
  exec $command
}

# reloadXfceDesktop
##Rereads XFCE4 Desktop configuration
##Called by SetupSaveLin after changing config files
proc reloadXfce4Desktop {} {
  tk_messageBox -type yesno -icon info -title "BiblePix Installation" -message "Reload XFCE4 desktop settings" -parent .
  catch {exec xfdesktop --reload}
}

######################################
####### C R O N T A B ################
######################################

# setupLinCrontab
##Detects running cron(d) & installs new crontab
##returns 0 or 1 for calling prog
##called by SetupSaveLin & Uninstall
##    T O D O: USE CRONTAB ONLY FOR INITIAL START, NOT FOR SLIDESHOW 
#    only FOR DESKTOPS OTHER THAN KDE/GNOME/XFCE4
proc setupLinCrontab args {

  global Biblepix Setup slideshow tclpath dirlist env linConfDir
  set cronfileOrig $dirlist(unixdir)/crontab.ORIG
  
  #if ARGS: Delete any crontab entries & exit
  if {$args != ""}  {
    if [file exists $cronfileOrig] {
      exec crontab $cronfileOrig
    } else {
      exec crontab -r
    }
    return
  }
  
  #Exit if [crontab] not found
  if { [auto_execok crontab] ==""} {
    return 0
  }

  #Check for running cron/crond & exit if not running
  catch {exec pidof crond} crondpid
  catch {exec pidof cron} cronpid

  if {! [string is digit $cronpid] && 
      ! [string is digit $crondpid] } {
    return 0
  }


###### 1. Prepare crontab text #############################
 
  #Check for user's crontab & save 1st time
  if {! [catch {exec crontab -l}] && 
      ! [file exists $cronfileOrig] } { 
    set runningCrontext [exec crontab -l]
    #save only if not B|biblepix
    if {! [regexp iblepix $runningCrontext] } {
      set chan [open $cronfileOrig w]
      puts $chan $runningCrontext
      close $chan
    }
  }

  #Prepare new crontab entry for running BiblePix at boot
  set cronScript $dirlist(unixdir)/cron.sh
  set cronfileTmp /tmp/crontab.TMP
  append BPcrontext \n @daily $cronScript \n @reboot $cronScript

  #Check presence of saved crontab
  if [file exists $cronfileOrig] {
    set chan [open $cronfileOrig r]
    set crontext [read $chan]
    close $chan
  }

  #Create/append new crontext, save&execute
  if [info exists crontext] {
    append crontext $BPcrontext
  } else {
    set crontext $BPcrontext
  }
  set chan [open $cronfileTmp w]
  puts $chan $crontext
  close $chan

  exec crontab $cronfileTmp
  file delete $cronfileTmp
  
  
##### 2. Prepare cronscript text ############################

  set cronScriptText "# ~/Biblepix/prog/unix/cron.sh\n# Bash script to add BiblePix to crontab
count=0
limit=5
#wait max. 5 min. for X or Wayland (should work with either)
export DISPLAY=:0
$tclpath $Biblepix
#get exit code
while [ $? -ne 0 ] \&\& \[ \"\$count\" -lt \"\$limit\" \] ; do 
  sleep 60
  ((count++))
  $tclpath $Biblepix
done
"
  #save cronscript & make executable
  set chan [open $cronScript w]
  puts $chan $cronScriptText
  close $chan
  file attributes $cronScript -permissions +x


### 3. Set ::crontab global var & delete any previous Autostart entries
  set ::crontab 1
 # setLinAutostart delete

  #Return success
  return 1
    
} ;#end setupLinCrontab




##################################################
# L I N U X   T E R M I N A L   S E T T E R 
##################################################
##TODO? move to better place
# cleanBlankLines
##cleans out empty lines & returns text lines as list
proc cleanBlankLines {file} {
  set chan [open $file r]
  foreach line [split [read $chan] \n] {
    if {$line != ""} {
      lappend cleanList $line
    }
  }
  close $chan
  return $cleanList
}

# setupLinTerminal
## Copies configuration file for Linux terminal to $confdir
## Makes entry in .bashrc for 
##use 'args' to delete - T O D O > Uninstall !!
# Called by SetupSaveLin if $enableterm==1
proc setupLinTerminal args {
  global dirlist HOME Terminal
  
  #OLD STUFF: Delete any previous=erroneous entries in .bash_profile
  set bashProfile $HOME/.bash_profile
  if [file exists $bashProfile] {
    set chan [open $bashProfile r]
    set bashProfileTxt [read $chan]
    close $chan
    if [regexp {[Bb]iblepix} $bashProfileTxt] {
      regsub -all -line {^.*iblepix.*$} $bashProfileTxt {} bashProfileTxt
      set chan [open $bashProfile w]
      puts $chan $bashProfileTxt
      close $chan
    }
  }
  
  ####1. Make entry in ~/.bashrc if missing
  set bashrc $HOME/.bashrc
  set bashrcTxt ""
  set bashEntry "#BiblePix: This line renews The Word whenever a terminal is opened\n~/Biblepix/prog/src/term/terminal.tcl ; ~/Biblepix/prog/unix/term.sh"
  
  ##extract any text from .bashrc, cleaning empty lines
  if [file exists $bashrc] {
    
    set bashrcList [cleanBlankLines $bashrc]
    
    if { [llength $bashrcList] >0 } {
      set listEl 0    
      for {set elNo [llength $bashrcList]} {$listEl <= $elNo} {incr listEl} {
        append bashrcTxt [lindex $bashrcList $listEl] \n
      }
    }
  }

  set save 1
  
  ##A) with args: delete any BiblePix entry
  if {$args != ""} {
  
    regsub -all -line {^.*Bible[pP]ix.*$} $bashrcTxt {} bashrcTxt
    set bashEntry ""
    set ::terminfo "Removed BiblePix entry for terminal from .bashrc"

  #B) Ignore if previous entry found  
  } else {
  
    if [regexp {[Bb]ible[Pp]ix} $bashrcTxt] {
      set ::terminfo "BiblePix for terminal: Nothing to do"
      set save 0
 
  #C) Append new entry to .bashrc
    } else {
      set ::terminfo "Added BiblePix entry for display in terminal to .bashrc"
    }
  }  

  if {$save} {
    set chan [open $bashrc w]
    puts $chan $bashrcTxt
    puts $chan $bashEntry
    close $chan
  }
  
  #TODO this isn't really of any use to users,
  #Tryed to move this to saveLin, but nothing shows up...
  #  NewsHandler::QueryNews $::terminfo lightblue
  puts $::terminfo
    
  
  #### 2. Create Terminal Config file always ###
  set configText {
  #!/bin/sh
  # ~/Biblepix/prog/conf/term.conf
  # Sets font variables for display of 'The Word' in a Linux terminal
  # Called by ~/Biblepix/prog/unix/term.sh
  # This command will produce 'The Word' in your shells:
  #   sh ~/Biblepix/prog/unix/term.sh
  # You can put it in ~/.bashrc for automation.
  # Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
  # Updated: 5oct17  

  ############################################################
  # N O  C H A N G E S  H E R E !
  # To change, replace variables further down!
  ############################################################
  #text colours (for normal text)
  txtred='\e[0;31m' # Red
  txtylw='\e[0;33m' # Yellow
  txtblu='\e[0;34m' # Blue
  txtpur='\e[0;35m' # Purple
  txtcyn='\e[0;36m' # Cyan
  txtwht='\e[0;37m' # White
  txtgrn='\e[0;32m' # Green
  #bold text colours (for title)
  bldblu='\e[1;34m' # Bold blue
  bldblk='\e[1;30m' # Bold black
  bldred='\e[1;31m' # Bold red
  bldgrn='\e[1;32m' # Bold green
  bldylw='\e[1;33m' # Bold yellow
  bldwht='\e[1;37m' # Bold white
  yontem=f$x
  #background colours (for title)
  bakblu='\e[44m'   # Blue
  bakcyn='\e[46m'   # Cyan
  bakwht='\e[47m'   # White
  bakred='\e[41m'   # Red
  bakgrn='\e[42m'   # Green
  #Reset colour to shell default
  txtrst='\e[0m'

  #########################################################
  # M A K E   A N Y  C H A N G E S   H E R E :
  # Variables used by BiblePix
  # To change, replace with any of the above, preceded by $
  #########################################################

  #Title background
  titbg=$bakblu
  #Title
  tit=$bldylw
  #Introline
  int=$txtred
  #Reference
  ref=$txtgrn
  #Reset to default
  txt=$txtrst
  #Tabulators
  tab="\t\t\t"
  }
  
  #Copy to file if new or corrupt
  set termConfFile "$dirlist(confdir)/term.conf"
  catch {file size $termConfFile} size
  if {![string is digit $size] || $size<50} {
    set chan [open $termConfFile w]
    puts $chan $configText
    close $chan
  }

} ;#END setupLinTerminal


#TODO Check with Live Install CD!!!
# setLinDesktopPicturesDir
##Provides correct "Images" path for Unix/Linux languages
##Called by saveLin.tcl
proc setLinDesktopPicturesDir {} {
  global HOME
  
  set ru "[file join $HOME Снимки]"
  set he "[file join $HOME תמונות]"
  set hu "[file join $HOME Képek]"
  set tr "[file join $HOME Resimler]"
  set uzl "[file join $HOME Suratlar]"
  set uzc  "[file join $HOME Суратлар]"
  set ar "[file join $HOME صور]"
  set pl "[file join $HOME Obrazy]"
  set th "[file join $HOME ภาพ]"
  set zhtrad "[file join $HOME 圖片]"
  set zhsimp "[file join $HOME 图片]"
  
  #ru
  if [file isdirectory $ru] {
    set DesktopPicturesDir $ru
  #hu
  } elseif [file isdirectory $hu] {
    set DesktopPicturesDir $hu
  #he
  } elseif [file isdirectory $he] {
  set DesktopPicturesDir $he
  #tr
  } elseif [file isdirectory $tr] {
    set DesktopPicturesDir $tr
  #Polish?
  } elseif [file isdirectory $pl] {
    set DesktopPicturesDir $pl
  #uzl
  } elseif [file isdirectory $uzl] {
    set DesktopPicturesDir $uzl
  #uzc
  } elseif [file isdirectory $uzc] {
    set DesktopPicturesDir $uzc
  #ar
  } elseif [file isdirectory $ar] {
    set DesktopPicturesDir $ar
  #zhtrad
  } elseif [file isdirectory $zhtrad] {
    set DesktopPicturesDir $zhtrad
  #zhsimp
  } elseif [file isdirectory $zhsimp] {
    set DesktopPicturesDir $zhsimp
  #Thai?
  } elseif [file isdirectory $th] {
    set DesktopPicturesDir $th
  
  #General Ima(ge) | Bil(der) etc.
  } elseif {
      ![catch {glob -type d -directory $HOME Im*} result] ||
      ![catch {glob -type d -directory $HOME Pict*} result] ||
      ![catch {glob -type d -directory $HOME Bil*} result] } {
      
    set DesktopPicturesDir $result
      
  #All else: set to $HOME
  } else {
    set DesktopPicturesDir $HOME
  }
    
    return $DesktopPicturesDir
} ;#END setLinDesktopPicturesDir
