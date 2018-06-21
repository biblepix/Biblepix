#~/Biblepix/prog/src/save/setupSaveLinHelpers.tcl
# Sourced by SetupSaveLin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 21jun18

################################################################################################
# A)  A U T O S T A R T : KDE / GNOME / XFCE4 all respect the Linux Desktop Autostart mechanism
#   more exotic Desktops NEED CONFIGURING via CRONTAB (see below)
#
# B)  D E S K T O P   M E N U : (Rightclick for Setup) works with KDE / GNOME / XFCE4 
#   other desktops can't be configured, hence information about Setup path is important >Manual
################################################################################################

#T<O<D<O: - GEETNET!!!!!!!!
proc copySetupToPath {} {
  #prepare progtext
  set path /usr/local/bin
  set firstLine [setShebangLine]
  append progtext $firstLine \n cd { } $srcdir \n $Setup
  set filename $path/biblepix-setup
  #open chan as root
  exec su -c set chan [open $filename w]
  puts $chan $progtext
  close $chan
  #make executable - NEEDS ROOT?
  file $filename -attributes +x
}

#TODO: USE THIS TO FIND plasma-desktop-apletsrc recursively - NO NEED!!!!!
# findFiles
# basedir - the directory to start looking in
# pattern - A pattern, as defined by the glob command, that the files must match
proc findFiles {directory pattern} {

    # Fix the directory name, this ensures the directory name is in the
    # native format for the platform and contains a final directory seperator
    set directory [string trimright [file join [file normalize $directory] { }]]

    # Starting with the passed in directory, do a breadth first search for
    # subdirectories. Avoid cycles by normalizing all file paths and checking
    # for duplicates at each level.

    set directories [list]
    set parents $directory
    while {[llength $parents] > 0} {

        # Find all the children at the current level
        set children [list]
        foreach parent $parents {
            set children [concat $children [glob -nocomplain -type {d r} -path $parent *]]
        }

        # Normalize the children
        set length [llength $children]
        for {set i 0} {$i < $length} {incr i} {
            lset children $i [string trimright [file join [file normalize [lindex $children $i]] { }]]
        }

        # Make the list of children unique
        set children [lsort -unique $children]

        # Find the children that are not duplicates, use them for the next level
        set parents [list]
        foreach child $children {
            if {[lsearch -sorted $directories $child] == -1} {
                lappend parents $child
            }
        }

        # Append the next level directories to the complete list
        set directories [lsort -unique [concat $directories $parents]]
    }

    # Get all the files in the passed in directory and all its subdirectories
    set result [list]
    foreach directory $directories {
        set result [concat $result [glob -nocomplain -type {f r} -path $directory -- $pattern]]
    }

    # Normalize the filenames
    set length [llength $result]
    for {set i 0} {$i < $length} {incr i} {
        lset result $i [file normalize [lindex $result $i]]
    }

    # Return only unique filenames
    return [lsort -unique $result]
}


#Set & create general Linux Desktop dirs
set LinConfDir $HOME/.config
file mkdir $LinConfDir
set LinLocalShareDir $HOME/.local/share
set LinDesktopFilesDir $LinLocalShareDir/applications
file mkdir $LinDesktopFilesDir
set KdeDir [glob -nocomplain $HOME/.kde*]
set KdeConfDir $KdeDir/share/config

#Set KDE dirs: 1. find location of plasmarc files - TODO: ??? use kwriteconfig instead???
if {[file exists $LinConfDir/plasma-org.kde.plasma.desktop-appletsrc]} {
  set rcfile $LinConfDir/plasma-org.kde.plasma.desktop-appletsrc
} else {
  set rcfile $KdeConfDir/plasma-desktop-appletsrc
  file mkdir $KdeConfDir
}
set KdeConfFile $rcfile

# 1 Menu entry/rightclick .desktop files
set LinDesktopFile $LinDesktopFilesDir/biblepixSetup.desktop
set Kde5DesktopFilesDir $LinLocalShareDir/kservices5/ServiceMenus
#file mkdir $Kde5DesktopFilesdir - TODO : only for KDE5!
set Kde5DesktopFile $Kde5DesktopFilesDir/biblepixSetup.desktop

# 2 Kde background configuration files (not needed for Gnome)
set Kde4Appletsrc $KdeConfDir/plasma-desktop-appletsrc
set Kde5Appletsrc $LinConfDir/plasma-org.kde.plasma.desktop-appletsrc

#Set vars for setKdeBackground
#TODO: write 2 different progs with old/new syntax
#TODO: write both files???
if [file exists $Kde4Appletsrc] {
  set KdeVersion 4
}
if [file exists $Kde5Appletsrc] {
  set KdeVersion 5
}

