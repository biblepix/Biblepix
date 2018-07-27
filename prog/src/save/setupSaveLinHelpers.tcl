#~/Biblepix/prog/src/save/setupSaveLinHelpers.tcl
# Sourced by SetupSaveLin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 27jul18

################################################################################################
# A)  A U T O S T A R T : KDE / GNOME / XFCE4 all respect the Linux Desktop Autostart mechanism
#   more exotic Desktops NEED CONFIGURING via CRONTAB (see below)
#
# B)  D E S K T O P   M E N U : (Rightclick for Setup) works with KDE / GNOME / XFCE4 
#   other desktops can't be configured, hence information about Setup path is important >Manual
################################################################################################

#Set & create general Linux Desktop dirs
##recognised by alle Desktops, including KDE5
set LinConfDir $HOME/.config
set LinLocalShareDir $HOME/.local/share
set LinDesktopFilesDir $LinLocalShareDir/applications

#Create dirs if missing (needed for [open] command)
file mkdir $LinDesktopFilesDir

#Set KDE dirs & Create ~/.kde if missing
set KdeDir [glob -nocomplain $HOME/.kde*]
set KdeConfDir $KdeDir/share/config
file mkdir $KdeConfDir


#Determine KDE config files
##KDE4
if [file exists $KdeConfDir/plasma-desktop-appletsrc] {
  set KdeConfFile $KdeConfDir/plasma-desktop-appletsrc
  set KdeVersion 4
##KDE5
} else {
  set KdeConfFile $LinConfDir/plasma-org.kde.plasma.desktop-appletsrc
  set KdeVersion 5
}

#Wayland/Sway
set SwayConfFile $LinConfDir/sway/config


# 1  M E N U   E N T R Y   .DESKTOP   F I L E 

## A) GNOME/XFCE/KDE5
set LinDesktopFile $LinDesktopFilesDir/biblepixSetup.desktop

## B) KDE4
set Kde4DesktopFile $KdeConfDir/share/kde4/services/biblepixSetup.desktop

## C) MENU ENTRY RIGHTCLICK FILE (works only for some Plasma 5 versions of Konqueror/Dolphin?)
set Kde5DesktopActionFile $LinDesktopFilesDir/biblepixSetupAction.desktop


# 3 Autostart files
set KdeAutostartDir $KdeDir/Autostart
set LinAutostartDir $LinConfDir/autostart
file mkdir $LinAutostartDir $KdeAutostartDir
set KdeAutostartFile $KdeAutostartDir/biblepix.desktop
set LinAutostartFile $LinAutostartDir/biblepix.desktop

#TODO: move to?
set Xfce4ConfigFile $LinConfDir/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml


