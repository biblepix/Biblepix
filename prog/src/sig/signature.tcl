# ~/Biblepix/prog/src/main/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15nov15

set dwsig ""
set twdfile ""
#get new sig text
source $Twdtools

puts "Updating signatures..."

set twdlist [getTWDlist]
foreach twdfile $twdlist {
  #get sig text
  set dwsig [formatSigText $twdfile]
  #set endung mit 4 Extrabuchstaben nach Sprache_
  set endung [string range $twdfile 0 5] 
  set sigfile [file join $sigDir signature-$endung]

  #create new sigfile if inexistent
  if {![file exists $sigfile]} {
    set sigfilechan [open $sigfile w]
    close $sigfilechan
    set sigalt ""
  } else {
  #read old sigfile if existent
    set sigfilechan [open $sigfile r]
    set sigalt [read $sigfilechan]
    close $sigfilechan
  }
   
  #check date, skip if today's and not empty
  set dateidatum [clock format [file mtime $sigfile] -format %d]
   
  if { $heute==$dateidatum && [file size $sigfile]!=0 } {
    puts " [file tail $sigfile] is up-to-date"
       continue 
    } 
 
  #cut out old verse and add blank line if missing
  set anf [string first === $sigalt]
  if {$anf == "-1"} { 
    set sigorig $sigalt 
  } else {
    set sigorig [string replace $sigalt $anf end]
    if {![string match *\n\n===* $sigalt]} {
    set sigorig [append sigorig "\n"]
    }
  }

  #overwrite sigfile with new text
  set signeu [append signeu "$sigorig$dwsig"]
  set sigfilechan [open $sigfile w]
  #channel for Win
  chan configure $sigfilechan -encoding utf-8
  puts $sigfilechan $signeu
  close $sigfilechan

  puts "Creating signature for signature-$endung"

  unset sigorig sigalt signeu
} ;#END main loop
