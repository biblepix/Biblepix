# ~/Biblepix/prog/src/biblepix.tcl
# Main program, called by System Autostart
# Projects The Word from "Bible 2.0" on a daily changing backdrop image 
# OR displays The Word in the terminal OR adds The Word to e-mail signatures
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2oct17
######################################################################

#Verify location & source Globals
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir com globals.tcl]"
source $Globals
source $Twdtools

#Run Setup if TWD file not found
if {[catch "set twdfile [getRandomTWDFile]"]} {
  source -encoding utf-8 $SetupTexts
  setTexts $lang
  tk_messageBox -title BiblePix -type ok -icon error -message $noTWDFilesFound
  #catch if run by running Setup
  catch {source $Setup} 
  return
}

#1. U p d a t e   s i g n a t u r e s  if $enablesig
if {$enablesig} {
  source $Signature
}

#2. C r e a t e   t e r m . s h   for Unix terminal if $enableterm
if {[info exists enableterm] && $enableterm} {
  catch {formatTermText $twdfile} dwterm

  if {$dwterm != 1} {
    #create shell script
    set chan [open $Terminal w]
    puts $chan ". $TerminalConf"
    puts $chan $dwterm
    close $chan
    file attributes $Terminal -permissions +x
  }
}

#3. P r e p a r e   c h a n g i n g   W i n   d e s k t o p
proc setWinBG {} {
  global TwdTIF regpath platform
  if {$platform=="windows"} {
    registry set $regpath Wallpaper [file nativename $TwdTIF]
    exec RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True
  }
}

if {$platform=="windows"} {
  package require registry
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
}

#Stop any running biblepix.tcl
foreach file [glob -nocomplain -directory $piddir *] {
  file delete -force $file
}
set pidfile [open $piddir/[pid] w]
close $pidfile

#4. C r e a t e   i m a g e   & start slideshow
if {$enablepic } {

  #run once
  source $Image
  setWinBG
  
  #exit if $crontab exists
  if {[info exists crontab]} {
    exit
  }

  #if Slideshow == 1
  if {$slideshow > 0} {
  
    #rerun until pidfile renamed by new instance
    set pidfile $piddir/[pid]
    set pidfiledatum [clock format [file mtime $pidfile] -format %d]
    while {[file exists $pidfile]} {
      if {$pidfiledatum==$heute} {
        sleep [expr $slideshow*1000]
        
        source $Image
        setWinBG
      } else {
      
        #Calling new instance of myself
        source $Biblepix
      }
    }
  
  #if Slideshow == 0    
  } else {
    if {$platform=="windows"} {
      
      #run every 10s up to 10x so Windows has time to update
      set limit 0
      
      while {$limit<9} {
        sleep 10000
        setWinBG
        incr limit
      }
    }
  } ;#END if slideshow
} ;#END if enablepic

exit
