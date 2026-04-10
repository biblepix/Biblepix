#!/usr/bin/env tclsh
# ~/Biblepix/prog/src/biblepix.tcl
# Main program, called by System Autostart
# Projects The Word from "Bible 2.0" on a daily changing backdrop image 
# OR displays The Word in the terminal OR adds The Word to e-mail signatures
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 10apr26 pv
######################################################################

#Verify location & source Globals
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir share globals.tcl]"
source $Globals
source $TwdTools

# killpid
##deletes old PID process if still running
proc killpid {PID} {
  if {$os == "Linux"} {
    set killpid {kill}
  } elseif {$os == "Windows"} {
    set killpid {taskkill /Pid}
  }
  exec $killpid
}

#Delete old PID(s) & write new PID into piddir
foreach pidPath [glob -nocomplain -type f $piddir/*] {
  file delete $pidPath
  catch {killpid [file tail $pidPath]}
}
set chan [open [file join $piddir [pid]] w]
close $chan

#Look for new prog files, limited to 24 h
catch {runHTTP 0}

#TWD list - this seems too much, only needed in Setup!
#catch testTlsConn

#für Jahreswechsel:
catch updateTwd

#Set TwdFileName for the 1st time, else run Setup
if [catch {set twdfile [getRandomTwdFile]}] {
  msgcatInit $lang
  package require Tk
  tk_messageBox -title BiblePix -type ok -icon error -message "[msgcat::mc noTwdFilesFound]"
  
  #catch if run by running Setup
  catch {source $Setup}
  return
}

#Export TwdFilename to global space
set ::TwdFileName $twdfile

#1. U p d a t e   s i g n a t u r e s  if $enablesig
if $enablesig {
  if [catch {source $Signature}] {
    puts "There is a problem updating signatures..."
  } {
    puts "Updating signatures..."
  }
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


#3. P r e p a r e   c h a n g i n g   b a c k g r o u n d

#Get appropriate setBg proc
##setBg is executed for Desktops that can accept a command
##setBg can be empty/non-existent as it is 'catched'
source $SetBackgroundChanger


#4. C r e a t e   i m a g e   & start slideshow

if $enablepic {

  #Run once for all Desktops
  if { [info exists Debug] && $Debug } {
    source $Image
  } else {
    catch {source $Image}
  }

  #Run multiple times if $slideshow
  if {$slideshow > 0} {
  
    #rerun until pidfile renamed by new instance
    
set pidfile $piddir/[pid]

    set pidfiledatum [clock format [file mtime $pidfile] -format %d]
    
while [file exists $pidfile] {
    
      if {$pidfiledatum==$heute} {

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
    
      #not heute
      #Calling new instance of myself   
      } else {
      
        source $Biblepix
        
      } ;#END heute
      
      #Renew surprise.sig every $interval
     if $enablesig  {
        renewSurpriseSig
      }
      
      after [expr $slideshow * 1000] 
    
    } ;#END while pidfile
 
  #NO SLIDESHOW: SINGLE PIC  - TODO JOEL good enough for Win?
  } else {
  
    catch setBg err
    if { [info exists Debug] && $Debug } {
      puts $err
    }
        
  } ;#END slideshow
    
} ;#END enablepic