# 3 Autostart files
set KdeAutostartDir $KdeDir/Autostart
set GnomeAutostartDir $LinConfDir/autostart
set KdeAutostartFile nowInAppBelow
set GnomeAutostartFile nowInAppBelow

set Xfce4ConfigFile $LinConfDir/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

# reloadKdeDesktop
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
  exec $command
}

# reloadXfceDesktop
##Rereads XFCE4 Desktop configuration
##Called by SetupSaveLin after changing config files
proc reloadXfceDesktop {} {
  set command [auto_execok xfdesktop]
  if {$command != ""} {
    exec $command --reload 
  }
}

# checkExecutables
## Check first line of Linux executables for correct 'env' path
## Standard env path as in Ubuntu/Debian/Gentoois /usr/bin/env
## Make files executable
proc checkExecutables {} {
  global Setup Biblepix
  
  set standardEnvPath {/usr/bin/env}
  set curEnvPath [auto_execok env]

  #1. Set permissions to executable
  file attributes $Biblepix -permissions +x
  file attributes $Setup -permissions +x
  
  #TODO: export to separate proc setShebangLine
  #2. Reset 1st Line if not standard
  if {$curEnvPath == $standardEnvPath} {
    return 1
  }
  
  set shBangLine "\#!${curEnvPath} tclsh"

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

  ##clean up & make files executable
  catch {unset shBangLine text1 text2}
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

  #Make .desktop file for KDE Autostart
  if [file exists $KdeDir] {
    file mkdir $KdeAutostartDir
    set desktopfile [open $KdeAutostartDir/biblepix.desktop w]
    puts $desktopfile "$desktopText"
    puts $desktopfile "$execText"
    close $desktopfile
  }

  #Make .desktop file for GNOME Autostart
  file mkdir $GnomeAutostartDir
  set chan [open $GnomeAutostartDir/biblepix.desktop w]
  puts $chan "$desktopText"
  puts $chan "$execText"
  close $chan

  #Delete any BP crontab entry - TODO ?????????????'
  catch {setupLinCrontab delete}

  return 0
}

proc setSwayAutostart {} {
  global LinConfDir Biblepix
  
  #append or create config file
  set swayConfFile $LinConfDir/sway/config
  #read out text
  set chan [open $swayConfFile r]
  set t [read $chan]
  close $chan
  #Skip if already there, else append entry
  if {![regexp {[Bb]iblepix} $t]} {
    append swayEntry \n # BiblePix: { this line runs BiblePix on your Sway desktop:} \n exec $Biblepix
    set chan [open $swayConfFile w]
    puts $chan $t
    puts $chan $swayEntry
    close $chan
  }
}


################################################################################
#  M E N U  E N T R Y   C R E A T E R   F O R   L I N U X   D E S K T O P S
################################################################################

# setLinMenu
## Makes .desktop files for Linux Menu entries 
## Works on KDE / GNOME / XFCE4
### T O D O : KDE5 path changed to .local/share/kservices5/ServiceMenus
proc setLinMenu {} {
  global LinIcon srcdir Setup wishpath tclpath bp LinDesktopFilesDir

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
  set chan [open $LinDesktopFilesDir/biblepixSetup.desktop w]
  puts $chan "$desktopText"
  puts $chan "$execText"
  close $chan

}

#########################################################################
# B A C K G R O U N D   P I C   S E T T E R S   FOR LINUXES THAT NEED CONFIGURING AT SETUP TIME  
#########################################################################

# setKdeBackground
##configures KDE5 Plasma for single pic or slideshow
# - TODO: > Anleitung in Manpage für andere KDE-Versionen/andere Desktops (Rechtsklick > Desktop-Einstellungen >Einzelbild/Diaschau)
#TODO: differentiate kde4/kde5 (s.o.)
proc setKdeBackground {KdeVersion args} {
  global KdeConfFile TwdPNG slideshow imgDir

  #set KDE version(s) & execute 1 or 2 progs
  lappend KdeVersions $KdeVersion $args

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
    puts "Cannot configure KDE background - Please do a hand job!!!! - TODO"
  }
  
  #Todo : write/rewrite progs!!!
  foreach v $KdeVersions {
    if {$v==4} {
      doKde4Desktop
    }
    if {$v==5} {
      doKde5Desktop
    }
  
  }
  
  
  #TODO: Below is crap, integrate old solution for 4
  #create new script for 5 !!!!!!!!!!!!!!!!!!!!!!
  
  
  
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

# setXfceBackground
##configures XFCE4 single pic or slideshow - TODO: >update MANPAGE!!!!!!!!!
proc setXfceBackground {} {
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
  
} ;#END setXfceBackground


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
      puts "Nothing to do"

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