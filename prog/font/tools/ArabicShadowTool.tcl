proc fixArabicShadows {FontFilePath} {
  set FontFileChan [open $FontFilePath]
  set fontFileText [read $FontFileChan]
  close $FontFileChan

  set flag "# Arabic shadows removed
"

  if {[string first $flag $fontFileText] != -1} {
    return
  }

  set initial {
    0xFE91 0xFEF3 0xFE8B 0xFE97 0xFEDF 0xFEDB 0xFEE3 0xFEE7 0xFE9B 0xFE9F 0xFEA3
    0xFEA7 0xFEB3 0xFEB7 0xFEBB 0xFEBF 0xFEC3 0xFEC7 0xFECB 0xFECF 0xFED3 0xFED7
    0xFEEB 0xfb58 0xfb7c 0xfb94 0xfb68 0xFBA8
  }

  set middle {
    0xFE92 0xFEF4 0xFE8C 0xFE98 0xFEE0 0xFEDC 0xFEE4 0xFEE8 0xFE9C 0xFEA0 0xFEA4
    0xFEA8 0xFEB4 0xFEB8 0xFEBC 0xFEC0 0xFEC4 0xFEC8 0xFECC 0xFED0 0xFED4 0xFED8
    0xFEEC 0xfb59 0xfb7d 0xfb95 0xfb69 0xFBA9
  }

  set final {
    0xFE90 0xFEF2 0xFE8A 0xFE96 0xFEDE 0xFEDA 0xFEE2 0xFEE6 0xFE9A 0xFE9E 0xFEA2
    0xFEA6 0xFEB2 0xFEB6 0xFEBA 0xFEBE 0xFEC2 0xFEC6 0xFECA 0xFECE 0xFED2 0xFED6
    0xFEEA 0xfb57 0xfb7b 0xfb93 0xfb67 0xFBA7 0xfb8b 0xfb89 0xfb8d 0xFEF0 0xFBAF
    0xFBB1 0xfb9f 0xFE8E 0xFE82 0xFE84 0xFE88 0xFEEE 0xFE86 0xFEAA 0xFEAC 0xFEAE
    0xFEB0 0xFEFC 0xFEFA 0xFEF8 0xFEF6 0xFE94
  }

  set indexFlag [expr [string first "# FONTBOUNDINGBOX INFO" $fontFileText] - 1]

  set preFlag [string range $fontFileText 0 [expr $indexFlag - 1]]
  set postFlag [string range $fontFileText $indexFlag end]
  set fontFileText [string cat $preFlag $flag $postFlag]

  set fontFileText [removeShadowFromLetters $initial 0 $fontFileText]
  set fontFileText [removeShadowFromLetters $middle 1 $fontFileText]
  set fontFileText [removeShadowFromLetters $final 2 $fontFileText]

  set FontFileChan [open [file rootname $FontFilePath].tcl w]
  puts $FontFileChan $fontFileText
  close $FontFileChan
}

proc removeShadowFromLetters {letters type fontFileText} {
  foreach letter $letters {
    set enc [expr $letter]

    set indexBegChar [string first "array set print_$enc" $fontFileText]
    set indexEndChar [expr [string first "\}\n\}" $fontFileText $indexBegChar] + 3]

    set charText [string range $fontFileText $indexBegChar $indexEndChar]

    if {$charText == ""} {
      continue
    }

    set fixedCharText [fixLetter $charText $enc $type]

    set fontFileText [string replace $fontFileText $indexBegChar $indexEndChar $fixedCharText]
  }

  return $fontFileText
}

proc fixLetter {charText enc type} {
  regexp -line {^  BBx .*$} $charText BBxList
  set BBxValue [lindex $BBxList 1]

  regexp -line {^  BBy .*$} $charText BByList
  set BByValue [lindex $BByList 1]

  regexp -line {^  BBxoff .*$} $charText BBxOffList
  set BBxOffValue [lindex $BBxOffList 1]

  regexp -line {^  BByoff .*$} $charText BByOffList
  set BByOffValue [lindex $BByOffList 1]

  regexp -line {^  DWx .*$} $charText DWxList
  set DWxValue [lindex $DWxList 1]

  regexp -line {^  DWy .*$} $charText DWyList
  set DWyValue [lindex $DWyList 1]

  regexp -line {^  BITMAP \{ .* \}$} $charText BitmapList
  set BitmapValue [lindex $BitmapList 1]
  set BitmapLines [split [string trim $BitmapValue]]

  if {$type == 0 || $type == 1} {
    set BBxValue [expr $BBxValue - 1]
    set DWxValue [expr $DWxValue - 1]

    set BitmapLines [lmap line $BitmapLines {
      string range $line 1 end
    }]
  }

  if {$type == 1 || $type == 2} {
    set BBxValue [expr $BBxValue - 1]
    set DWxValue [expr $DWxValue - 1]

    set BitmapLines [lmap line $BitmapLines {
      string range $line 0 end-1
    }]
  }

  set BitmapValue ""
  foreach line $BitmapLines {
    lappend BitmapValue $line
  }

  set charText "array set print_$enc \{
  BBx $BBxValue
  BBy $BByValue
  BBxoff $BBxOffValue
  BByoff $BByOffValue
  DWx $DWxValue
  DWy $DWyValue
  BITMAP \{ $BitmapValue \}
\}
"

  return $charText
}