# ~/Biblepix/prog/src/com/BdfTools.tcl
# BDF printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 1apr21 

namespace eval bdf {

  variable xBase
  variable YBase
  variable x
  variable y
  
  # printTwd
  ##Toplevel printing proc
  ##called by BdfPrint
  proc printTwd {TwdFileName img} {
    ##global vars
    global ::RtL ::fontcolortext
    ##vars set by Image
    global bdf::marginleft
    global bdf::margintop
    global bdf::pngmargins
    global bdf::luminacy
    set screenW [winfo screenwidth .]
    
    #Create global picture function
    image create photo textbild
      
    #Get text into bdf:: vars & print to textpic
    parseTwdTextParts $TwdFileName
    printTwdTextParts textbild

    #Crop pic to text width if RtL
    if $RtL {
      cropPic2Textwidth
    }
    
    #Reset textbild coords to avoid margin violation
    lassign [resetTextpicCoords $marginleft $margintop] x1 y1
    
    set textpicW [image width textbild]
    set textpicH [image height textbild]
    set x2 [expr $x1 + $textpicW]
    set y2 [expr $y1 + $textpicH]
    
    #Recompute luminance for non-pnginfo pics, excluding RtL
    ##if bdf::luminacy is not 0
    if $luminacy {
      set lumChanged 0

    } elseif !$RtL {

       set newLum [getAreaLuminacy hgbild [list $x1 $y1 $x2 $y2]]
       set bdf::luminacy $newLum
       set lumChanged 1
    }

    #Handle RtL special cases
    if $RtL {
    
      ##align text with right margin if no pnginfo found 
      if !$pngmargins {
        ##and if default marginleft is leftish of centre
        if {$x1 < [expr $screenW/3] } {
          set x1 [expr $screenW - $textpicW - $::marginleft]
          set x2 [expr $x1 + $textpicW]
          ##luminacy must be rechecked
          set luminacy 0

        }
      }

      ##if lum=0 check if luminacy changed
      if !$luminacy { 
        set newLum [getAreaLuminacy hgbild [list $x1 $y1 $x2 $y2]]
        set bdf::luminacy $newLum
        set lumChanged 1
      }
      
    } ;#END if RtL
    
    #in case of changed luminacy rerun printTwdTextParts
    if $lumChanged {
      setFontShades $fontcolortext
      image create photo textbild
      printTwdTextParts textbild
      if $RtL {
        cropPic2Textwidth
     }
    }

    #Copy textpic to final image - for testing image width use '-comp_rule set'
    hgbild copy textbild -to $x1 $y1 -compositingrule overlay

    #Cleanup
    namespace delete [namespace current]
    
    #Return pic as function
    return hgbild

  } ;#End printTwd

  # resetTextpicCoords
  ##fits textbild onto hgbild & 
  ##returns new marginleft + margintop
  ##called by twdPrint
  proc resetTextpicCoords {marginleft margintop} {
    set minmarg 25

    #Correct right & top margins
    set screenW [winfo screenwidth .]
    set screenH [winfo screenheight .]
    set textpicW [image width textbild]
    set textpicH [image height textbild]

    set reservedW [expr $screenW - $marginleft - $minmarg]
    set reservedH [expr $screenH - $margintop - $minmarg]

    ##zu weit rechts -> move textpic left
    if {$reservedW < $textpicW} {
      set diff [expr $textpicW - $reservedW]
      #set marginleft [expr $screenW - $textpicW - $minmarg]
      
      set marginleft [expr $marginleft - $diff] 
    }

    ##zu weit unten -> Move textpic up
    if {$reservedH < $textpicH} {
      set diff [expr $textpicH - $reservedH]
      set margintop [expr $margintop - $diff] 
    }

    return "$marginleft $margintop"
  }

