# computeAvColours
##fetches R G B from a section & computes avarages into ::rgb namespace
##called by BdfPrint - TODO: still testing!!! - not needed now, included in scanColourArea!
proc computeAvColours {img} {
  global marginleft margintop RtL
  #no. of pixels to be skipped
  set skip 5

  package require math

  set imgX [image width $img]
  set imgY [image height $img]
  set x1 $marginleft
  set y1 $margintop
  set x2 [expr $imgX / 3]
  set y2 [expr $imgY / 3]

  if $RtL {
    set x2 [expr $imgX - $marginleft]
    set x1 [expr $x2 - ($imgX / 3)]
  }    

puts "Computing pixels..."

    for {set x $x1} {$x<$x2} {incr x $skip} {

      for {set y $y1} {$y<$y2} {incr y $skip} {
        
        lassign [$img get $x $y] r g b
        lappend R $r
        lappend G $g
        lappend B $b
      }
    }
puts "Done computing pixels"
#zisisnt workin, donno why...
return

  #Compute avarage colours
  set avR [calcAverage $R]
  set avG [calcAverage $G]
  set avB [calcAverage $B]
  set avBri [calcAverage [list $avR $avG $avB]]
#puts "avR $avR"
#puts "avG $avG"
#puts "avB $avB"

  #Export vars to ::rgb namespace
  catch {namespace delete rgb}
  namespace eval rgb {}
  set rgb::avRed $avR
  set rgb::avGreen $avG
  set rgb::avBlue $avB
  set rgb::avBrightness $avBri

  #Compute strong colour
  namespace path {::tcl::mathfunc}
  set rgb::maxCol [max $avR $avG $avB]
  set rgb::minCol [min $avR $avG $avB]

#puts "strongCol $rgb::maxCol"

  #Delete colour lists
  catch {unset R G B}

} ;#END computeAvColours



# changeFontColour - TODO just testing
#TODO: to be implemented in above! - MAY NOT BE NECESSARY!!!
#Theory: 
##wenn HG überwiegend dunkelblau, fontcolor-> silver
##wenn HG überwiegend dunkelgrün, fontcolor-> gold

#TODO don't change colour, but only shades of colour (brighter/darker)
proc changeFontColour {} {
  if {$rgb::avBrightness <= 100 &&
  [expr $rgb::maxCol - $rgb::minCol] > 70} {
  #puts "Not resetting colour."
    return 0
  }

  if {$rgb::maxCol == $rgb::avBlue} {
    set newFontcolortext silver
  } elseif {$rgb::maxCol == $rgb::avGreen} {
    set newFontcolortext gold
  }

  set rgb::fontcolortext $newFontcolortext
  puts "Changed font colour to $fontcolortext"
  return 1
}


#TODO OBSOLETE, the code is already in nthe row pixel arrays!
# setLumCode - returns 1(dark) / 2(normal) / 3(light)
##calculates average luminance of a pixel colour array
##TODO Normalwert zwischen 70 und 100 -wo festlegen?
##called by scanColourArea after each run of x loop
proc setLuminanceCode {pixArr} {
  upvar $pixArr myArr
  set avCol [expr ($myArr(r) + $myArr(g) + $myArr(b)) / 3]
  
  set lumCode "2"
  if {$avCol < 70}  {set lumCode "1"}
  if {$avCol > 100} {set lumCode "3"}
  
  return $lumCode
}

### OBSOLETE! ##############
proc setShadeHex {rgb} {
#called by ??? - now in Setup, var saved to Config!!! ????
  global shadefactor
  foreach c [split $rgb] {
    lappend shadergb [expr {int($shadefactor*$c)}]
  }
  #darkness values under 0 don't matter   
  set shade [rgb2hex $shadergb]
  return $shade
}
############# Obsolete! ###################
#called by Hgbild
proc setSunHex {rgb} {
  global sunfactor
  foreach c [split $rgb] {
    lappend sunrgbList [expr {int($sunfactor*$c)}]
  }
  #avoid brightness values over 255
  foreach i $sunrgbList {
    if {$i>255} {set i 255}
    lappend sunrgb $i
  }
  set sun [rgb2hex $sunrgb]
  return $sun
}

