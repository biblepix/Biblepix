# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 6mch26 pv

source $TwdTools
source $SigTools

#########################################################################
# Main process: update sig files for any mail client that can handle them
#########################################################################

#Provide sigfile names with ending .sig
set twdSigL [getTwdSigList]

if {$twdSigL == ""} {
  package require Tk
  set msg "No corresponding Bible text files found! Please rerun Setup to define which languages you desire for your e-mail signatures."
  tk_messageBox -message $msg -title "BiblePix E-mail Signature"
  return 1
}

#Prepare signatures for all selected langs
foreach sigfile $twdSigL {

  set sig_twd [lindex $sigfile 0]
  set sig_sig [lindex $sigfile 1]
  
  #check presence of file - TODO Was soll das?
  if ![file exists $sig_sig] {
    close [open $sigdir/$sig_sig w]
  }
  
  #check date, skip if today's & sig present
  cd $sigdir
  set dateidatum [clock format [file mtime $sig_sig] -format %d]

  if {$heute == $dateidatum && [sig::checkSigPresent $sig_sig] } {
    puts " [file tail $sig_sig] is up-to-date"
    continue
  }

  #Recreate The Word for each file
  set dwsig [getTodaysTwdSig $sig_twd]
  set sigPath [file join $sigdir $sig_sig]
  set cleanSig [sig::cleanSigfile $sigPath]

  #Write new sig to file
  set chan [open $sigPath w]
  puts $chan $cleanSig 
  puts $chan \n${dwsig}
  close $chan

  puts "Created new signature for $sigPath"

} ;#END main loop

#Create random sigfile for SURPRISE file at each run of Biblepix
set randomSigfile [getRandomTwdFile 1]
set surpriseFile signature-SURPRISE.sig
set surpriseFilePath [file join $sigdir $surpriseFile]

file copy -force [file join $sigdir [lindex $randomSigfile 1]] $surpriseFilePath
##old name with .txt - to be removed sometime soon
file copy -force $surpriseFilePath $sigdir/signature-SURPRISE.txt

#Clear stale sigs not in current list
foreach f [glob -directory $sigdir *] {
  set dateidatum [clock format [file mtime $f] -format %d]
  if {$dateidatum != $heute} {
    file delete $f
  }
}


#####################################################################
### TROJITA IMAP MAILER 
#####################################################################

#Check presence of Trojita Win/Lin config || exit
##Windoze bug: auto_execok can't find executable in C:\Program Files (x86)\trojita.exe 
set sig::trojitaLinConfFile [file join $env(HOME) .config flaska.net trojita.conf]
set sig::trojitaWinRegpath [join {HKEY_CURRENT_USER SOFTWARE flaska.net trojita} \\]

if {$os=="Windows NT"} {
  package require registry
  
  if [catch {registry keys $trojitaWinRegpath}] {
    puts "No Registry entry for Trojitá found. Exiting."
    #return 1
  }
  catch sig::doSigTrojitaWin err

} elseif {$os=="Linux"} {

  if {[auto_execok trojita] == "" || ![file exists $sig::trojitaLinConfFile]} {
    puts "No Trojitá executable/configuration file found. Exiting."
  }
  catch sig::doSigTrojitaLin err
}

if [info exists err] {
  puts $err
}


###########################################################################
### EVOLUTION MAIL CLIENT (only Linux)
###########################################################################

#Check presence of Evolution
if {[auto_execok evolution] == ""} {
  puts "No $sig::ev executable found. Exiting."

} else {

  catch sig::doSigEvolution err
} 

if [info exists err] {
  puts $err
}

#Clean up
namespace delete sig
