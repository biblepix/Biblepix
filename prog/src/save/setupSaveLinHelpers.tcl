#~/Biblepix/prog/src/save/setupSaveLinHelpers.tcl
# Sourced by SetupSaveLin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 1jun18

################################################################################################
# A)  A U T O S T A R T : KDE / GNOME / XFCE4 all respect the Linux Desktop Autostart mechanism
#   more exotic Desktops NEED CONFIGURING via CRONTAB (see below)
#
# B)  D E S K T O P   M E N U : (Rightclick for Setup) works with KDE / GNOME / XFCE4 
#   other desktops can't be configured, hence information about Setup path is important >Manual
################################################################################################

set LinConfDir $HOME/.config
set LinDesktopDir $HOME/.local/share/applications
set KdeDir [glob -nocomplain $HOME/.kde*]
set KdeConfDir $KdeDir/share/config
set KdeConfFile $KdeConfDir/plasma-desktop-appletsrc
set KdeAutostartDir $KdeDir/Autostart
set GnomeAutostartDir $LinConfDir/autostart
set Xfce4ConfigFile $LinConfDir/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

# detectRunningLinuxDesktop
##returns 1 if GNOME or WAYLAND-SWAY detected
##returns 2 if KDE or XFCE4 detected
##returns 0 if no running desktop detected
##called by SetupSaveLin & SetBackgroundChanger
proc detectRunningLinuxDesktop {} {
  global env
  
  #check GNOME
  if { [info exists env(GNOME_KEYRING_CONTROL)] ||
       [info exists env(GNOME_DESKTOP_SESSION_ID)] } {
    puts GnomeDetected
    return 1
    
  }
  
  #check KDE / XFCE
  if { [info exists env(XDG_CURRENT_DESKTOP)] && {
       $env(XDG_CURRENT_DESKTOP) == "KDE" ||
       $env(XDG_CURRENT_DESKTOP) == "XFCE" } ||
     [info exists env(DESKTOP_SESSION)] && {
       $env(DESKTOP_SESSION) == "kde-plasma" ||
       $env(DESKTOP_SESSION) == "xfce" }
     } {
     puts KDEdetected
    return 2
  }
  
  #detect Wayland/Sway
  if { [info exists env(SWAYSOCK)] ||
       [info exists env(WAYLAND_DISPLAY)] } {
       puts SwayDetected
    return 1
  }

  #nothing found
  puts nothingDetected
  return 0
}

########################################################################
# A U T O S T A R T   S E T T E R   F O R   L I N U X   D E S K T O P S
########################################################################

# setLinAutostart
##makes Autostart entries for Linux Desktops (GNOME, XFCE4? & KDE)
##args == delete
proc setLinAutostart args {
global Biblepix Setup LinIcon tclpath srcdir bp GnomeAutostartDir KdeDir KdeAutostartDir
  
  #If args exists, delete any autostart files and exit
  if  {$args != ""} {
    file delete $GnomeAutostartDir/biblepix.desktop
    file delete $KdeAutostartDir/biblepix.desktop
    return
  }

  #set Texts
  set desktopText "\[Desktop Entry\]
  Name=$bp Setup
  Type=Application
  Icon=$LinIcon
  Path=$srcdir
  Categories=Settings
  Comment=Configures and runs BiblePix"
  set execText "Exec=$tclpath $Biblepix"

  #make .desktop file for KDE Autostart
  if [file exists $KdeDir] {
    file mkdir $KdeAutostartDir
    set desktopfile [open $KdeAutostartDir/biblepix.desktop w]
    puts $desktopfile "$desktopText"
    puts $desktopfile "$execText"
    close $desktopfile
  }

  #make .desktop file for GNOME Autostart
  file mkdir $GnomeAutostartDir
  set chan [open $GnomeAutostartDir/biblepix.desktop w]
  puts $chan "$desktopText"
  puts $chan "$execText"
  close $chan

  #Delete any BP crontab entry
  catch {setLinAutostartCrontab del}

  return 0
}


######################################################################################
# R I G H T C L I C K   M E N U   C R E A T E R   F O R   L I N U X   D E S K T O P S
######################################################################################

#T O D O : CHECK FOR XFCE4

# setLinDesktopMenu
## Makes Menu entries for GNOME & KDE
proc setLinMenu {} {
  global LinIcon srcdir Setup wishpath tclpath bp LinDesktopDir

  #set Texts
  set desktopText "\[Desktop Entry\]
  Name=$bp Setup
  Type=Application
  Icon=$LinIcon
  Path=$srcdir
  Categories=Settings
  Comment=Configures and runs BiblePix Setup"
  set execText "Exec=$wishpath $Setup"

  #make .desktop file for GNOME & KDE prog menu
  set chan [open $LinDesktopDir/biblepixSetup.desktop w]
  puts $chan "$desktopText"
  puts $chan "$execText"
  close $chan

}

