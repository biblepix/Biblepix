# ~/Biblepix/prog/src/sig/sigTrojita.tcl
# Adds The Word to e-mail signature files once daily
# Called by Signature if Trojitá IMAP Mailer installed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7mch19

#Set global vars
set tr {Trojitá}
set catchword {www.bible2.net}
set startcatch {=====}
set endcatch {bible2.net]}
set datecatch {twdDate=}
set dayOTY [clock format [clock seconds] -format %j]

# trojitaSigWin
##Adds The Word to any signature(s) in Trojita IMAP mailer
##Rewrites Trojita Registry entry once a day
##Called by signature.tcl
proc trojitaSigWin {} {
  global tr dayOTY catchword trojitaWinRegpath
  set idPath "$trojitaWinRegpath\\identities"

  #1. 1st run: check catchword present & replace with Twd
  foreach id [registry keys $idPath] {
    set sigtext [registry get $idPath\\$id signature] 
    if [regexp $catchword $sigtext] {
	    set newSig [trojitaReplaceSigWin $sigtext]
      registry set $idPath\\$id signature $newSig 
    }
  }
  
  #2. Check date & exit if Today's
  set twdDate [trojitaGetDate]
  if {$twdDate==$dayOTY} {
    return " $tr signatures up-to-date"
  }
  
  #3. 2nd run: replace previous Twd's
  foreach id [registry keys $idPath] {
	  set sigtext [registry get $idPath\\$id signature]
	  set newSig [trojitaReplaceSigWin $sigtext]
    registry set $idPath\\$id signature $newSig
  }

  #4. Reset date if sig changed (var from trojitaReplaceSigWin)
  if [info exists ::sigChanged] {
    trojitaSetDate
  }

} ;#END trojitaSigWin

proc trojitaReplaceSigWin {sigtext} {
  global tr catchword startcatch endcatch

  #1. Replace catchword
  if [regexp $catchword $sigtext] {
    puts "Replacing $tr catchword with The Word..."
    regsub $catchword $sigtext \n$::dw sigtext 
    incr ::sigChanged
  
  #2. Replace previous TWD  
  } elseif [regexp $startcatch $sigtext] {
    puts "Renewing The Word for $tr..."
    regsub $startcatch.*$endcatch $sigtext $::dw sigtext
    incr ::sigChanged
  }

  #3. Create dw for next run
  set twdFile [getRandomTwdFile]
  set ::dw [getTodaysTwdSig $twdFile]

  return $sigtext
} ;#END trojitaReplaceSigWin


