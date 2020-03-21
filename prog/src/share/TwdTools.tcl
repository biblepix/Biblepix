# ~/Biblepix/prog/src/share/TwdTools.tcl
# Tools to extract & format "The Word" / various listers & randomizers
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15may19

#tDom is standard in ActiveTcl, Linux distros vary
if [catch {package require tdom}] {
  package require Tk
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $packageRequireTDom
  exit
}


# G E N E R A L   T O O L S  ###########################################

#L i s t e n   o h n e   P f a d
proc getTWDlist {} {
  global dirlist jahr
  set twdlist [glob -nocomplain -tails -directory $dirlist(twdDir) *_$jahr.twd]
  return $twdlist
}

#R a n d o m i z e r s
proc getRandomTwdFile {} {
  #Ausgabe ohne Pfad
  set twdlist [getTWDlist]
  set randIndex [expr {int(rand()*[llength $twdlist])}]
  return [lindex $twdlist $randIndex]
}

proc getRandomBMP {} {
  #Ausgabe ohne Pfad
  set bmplist [getBMPlist]
  set randIndex [expr {int(rand()*[llength $bmplist])}]
  return [lindex $bmplist $randIndex]
}

proc getRandomPhoto {} {
  #Ausgabe JPG/PNG mit Pfad
  global platform dirlist
  
  if {$platform=="unix"} {
    set imglist [glob -nocomplain -directory $dirlist(photosDir) *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
  } elseif {$platform=="windows"} {
    set imglist [glob -nocomplain -directory $dirlist(photosDir) *.jpg *.jpeg *.png]
  }
  
  return [ lindex $imglist [expr {int(rand()*[llength $imglist])}] ] 
}

proc updateTwd {} {
  
}


### T W D   P A R S I N G   T O O L S   ###############################
  
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
#  global datum - can change any time!!!
  set datum [clock format [clock seconds] -format %Y-%m-%d]
  set rootDomNode [$domDoc documentElement]
  return [$rootDomNode selectNodes /thewordfile/theword\[@date='$datum'\]]
}

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

  if {$RtL} {
    if {[info procs bidi] == ""} {
      source $BdfBidi
    }

    if {$os == "Windows NT"} {
      set text [bidi $text $TwdLang]
    } else {
      set text [bidi $text $TwdLang revert]
    }
  }
  return $text
}



proc appendParolToText {parolNode TwdText indent {TwdLang "de"} {RtL 0}} {
  global tab
  
  set intro [getParolIntro $parolNode $TwdLang]
  if {$intro != ""} {
    if {$RtL} {
      append TwdText $intro $indent\n
    } else {
      append TwdText $indent $intro\n
    }
  }
  
  set text [getParolText $parolNode $TwdLang]
  set textLines [split $text \n]
   
  foreach line $textLines {
    if {$RtL} {
      append TwdText $line $indent\n
    } else {
      append TwdText $indent $line\n
    }
  }
  
  set ref [getParolRef $parolNode $TwdLang]
  if {$RtL} {
    append TwdText $ref $tab
  } else {
    append TwdText $tab $ref
  }
  
  return $TwdText
}

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
  set indent ""
  set RtL [isRtL $TwdLang]
  set TwdText ""
  
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

} ;#END getTwdText

proc getTodaysTwdSig {TwdFileName} {
  global ind
  
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set TwdText "No Bible text found for today."
  } else {
    set twdTitle [getTwdTitle $twdTodayNode]
    set TwdText "===== $twdTitle =====\n"
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set TwdText [appendParolToText $parolNode $TwdText $ind]
    
    append TwdText \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set TwdText [appendParolToText $parolNode $TwdText $ind]
  }
  
  $twdDomDoc delete
  set bible2Url {                                               [bible2.net]}
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
    set twdTerm "echo -e \$\{titbg\}\$\{tit\}\"* $twdTitle *\"\n"
    
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