#########################################################################
# BACKGROUND PIC SETTERS FOR LINUXES THAT NEED CONFIGURING AT SETUP TIME  
#########################################################################

# setKdeBackground
##configures KDE5 Plasma for single pic or slideshow
# - TODO: > Anleitung in Manpage für andere KDE-Versionen/andere Desktops (Rechtsklick > Desktop-Einstellungen >Einzelbild/Diaschau)
proc setKdeBackground {} {
  global KdeConfFile TwdPNG slideshow imgDir

  set chan [open $KdeConfFile w]
  set s [read $chan]
  
  #replace "wallpaper= ..." -line
  regsub -lineanchor -line {^wallpaper=.*$} $s wallpaper=$TwdPNG s
  #change all Containments , no matter if they are the current or not 
  if {$slideshow} {
    regsub -all -lineanchor -line {^slideTimer=.*$} $s slideTimer=[expr $slideshow * 60]
    regsub -all -lineanchor -line {^slidepaths=.*$} $s slidepaths=$imgDir s
    regsub -all -lineanchor -line {^wallpaperpluginmode=.*$} $s wallpaperpluginmode=Slideshow s
    
    } else {
    regsub -all -lineanchor -line {^wallpaperpluginmode=.*$} $s wallpaperpluginmode=SingleImage s
  }
  puts $chan $s
  close $chan
}

# setXfce4Background
##configures XFCE4 single pic or slideshow - TODO: >update MANPAGE!!!!!!!!!
proc setXfce4Background {} {
  global slideshow Xfce4ConfigFile
  package require tdom
  
 ###configFile hierarchy: 
 #<channel name="xfce4-desktop" ...>
  #<property name="backdrop" type="empty">
  #  <property name="screen0" type="empty">
  #    <property name="monitor0" type="empty">
  #      <property name="image-path"..."/>
  
  
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
    set backdropList $confDir/xfce4/desktop/backdrop-list
    set backdropListChan [open $backdropList w]
    puts $backdropListChan "$TwdPNG\n$TwdBMP"
    close $backdropListChan
    
    set imgPath $backdropList
    set imgShow "empty"
    set backdropCycleEnable "true"
    set backdropCycleTimer "[expr $slideshow/60]"
  }

###################################################################################
#KEEP THIS AS RELICT FOR GOOD regsub grouping policy!!!
#append ss2 \\1value= \"true\" /> 
#WICHTIG: die 1 vor dem Wert bezeichnet die zu ersetzende Gruppe
#      regsub -all -line {(backdrop-cycle-enable.*)(value=.*$)} $t $ss2 confText
###################################################################################


  #2 parse configFile
  set path $Xfce4ConfigFile
  set confChan [open $path]
  chan configure $confChan -encoding utf-8
  set data [read $confChan]
  set doc [dom parse $data]
  set root [$doc documentElement]

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
  
} ;#END setXfce4Background


# setGnomeBackground
##configures Gnome single pic
##setting up slideshow not needed because Gnome detects picture change automatically
proc setGnomeBackground {} {
  #Gnome2
  if {[auto_execok gconftool-2] != ""} {
    return "gconftool-2 --type=string --set /desktop/gnome/background/picture_filename $::TwdPNG"
  #Gnome3
  } elseif {[auto_execok gsettings] != ""} {
    return "gsettings set org.gnome.desktop.background picture-uri file:///$::TwdBMP"
  }
}



# setLinCrontab
##Detects running cron(d) & installs new crontab
##returns 0 or 1 for calling prog
##called by SetupSaveLin & Uninstall
##    T O D O: USE CRONTAB ONLY FOR INITIAL START, NOT FOR SLIDESHOW 
#    only FOR DESKTOPS OTHER THAN KDE/GNOME/XFCE4
proc setLinAutostartCrontab args {

  global Biblepix Setup slideshow tclpath unixdir env
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
    return
  }

  #Check for running cron/crond & exit if not running
  catch {exec pidof crond} crondpid
  catch {exec pidof cron} cronpid

  if {! [string is digit $cronpid] && 
      ! [string is digit $crondpid] } {
    return
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
  set BPcrontext "
@daily $cronScript
@reboot $cronScript"

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

  #Cron doesn't work with non-X environment
  if [info exists env(SWAYSOCK)] {
#  TODO: make Autostart entry in .config/sway/config
    return
  }

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
  setLinAutostart delete

  #Return success
  return 1
    
} ;#end setLinCrontab


##################################################
# L I N U X   T E R M I N A L   S E T T E R 
##################################################

## copyLinTerminalConf
# Copies configuration file for Linux terminal to $confdir 
# Called by SetupSaveLin if $enableterm==1
proc copyLinTerminalConf {} {
  global confdir
  
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
} ;#END copyLinTerminalConf