# trojitaSigLin
##Adds The Word to any signature(s) in Trojita IMAP mailer
##Rewrites 'trojita.conf' once a day
##Called by signature.tcl
## !CONFIG FILE: Trojita allows for several config files (=profiles) which can be called with the -p option. - Change as needed
## !CATCHWORD: FIRST TIME USERS MUST ADD A CATCHWORD at end of each signature text where they want 'The Word' inserted {in Trojita go to >IMAP >Settings >General >"NAMES" >Edit and edit signature text accordingly} !!  
proc trojitaSigLin {} {
  global env heute jahr dw trojitaLinConfFile catchword startcatch tr dayOTY

  #Open config file for reading
  set chan [open $trojitaLinConfFile r]
  set confText [read $chan]
  close $chan
  
  #Save original config file once
  set confFileSaved ${trojitaLinConfFile}.SAVED
  if {![file exists $confFileSaved]} {
    puts "Saving original $trojitaLinConfFile to $confFileSaved"
    file copy $trojitaLinConfFile $confFileSaved
  }

  #Split off signature chunk from main chunk
  set sigStartIndex [string first {.\signature=} $confText]
  set mainChunk [string range $confText 0 [expr $sigStartIndex -1]] 
  set sigChunk [string range $confText $sigStartIndex end]

  #Determine catchwordPresent / twdPresent & exit if both missing
  set catchwordPresent [regexp $catchword $sigChunk]
  ##check in Ascii & Hex  
  set twdPresent [regexp $startcatch $sigChunk]
  if {!$twdPresent} {
    set twdPresent [regexp x3d+ $sigChunk]
  }

  if {!$catchwordPresent && !$twdPresent} {
    return "$tr: No signatures to process, exiting. If you expected something else, add a line saying $catchword where you want The Word."
  }

  # # #  A C T I O N S

  #1. Replace catchword regardless of date & exit
  if {$catchwordPresent} {
    set sigChunk [trojitaReplaceSigLin $sigChunk]
    ##2.Save confFile
    append confNeuText $mainChunk $sigChunk
    set chan [open $trojitaLinConfFile w]
    puts $chan $confNeuText
    close $chan
    ##3.Save new date
    trojitaSetDate

    return "Added The Word to $::sigChanged $tr signatures"

  #2. Check date & exit if todays
  } elseif {$twdPresent} {
    
    set twdDate [trojitaGetDate]
    if {$twdDate==$dayOTY} {
      return "$tr signatures up-to-date."
    } 
  }

  #3. Replace old Twd's with new
  set sigChunk [trojitaReplaceSigLin $sigChunk]

  #4. save config if signatures changed
  if [info exists ::sigChanged] {
      
    append confNeuText $mainChunk $sigChunk
    set chan [open $trojitaLinConfFile w]
    puts $chan $confNeuText
    close $chan
    puts "Added The Word to $::sigChanged $tr signatures"

    #5. save date
    trojitaSetDate
  }
} ;#END trojitaSigLin

# trojitaReplaceSigLin
##Determines number of ID's in sigChunk
##Replaces A) Catchword & B) Old TWD's C) date line
##called by trojitaSig
proc trojitaReplaceSigLin {sigChunk} {
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
} ;#END trojitaReplaceSigLin

# trojitaGetDate
##returns any registered date, else 0
##called by trojitaSigLin + trojitaSigWin
proc trojitaGetDate {} {
  global os trojitaWinRegpath trojitaLinConfFile datecatch

  # W I N D O W S
  if {$os=="Windows NT"} {
    package require registry
    catch {registry get $trojitaWinRegpath twdDate} twdDate
    if {![string is digit $twdDate]} {
      set twdDate 0
    }

  # L I N U X
  } elseif {$os=="Linux"} {

    set chan [open $trojitaLinConfFile r]
    set confText [read $chan]
    close $chan

    set datePos [string first $datecatch $confText]
    if {![string is digit $datePos]} {
      return 0
    }
 
    set pos1 [expr $datePos + 8]
    set pos2 [expr $datePos + 10]
    set twdDate [string range $confText $pos1 $pos2]
  }

  return $twdDate
}

# trojitaSetDate
##registers today's date
##called by trojitaSigWin & trojitaSigLin if needed
proc trojitaSetDate {} {
  global os dayOTY trojitaWinRegpath trojitaLinConfFile datecatch linuxConfText

  # W I N D O W S
  if {$os=="Windows NT"} {
    package require registry
    registry set $trojitaWinRegpath twdDate $dayOTY
    
  # L I N U X
  } elseif {$os=="Linux"} {

    #Open confFile for reading
    set chan [open $trojitaLinConfFile r]
    set confText [read $chan]
    close $chan

    set datePos [string first $datecatch $confText]

    #Open confFile for writing
    set chan [open $trojitaLinConfFile w]

    ##set twdDate 1st time
    if {![string is digit $datePos]} {
      append confText "\n\n\[BiblePix\]\ntwdDate=$dayOTY"
    ##reset twdDate
    } else {
      set pos1 [expr $datePos + 8]
      set pos2 [expr $datePos + 10]
      set twdDate [string range $confText $pos1 $pos2]
      set confText [string replace $confText $pos1 $pos2 $dayOTY]
    }
    ##Save new text
    puts $chan $confText
    close $chan
  }

return "Setting new TWD date in Trojitá"
} ;#END trojitaSetDate
