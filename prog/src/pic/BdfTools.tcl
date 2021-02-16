# ~/Biblepix/prog/src/com/BdfTools.tcl
# BDF printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 16feb21 pv

namespace eval bdf {

  variable xBase
  variable YBase  
  variable x
  variable y
  
  # printTwd
  ##Toplevel printing proc
  ##called by BdfPrint
  proc printTwd {TwdFileName img marginleft margintop} {
    
    global RtL fontcolortext
    set minmarg 25

    #Create textpic
    image create photo textbild
    parseTwdTextParts $TwdFileName
    set textbild [printTwdTextParts $minmarg $minmarg textbild]
    
    #Correct right & top margins
    set screenW [winfo screenwidth .]
    set screenH [winfo screenheight .]
    set textpicW [image width textbild]
    set textpicH [image height textbild]
    set reservedW [expr $screenW - $marginleft]
    set reservedH [expr $screenH - $margintop]
    ##zu weit unten -> Move textpic up
    if {$reservedH < $textpicH} {
      set diff [expr $textpicH - $reservedH]
      set margintop [expr $margintop - $diff - $minmarg] 
    }
    ##zu weit rechts -> move textpic left
    if {$reservedW < $textpicW} {
      set diff [expr $textpicW - $reservedW]
      set marginleft [expr $marginleft - $diff - $minmarg] 
    }

    #Produce final image: copy textpic to hgbild
    if $RtL {
    
      ##correct RtL left margin: create croppic
      cropPic textbild $fontcolortext
      hgbild copy croppic -to $marginleft $margintop
      ##check if pngInfo exists & correct further
      if ![info exists colour::pngInfo(Marginleft)] {
        set screenW [winfo screenwidth .]
        set textbildW [image width textbild]
        set marginleft [expr $screenW - $marginleft - $textbildW]
      }
 
    } else {
        
      hgbild copy textbild -to $marginleft $margintop
    }
    
    #Cleanup
    namespace delete [namespace current]
    catch {namespace delete colour}
    #Return pic as function
    return hgbild
  }

  # parseTwdTextParts
  ## prepares Twd nodes in a separate namespace for further processing
  ## called by printTwd
  proc parseTwdTextParts {TwdFileName} {
    global TwdLang
    set screenW [winfo screenwidth .]
    set screenH [winfo screenheight .]
    
    #A: SET TWD NODE NAMES
    set domDoc [parseTwdFileDomDoc $TwdFileName]
    set todaysTwdNode [getDomNodeForToday $domDoc]
    set parolNode1 [$todaysTwdNode child 2]
    set parolNode2 [$todaysTwdNode lastChild]
    
    if {$todaysTwdNode == ""} {
      source $SetupTexts
      set text1 $noTwdFilesFound
    } else {
      set titleNode [$todaysTwdNode selectNodes title]
    }
    
    set introNode1 [$parolNode1 selectNodes intro]
    set introNode2 [$parolNode2 selectNodes intro]
    set refNode1 [$parolNode1 selectNodes ref]
    set refNode2 [$parolNode2 selectNodes ref]
    set textNode1 [$parolNode1 selectNodes text]
    set textNode2 [$parolNode2 selectNodes text]

    # B: EXTRACT TWD TEXT PARTS
     
    ##title
    set title [$titleNode text]
    ##intros
    if {![catch {$introNode1 text} res]} {
      set intro1 $res
    }
    if {![catch {$introNode2 text} res]} {
      set intro2 $res
    }
    
    ##refs
    set ref1 [$refNode1 text]
    set ref2 [$refNode2 text]

    # Detect texts with <em> tags & mark as Italic
    foreach node "[split [$textNode1 selectNodes em/text()]] [split [$textNode2 selectNodes em/text()]]" {
      set nodeText [$node nodeValue]
      if {$nodeText != ""} {
        $node nodeValue \<$nodeText\~
      }
    }
    ##extract text including any tagged
    set text1 [$textNode1 asText]
    set text2 [$textNode2 asText]
        
    #export text parts to namespace current:
    if [info exists intro1] {
     set [namespace current]::intro1 $intro1
    }
    if [info exists intro2] {
      set [namespace current]::intro2 $intro2
    }
    if [info exists title] {
      set [namespace current]::title $title
    }
    set [namespace current]::ref1 $ref1
    set [namespace current]::ref2 $ref2
    set [namespace current]::text1 $text1
    set [namespace current]::text2 $text2
        
  } ;#END parseTwdTextParts
  
