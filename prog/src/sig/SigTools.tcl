# ~/Biblepix/prog/src/sig/sigTools.tcl
# Procs for Trojitá & Evolution mail clients
# Called by Signature if any of above found
# Authors: Peter Vollmar, biblepix.vollmar.ch
# Updated: 2jul24 pv

namespace eval sig {
  
  variable addednum
  
  #Set ::sig global vars
  set tr {Trojitá}
  set ev {Evolution}
  set evolSigdir [file join $env(HOME) .config evolution signatures]
  set catchword {www.bible2.net}
  set startcatch {=====}
  set endcatch {bible2.net]}
  set datecatch {twdDate=}
  set dayOTY [clock format [clock seconds] -format %j]
  set triggerRef {(<a href=\"http?:\/\/www\.bible2)(.*a>)}
  set nosigfoundT "Signatures up-to-date. If you expected something else, add a line saying $catchword where you want The Word."
  set addednum 0
  set addedsigT "Added The Word to $sig::addednum signature(s)."

  # checkSigPresent
  ##returns 0 or 1
  ##called by Signature
  proc checkSigPresent {sigFile} {
    global sig::startcatch
    
    set chan [open $sigFile r]
    set sigtext [read $chan]
    close $chan
    
    if [regexp $startcatch $sigtext] {
      return 1
    }
    return 0
  }

  # cleanSigfile
  ##cleans out old dw & returns original sig text, removing any tailing empty lines
  ##called by Signature
  proc cleanSigfile {sigFile} {
    global sig::startcatch

    set chan [open $sigFile r]
    chan configure $chan -encoding utf-8
    set sigOld [read $chan]
    close $chan

    #cut out any old verse
    set startIndex [string first $startcatch $sigOld]
    if {$startIndex == "-1"} {
      set sigHead $sigOld
    } else {
      set sigHead [string replace $sigOld $startIndex end]
    }

    ##clear any tailing blank lines & return text
    regsub \n*$ $sigHead {} sigHead
    return $sigHead
  }

  #######################################################################
  # E v o l u t i o n
  #######################################################################

  # doSigEvolution
  ##checks signature files for DW or trigger present & calls updateSigEvolution
  ##called by Signature
  proc doSigEvolution {} {
    global env sig::dayOTY ev
    global sig::addedsigT sig::catchword sig::ev sig::nosigfoundT sig::evolSigdir sig::triggerRef sig::startcatch sig::addednum
  
    puts "Updating evolution signatures..."
  	
    #Check all Evolution sig files for triggers
    foreach sigFilePath [glob -directory $evolSigdir *] {

      set mtimeDay [clock format [file mtime $sigFilePath] -format %j]
      set chan [open $sigFilePath r]
      set t [read $chan]
      close $chan
      
      #1) Check for The Word present & date >>cleanSig
      if { [regexp $startcatch $t] && $mtimeDay < $dayOTY } {
       
        set cleanSig [cleanSigfile $sigFilePath]
      } 
      
      #2) Remove any catchword/triggerRef & >>cleanSig
      if [regexp $catchword $t] {
        regsub $catchword $t {} cleanSig
      } elseif [regexp $triggerRef $t] {
        regsub $triggerRef $t {} cleanSig
      }
   
      #3) Update signature if old AND cleanSig exists
      if [info exists cleanSig] {
        updateSigEvolution $sigFilePath $cleanSig
        incr addednum
        unset cleanSig
      }
    }
    
    if $addednum {
      puts "$ev: $addedsigT $addednum"
    } else {
      puts "$ev: $nosigfoundT"
    }
    
    set addednum 0
    
  } ;#END doSigEvolution


  # updateSigEvolution 
  ##called by doSigEvolution for each sig file - NO HTML FORMATTING NEEDED NOW
  proc updateSigEvolution {sigfile cleanSig} {

    set twdFile [getRandomTwdFile 1]
    set dw [getTodaysTwdSig $twdFile]
    set chan [open $sigfile w]
    puts $chan $cleanSig
    puts $chan $dw
    close $chan
  }


  ########################################################################
  # T r o j i t a
  ########################################################################

  # trojitaSigWin
  ##Adds The Word to any signature(s) in Trojita IMAP mailer
  ##Rewrites Trojita Registry entry once a day
  ##Called by signature.tcl
  proc doSigTrojitaWin {} {
    global sig::dayOTY
    global sig::tr sig::catchword sig::trojitaWinRegpath sig::addedsigT
    set idPath "$trojitaWinRegpath\\identities"

    #1. 1st run: check catchword present & replace with Twd
    foreach id [registry keys $idPath] {
      set sigtext [registry get $idPath\\$id signature] 
      if [regexp $catchword $sigtext] {
	      set newSig [trojitaReplaceSigWin $sigtext]
        registry set $idPath\\$id signature $newSig 
      }
    }
    
    #2. Check date & exit if Today's - OBSOLETE, Verse is changed at each reboot (=BiblePix routine)
  #  set twdDate [trojitaGetDate]
  #  if {$twdDate==$dayOTY} {
  #    return " $tr signatures up-to-date"
  #  }
    
    #3. 2nd run: replace previous Twd's
    foreach id [registry keys $idPath] {
	    set sigtext [registry get $idPath\\$id signature]
	    set newSig [trojitaReplaceSigWin $sigtext]
      registry set $idPath\\$id signature $newSig
      puts "$tr: $addedSigT $addednum"
    }

    #4. Reset date if sig changed (var from trojitaReplaceSigWin) - OBSOLETE, has no effect now
    if $addednum {
      trojitaSetDate
    }
    
    set addednum 0
    
  } ;#END trojitaSigWin

  proc trojitaReplaceSigWin {sigtext} {
    global tr catchword startcatch endcatch
    
    #1. Create dw
    set twdFile [getRandomTwdFile 1]
    set dw [getTodaysTwdSig $twdFile]
    
    #2. Replace catchword
    if [regexp $catchword $sigtext] {
      puts "Replacing $tr catchword with The Word..."
      regsub $catchword $sigtext \n$dw sigtext 
      incr addednum
    
    #2. Replace previous TWD  
    } elseif [regexp $startcatch $sigtext] {
      puts "Renewing The Word for $tr..."
      regsub $startcatch.*$endcatch $sigtext $dw sigtext
      incr addednum
    }

    return $sigtext
  } ;#END trojitaReplaceSigWin


  # trojitaSigLin
  ##Adds The Word to any signature(s) in Trojita IMAP mailer
  ##Rewrites 'trojita.conf' once a day
  ##Called by signature.tcl
  ############################### INFO TODO put in Manpage! ########################################################################
  ## !CONFIG FILE: Trojita allows for several config files (=profiles) which can be called with the -p option. - Change as needed
  ## !CATCHWORD: FIRST TIME USERS MUST ADD A CATCHWORD at end of each signature text where they want 'The Word' inserted {in Trojita 
  ## go to >IMAP >Settings >General >"NAMES" >Edit and edit signature text accordingly} !!
  ##################################################################################################################################  
  proc doSigTrojitaLin {} {
    global env heute jahr sig::dayOTY
    global sig::addednum sig::nosigfoundT sig::addedsigT sig::trojitaLinConfFile sig::catchword sig::startcatch sig::tr
    
    #Open config file for reading
    set chan [open $trojitaLinConfFile r]
    set confText [read $chan]
    close $chan
    
    #Save original config file once
    set confFileSaved ${trojitaLinConfFile}.SAVED
    if ![file exists $confFileSaved] {
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
    if !$twdPresent {
      set twdPresent [regexp x3d+ $sigChunk]
    }

    if {!$catchwordPresent && !$twdPresent} {
      return "$tr: $nosigfoundT"
    }

    # # #  A C T I O N S

    #1. Replace catchword regardless of date & exit
    if $catchwordPresent {
      set sigChunk [trojitaReplaceSigLin $sigChunk]
      ##2.Save confFile
      append confNeuText $mainChunk $sigChunk
      set chan [open $trojitaLinConfFile w]
      puts $chan $confNeuText
      close $chan

      ##3.Save new date
      trojitaSetDate

      return "$tr: $addedsigT $addednum"

    #2. Check date & exit if todays - OBSOLETE????????, see above
    } elseif $twdPresent {
      
      set twdDate [trojitaGetDate]
      if {$twdDate==$dayOTY} {
        return "$tr: $nosigfoundT"
      } 
    }

    #3. Replace old Twd's with new
    set sigChunk [trojitaReplaceSigLin $sigChunk]

    #4. save config if signatures changed
    if [info exists addednum] {
        
      append confNeuText $mainChunk $sigChunk
      set chan [open $trojitaLinConfFile w]
      puts $chan $confNeuText
      close $chan
      puts "$tr $addedsigT $addednum"

      #5. save date
      trojitaSetDate
    }
    
    set addednum 0

  } ;#END doSigTrojitaLin

  # trojitaReplaceSigLin
  ##Determines number of ID's in sigChunk
  ##Replaces A) Catchword & B) Old TWD's C) date line
  ##called by trojitaSig
  proc trojitaReplaceSigLin {sigChunk} {
    global sig::catchword sig::startcatch sig::endcatch sig::tr sig::addednum
    
    #Get fist TWD - TODO is this needed?
    set file [getRandomTwdFile 1]
    set dwsig [getTodaysTwdSig $file]    
    set dwhex [getTwdHex $dwsig]

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
        incr addednum
   
      #2. REPLACE OLD TWD if present
      } elseif [regexp $endcatch $idChunk] {
        ##Replace with new TW, re-adding "" to whole signature
        regsub {signature=} $idChunk {signature="} idChunk
        regsub $startcatch.*$endcatch $idChunk $dwhex\" idChunk
        set sigChunk [string replace $sigChunk $pos1 $pos2 $idChunk]
        incr addednum

        #Get new Twd for next signature
        set file [getRandomTwdFile 1]
        set dwsig [getTodaysTwdSig $file]    
        set dwhex [getTwdHex $dwsig]
      }
    } ;#END main loop

    return $sigChunk
  } ;#END trojitaReplaceSigLin

} ;# END ::sig namespace
