# ~/Biblepix/prog/src/sig/sigTrojita.tcl
# Adds The Word to e-mail signature files once daily
# called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9feb19

#Called by Signature if Trojitá installed
##scans Trojita identities in Registry & replaces any BiblePix signatures

#Set global vars
set tr {Trojitá}
set catchword {www.bible2.net}
set startcatch {=====}
set endcatch {bible2.net]}
set dayOTY [clock format [clock seconds] -format %j]

# trojitaSigWin
##Adds The Word to any signature(s) in Trojita IMAP mailer
##Rewrites Trojita Registry entry once a day
##Called by signature.tcl
proc trojitaSigWin {} {
  global tr dayOTY catchword trojitaWinRegpath
  set idPath "$trojitaWinRegpath\\identities"

  #1. determine catchword present & replace with Twd
  foreach id [registry keys $idPath] {
    set sigtext [registry get $idPath\\$id signature] 
    if [regexp $catchword $sigtext] {
	    set newSig [replaceTrojitaSigWin $sigtext]
      registry set $idPath\\$id signature $newSig
    }
  }
  
  #2. check date & exit if Today?s
  if [trojitaCheckDate] {
    return " $tr signatures up-to-date"
  }
  
  #3. Replace previous Twd's
  foreach id [registry keys $idPath] {
	  set sigtext [registry get $idPath\\$id signature]
	  set newSig [replaceTrojitaSigWin $sigtext]
    registry set $idPath\\$id signature $newSig
  }

} ;#END trojitaSigWin

proc replaceTrojitaSigWin {sigtext} {
  global tr catchword startcatch endcatch

  #1. Replace catchword
  if [regexp $catchword $sigtext] {
    puts "Replacing $tr catchword with The Word..."
    regsub $catchword $sigtext \n$::dw sigtext 
    incr ::sigChanged
  }
  
  #2. Replace previous TWD
  if [regexp $startcatch $sigtext] {
    puts "Renewing The Word for $tr..."
    regsub $startcatch.*$endcatch $sigtext $::dw sigtext
    incr ::sigChanged
  }
  #3. Create new dw
  set ::dw [getTodaysTwdSig $::twdFile]

return $sigtext

} ;#END replaceTrojitaSigWin

# trojitaCheckDate
##Returns 1 if Today's date found, else return 0
##Makes first time date entry if missing
##args is for Linux $sigChunk
##called by trojitaSigWin & trojitaSigLin
proc trojitaCheckDate {args} {
  global os dayOTY sigChunk trojitaWinRegpath

puts "Running trojitaCheckDate"
  # W I N D O W S
  if {$os=="Windows NT"} {
    package require registry
    catch {registry get $trojitaWinRegpath twdDate} twdDate
puts $twdDate
    if {![string is digit $twdDate]} {
      registry set $trojitaWinRegpath twdDate $dayOTY
    }
    
  # L I N U X
  } elseif {$os=="Linux"} {
  
    set sigChunk $args
    set datePresent [regexp {twdDate=} $sigChunk]

    ##1st time set date, return 0 for further processing
    if {!$datePresent} {
      append sigChunk "\n\n\[BiblePix\]\ntwdDate=$dayOTY"
      return 0

    } else {

      ##get twdDate 
      set datePos [string first twdDate= $sigChunk]
      set twdDate [string range $sigChunk [expr $datePos + 8] [expr $datePos + 10]]     

     
    }
    
  }
   if {$twdDate==$dayOTY} {
        return 1
      } else {
        return 0
      }
} ;#END trojitaCheckDate

# trojitaSigLin
##Adds The Word to any signature(s) in Trojita IMAP mailer
##Rewrites 'trojita.conf' once a day
##Called by signature.tcl
## !CONFIG FILE: Trojita allows for several config files (=profiles) which can be called with the -p option. - Change as needed
## !CATCHWORD: FIRST TIME USERS MUST ADD A CATCHWORD at end of each signature text where they want 'The Word' inserted {in Trojita go to >IMAP >Settings >General >"NAMES" >Edit and edit signature text accordingly} !!  
proc trojitaSigLin {} {
  global env heute jahr dw trojitaLinConfFile catchword startcatch tr dayOTY
puts "Running trojitaSigLin"
  #Open config file for reading
  set chan [open $trojitaLinConfFile r]
  set confText [read $chan]
  close $chan

  #Split off signature chunk from main chunk
  set sigStartIndex [string first {.\signature=} $confText]
  set mainChunk [string range $confText 0 [expr $sigStartIndex -1]] 
  set sigChunk [string range $confText $sigStartIndex end]


  #1. Determine catchwordPresent / twdPresent & exit if both missing
  set catchwordPresent [regexp $catchword $sigChunk]
  ##check twdPresent in Ascii & Hex  
  set twdPresent [regexp $startcatch $sigChunk]
  if {!$twdPresent} {
    set twdPresent [regexp x3d+ $sigChunk]
  }

  if {!$catchwordPresent && !$twdPresent} {
    return "$tr: No signatures to process, exiting. If you expected something else, add a line with $catchword where you want The Word."
  }

  #1. Replace catchword regardless of date
  if {$catchwordPresent} {
    set sigChunk [replaceTrojitaSigLin $sigChunk]

  #2. Determine date, exit if Today's found
  ##!config file date unreliable since file is updated by Trojita!
  } elseif [trojitaCheckDate $sigChunk] {
    return " $tr signatures up-to-date"
  
  } else {

  #3. Replace old Twd
    set sigChunk [replaceTrojitaSigLin $sigChunk]
  
  }
      
  #Save original config file once
  set confFileSaved ${trojitaLinConfFile}.SAVED
  if {![file exists $confFileSaved]} {
    puts "Saving original $trojitaLinConfFile to $confFileSaved"
    file copy $trojitaLinConfFile $confFileSaved
  }
 
  #Open config file for writing
  append confNeuText $mainChunk $sigChunk
  set chan [open $trojitaLinConfFile w]
  puts $chan $confNeuText
  close $chan
  puts "Added The Word to $::sigChanged $tr signatures"

} ;#END trojitaSigLin

# replaceTrojitaSigLin
##Determines number of ID's in sigChunk
##Replaces A) Catchword & B) Old TWD's
##called by trojitaSig
proc replaceTrojitaSigLin {sigChunk} {
puts "Running replaceTrojitaSigLin"
  global catchword startcatch endcatch tr

  #Get The Word in Hex format for Linux
  set dwhex [getTwdHex $::dw]

  #get start & end positions
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
      puts "Replacing $tr catchword with The Word..."

      regsub $catchword $idChunk \n$dwhex\" idChunk
      regsub {signature=} $idChunk signature=\" idChunk    
      set sigChunk [string replace $sigChunk $pos1 $pos2 $idChunk]
      incr ::sigChanged
 
    #2. REPLACE OLD TWD if present
    } elseif [regexp $endcatch $idChunk] {
      ##Replace with new TW, re-adding "" to whole signature
      regsub {signature=} $idChunk {signature="} idChunk
      regsub $startcatch.*$endcatch $idChunk $dwhex\" idChunk
      set sigChunk [string replace $sigChunk $pos1 $pos2 $idChunk]
      incr ::sigChanged

      #Get new Twd for next signature
      set file [getRandomTwdFile]
      set dw [getTodaysTwdSig $file]    
      set dwhex [getTwdHex $dw]
    }

  } ;#END main loop

  return $sigChunk
} ;#END replaceTrojitaSigLin