  # printTwdTextParts  
  ## called by printTwd
  proc printTwdTextParts {x y img} {
  
  #TODO testing
  set x 20
  set y 20
  
    set screenW [winfo screenwidth .]
    set screenH [winfo screenheight .]
    global enabletitle TwdLang
    global [namespace current]::title
    global [namespace current]::intro1
    global [namespace current]::intro2
    global [namespace current]::ref1
    global [namespace current]::ref2
    global [namespace current]::text1
    global [namespace current]::text2
    
    
    #2) SORT OUT markrefs for Italic & Bold
    if {$TwdLang == "th" || $TwdLang == "zh" } {
      set markTitle ""
      set markRef ""
      set markText ""
    } elseif {[isArabicScript $TwdLang]} {
      #Arabic has no Italics!
      set markTitle +
      set markRef ~
      set markText ~
    } elseif {$::fontweight == "bold"} {
      set markTitle +
      set markRef <
      set markText +
    } else {
      set markTitle +
      set markRef <
      set markText ~
    }

    #3) START PRINTING

    # 1. Print Title in Bold +...~
    if {$enabletitle} {
      set y [printTextLine ${markTitle}${title} $x $y $img]
    }
    #Print intro1 in Italics <...~
    if [info exists intro1] {
      set y [printTextLine ${markRef}${intro1} $x $y $img IND]
    }
    #Print text1
    set textLines [split $text1 \n]
    foreach line $textLines {
      set y [printTextLine ${markText}$line $x $y $img IND]
    }
    #Print ref1 in Italics
    set y [printTextLine ${markRef}${ref1} $x $y $img TAB]
    #Print intro2 in Italics
    if [info exists intro2] {
      set y [printTextLine ${markRef}${intro2} $x $y $img IND]
    }
    #Print text2
    set textLines [split $text2 \n]
    foreach line $textLines {
      set y [printTextLine ${markText}$line $x $y $img IND]
    }
    #Print ref2
    set y [printTextLine ${markRef}${ref2}${markText} $x $y $img TAB]


#TODO yor x's and y's are in a muddle!!!!!!!!!!!!!!!!!!!!!!!!!!!
#it's probably evalMargin...
    #EVALUATE MARGIN ERRORS
#    lassign [evalMarginErrors $x $y] newX newY
#puts "$x $y"
#puts "$newX $newY"
#    ##A) if none, return $img
#    if {$newX == $x && $newY == $y} {
#      
#      return $img
#      
#    ##B) if some, return new coords for fresh run of this prog
#    } else {

#      if {$newX != $x} {set x $newX} 
#      if {$newY != $y} {set y $newY}
#      
#      return "$x $y"
#    }
#    

#  testoverlay write /tmp/testoverlay.png -format PNG

  } ;#END printTwdTextParts


  # printLetter
  ## prints single letter to $img
  ## called by printTextLine
  proc printLetter {letterName img x y} {
    global colour::regHex
    global colour::sunHex
    global colour::shaHex
    global RtL prefix
    upvar $letterName curLetter

    set imgW [image width $img]
    set imgH [image height $img]

    set BBxoff $curLetter(BBxoff)
    set BBx $curLetter(BBx)

    if {$RtL} {
      set x [expr $x - $curLetter(DWx)]
    }

    set xLetter [expr $x + $BBxoff]
    set yLetter [expr $y - $curLetter(BByoff) - $curLetter(BBy)]

    set yCur $yLetter
    set pixelLines $curLetter(BITMAP)
    
    foreach pxLine $pixelLines {
      set xCur $xLetter
      for {set i 0} {$i < $curLetter(BBx)} {incr i} {
        set pxValue [string index $pxLine $i]
        
        if {$pxValue != 0} {
          switch $pxValue {
            1 { set pxColor $regHex }
            2 { set pxColor $sunHex }
            3 { set pxColor $shaHex }
          }
           
        #A) Truncate text (break loop) if it exceeds image width or height
        #if {$xCur >= $imgW || $yCur >= $imgH} {break}
        #B) else put colour pixel
        if {$xCur <0} {set xCur 1} 
          $img put $pxColor -to $xCur $yCur
        }
        incr xCur
      }  
    incr yCur
    }
  } ;#END printLetter


  # printTextLine - prints 1 line of text to $img
  ## calls printLetter
  ## use 'args' for TAB or IND
  ## Called by printTwd
  proc printTextLine {textLine x y img args} {
      
    global TwdLang enabletitle RtL BdfBidi prefix

    #set textpic width for RtL, to be cropped later
    if $RtL {
      $img conf -width 800
      set x 800
    } 

    set FontAsc "$${prefix}::FontAsc"
    set tab 400
    set ind 0
    if {$enabletitle} {set ind 20}
    
    set xBase $x
    if [catch {set yBase [expr $y + $FontAsc]}] {
      set yBase $y
    }

    #Set text alignment: 
 
    ##for normal text
    if !$RtL {
      set operator +

    ##for RtL text
    } else {
      ##a) if no png info found, move text to the right - #?TODO? recompute luminacy for new area?!
      set operator -
      source $BdfBidi
      set textLine [bidi $textLine $TwdLang]
    }

    #Compute indentations
    if {$args=="IND"} {
      set xBase [expr $xBase $operator $ind]
    } elseif {$args=="TAB"} {
      set xBase [expr $xBase $operator $tab]
    }

    set letterList [split $textLine {}]
    
    foreach letter $letterList {

      #Set new fontstyle if marked
      if {$letter == "<"} {
        set prefix I
        continue
      } elseif {$letter == "~"} {
        set prefix R
        continue
      } elseif {$letter == "+"} {
        set prefix B
        continue
      }

      set encLetter [scan $letter %c]

      if { [catch {upvar 3 ${prefix}::print_$encLetter print_$encLetter} error] } {
        puts $error
        continue
        
      } else {
        
        array set curLetter [array get print_$encLetter]
        if [catch {printLetter curLetter $img $xBase $yBase} error] {
          puts "could not print letter: $encLetter"
          error $error
          continue
        }
        set xBase [expr $xBase $operator $curLetter(DWx)]
      }
    } ;#END foreach

    set yBase [expr $y + $${prefix}::FBBy]
    
    #return new Y position for next line
    return $yBase

  } ;#END printTextLine

  # cropPic
  ##cuts image to text width
  ##works on basis of picdata/piclists
  ##called by printTwd
  proc cropPic {img fontcolorname} {
    set fontHex [set colour::$fontcolorname]
    set dataL [$img data]

    foreach i $dataL {
      set res [lsearch $i $fontHex]
      if {$res != "-1"} {
        lappend margL $res
      }
    }

    set margL [join $margL ,]
    set minleft [expr min($margL)]

    #Crop pic
    image create photo croppic
    croppic copy $img -from $minleft 10  
      
  #  return $newpic
  } ;#END cropPic

} ;#END bdf:: namespace



