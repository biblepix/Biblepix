proc getRandomTWDFileName {} {
  set twdlist [getTWDlist]
  set randIndex [expr {int(rand()*[llength $twdlist])}]
  return [lindex $twdlist $randIndex]
}

#JOEL: DIESE EINE GLOBALE VAR BRAUCHEN WIR!
proc getTodaysXML {twdFile} {
  global twdDir datum
  
  #Parse TWD file root
  set path [file join $twdDir $twdFile]
  set file [open $path]
  chan configure $file -encoding utf-8
  set TWD [read $file]
  close $file
  set doc [dom parse $TWD]
  set root [$doc documentElement]
  
  #Set TheWordNode global variable
  set ::TheWordNode [$root selectNodes /thewordfile/theword\[@date='$datum'\]]
}

proc parseTodaysTitle {} {
  global TheWordNode
  return [$TheWordNode selectNodes title]
}

#Today's intro(s) may be empty
proc parseTodaysIntro no {
  global TheWordNode
  return [$TheWordNode selectNodes parol\[$no\]/intro]
}

#Number must be 1 or 2
#JOEL: ZUM TESTEN MACH: 
# set twdFile de_Schlachter2000_2017.twd
# set datum 2017-01-10

proc parseTodaysText no {
  global TheWordNode
  set textNode [$TheWordNode selectNodes parol\[$no\]/text]
  
  #Search for <em> tags in text & mark text with _..._
  set emNodes [$textNode selectNodes em/text() ]
  if {$emNodes != ""} {
    foreach i $emNodes {
      set nodeText [$i nodeValue]
      $i nodeValue [join "_ $nodeText _" {}]
    }
  }
  
  #Give out entire text
  #must be called with '$textNode asText' to include <em>'s
  return $textNode
}

proc parseTodaysRef no {
  global TheWordNode
  return [$TheWordNode selectNodes parol\[$no\]/ref]
}

