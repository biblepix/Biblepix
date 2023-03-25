# ~/Biblepix/prog/src/share/TwdTools.tcl
# Tools to extract & format "The Word" / various listers & randomizers
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 1apr21 pv

#tDom is standard in ActiveTcl, Linux distros vary
if [catch {package require tdom}] {
  package require Tk
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $packageRequireTDom
  exit
}

################################################################################
######################### G E N E R A L   T O O L S  ###########################
################################################################################

#L i s t e n   o h n e   P f a d
proc getTwdList {} {
  global dirlist jahr
  set twdL [glob -nocomplain -tails -directory $dirlist(twdDir) *_$jahr.twd]
  return $twdL
}

# getTwdSigList
##selects TWD files for languages selected in SetupEmail CodeList
##called by getRandomTwdFile with args=sig
proc getTwdSigList {} {
  global dirlist jahr sigLanglist

  #A) Use only files that match $sigLangist
  if { [info exists sigLanglist] && $sigLanglist != ""} {
    ##get all twdfiles related to $lang
    foreach code $sigLanglist {
      foreach item [glob -nocomplain -tails -directory $dirlist(twdDir) ${code}*_$jahr.twd] {
        lappend twdsigL $item
      }
    }
  } 
  if [info exists twdsigL] {
    return $twdsigL
  }
}

#R a n d o m i z e r s

# getRandomTwdFile
##Ausgabe ohne Pfad
##called by Biblepix, with args=1 =sig
proc getRandomTwdFile {{sig 0}} {
  #A) for signature
  if $sig {
    set twdL [getTwdSigList]
  #B) for all others 
  } else {
    set twdL [getTwdList]
  }
  
  if {$twdL != ""} {
    set randIndex [expr {int(rand()*[llength $twdL])}]  
    return [lindex $twdL $randIndex]
  }
}

# getRandomFontcolor
##called by Image if randomFontcolor = 1
proc getRandomFontcolor {} {
  global fontcolourL
  set randIndex [expr {int(rand()*[llength $fontcolourL])}]
  return [lindex $fontcolourL $randIndex]
}

proc updateTwd {} {
  package require json
  source $::Http

  set twdFiles [glob -nocomplain -directory $::dirlist(twdDir) *.twd]

  ##########################################
  # Download Current TwdFiles if missing
  ##########################################

  foreach twdFile $twdFiles {
    set fileParts [split [file tail $twdFile] "_"]
    if {[lindex $fileParts 2] < "$::jahr.twd"} {
      set oldFileName [lindex $fileParts 1]
      set currentExists 0
      foreach otherTwdFile $twdFiles {
        set otherFileParts [split [file tail $otherTwdFile] "_"]
        if {[lindex $otherFileParts 1] == $oldFileName && [lindex $otherFileParts 2] == "$::jahr.twd"} {
          set currentExists 1
        }
      }

      if {!$currentExists} {
        downloadTwdFile $twdFile $::jahr
      }
    }
  }

  ##########################################
  # Download New TwdFiles if available
  ##########################################

  if {[catch {set onlineJsonFileList [getDataFromUrl "$::twdUrl?format=json"]}]} {
    return
  }

  set onlineDictFileList [::json::json2dict $onlineJsonFileList]
  
  set nextYearAvailable 0
  set nextYear [expr {$::jahr + 1}]

  foreach onlineDictFile $onlineDictFileList {
    if {[dict get $onlineDictFile "year"] == $nextYear} {
      set nextYearAvailable 1
      break
    }
  }

  if {$nextYearAvailable} {
    set currentTwdList [glob -nocomplain -directory $::dirlist(twdDir) *$::jahr.twd]
    set nextTwdList [glob -nocomplain -directory $::dirlist(twdDir) *$nextYear.twd]

    foreach currentFile $currentTwdList {
      set nextExists 0
      set nextOnlineMissing 1
      set currentName [lindex [split [file tail $currentFile] "_"] 1]

      foreach onlineDictFile $onlineDictFileList {
        if {[dict get $onlineDictFile "year"] == $nextYear \
         && [dict get $onlineDictFile "bible"] == $currentName} {
          set nextOnlineMissing 0
          break
        }
      }

      if {$nextOnlineMissing} {
        continue
      }

      if {$nextTwdList != ""} {
        foreach nextFile $nextTwdList {
          if {$currentName == [lindex [split [file tail $nextFile] "_"] 1]} {
            set nextExists 1
          }
        }
      }

      if {!$nextExists} {
        downloadTwdFile $currentFile $nextYear
      }
    }
  }

  ##########################################
  # Delete old TwdFiles
  ##########################################

  foreach twdFile $twdFiles {
    set fileParts [split [file tail $twdFile] "_"]
    if {[lindex $fileParts 2] < "$::jahr.twd"} {
      set fileName [lindex $fileParts 1]
      foreach otherTwdFile $twdFiles {
        set otherFileParts [split [file tail $otherTwdFile] "_"]
        if {[lindex $otherFileParts 1] == $fileName && [lindex $otherFileParts 2] == "$::jahr.twd"} {
          file delete $twdFile
          break
        }
      }
    }
  }
}

