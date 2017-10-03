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
proc getRandomTWDFile {} {
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

## O U T P U T

proc formatImgText {twdFile} {
##Returns $dw for Img & Textfenster
global tab datum ind enableintro

  set root [getTWDFileRoot $twdFile]
  
#Set Datumszeile & return error if empty
  set titelnode [$root selectNodes /thewordfile/theword\[@date='$datum'\]//title/text()]
  if {$titelnode==""} {
    return "No Bible text found for today."
  }

  if {$enableintro} {
    set dw "* [$titelnode data] *\n"
  } else {
    set ind ""
  }
  
#Spruch 1
  set parol [$root selectNodes /thewordfile/theword\[@date='$datum'\]//parol\[1\]]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dw $ind $intro\n
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dw $ind $line\n
  }    
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dw $tab "~ $ref\n" 
  
#Spruch 2
  set parol [$parol nextSibling]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dw $ind $intro\n 
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dw $ind $line\n 
  }    
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dw $tab "~ $ref"

  return $dw
}

## formatSigText
#  Formatiert den TWD-Text for die Signaturdateien.
#  Returns $dwsig for signature
proc formatSigText {twdFile} {
  global datum tab ind
  
  set root [getTWDFileRoot $twdFile]
  
  #Datumszeile obligatorisch, return error if empty
  set titelnode [$root selectNodes /thewordfile/theword\[@date='$datum'\]//title/text()]
  if {$titelnode==""} {
    return "No Bible text found for today."
  }

  set dwsig "===== [$titelnode data] ====="
  
#Spruch 1
  set parol [$root selectNodes /thewordfile/theword\[@date='$datum'\]//parol\[1\]]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dwsig \n "   $intro"
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dwsig \n "   $line"
  }
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dwsig \n "\t\t\t\~ $ref"
  
#Spruch 2
  set parol [$parol nextSibling]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dwsig \n "   $intro"
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dwsig \n "   $line"
  }
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dwsig \n "\t\t\t\~ $ref"
  
  return $dwsig
}

proc formatTermText {twdFile} {
#ONLY FOR UNIX!!!
##Returns $dwterm, to be processed by term.sh

  global datum tab ind
   #     source $Globals
  
  set root [getTWDFileRoot $twdFile]

  #Datumszeile obligatorisch, return error if empty
  set titelnode [$root selectNodes /thewordfile/theword\[@date='$datum'\]//title/text()]
  if {$titelnode==""} {
    return "No Bible text found for today."
  }
  set dwterm "echo -e \$\{titbg\}\$\{tit\}\"* [$titelnode data] *\""
    
#Spruch 1
  set parol [$root selectNodes /thewordfile/theword\[@date='$datum'\]//parol\[1\]]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dwterm \n "echo -e \$\{txtrst\}\$\{int\}\" $intro\""
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dwterm \n "echo -e \$\{txt\}\" $line\""
  }
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dwterm \n "echo -e \$\{ref\}\$\{tab\}\"$ref\""
  
#Spruch 2
  set parol [$parol nextSibling]
  #intro
  set intronode [$parol firstChild]
  set intro ""
  if { [$intronode nodeName] == "intro" } {
    set intro [$intronode text]
    set textnode [$intronode nextSibling]
  } else {
    set textnode [$parol firstChild]
  }
  if {$intro != ""} {
    append dwterm \n "echo -e \$\{txtrst\}\$\{int\}\" $intro\""
  }
  #Bibeltext
  foreach line [split [$textnode text] \n] {  
    append dwterm \n "echo -e \$\{txt\}\" $line\""
  }
  #Bibelstelle
  set refnode [$textnode nextSibling]
  set ref [$refnode text]
  regsub {\(.*\)} $ref {} ref
  append dwterm \n "echo -e \$\{ref\}\$\{tab\}\"$ref\""

  return $dwterm
}

proc setTWDWelcome {dwWidget} {
global srcdir platform lang enableintro Twdtools Bidi noTWDFilesFound
  
  # get TWD
  set twdfile [getRandomTWDFile]

  # check TWD
  if {$twdfile==""} {
    $dwWidget conf -fg black -bg red -activeforeground black -activebackground orange
    set dw $noTWDFilesFound
  
  } else {    
  # get TWD
    source $Twdtools
    set dw [formatImgText $twdfile]
    $dwWidget conf -justify left

    #Check for Hebrew text 
    if { [regexp {[\u05d0-\u05ea]} $dw] } {
      set justify right
      source $Bidi
      #Unix
      if {$platform=="unix"} {
        set dw [fixHebUnix $dw]
      
      #Win
      } elseif {$platform=="windows"} {
        set ind ""
        set dw [fixHebWin $dw]
      }
      $dwWidget conf -justify right
     
         
     #Check for Arabic text
    } elseif { [regexp {[\u0600-\u076c]} $dw] } {
      set justify right
      source $Bidi
      #Unix
      if {$platform=="unix"} {
        set dw [fixArabUnix $dw]
      } elseif {$platform=="windows"} {
      #Win
        set ind ""
        set dw [fixArabWin $dw]
      }
      $dwWidget conf -justify right
    }
  }
  return $dw
        
} ;#end setTWD