# formatLinuxExecutables
## 1 Check first line of Linux executables for correct 'env' path
#### Standard env path as in Ubuntu/Debian/Gentoois /usr/bin/env
## 2 Make files executable
## 3 Copy biblepix-setup to $HOME/bin
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

  # 3. Put Setup bash script in ~/bin (precaution in case it can't be found in menus)
  set homeBin $env(HOME)/bin
  set homeBinFile $homeBin/setup-biblepix
  
  if { ![file exists $homeBin] } {
    file mkdir $homeBin
    file attributes $homeBin -permissions +x
  }
  #Create script text and save
  set chan [open $homeBinFile w]
  append t #!/bin/sh \n exec { } $Setup
  puts $chan $t
  close $chan
  
  # 4. Add ~/bin to $PATH in .bash_profile
  set bashProfile "$env(HOME)/.bash_profile"
  set PATH $env(PATH)

  if {![regexp $homeBin $PATH]} {
    
    set homeBinText "
if \[ -d $env(HOME)/bin \] ; then
PATH=$env(HOME)/bin:$PATH
fi"
    #read out any existing file
    if [file exists $bashProfile] {
      set chan [open $bashProfile r]
      set t [read $chan]
      close $chan
    } {
      set t ""
    }
    
    #append text if missing
    if {![regexp $homeBin $t]} {
      set chan [open $bashProfile a]
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
## makes Autostart entries for Linux Desktops: GNOME, XFCE4, KDE, Wayland/Sway
## args == delete
## called by SetupSaveLin
proc setupLinAutostart args {
  global Biblepix Setup LinIcon bp LinAutostartFile KdeAutostartFile SwayConfFile
  #set Err 0
  
  #If args exists, delete any autostart files and exit
  if  {$args != ""} {
    file delete $LinAutostartFile $KdeAutostartFile
    catch {setSwayConfig delete}
    return 0
  }

  #set Texts
  set desktopText "\[Desktop Entry\]
Name=$bp Setup
Type=Application
Icon=$LinIcon
Comment=Runs BiblePix at System start
Exec=$Biblepix
"
  #Make .desktop file for KDE Autostart
  set chan [open $KdeAutostartFile w]
  puts $chan $desktopText
  close $chan

  #Make .desktop file for GNOME/XFCE Autostart
  set chan [open $LinAutostartFile w]
  puts $chan $desktopText
  close $chan

  #Delete any BP crontab entry - TODO ?????????????'
  catch {setupLinCrontab delete}

  #Set up Sway if conf file found
  if [file exists $SwayConfFile] {
    catch setupSwayBackground SwayErr
  }
  
  if [info exists SwayErr] {
    puts "Having problem setting up Sway config..."
    return 1
    
  } {
    return 0
  }
} ;#END setLinAutostart

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
  if {$args!="" && $entryFound} {
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
#  set sleepLine "exec sleep 3"
  set outputList [getSwayOutputName]
  
#TODO: CHECK sleepline !!!!!!!!!!!!!
  #append lines at end of file
  set chan [open $SwayConfFile a]
  puts $chan $autostartLine
  #puts $chan $sleepLine
  foreach outputName $outputList {
    puts $chan "exec swaymsg output $outputName bg $::TwdBMP center"
  }
  close $chan

  puts "Made BiblePix entry in $SwayConfFile"
  return 0
}


################################################################################
#  M E N U  E N T R Y   C R E A T E R   F O R   L I N U X   D E S K T O P S
################################################################################

# setLinMenu
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
  global LinIcon srcdir Setup wishpath tclpath bp LinDesktopFilesDir
  set filename "biblepixSetup.desktop"

  #set Texts
  set desktopText "\[Desktop Entry\]
Name=$bp Setup
Type=Application
Icon=$LinIcon
Categories=Settings;Utility;Graphics;Education;DesktopSettings;Core
Comment=Runs & configures BiblePix"
  set execText "Exec=$wishpath $Setup"

  #make .desktop file for GNOME & KDE prog menu
  set chan [open $LinDesktopFilesDir/$filename w]
  puts $chan "$desktopText"
  puts $chan "$execText"
  close $chan
  
  return 0
} ;#END setLinMenu

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
  global KdeVersion KdeConfFile TwdPNG slideshow imgDir

  #check kread/kwrite executables
  if {[auto_execok kreadconfig5] != "" && 
      [auto_execok kwriteconfig5] != ""} {
    set kread kreadconfig5
    set kwrite kwriteconfig5

  } elseif { [auto_execok kreadconfig] != "" && 
      [auto_execok kwriteconfig] != ""} {
    set kread kreadconfig
    set kwrite kwriteconfig

  } else {

    return 1
  }

  #set KDE4 if detected
  set errCode4 ""
  if {$KdeVersion==4} {
    catch {setKde4Bg $kread $kwrite} errCode4
  }

  #set KDE5 in any case
  catch {setKde5Bg $KdeConfFile $kread $kwrite} errCode5
  
  if {$errCode4=="" && $errCode5==""} {
    return 0
  } else {
    return "KDE4: $errCode4 / \nKDE5: $errCode5"
  }
  
} ;#END setKdeBackground

# setupKde4Bg
# called by setKdeBackground if KDE4 rcfile found
proc setupKde4Bg {kread kwrite} {
  global slideshow
  
  if {$slideshow} {
    set slidepaths $imgDir
    set mode Slideshow
  } else {
    set slidepaths ""
    set mode SingleImage
  }

# rcfile ausschreiben? ohne path? - so übernommen.
        
  for {set g 1} {$g<200} {incr g} {

    if {[exec $kread --file plasma-desktop-appletsrc --group Containments --group $g --key wallpaperplugin] != ""} {
    
      puts "Changing KDE $rcfile Containments $g ..."
      
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --key mode $mode
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key slideTimer $slideshow
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key slidepaths $slidepaths
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key userswallpapers ''
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpaper $TwdPNG
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpapercolor 0,0,0
      exec $kwrite --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpaperposition 0
    }
  }

  return 0
} ;#END setKde4Bg

