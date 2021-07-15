#!/usr/bin/env tclsh
# ~/Biblepix/prog/src/biblepix.tcl
# Main program, called by System Autostart
# Projects The Word from "Bible 2.0" on a daily changing backdrop image 
# OR displays The Word in the terminal OR adds The Word to e-mail signatures
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24feb21 pv
######################################################################

#Verify location & source Globals
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir share globals.tcl]"
source $Globals
source $TwdTools

#TODO testing
if { [info exists Debug] && $Debug } {
  updateTwd
} else {
  catch updateTwd
}

#Set TwdFileName for the 1st time, else run Setup
if [catch {set twdfile [getRandomTwdFile]}] {
  source -encoding utf-8 $SetupTexts
  setTexts $lang
  package require Tk
  tk_messageBox -title BiblePix -type ok -icon error -message $noTwdFilesFound
  #catch if run by running Setup
  catch {source $Setup}
  return
}

#Export TwdFilename to global space
set ::TwdFileName $twdfile

#1. U p d a t e   s i g n a t u r e s  if $enablesig
if {$enablesig} {
  source $Signature
}

#2. C r e a t e   TheWord for for Unix terminal once per day, if $enableterm
if {[info exists enableterm] && $enableterm } {
  #check date of any existing file
  if [file exists $TerminalShell] {
    set fileDay [clock format [file mtime $TerminalShell] -format %d]
    if {$fileDay != $heute} {
      puts "Renewing The Word for the terminal..."
      source $Terminal
    }
  } else {
  #first time ever
    puts "Renewing The Word for the terminal..."
    source $Terminal
  }
}


#3. P r e p a r e   c h a n g i n g    d e s k t o p

#Get appropriate setBg proc
##setBg is executed for Desktops that can accept a command
##setBg can be empty/non-existent as it is 'catched'
source $SetBackgroundChanger

#Stop any running biblepix.tcl
foreach file [glob -nocomplain -directory $piddir *] {
  file delete -force $file
}
set pidfile [open $piddir/[pid] w]
close $pidfile

#4. C r e a t e   i m a g e   & start slideshow
if {$enablepic} {

  #Run once for all Desktops
  if { [info exists Debug] && $Debug } {
    source $Image
  } else {
    catch {source $Image}
  }

  #Try to set background
  catch setBg err
  if { [info exists Debug] && $Debug } {
    puts $err
  }
 
  #Run multiple times if $slideshow
  if {$slideshow > 0} {
  
    #rerun until pidfile renamed by new instance
    set pidfile $piddir/[pid]
    set pidfiledatum [clock format [file mtime $pidfile] -format %d]
    while {[file exists $pidfile]} {
      if {$pidfiledatum==$heute} {
        sleep [expr $slideshow * 1000]

        #export new TwdFile
        set ::TwdFileName [getRandomTwdFile]

        if { [info exists Debug] && $Debug } {
          source $Image
        } else {
          catch {source $Image}
        }
        #try to set background
        catch setBg err
        if { [info exists Debug] && $Debug } {
          puts $err
        }
  
      } else {
      
        #Calling new instance of myself
        source $Biblepix
      }
    }
  
  #if Slideshow == 0
  } else {

    if {$platform=="windows"} {
    
    #TODO testing
    setBg
      
      #run every 10s up to 15x so Windows has time to update      
#      for {set limit 0} {$limit < 15} {incr limit} {
#        sleep 10000
#        catch setBg
#      }
    }
    
  } ;#END if slideshow
} ;#END if enablepic

exit
