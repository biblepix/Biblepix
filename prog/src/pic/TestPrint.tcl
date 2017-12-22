package require Img

proc printLetterToImage {letterName img x y} {
  global sun shade color mark
  
  upvar $letterName curLetter
  
  set xLetter [expr $x + $curLetter(BBxoff)]
  set yLetter [expr $y - $curLetter(BByoff) - $curLetter(BBy)]

  set yCur $yLetter
  set pixelLines $curLetter(BITMAP)
  foreach pxLine $pixelLines {
    set xCur $xLetter
    for {set i 0} {$i < $curLetter(BBx)} {incr i} {
      set pxValue [string index $pxLine $i]
      
      if {$pxValue != 0} {
        switch $pxValue {
          1 { set pxColor $color }
          2 { set pxColor $sun }
          3 { set pxColor $shade }
          default { set pxColor $mark }
        }
        
        $img put $pxColor -to $xCur $yCur
      }
      incr xCur
    }
    incr yCur
  }
}

proc writeTextLine {textLine x y img} {
  global mark print_32
  
  upvar 2 FontAsc fontAsc
  upvar 2 FBBy FBBy

  set xBase $x
  set yBase [expr $y + $fontAsc]
  
  set textLine [encoding convertfrom utf-8 $textLine]

  set letterList [split $textLine {}]

  foreach letter $letterList {
    set encLetter [scan $letter %c]
    
    upvar 2 "print_$encLetter" "print_$encLetter"
    
    if {[info exists "print_$encLetter"]} {
      array set curLetter [array get "print_$encLetter"]
    } else {
      array set curLetter [array get "print_32"]
    }

    printLetterToImage curLetter $img $xBase $yBase

    set xBase [expr $xBase + $curLetter(DWx)]
  }

  $img put $mark -to $x $y
  $img put $mark -to $xBase $yBase
  
  return [expr $y + $FBBy]
}

proc writeText {text x y img} {
  set textLines [split $text \n]
  
  foreach line $textLines {
    set y [writeTextLine $line $x $y $img]
  }
  
  return $y
}

set color #2e8b57
set shade #1b5334
set sun #5cffae
set mark #ff0000

set finalImg [image create photo -width 500]

set x 10
set y 10

set text "test Text
mit newLine und laaaaangem text.
titel: \"RANDOM123!!\"
läuft bei dir?"

source "E:/Projekte/BiblePix/prog/fonts/24.iso8859.tcl"
set y [writeText $text $x $y $finalImg]

source "E:/Projekte/BiblePix/prog/fonts/etl24-latin2.tcl"
set y [writeText $text $x $y $finalImg]

source "E:/Projekte/BiblePix/prog/fonts/heb24-etl.tcl"
set y [writeText $text $x $y $finalImg]

$finalImg write E:/Projekte/BiblePix/prog/src/pic/test.tiff -format TIFF

image delete $finalImg

exit