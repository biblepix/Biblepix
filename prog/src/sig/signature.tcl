# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15may19

source $TwdTools
puts "Updating signatures..."
set twdList [getTWDlist]
set twdFile [getRandomTwdFile]
set ::dw [getTodaysTwdSig $twdFile]

foreach twdFileName $twdList {
  
  #set endung mit 8 Extrabuchstaben nach Sprache_
  set endung [string range $twdFileName 0 8] 
  set sigFile [file join $dirlist(sigDir) signature-$endung.txt]
  
  #create the File if it doesn't exist and open it.
  set sigFileChan [open $sigFile a+]
  chan configure $sigFileChan -encoding utf-8
  seek $sigFileChan 0
  
  #check date, skip if today's and not empty
  set dateidatum [clock format [file mtime $sigFile] -format %d]
  if {$heute == $dateidatum && [file size $sigFile] != 0} {
    puts " [file tail $sigFile] is up-to-date"
    continue
  }

  #Recreate The Word for each file
  set twdFile [getRandomTwdFile]
  set dw [getTodaysTwdSig $twdFile]
  
  #read the old sigFile
  set sigOld [read $sigFileChan]

  #cut out old verse and add blank line if missing
  set startIndex [string first "=====" $sigOld]
  if {$startIndex == "-1"} {
    set sigHead $sigOld
  } else {
    set sigHead [string replace $sigOld $startIndex end]
    if {![string match *\n\n=====* $sigOld]} {
      append sigHead "\n\n"
    }
  }

  set sigNew "$sigHead$dw"

  seek $sigFileChan 0
  puts $sigFileChan $sigNew
  chan truncate $sigFileChan [tell $sigFileChan]
  close $sigFileChan

  puts "Creating signature for signature-$endung"
} ;#END main loop


###############################################################################
### TROJITA IMAP MAILER #######################################################
###############################################################################

#Check presence of Trojita Win/Lin config || exit
##Windoze bug: auto_execok can't find executable in C:\Program Files (x86)\trojita.exe 
set trojitaLinConfFile [file join $env(HOME) .config flaska.net trojita.conf]
set trojitaWinRegpath [join {HKEY_CURRENT_USER SOFTWARE flaska.net trojita} \\]

if {$os=="Windows NT"} {
  package require registry
  
  if [catch {registry keys $trojitaWinRegpath}] {
    return "No Registry entry for Trojitá found. Exiting."
  }
    source $SigTrojita
	  catch trojitaSigWin err

} elseif {$os=="Linux"} {

  if {[auto_execok trojita] == "" || ![file exists $trojitaLinConfFile]} {
    return "No Trojitá executable / configuration file found. Exiting."
  }
    source $SigTrojita
    catch trojitaSigLin err
}

if [info exists err] {
  puts $err
}

#Clean up global vars
catch {unset ::sigChanged ::dw}