# setupKde5Bg
## called by setKdeBackground if KDE5 found
## expects rcfile [file join $env(HOME) .config plasma-org.kde.plasma.desktop-appletsrc]
## expects correct version of kreadconfig(?5) kwriteconfig(?5)
## must be set to slideshow even if single picture, otherwise it is never renewed at boot
proc setupKde5Bg {rcfile kread kwrite} {
  global slideshow
  
  if {!$slideshow} {set slideshow 120}
  set oks "org.kde.slideshow"

  for {set g 1} {$g<200} {incr g} {
        
    if {[exec $kread --file $rcfile --group Containments --group $g --key activityId] != ""} {
    
      puts "Changing KDE $rcfile Containments $g ..."
      
      ##1.[Containments][$g] >wallpaperplugin - must be slideshow, bec. single pic never renewed!
      exec $kwrite --file $rcfile --group Containments --group $g --key wallpaperplugin $oks
      ##2.[Containments][$g][Wallpaper][General] >Image+SlidePaths
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group General --key Image file://$TwdPNG
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group General --key SlidePaths $imgDir 
      ##3.[Containments][7][Wallpaper][org.kde.slideshow][General] >SlideInterval+SlidePaths+height+width
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlidePaths $imgDir
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlideInterval $slideshow
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key height [winfo screenheight .]
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key width [winfo screenwidth .]
      #FillMode 6=centered
      exec $kwrite --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key FillMode 6
    }
  }

  return 0
} ;#END setKde5Bg

# setupXfceBackground
##configures XFCE4 single pic or slideshow - TODO: >update MANPAGE!!!!!!!!!
### configFile hierarchy: 
  #<channel name="xfce4-desktop" ...>
  #<property name="backdrop" type="empty">
  #  <property name="screen0" type="empty">
  #    <property name="monitor0" type="empty">
  #      <property name="image-path"..."/>
#xfconf-query syntax für neue 'property':
# xfconf-query -c -p* -n -t -s
# * ganzer (neuer) Pfad
##########################################

