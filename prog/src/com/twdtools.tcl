# ~/Biblepix/prog/src/com/twdtools.tcl
# Tools to extract & format "The Word" / various listers & randomizers
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 26Sep17

#tDom is standard in ActiveTcl, Linux distros vary
if {[catch {package require tdom}]} {
  package require Tk
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $packageRequireTDom
   exit
}

#Listen ohne Pfad
proc getTWDlist {} {
  global twdDir jahr
  set twdlist [glob -nocomplain -tails -directory $twdDir *_$jahr.twd]
  return $twdlist
}

proc getBMPlist {} {
  global bmpdir
  set bmplist [glob -nocomplain -tails -directory $bmpdir *.bmp]
  return $bmplist
}

#Randomizers
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
  global platform jpegDir
  
  if {$platform=="unix"} {
    set imglist [glob -nocomplain -directory $jpegDir *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
  } elseif {$platform=="windows"} {
    set imglist [glob -nocomplain -directory $jpegDir *.jpg *.jpeg *.png]
  }
  
  return [ lindex $imglist [expr {int(rand()*[llength $imglist])}] ] 
}

proc getTWDFileRoot {twdFile} {
global twdDir
  set path [file join $twdDir $twdFile]
  set file [open $path]
  chan configure $file -encoding utf-8
  set TWD [read $file]
  close $file
  set doc [dom parse $TWD]
  return [$doc documentElement]
}

proc parseTwdFileDomDoc {twdFile} {
global twdDir
  set path [file join $twdDir $twdFile]
  set file [open $path]
  chan configure $file -encoding utf-8
  set Twd [read $file]
  close $file
  return [dom parse $Twd]
}

proc getDomNodeForToday {domDoc} {
  global datum
  set rootDomNode [$domDoc documentElement]
  return [$rootDomNode selectNodes /thewordfile/theword\[@date='$datum'\]]
}

proc parseToText {node twdLanguage {withTags 0}} {
  global Bidi os
  
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
  
  #Fix Hebrew
  if {$twdLanguage == "he"} {
    puts "Computing Hebrew text..."
    if {[info procs fixHebWin] == ""} {
      source $Bidi
    }

    if {$os == "Windows NT"} {
      set text [fixHebWin $text]
    } else {
      set text [fixHebUnix $text]
    }
  }

  #Fix Arabic
  if {$twdLanguage == "ar" || $twdLanguage == "ur" || $twdLanguage == "fa"} {
    puts "Computing Arabic text..."
    if {[info procs fixArabWin] == ""} {
      source $Bidi
    }
    
    if {$os == "Windows NT"} {
      set text [fixArabWin $text]
    } else {
      set text [fixArabUnix $text]
    }
  }
  
  return $text
}

proc appendParolToText {parolNode twdText twdLanguage indent {RtL 0}} {
  global tab
  
  set intro [getParolIntro $parolNode $twdLanguage]
  if {$intro != ""} {
    if {$RtL} {
      append twdText $intro $indent\n
    } else {
      append twdText $indent $intro\n
    }
  }
  
  set text [getParolText $parolNode $twdLanguage]
  set textLines [split $text \n]
   
  foreach line $textLines {
    if {$RtL} {
      append twdText $line $indent\n
    } else {
      append twdText $indent $line\n
    }
  }
  
  set ref [getParolRef $parolNode $twdLanguage]
  if {$RtL} {
    append twdText $ref $tab
  } else {
    append twdText $tab $ref
  }
  
  return $twdText
}

proc appendParolToTermText {parolNode twdText indent} {
  global tab
  
  set intro [getParolIntro $parolNode]
  if {$intro != ""} {
    append twdText "echo -e \$\{txtrst\}\$\{int\}\"$indent$intro\"\n"
  }
  
  set text [getParolText $parolNode]
  set textLines [split $text \n]
   
  foreach line $textLines {
    append twdText "echo -e \$\{txt\}\"$indent$line\"\n"
  }
  
  set ref [getParolRef $parolNode]
  append twdText "echo -e \$\{ref\}\$\{tab\}\"$ref\""
  
  return $twdText
}

## O U T P U T

proc getTwdLanguage {twdFileName} {
  return [string range $twdFileName 0 1]
}

proc isRtL {twdLanguage} {
  if {$twdLanguage == "he" || $twdLanguage == "ar" || $twdLanguage == "ur" || $twdLanguage == "fa"} {
    return 1
  } else {
    return 0
  }
}

proc getTwdTitle {twdNode twdLanguage {withTags 0}} {
  return [parseToText [$twdNode selectNodes title] $twdLanguage $withTags]
}

proc getTwdParolNode {no twdNode} {
  return [$twdNode selectNodes parol\[$no\]]
}

proc getParolIntro {parolNode {twdLanguage "de"} {withTags 0}} {
  return [parseToText [$parolNode selectNodes intro] $twdLanguage $withTags]
}

proc getParolText {parolNode {twdLanguage "de"} {withTags 0}} {
  return [parseToText [$parolNode selectNodes text] $twdLanguage $withTags]
}

proc getParolRef {parolNode {twdLanguage "de"} {withTags 0}} {
  return [string cat "~ " [parseToText [$parolNode selectNodes ref] $twdLanguage $withTags]]
}

proc getTodaysTwdText {twdFileName} {
  global enabletitle ind
  
  set twdLanguage [getTwdLanguage $twdFileName]
  set indent ""
  set RtL [isRtL $twdLanguage]
  set twdText ""
  
  set twdDomDoc [parseTwdFileDomDoc $twdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set twdText "No Bible text found for today."
  } else {
    if {$enabletitle} {
      set twdTitle [getTwdTitle $twdTodayNode $twdLanguage]
      append twdText $twdTitle\n
      set indent $ind
    }
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set twdText [appendParolToText $parolNode $twdText $twdLanguage $indent $RtL]
    
    append twdText \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set twdText [appendParolToText $parolNode $twdText $twdLanguage $indent $RtL]
  }
  
  $twdDomDoc delete
  
  return $twdText
}

proc getTodaysTwdSig {twdFileName} {
  global ind
  
  set twdLanguage [getTwdLanguage $twdFileName]
  
  set twdDomDoc [parseTwdFileDomDoc $twdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set twdText "No Bible text found for today."
  } else {
    set twdTitle [getTwdTitle $twdTodayNode $twdLanguage]
    set twdText "===== $twdTitle =====\n"
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set twdText [appendParolToText $parolNode $twdText $twdLanguage $ind]
    
    append twdText \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set twdText [appendParolToText $parolNode $twdText $twdLanguage $ind]
  }
  
  $twdDomDoc delete
  
  return $twdText
}

proc getTodaysTwdTerm {twdFileName} {
  global ind
  
  set twdLanguage [getTwdLanguage $twdFileName]
  
  set twdDomDoc [parseTwdFileDomDoc $twdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  if {$twdTodayNode == ""} {
    set twdTerm "echo -e \$\{error\}\"No Bible text found for today.\""
  } else {
    set twdTitle [getTwdTitle $twdTodayNode $twdLanguage]
    set twdTerm "echo -e \$\{titbg\}\$\{tit\}\"* $twdTitle *\"\n"
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    set twdTerm [appendParolToTermText $parolNode $twdTerm $twdLanguage $ind]
    
    append twdTerm \n
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    set twdTerm [appendParolToTermText $parolNode $twdTerm $twdLanguage $ind]
  }
  
  $twdDomDoc delete
  
  return $twdText
}