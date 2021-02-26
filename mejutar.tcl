##MEJUTAR.OBSOLETE!!!!!!!!!!!!!!!
# getAvAreaColour
##computes average colour+luminance of a given canvas pic area
##called by SetupRepos UNTIL AUTOMATED IN SCANCOLOURAREA!
proc getAvAreaColour {img} {

  #no. of pixels to be skipped
  set skip 5

#TODO get X and Y from canvas movingText!

  package require math

  set imgX [image width $img]
  set imgY [image height $img]
  set x1 $marginleft
  set y1 $margintop
  set x2 [expr $imgX / 3]
  set y2 [expr $imgY / 3]

#  if $RtL {
#    set x2 [expr $imgX - $marginleft]
#    set x1 [expr $x2 - ($imgX / 3)]
#  }    

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

#  if $RtL {
#    set x2 [expr $imgX - $marginleft]
#    set x1 [expr $x2 - ($imgX / 3)]
#  }    

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


# setShade
##reduces colour array's r/g/b by $shadefactor, avoiding values below 0
##with args = return as hex
##called by BdfPrint
proc setShade {arrname args} {
  global shadefactor
  upvar $arrname myarr
  set hex [rgb2hex myarr]
  set shaHex [gradient $hex $shadefactor]
puts "computing shaHex..."
return $shaHex



#  set shadeR [expr max(int($shadefactor*$myarr(r)),0)]
#  set shadeG [expr max(int($shadefactor*$myarr(g)),0)]
#  set shadeB [expr max(int($shadefactor*$myarr(b)),0)]

  #A) without args return as r g b
  if {$args == ""} {
    return "$shadeR $shadeG $shadeB"
  #B) with args return as hex
  } else {
    array set myarr "r $shadeR g $shadeG b $shadeB"
    return [rgb2hex myarr]
  }
}
# setSun
##increases colour array's r/g/b by $sunfactor, avoiding values over 255
##with args = return as hex
##called by BdfPrint
proc setSun {arrname args} {
  global sunfactor
  upvar $arrname myarr
  set hex [rgb2hex myarr]
  set sunHex [gradient $hex $sunfactor]
puts "Computing sunHex..."
return $sunHex

#  set sunR [expr min(int($sunfactor*$myarr(r)),255)]
#  set sunG [expr min(int($sunfactor*$myarr(g)),255)]
#  set sunB [expr min(int($sunfactor*$myarr(b)),255)]
  
  #A) without args return as r g b
  if {$args == ""} {
    return "$sunR $sunG $sunB"
  #B) with args return as hex
  } else {
    array set myarr "r $sunR g $sunG b $sunB"
    return [rgb2hex myarr]
  }
}
 setBdfFontcolour - TODO OBSOLETE!!!!!!!!!!!!!!
#uses above procs, exporting hex values to ::colour NS
#called by BdfPrint
proc setBdfFontcolours {fontcolortext} {
  ##get font array from fontcolortext
  append fontArrname $fontcolortext Arr
  global $fontArrname
  global colour::pnginfo
  array set regArr [array get $fontArrname]
  
  ##export vars to ::colour
  namespace eval colour {
    variable regHex
    variable sunHex
    variable shaHex
    variable pnginfo
  }

  #Set normal hex values (lum=2)
  set regHex [rgb2hex regArr]
  set sunHex [setSun regArr ashex]
  set shaHex [setShade regArr ashex]
puts adhena1

  #Reset if PNG luminance info differs from 2
  if [info exists pnginfo(Luminacy)] {

    ##1) shade bg: increase font colour luminance
    if {$pnginfo(Luminacy) == 1} {
      set regHex $sunHex
      set shaHex $regHex
      
      lassign [setSun regArr] sunR sunG sunB
      array set sunArr "r $sunR g $sunG b $sunB"
      set sunHex [setSun sunArr ashex]
      
    ##2) sun bg: reduce font colour luminance
    } elseif {$pnginfo(Luminacy) == 3} {
    
      set regHex $shaHex
      set sunHex $regHex
      
      lassign [setShade regArr] shaR shaG shaB
      array set shaArr "r $shaR g $shaG b $shaB"
      set shaHex [setShade shaArr ashex]
    }
  }
  #Export to ::colour NS
  set colour::regHex $regHex
  set colour::sunHex $sunHex
  set colour::shaHex $shaHex
puts adhena2
}

# cropPic2Text - OBSOLETE!
##cuts image to text width
##works on basis of pixel lsits [pic get x y]
##called by printTwd for RtL pictures
proc cropPic2textwidth {img} {

#  lassign [hex2rgb $fontcol] r g b
  set imgW [image width $img]
  set imgH [image height $img]
puts $imgH
puts $imgW
  
  for {set y 0} {$y < [expr $imgH/10]} {incr y} {
   
    for {set x 0} {$x < [expr $imgW/2]} {incr x} {

puts "$y $x"

      set c [$img get $x $y]
puts "Colour: $c"
      
      if {$c != "0 0 0"} {
        lappend leftmargL $x
        break
      }
    }
  }
  
  
  puts "LeftmargL $leftmargL"
  
  if [info exists leftmargL] {
    set maxL [join $leftmargL ,]
    set textW [expr min($maxL)
  }
  #crop pic
  if {$textW > $imgW} {
    set leftmargin [expr $imgW - $textW] 
    image create photo newpic
    newpic copy $img -from $leftmargin 0
  }
  
  return newpic
} ;#END cropImg

  # evalMarginErrors - OBSOLETE! now done by cropPic
  ##evaluates lists created by checkMarginErrors
  ##returns (un)changed x + y
  ##called by printTwd  
  proc evalMarginErrors {x} {
    puts "Evaluating margin errors..."

    set minmarg 15
    set screenY [winfo screenheight .]
    set screenX [winfo screenwidth .]
    
    #global TwdLang
    global RtL
    global [namespace current]::xErrL
    global [namespace current]::yErrL
    
#puts [info vars [namespace current]::*]

    set xL [join $xErrL ,]
    set xMax [expr max($xL)]
    set xMin [expr min($xL)]
    set xTot [expr $xMax - $xMin]
    
    set yL [join $yErrL ,]
    set yMax [expr max($yL)]
    set yMin [expr min($yL)]
    set yTot [expr $yMax - $yMin]
    
    # 1.  W I D T H   E R R O R S
    ##correct bottom margin err
 
 #TODO test conditions! - printTwdTextParts is in a hassle!
 
    ##right margin too far right
    if {$xMax > $screenX} {
      set x [expr $screenX - ($xMax - $screenX) - $minmarg]
   ##left margin too far left
    } elseif {$xMax < 10} {
       set x [expr $x + ($xMin * -1) + $minmarg] 
    }
    #Get RtL Bidi x pos right
    if {$RtL} {
      set x [expr $x + $xTot]
    }    

    # 2.  H E I G H T   E R R O R S 
    if {$yMax < $screenY} {
      set y [expr $y - $yTot - $minmarg]
    }
    
    #return original or new x + y
    return "$x $y"
    
  } ;#END evalMarginErrors
  
  
#THIS PrOC IS OBSOLETE!
  proc applyChangedLuminacy {marginleft margintop newLum} {
    global fontcolortext
            
    set textpicY [image height textbild]
    set textpicX [image width  textbild]
    set curLum $bdf::luminacy
    
      puts "Adapting font luminance..."
      lassign [setFontShades $fontcolortext] newReg newSun newSha
    
      ##get old shades
      set oldReg $colour::regHex
      set oldSun $colour::sunHex
      set oldSha $colour::shaHex      
      ##replace colours
      set dataL [textbild data]
      regsub -all $oldReg $dataL $newReg newData
      regsub -all $oldSun $dataL $newSun newData
      regsub -all $oldSha $dataL $newSha newData
  
#regsub -all {#000000} $dataL 0 newData  
  
  #TODO schwarzer hintergrund?!
      ##copy new data to croppic
image create photo temppic 
temppic put $newData
temppic write /tmp/temppic.gif -format GIF
textbild read /tmp/temppic.gif -format GIF
return

#     image create photo temppic -data [list $newData] -format PPM
    image create photo temppic
     temppic put $newData
     temppic conf -height $textpicY -width $textpicX
    temppic write /tmp/temppic.ppm
    return
    
#scan given canvas/image area - TODO manchmal ist sumTotal leer - liegts am Skip?
  for {set y 0} {$y < $textpicY} {incr y} {

    for {set x 0} {$x < $textpicX} {incr x} {
      lassign [temppic get $x $y] r g b

      if {!$r && !$g && !$b} {
        temppic transparency set $x $y 1 
      }
       
    }
  }
  
      textbild blank
#      textbild copy croppic -compositingrule overlay -shrink
 textbild copy temppic -shrink -compositingrule overlay
 
# textbild transparency set 0 0 1
# set data [textbild data]
# #TODO testing
#  set chan [open /tmp/data w]
#  puts $chan $data
#  close $chan
  
  } ;#END applyChangedLuminacy
  
