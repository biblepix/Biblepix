# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 12mch26 pv

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
  set sig_txt [lindex $sigfile 1]
  set sigpath signature-${sig_txt}
  
  #check presence of file
  if ![file exists $sigpath] {
    close [open $sigpath w]
  }
  
  #check date, skip if today's & sig present
  #cd $sigdir
  set dateidatum [clock format [file mtime $sigpath] -format %d]

  if {$heute == $dateidatum && [sig::checkSigPresent $sigpath] } {
    puts " [file tail $sig_txt] is up-to-date"
    continue
  }

  #Recreate The Word for each file
  set dwsig [getTodaysTwdSig $sig_twd]
  set cleanSig [sig::cleanSigfile $sigpath]

  #Write new sig to file
  set chan [open $sigpath w]
  puts $chan $cleanSig 
  puts $chan \n${dwsig}
  close $chan

  puts "Created new signature for $sigpath"

} ;#END main loop

#Create random sigfile for SURPRISE file at each run of Biblepix
##run once, later run by Biblepix if '$slideshow' enabled
renewSurpriseSig

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
