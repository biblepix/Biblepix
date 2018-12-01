proc removeArabicShadows {FontFilePath} {
  set FontFileChan [open $FontFilePath]
  set fontFileText [read $FontFileChan]
  close $FontFileChan
  
  set initials {
    {\uFE91} {\uFEF3} {\uFE8B} {\uFE97} {\uFEDF} {\uFEDB} {\uFEE3} {\uFEE7} {\uFE9B} {\uFE9F}
    {\uFEA3} {\uFEA7} {\uFEB3} {\uFEB7} {\uFEBB} {\uFEBF} {\uFEC3} {\uFEC7} {\uFECB} {\uFECF}
    {\uFED3} {\uFED7} {\uFEEB} {\ufb58} {\ufb7c} {\ufb94} {\ufb68} {\uFBA8}
  }
  
  set middle {
    {\uFE92} {\uFEF4} {\uFE8C} {\uFE98} {\uFEE0} {\uFEDC} {\uFEE4} {\uFEE8} {\uFE9C} {\uFEA0}
    {\uFEA4} {\uFEA8} {\uFEB4} {\uFEB8} {\uFEBC} {\uFEC0} {\uFEC4} {\uFEC8} {\uFECC} {\uFED0}
    {\uFED4} {\uFED8} {\uFEEC} {\ufb59} {\ufb7d} {\ufb95} {\ufb69} {\uFBA9}
  }
  
  set final {
    {\uFE90} {\uFEF2} {\uFE8A} {\uFE96} {\uFEDE} {\uFEDA} {\uFEE2} {\uFEE6} {\uFE9A} {\uFE9E}
    {\uFEA2} {\uFEA6} {\uFEB2} {\uFEB6} {\uFEBA} {\uFEBE} {\uFEC2} {\uFEC6} {\uFECA} {\uFECE}
    {\uFED2} {\uFED6} {\uFEEA} {\ufb57} {\ufb7b} {\ufb93} {\ufb67} {\uFBA7} {\ufb8b} {\ufb89}
    {\ufb8d} {\uFEF0} {\uFBAF} {\uFBB1} {\ufb9f} {\uFE8E} {\uFE82} {\uFE84} {\uFE88} {\uFEEE}
    {\uFE86} {\uFEAA} {\uFEAC} {\uFEAE} {\uFEB0} {\uFEFC} {\uFEFA} {\uFEF8} {\uFEF6} {\uFE94}
  }
  
  set FontFileChan [open [file rootname $FontFilePath]"arabic.tcl" w]
  puts $FontFileChan $fontFileText
  close $FontFileChan
}

proc fixLetter {fontFileText enc type} {
  set indexBegChar [string first "array set print_$enc" $fontFileText]
  set indexEndChar [expr indexBegChar + 8]
  
  set charText [string range $fontFileText $indexBegChar $indexEndChar]
  
  regexp -line {^BBx .*$} $charText BBxList
  set BBxValue [lindex $BBXList 1]
  
  regexp -line {^BBxoff .*$} $charText BBxOffList
  set BBxOffValue [lindex $BBxOffList 1]
  
  regexp -line {^DWx .*$} $charText DWxList
  set DWxValue [lindex $DWxList 1]
  
  regexp -line {^BITMAP .*$} $charText BitmapList
  set BitmapValue [lindex $BitmapList 1]
  
  if {type == 0 || type == 1} {
    set BBxValue [expr BBxValue - 1]
    set BBxOffValue [expr BBxOffValue - 1]
    set DWxValue [expr DWxValue - 1]
    
    set BitmapValue
  }
  
  return $fontFileText
}