#####################################################################
### T W D   P A R S I N G   T O O L S   #############################
#####################################################################
  
proc getTWDFileRoot {twdFile} {
  global dirlist

  set path [file join $dirlist(twdDir) $twdFile]
  set file [open $path]
  chan configure $file -encoding utf-8
  set TWD [read $file]
  close $file
  set doc [dom parse $TWD]
  return [$doc documentElement]
}

proc parseTwdFileDomDoc {twdFile} {
  global dirlist

  set path [file join $dirlist(twdDir) $twdFile]
  set file [open $path]
  chan configure $file -encoding utf-8
  set Twd [read $file]
  close $file
  return [dom parse $Twd]
}

proc getDomNodeForToday {domDoc} {
  set datum [clock format [clock seconds] -format %Y-%m-%d]
  set rootDomNode [$domDoc documentElement]
  return [$rootDomNode selectNodes /thewordfile/theword\[@date='$datum'\]]
}

# parseToText
##called by getTwdTitle getTwdParolNode getParolIntro getParolText getParolRef
proc parseToText {node TwdLang {withTags 0}} {
  global BdfBidi os
  
  if {$node == ""} {
    return ""
  }
  
  if {$withTags} {
    set emNodes [$node selectNodes em/text()]
    if {$emNodes != ""} {
      foreach emNode $emNodes {
        $emNode nodeValue "_[$emNode nodeValue]_"
      }
    }
  }
  
  set text [$node asText]
  
  #Fix Bidi languages
  set RtL [isRtL $TwdLang]
  if $RtL {
    if ![namespace exists bidi] {
      source $BdfBidi
    }
  set text [bidi::fixBidi $text]
  }
  
  return $text
} ;#END parseToText

# appendParolToText
##called by getTodaysTwdText & getTodaysTwdSig
##args='html' for Evolution
proc appendParolToText {parolNode TwdText indent {TwdLang "de"} {RtL 0}} {
  
  global tab
  
  set intro [getParolIntro $parolNode $TwdLang]
  if {$intro != ""} {
    if $RtL {
      append TwdText $intro $indent { } \n
    } else {
      append TwdText $indent $intro { } \n
    }
  }
  
  set text [getParolText $parolNode $TwdLang]
  set textLines [split $text \n]
   
  foreach line $textLines {
    if $RtL {
      append TwdText $line $indent \n
    } else {
      append TwdText $indent $line \n
    }
  }
  
  set ref [getParolRef $parolNode $TwdLang]
  if $RtL {
    append TwdText $ref $tab
  } else {
    append TwdText $tab $ref
  }
  
  return $TwdText  
} ;#END appendParolToText

# appendParolToTermText
##called by ?
proc appendParolToTermText {parolNode TwdText indent} {
  global tab
    
  set intro [getParolIntro $parolNode]
  if {$intro != ""} {
    append TwdText "echo -e \$\{txtrst\}\$\{int\}\"$indent$intro\"\n"
  }
  
  set text [getParolText $parolNode]
  set textLines [split $text \n]
   
  foreach line $textLines {
    append TwdText "echo -e \$\{txt\}\"$indent$line\"\n"
  }
  
  set ref [getParolRef $parolNode]
  append TwdText "echo -e \$\{ref\}\$\{tab\}\"$ref\""
  
  return $TwdText
}

## O U T P U T

proc getTwdLang {TwdFileName} {
  return [string range $TwdFileName 0 1]
}

