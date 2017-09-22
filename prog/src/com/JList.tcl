# ~/Biblepix/prog/src/share/JList.tcl
# List helper, sourced by Imgtools
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 8nov2016

proc jappend {fileJList value} {
  append fileJList $value "> "
  return $fileJList
}

proc jlfirst {fileJList} {
  set endPos [expr [string first ">" $fileJList] - 1]
  
  return [string range $fileJList 0 $endPos]
}

proc jllast {fileJList} {
  set startPos [expr [string last ">" $fileJList end-1] - 1]
  
  return [string range $fileJList $startPos end-1]
}

proc jlindex {fileJList idx} {
  set pos 0
  set i 0
  while {$i < $idx} {
    set pos [string first ">" $fileJList 0]
    incr i
  }
  set endPos [expr [string first ">" $fileJList $pos] - 1]
  
  return [string range $fileJList $pos $endPos]
}

proc jlremovefirst {fileJList} {
  set endPos [string first ">" $fileJList]
  
  return [string range $fileJList [expr $endPos + 2] end]
}

proc jlstep {fileJList fwd} {  
  if {$fileJList != ""} {
    if {$fwd} {
      set stepPos [string first ">" $fileJList 0]
    } else {
      set stepPos [string last ">" $fileJList end-1]
    }
      
    return [concat [string range $fileJList [expr $stepPos + 1] end] [string range $fileJList 0 $stepPos]]
  } else {
    return $fileJList
  }
}