proc setupXfceBackground {} {
  global slideshow TwdBMP TwdTIF

  #Exit if xfconf-query not found
  if {[auto_execok xfconf-query] == ""} {
    return 1
  }
  
  #Our 'channel' is actually an XML file found in .config/xfce4/xfconf/xfce-perchannel-xml/
  set channel "xfce4-desktop"
  
  puts "Configuring XFCE background image..."

  #This rewrites backdrop.list for old xfce4 installations
  #Not used now
  if {$slideshow} {
    set backdropDir ~/.config/xfce4/desktop
    file mkdir $backdropDir
    set backdropList $backdropDir/backdrop.list
    set chan [open $backdropList w]
    puts $chan "$TwdBMP\n$TwdTIF"
    close $chan
    set origPicPath $backdropList
    set cycleEnableValue true
  } else {
    set origPicPath $TwdBMP
    set cycleEnableValue false
  }


 #Set monitoring - no Luck, holds up everything!
#exec xfconf-query -c xfce4-desktop -m
#DIESE PFADE SIND IMMER DA:
##  A) /backdrop/screen?/monitor?/workspace[0-3]/last-image
##  B) /backdrop/screen?/monitor?/image-path
    
#xfconf-query -c xfce4-desktop -l >
#/backdrop/screen0/monitor0/image-path NEEDED? [path]
#/backdrop/screen0/monitor0/workspace0/backdrop-cycle-enable NEEDED true
#/backdrop/screen0/monitor0/workspace0/backdrop-cycle-timer NEEDED int

# xfconf-query 'set' = set property if existent
# xfconf-query 'create' = create property

  #Check monitor name
  set desktopXmlTree [exec xfconf-query -c xfce4-desktop -l]

  if [regexp {monitor0} $desktopXmlTree] {
    set monitorName "monitor"
  } else {
    regexp -line {(backdrop/screen0/)(.*)(/.*$)} $t var1 monitorName var3
  }

  #1. Scan through 4 screeens & monitors
  ##NOTE: Never seen more than screen0 , but 4 each is a reasonable compromise.
  for {set s 0} {$s<5} {incr s} {
    for {set m 0} {$m<5} {incr m} {

      #must set single img path even if slideshow?
      ##old inst. needs path to backdrop.list!
      #imgStyle seems to be: 1==centred
      #imgShow seems to be needed for old inst. 
      set imgpath /backdrop/screen$s/${monitorName}${m}/image-path
      set imgStylePath /backdrop/screen$s/$monitorName$m/image-style
      set imgShowPath /backdrop/screen$s/$monitorName$m/image-show
      
      #these are needed here for old inst., and also in the screen section below for the new!!
      set monitorLastImagePath /backdrop/screen$s/$monitorName$m/last-image
      set monitorCycleEnablePath /backdrop/screen$s/$monitorName$m/backdrop-cycle-enable
      set monitorCycleTimerPath /backdrop/screen$s/$monitorName$m/backdrop-cycle-timer
      #this was added in new inst.  - old has only min., hence:
      #set cycle-timer in mins for old inst. (min=1), set type to 'uint'
      set monitorCycleTimerPeriodPath /backdrop/screen$s/$monitorName$m/backdrop-cycle-period
            
      if [catch "exec xfconf-query -c $channel -p $imgpath"] {
      
        continue
      
      } else {
      
        puts "Setting $imgpath"
      
        #some of this is only needed for old inst.
        exec xfconf-query -c $channel -p $imgpath -n -t string -s $origPicPath
        exec xfconf-query -c $channel -p $imgStylePath -n -t int -s 1
        exec xfconf-query -c $channel -p $imgShowPath -n -t bool -s true
        exec xfconf-query -c $channel -p $monitorLastImagePath -n -t string -s $TwdBMP        
        exec xfconf-query -c $channel -p $monitorCycleEnablePath -n -t bool -s $cycleEnableValue
        exec xfconf-query -c $channel -p $monitorCycleTimerPath -n -t uint -s [expr $slideshow/60]
        exec xfconf-query -c $channel -p $monitorCycleTimerPeriodPath -n -t int -s 1
        
        set ctrlBit 1
      }

      if {$slideshow} {
        
      #2. Scan through 9 workspaces! (w) 
        #NOTE1: any number of ws's can be added, but standard is 4.
        #NOTE2: old inst. doesn't seem to respect workspaces, 
        # >> put all information in the /screen0/monitor0 main section for now
        for {set w 0} {$w<10} {incr w} {
        
          set lastImagePath /backdrop/screen$s/$monitorName$m/workspace$w/last-image
          
          #check if workspace exists, else skip
          if [catch {exec xfconf-query -c xfce4-desktop -p $lastImagePath}] {

            continue
            
          } else {

            puts "Setting $lastImagePath"
            
            set wsCycleEnablePath /backdrop/screen$s/$monitorName$m/workspace$w/backdrop-cycle-enable
            set wsCycleTimerPath /backdrop/screen$s/$monitorName$m/workspace$w/backdrop-cycle-timer
            set wsCycleTimerPeriodPath /backdrop/screen$s/$monitorName$m/workspace$w/backdrop-cycle-period
             
            exec xfconf-query -c $channel -p $lastImagePath -n -t string -s $TwdBMP
            exec xfconf-query -c $channel -p $wsCycleEnablePath -n -t bool -s true
            exec xfconf-query -c $channel -p $wsCycleTimerPath -n -t uint -s $slideshow
            exec xfconf-query -c $channel -p $wsCycleTimerPeriodPath -n -t int -s 0
          }
        } ;#END for3
      } ;#END if slideshow
    } ;#END for2
  } ;#END for1
    

#reload XFCE4 desktop if running - TODO hammer des net scho woanders?
proc reloadXfceDesktop {} {
  if {! [catch "exec pidof xfdesktop"] } {
    wm withdraw .
    exec xfdesktop --reload
  }
}

  if [info exists ctrlBit] {
      return 0
  } {
    puts NoLuckSettingXfce
    return 1
  }
  
} ;#END setXfceBackground
 
