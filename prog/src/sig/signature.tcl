# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 29dec20
source $TwdTools
source $SigTools

#########################################################################
# Main process: update sig files for any mail client that can handle them
#########################################################################

puts "Updating signatures..."
set twdFileList [getTwdSigList]

foreach twdFileName $twdFileList {
  
  #set endung mit 8 Extrabuchstaben nach Sprache_
  set endung [string range $twdFileName 0 8] 
  set sigFile [file join $sigdir signature-$endung.txt]
  
  #check presence of file
  if ![file exists $sigFile] {
    close [open $sigFile w]
  }
  #check date, skip if today's & sig present
  set dateidatum [clock format [file mtime $sigFile] -format %d]

  if {$heute == $dateidatum && [checkSigPresent $sigFile] } {
    puts " [file tail $sigFile] is up-to-date"
    continue
  }

  #Recreate The Word for each file
  set ::dwsig [getTodaysTwdSig $twdFileName]
  set sigPath [file join $sigdir $sigFile]
  set cleanSig [cleanSigfile $sigPath]

  #Write new sig to file
  set chan [open $sigPath w]
  puts $chan $cleanSig 
  puts $chan \n${::dwsig}
  close $chan
  
  puts "Created signature for signature-$endung"
} ;#END main loop


#####################################################################
### TROJITA IMAP MAILER 
#####################################################################

#Check presence of Trojita Win/Lin config || exit
##Windoze bug: auto_execok can't find executable in C:\Program Files (x86)\trojita.exe 
set trojitaLinConfFile [file join $env(HOME) .config flaska.net trojita.conf]
set trojitaWinRegpath [join {HKEY_CURRENT_USER SOFTWARE flaska.net trojita} \\]

if {$os=="Windows NT"} {
  package require registry
  
  if [catch {registry keys $trojitaWinRegpath}] {
    return "No Registry entry for Trojitá found. Exiting."
  }
  catch doSigTrojitaWin err

} elseif {$os=="Linux"} {

  if {[auto_execok trojita] == "" || ![file exists $trojitaLinConfFile]} {
    return "No Trojitá executable/configuration file found. Exiting."
  }
  catch doSigTrojitaLin err
}

if [info exists err] {
  puts $err
}


###########################################################################
### EVOLUTION MAIL CLIENT (only Linux)
###########################################################################

#Check presence of Evolution
if {[auto_execok evolution] != ""} {
puts "Evrim bulduk!"
  doSigEvolution
}

