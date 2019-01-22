# ~/Biblepix/prog/src/sig/signature.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 22jan19

source $TwdTools
puts "Updating signatures..."
set twdList [getTWDlist]
set twdFile [getRandomTwdFile]
set ::dw [getTodaysTwdSig $twdFile]
#puts $dw

foreach twdFileName $twdList {
  
  #set endung mit 8 Extrabuchstaben nach Sprache_
  set endung [string range $twdFileName 0 8] 
  set sigFile [file join $sigDir signature-$endung.txt]
  
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

#Check presence of Trojita executable
if {[auto_execok trojita] == ""} {
  return "No Trojitá executable found. Exiting."
}

# trojitaSig
##Adds The Word to any signature(s) in Trojita IMAP mailer
##Rewrites 'trojita.conf' once a day
##Called by signature.tcl
## CONFIG FILE: Trojita allows for several config files (=profiles) which can be called with the -p option. - Change as needed
## CATCHWORD: !!Important: FIRST TIME USERS MUST ADD A CATCHWORD at end of each signature text where they want 'The Word' inserted {in Trojita go to >IMAP >Settings >General >"NAMES" >Edit and edit signature text accordingly} !!  
proc trojitaSig {} {
  global env heute jahr trojitaConfFile dw
  set catchword {www.bible2.net}
  set startcatch {=====}
  set endcatch {bible2.net]}
  
  #Run trojitaSig if config file found - TODO: Windows location???
  set trojitaConfDir "$env(HOME)/.config/flaska.net"
  set trojitaConfFile $trojitaConfDir/trojita.conf
  if {![file exists $trojitaConfFile]} {
    return "No Trojitá configuration file found. Exiting."
  }
  
  #Get The Word in Hex format
  set dwhex [getTwdHex $dw]

  #Open config file for reading
  set chan [open $trojitaConfFile r]
  set confText [read $chan]
  close $chan

  #Split off signature chunk from main chunk
  set sigStartIndex [string first {.\signature=} $confText]
  set mainChunk [string range $confText 0 [expr $sigStartIndex -1]] 
  set sigChunk [string range $confText $sigStartIndex end]

######### START ACTIONS #############################################

  #1. Determine catchwordPresent / twdPresent & exit if both missing
  set catchwordPresent [regexp $catchword $sigChunk]
  ##check twdPresent in Ascii & Hex  
  set twdPresent [regexp $startcatch $sigChunk]
  if {!$twdPresent} {
    set twdPresent [regexp x3d+ $sigChunk]
  }

  if {!$catchwordPresent && !$twdPresent} {
    return "Trojitá: No signatures to process, exiting. If you expected something else, add a line with $catchword where you want The Word."
  }

  #2. Determine date, exit if Today's found
  ##!config file date unreliable since file is updated at every run!
  set dayOTY [clock format [clock seconds] -format %j]
  set twdDatePresent [regexp {twdDate} $sigChunk] 
  if {$twdDatePresent} {
    set twdDateIndex [string first twdDate= $sigChunk]
    set twdDate [string range $sigChunk [expr $twdDateIndex + 8] [expr $twdDateIndex + 11]]
    if {$twdDate==$dayOTY} {
      return " Trojita signatures up-to-date"
    }
  }

  #3. Determine number of ID's

  ##get start & end positions
  set idNo 1
  lappend indexList 0
  foreach id $sigChunk {
    set idStart [string first $idNo\\signature= $sigChunk]
    #Add 0 only once for start
    if {$idStart >0} {
    #Add double index -1 for following lines  
      lappend indexList [expr $idStart - 1] $idStart
    }
  incr idNo
  }
  #Add end of text pos as last line
  lappend indexList [string length $sigChunk]
  array set indexArr $indexList

  #Start main loop: Text replacing operations
  foreach name [array names indexArr] {
    set pos1 $name
    set pos2 [lindex [array get indexArr $name] 1]
    set idChunk [string range $sigChunk $pos1 $pos2]
    regsub -all {"} $idChunk {} idChunk
    
    #1. 1ST TIME REPLACING
    ##find catchword, replace and exit, do not verify date
    if [regexp $catchword $idChunk] {
      ##replace catchword, put whole sig between ""
      puts "replacing $catchword..."

      regsub $catchword $idChunk \n$dwhex\" idChunk
      regsub {signature=} $idChunk signature=\" idChunk    
      set sigChunk [string replace $sigChunk $pos1 $pos2 $idChunk]
      incr sigChanged
 
    #2. REPLACE OLD TWD if present
    } elseif [regexp $endcatch $idChunk] {
      ##Replace with new TW, re-adding "" to whole signature
      regsub {signature=} $idChunk {signature="} idChunk
      regsub $startcatch.*$endcatch $idChunk $dwhex\" idChunk
      set sigChunk [string replace $sigChunk $pos1 $pos2 $idChunk]
      incr sigChanged

      #Get new Twd for next signature
      set file [getRandomTwdFile]
      set dw [getTodaysTwdSig $file]    
      set dwhex [getTwdHex $dw]
    }

  } ;#END main loop

  #Amend/Add date if sig changed
  if [info exists sigChanged] {
    puts "Added The Word to $sigChanged Trojitá signature(s)."
    ##amend
    if [info exists twdDate] {
      regsub {twdDate=...} $sigChunk twdDate=$dayOTY sigChunk
    ##1st time add (extra [header] seems to do no harm!)
    } else {
      append sigChunk "\n\n\[BiblePix\]\ntwdDate=$dayOTY"
    }
  #Exit if nothing done
  } else {
    return "Trojita: signatures unchanged; if you want The Word added to one of your signatures please add a new line with the expression $catchword under >IMAP>Settings>General>Edit."
  }

  #Save original config file once
  set confFileSaved ${trojitaConfFile}.SAVED
  if {![file exists $confFileSaved]} {
    puts "Saving original $trojitaConfFile to $confFileSaved"
    file copy $trojitaConfFile $confFileSaved
  }
 
  #Open config file for writing
  append confNeuText $mainChunk $sigChunk
  set chan [open $trojitaConfFile w]
  puts $chan $confNeuText
  close $chan
  puts "Saved new Trojitá config file."
} ;#END trojitaSig

catch trojitaSig err
puts $err
