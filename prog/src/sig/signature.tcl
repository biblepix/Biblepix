# ~/Biblepix/prog/src/main/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15nov15

source $Twdtools

puts "Updating signatures..."

set twdList [getTWDlist]
foreach twdFileName $twdList {
  set twdSig [getTodaysTwdSig $twdFileName]

  #set endung mit 5 Extrabuchstaben nach Sprache_
  set endung [string range $twdFileName 0 5] 
  set sigFile [file join $sigDir signature-$endung]
  
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

  set sigNew "$sigHead$twdSig"
  
  seek $sigFileChan 0
  puts $sigFileChan $sigNew
  chan truncate $sigFileChan [tell $sigFileChan]
  close $sigFileChan

  puts "Creating signature for signature-$endung"
} ;#END main loop