# isRtL
##checks if TwdLang is RtL (Hebrew or Arabic script)
##called by BdfPrint
proc isRtL {TwdLang} {
  if {
  $TwdLang == "he" ||
	[isArabicScript $TwdLang]
  } {
    return 1
  } else {
    return 0
  }
}
# isArabicScript
##checks if TwdLang is Arabic script (including Arabic+Urdu+Farsi)
##called by isRtL
proc isArabicScript {TwdLang} {
  if {
  $TwdLang == "ar" || 
  $TwdLang == "ur" || 
  $TwdLang == "fa"
  } {
    return 1
  } else {
    return 0
  }
}

proc getTwdTitle {twdNode {TwdLang "de"} {withTags 0}} {
  return [parseToText [$twdNode selectNodes title] $TwdLang $withTags]
}

proc getTwdParolNode {no twdNode} {
  return [$twdNode selectNodes parol\[$no\]]
}

proc getParolIntro {parolNode {TwdLang "de"} {withTags 0}} {
  return [parseToText [$parolNode selectNodes intro] $TwdLang $withTags]
}

proc getParolText {parolNode {TwdLang "de"} {withTags 0}} {
  return [parseToText [$parolNode selectNodes text] $TwdLang $withTags]
}

proc getParolRef {parolNode {TwdLang "de"} {withTags 0}} {
  #return [string cat "~ " [parseToText [$parolNode selectNodes ref] $TwdLang $withTags]]
  return [parseToText [$parolNode selectNodes ref] $TwdLang $withTags]
}


# getTodaysTwdNodes
##used in BdfPrint
proc setTodaysTwdNodes {TwdFileName} {
  set TwdLang [getTwdLang $TwdFileName]
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
}

#getTodaysTwdText
## used in Setup
proc getTodaysTwdText {TwdFileName} {
  global enabletitle ind
  
  set TwdLang [getTwdLang $TwdFileName]
  set RtL [isRtL $TwdLang]
  set TwdText ""
  set indent ""
    
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set TwdText "No Bible text found for today."
    return 
    
  } else {
  
    if {$enabletitle} {
      set twdTitle [getTwdTitle $twdTodayNode $TwdLang]
      append TwdText $twdTitle\n
      set indent $ind
    }
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set TwdText [appendParolToText $parolNode $TwdText $indent $TwdLang $RtL]
    
    append TwdText \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set TwdText [appendParolToText $parolNode $TwdText $indent $TwdLang $RtL]
  }
  
  $twdDomDoc delete
  
  return $TwdText

} ;#END getTodaysTwdText

# getTodaysTwdSig
##formats Twd text for signature
##args=='html' for Evolution
##called by Signature & SigTools (Trojita+Evolution) & Setup!
proc getTodaysTwdSig {TwdFileName {setup 0}} {
  global ind tab
  
  if $setup {
    .sigL1 conf -justify left
    .sigL2 conf -justify left
  }
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set TwdText "No Bible text found for today."

  } else {
    set twdTitle [getTwdTitle $twdTodayNode]
    set TwdText "===== $twdTitle ===== \n"
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    
    set TwdText [appendParolToText $parolNode $TwdText $ind]
    
    append TwdText \n
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    
    set TwdText [appendParolToText $parolNode $TwdText $ind]
  
    if {$setup && [isBidi $TwdText]} {
      source $BdfBidi
      set TwdText [bidi::fixBidi $TwdText]
      .sigL2 conf -justify right
    }
  }
  
  $twdDomDoc delete
  append tab "                      "
  set bible2Url "$tab \[bible2.net\]"
  append TwdText \n $bible2Url
  
  return $TwdText
}

proc getTodaysTwdTerm {TwdFileName} {
  global ind
  
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set twdTerm "echo -e \$\{error\}\"No Bible text found for today.\""
  } else {
    set twdTitle [getTwdTitle $twdTodayNode]
    set twdTerm "echo -e \$\{titbg\}\$\{tit\}\"* $twdTitle *\"\n
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set twdTerm [appendParolToTermText $parolNode $twdTerm $ind]
    
    append twdTerm \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set twdTerm [appendParolToTermText $parolNode $twdTerm $ind]
  }
  
  $twdDomDoc delete
  
  return $twdTerm
}

# getTwdHex
##convert The Word to Hex format
##called by trojitaSig for non-Ascii characters
proc getTwdHex {dw} {
  foreach letter [split $dw ""] {
    #append dwhex \\x[binary encode hex $letter]
    set uniCode [scan $letter %c]
    set hexCode [format %x $uniCode]
    append dwhex \\x${hexCode}
  }

  return $dwhex
}