proc setupXfceBackgroundOLD {} {
  global slideshow Xfce4ConfigFile LinConfDir
  package require tdom
 
  #Check for config files & exit 1 if missing
  set backdropList $LinConfDir/xfce4/desktop/backdrop-list
  if {![file exists $Xfce4ConfigFile] ||
      ![file exists $backdropList] } {
puts fileBulamadik
return 1
  }  
  
  #Single Picture
  if {! $slideshow} {
  #needed properties:
  ##image-path value=TwdPNG oder TwdBMP
  ##image-show value=true
  ##backdrop-cycle-enable value=false
  
    set imgPath $TwdBMP
    set imgShow "true"
    set backdropCycleEnable "false"
    set backdropCycleTimer "0"
  
  #Slideshow
  } else {
    
  #needed properties:
  ##image-path value=backdropList
  ##backdrop-cycle-enable value=true
  ##backdrop-cycle-timer value=[expr $slideshow/60]

    #rewrite backdrop list
    puts changingBackdropList
   set chan [open $backdropList w]
    puts $chan "$TwdPNG\n$TwdBMP"
    close $chan
    
    set imgPath $backdropList
    set imgShow "empty"
    set backdropCycleEnable "true"
    set backdropCycleTimer "[expr $slideshow/60]"
  }

  #2 parse configFile
  set confChan [open $Xfce4ConfigFile r]
  chan configure $confChan -encoding utf-8
  set data [read $confChan]
  set doc [dom parse $data]
  set root [$doc documentElement]
puts parsingXfceConfigFile

  set mainNode [$root selectNodes {//property[@name="backdrop"]} ]
  
  #Search screens 1-10 and monitors 1-10 for relevant properties
  for {set screenNo 0} {$screenNo==10} {incr screenNo} {
  
    #skip if screen not found (screen0 should always be there)
    set screenNode [$mainNode selectNodes "/property\[@name=\"screen${$screenNo}\"\]" ]
    if {$screenNode == ""} {
      continue
    }
    
    for {set monitorNo 0} {$monitorNo==10} {incr monitorNo} {

      #skip if monitor not found (monitor0 should always be there)
      set monitorNode [$screenNode selectNodes "/property\[@name=\"monitor${monitorNo}\"\]" ]
      if {$monitorNode == ""} {
        continue
      }
      
      set imgPathNode [$monitorNode selectNodes {/property[@name="image-path"]} ]
      $imgPathNode setAttribute value $imgPath
      
      set imgShowNode [$monitorNode selectNodes {/property[@name="image-show"]} ]
      $imgShowNode setAttribute value $imgShow

      set backdropCycleEnableNode [$monitorNode selectNodes {/property[@name="backdrop-cycle-enable"]} ]
      if {$slideshow && $backdropCycleEnableNode == ""} {
          #TODO create node
        }
      #This property is only needed for slideshow
      catch {$backdropCycleEnableNode setAttribute value $backdropCycleEnable}

      set backdropCycleTimerNode [$monitorNode selectNodes {/property[@name="backdrop-cycle-timer"]} ]
      if {$slideshow && $backdropCycleTimerNode == ""} {
          #TODO create node
      }
      #This property is only needed for slideshow
      catch {$backdropCycleTimerNode setAttribute value $backdropCycleTimer}
     
    } #END for1
  } ;#END for2

  puts $confChan $confText
  close $confChan

puts finishedChangingXFCEConfFile
  return 0
} ;#END setXfceBackground


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

# reloadKdeDesktop - TODO: DONT BOTZHER!!
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
proc reloadXfceDesktop {} {
  set command [auto_execok xfdesktop]
  if {$command != ""} {
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "TODO:MUSTRELOADDESKTOP"
    exec $command --reload 
  }
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

  global Biblepix Setup slideshow tclpath unixdir env linConfDir
  set cronfileOrig $unixdir/crontab.ORIG
  
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
  set cronScript $unixdir/cron.sh
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

# setupLinTerminal
## Copies configuration file for Linux terminal to $confdir
## Makes entry in .bashrc for 
##use 'args' to delete - T O D O > Uninstall !!
# Called by SetupSaveLin if $enableterm==1
proc setupLinTerminal {args} {
  global confdir HOME Terminal
  
  #Delete any previous/erroneous entries in .bash_profile
  set f $HOME/.bash_profile
  if [file exists $f] {
    set chan [open $f r]
    set t [read $chan]
    close $chan
    if [regexp {[Bb]iblepix} $t] {
      regsub -all -line {^.*iblepix.*$} $t {} t
      set chan [open $f w]
      puts $chan $t
      close $chan
    }
  }
  
  #Read out .bashrc
  set f $HOME/.bashrc
  
  if [file exists $f] {
    set chan [open $f r]
    set t [read $chan]
    close $chan

    #If 'args' delete any previous entries 
    if {$args != "" && $t != ""} {  
      regsub -all -line {^.*iblepix.*$} $t {} t
      set chan [open $f w]
      puts $chan $t
      close $chan
      return
    }

    # Set entry text for .bashrc
    append bashrcEntry {
#Biblepix: This line shows The Word each terminal
} {[ -f } $Terminal { ] && } $Terminal

    if [regexp {[Bb]iblepix} $t] {
    
      #Ignore if previous entries found
      puts "Bashrc/Terminal: Nothing to do"

    } else {

      #Append line
      append t $bashrcEntry
      set chan [open $f w]
      puts $chan $t
      close $chan
    }
    
  } ;#End if file exists
  
  
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
  set termConfFile "$confdir/term.conf"
  catch {file size $termConfFile} size
  if {![string is digit $size] || $size<50} {
    set chan [open $termConfFile w]
    puts $chan $configText
    close $chan
  }

} ;#END setupLinTerminal