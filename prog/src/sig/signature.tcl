# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 20jan22 pv
source $TwdTools
source $SigTools

#########################################################################
# Main process: update sig files for any mail client that can handle them
#########################################################################

puts "Updating signatures..."

set twdFileList [getTwdSigList]

#TODO change surprise file each time BP runs, not only once a day!
set surpriseFile signature-SURPRISE.txt
lappend twdFileList $surpriseFile
  
if ![file exists $sigdir/$surpriseFile] {
  set chan [open $sigdir/$surpriseFile w]
  close $chan 
}

if {$twdFileList == ""} {
#TODO who can read this?!
  return "No corresponding TWD language files found!\n Please rerun Setup to define which languages your desire for your e-mail signatures."
}

# Prepare signatures for all selected langs
foreach twdFileName $twdFileList {

  if {$twdFileName == "$surpriseFile"} {

    set sigFile $surpriseFile
    
  } else {
  
    #set endung mit 8 Extrabuchstaben nach Sprache_
    set endung [string range $twdFileName 0 8] 
    set sigFile [file join $sigdir signature-$endung.txt]
  }
  
  #check presence of file
  if ![file exists $sigFile] {
    close [open $sigFile w]
  }
  
  #check date, skip if today's & sig present
  set dateidatum [clock format [file mtime $sigFile] -format %d]
  if {$heute == $dateidatum && [sig::checkSigPresent $sigFile] } {
    puts " [file tail $sigFile] is up-to-date"
    continue
  }

  #Recreate The Word for each file
  if {$sigFile == $surpriseFile} {
    ##if SURPRISE, get one out of siglist (=1)
    set twdFileName [getRandomTwdFile 1]
  }
  set dwsig [getTodaysTwdSig $twdFileName]
  set sigPath [file join $sigdir $sigFile]
  set cleanSig [sig::cleanSigfile $sigPath]

  #Write new sig to file
  set chan [open $sigPath w]
  puts $chan $cleanSig 
  puts $chan \n${dwsig}
  close $chan
  
  puts "Created signature for signature-$endung"

} ;#END main loop


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
if {[auto_execok evolution] != ""} {
  catch sig::doSigEvolution err
}
if [info exists err] {
  puts $err
}

#Clean up
namespace delete sig