  # parseTwdTextParts
  ## prepares Twd nodes for further processing
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
  proc printTwdTextParts {img} {
    set x 0
    set y 0
  
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
    set markTitle +
    set markRef <
    if {$::fontweight == "bold"} {
      set markText +
    } else {
      set markText ~
    }

    #Arabic has no Italics!
    if {[isArabicScript $TwdLang]} {
      set markRef $markText
    }

    #No marking for Asian
    if {$TwdLang == "th" || $TwdLang == "zh" } {
      set markTitle ""
      set markRef ""
      set markText ""
    }

    #3) START PRINTING

    # 1. Print Title in Bold +...~
    if {$enabletitle} {
      set y [printTextLine ${markTitle}${title} $x $y $img TIT]
    }
    
    #TODO? Textbreite von Titel berechnen (get first & last x pos)
    #für Positionierung von refs rechtsbündig mit Titel
    #dafür müssen die refs vorerst in 2 separate Bilder gedruckt werden, um ihre Textbreite zu bestimmen
    ##TODO use TAB if no title found!
    
    
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
#set refX [alignRef $markRef 1]
set refX $x
set y [printTextLine ${markRef}${ref1} $refX $y $img TAB]
    
    
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
#set refX [alignRef $markRef 2]
set refX $x
set y [printTextLine ${markRef}${ref2} $refX $y $img TAB]
    
  } ;#END printTwdTextParts

#TODO this is not used at present!
  proc alignRef {markRef refNo} {
      global [namespace current]::titleEnd
      global [namespace current]::ref1
      global [namespace current]::ref2 
      global [namespace current]::marginleft
      
#      set titleW [expr $marginleft - $titleEnd]
#puts "titleW $titleW"

      if {$refNo == 1} {
        set ref $ref1
      } elseif {$refNo == 2} {
        set ref $ref2
      }
      
      image create photo refpic
      printTextLine ${markRef}${ref} 0 0 refpic
      refpic write /tmp/refpic.png -format PNG
      
      set refW [image width refpic]
puts "refpicW: $refW"
puts "titleEnd: $titleEnd"
      set refPos [expr $marginleft - $titleEnd - $refW]
      ##export for printTextParts
puts "refPos $refPos"
      set [namespace current]::refPos $refPos
      
      return $refPos
  }
    
    
  # printLetter
  ## prints single letter to $img
  ## called by printTextLine
  proc printLetter {letterName img x y} {
#puts $letterName

    global colour::regHex
    global colour::sunHex
    global colour::shaHex
    global RtL prefix
    upvar $letterName curLetter

    set imgW [image width $img]
    set imgH [image height $img]
    set BBxoff $curLetter(BBxoff)
    set BBx $curLetter(BBx)

    if $RtL {
      set x [expr $x - $curLetter(DWx)]
    }

    set xLetter [expr $x + $BBxoff]
    set yLetter [expr $y - $curLetter(BByoff) - $curLetter(BBy)]

    set yCur $yLetter
    set pixelLines $curLetter(BITMAP)
    
    foreach pxLine $pixelLines {
      if {$yCur < 0} {
        incr yCur
        continue
      }

      set xCur $xLetter
      for {set i 0} {$i < $curLetter(BBx)} {incr i} {
        set pxValue [string index $pxLine $i]

        if {$pxValue != 0} {
          switch $pxValue {
            1 { set pxColor $regHex }
            2 { set pxColor $sunHex }
            3 { set pxColor $shaHex }
          }

          if {$xCur <0} {
            set xCur 1
          }
          # put colour pixel
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
      
    global TwdLang enabletitle RtL Bidi prefix

    #set textpic width for RtL, to be cropped later
    if $RtL {
      $img conf -width 1000
      set x 1000
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
      ##a) if no png info found, move text to the right
      set operator -
      if ![namespace exists bidi] {
        source $Bidi
      }
      set textLine [bidi::fixBidi $textLine 0 1]
    }

    #Compute indentations
    if {$args=="IND"} {
      set xBase [expr $xBase $operator $ind]
    
    } elseif {$args=="TAB"} {
    
      #TODO use tab only if no titleEnd found!
      global [namespace current]::refPos 
      if [info exists refPos] {
        set tab [expr $xBase - $refPos]
        set tab $refPos
      }
    
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
          puts $error
          #better skip spurious chars!
          #error $error
          continue
        }
        set xBase [expr $xBase $operator $curLetter(DWx)]
        
        #Count line length if title for alignment of refs, to be computed later by alignRef
        if {$args=="TIT"} {
          set [namespace current]::titleEnd $xBase
        }
        
      }
    } ;#END foreach

    set yBase [expr $y + $${prefix}::FBBy]
    
    #return new Y position for next line
    return $yBase

  } ;#END printTextLine

} ;#END bdf:: namespace

