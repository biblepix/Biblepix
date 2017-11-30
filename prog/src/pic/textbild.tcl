# ~/Biblepix/prog/src/pic/textbild.tcl
# Creates text picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 26Sep17 

#Set window bottom-left, no frame
wm overrideredirect . 1
wm geometry . +0-30

set screenX [winfo screenwidth .]
set maxLineWidth 0

#Create font only once
catch {font create BiblepixFont}
catch {font create BiblepixItalicFont -slant italic}

proc text>bmp {bmpFilePath twdFileName} {
global fontsize fontfamily fontweight hghex fghex Twdtools enabletitle ind screenX maxLineWidth

  source $Twdtools

  #Configure font
  font configure BiblepixFont -family $fontfamily -size -$fontsize -weight $fontweight
  font configure BiblepixItalicFont -family $fontfamily -size -$fontsize -weight $fontweight
  
  set twdLanguage [getTwdLanguage $twdFileName]
  set indent 0
  set RtL [isRtL $twdLanguage]
  
  #force non-bold for Chinese
  if {$twdLanguage == "zh"} {
    font configure BiblepixFont -weight normal
    font configure BiblepixItalicFont -weight normal
  }
  
  #force non-bold for RtL
  if {$RtL} {
    font configure BiblepixFont -weight normal
    font configure BiblepixItalicFont -weight normal
  }

  #Create & preconfigure empty one-line text widget
  catch {text .textImgTextWidget }
  .textImgTextWidget configure -background $hghex -foreground $fghex
  .textImgTextWidget configure -height 1 -pady 0
  .textImgTextWidget configure -relief flat -borderwidth 0
  .textImgTextWidget configure -font BiblepixFont 
  .textImgTextWidget tag configure kursiv -font BiblepixItalicFont
  pack .textImgTextWidget
  
  set twdDomDoc [parseTwdFileDomDoc $twdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  set textImg [image create photo]
  
  if {$twdTodayNode == ""} {
    addTextLineToTextImg "No Bible text found for today." $textImg
  } else {
    if {$RtL} {
      $textImg configure -width $screenX
    }
    
    if {$enabletitle} {
      set twdTitle [getTwdTitle $twdTodayNode $twdLanguage 1]
      addTextLineToTextImg $twdTitle $textImg $RtL
      set indent [font measure BiblepixFont $ind]
    }
    
    set parolNode [getTwdParolNode 1 $twdTodayNode]
    addParolToTextImg $parolNode $textImg $twdLanguage $RtL $indent
    
    set parolNode [getTwdParolNode 2 $twdTodayNode]
    addParolToTextImg $parolNode $textImg $twdLanguage $RtL $indent

    #Cut out left whitespace for RtL
    if {$RtL} {
      set tempImg [image create photo]
      $tempImg copy $textImg -from [expr $screenX - $maxLineWidth] 0 -shrink
      $textImg blank
      $textImg configure -width [image width $tempImg]
      $textImg copy $tempImg
      image delete $tempImg
    }
  }
  
  $textImg write $bmpFilePath -format bmp
  image delete $textImg
  
  $twdDomDoc delete
} ;#END text>bmp

proc addParolToTextImg {parolNode textImg twdLanguage RtL {indent 0}} {
  global tab
  
  set intro [getParolIntro $parolNode $twdLanguage 1]
  if {$intro != ""} {
    addTextLineToTextImg $intro $textImg $RtL $indent
  }
  
  set text [getParolText $parolNode $twdLanguage 1]
  set textLines [split $text \n]
  
  foreach line $textLines {
    addTextLineToTextImg $line $textImg $RtL $indent
  }
  
  set ref [getParolRef $parolNode $twdLanguage 1]
  addTextLineToTextImg $ref $textImg $RtL [font measure BiblepixFont $tab]
}

proc addTextLineToTextImg {text textImg {RtL 0} {indent 0}} {
  global screenX maxLineWidth
  
  set lineWidth [prepareTextWidgetAndGetLineWidth .textImgTextWidget $text]
  
  set ::maxLineWidth [::tcl::mathfunc::max $maxLineWidth $lineWidth]
  
  if { [catch {set tempImg [image create photo -data .textImgTextWidget -format window -width $lineWidth]}] } {
    puts "tempImg could not be created. Line skipped"
    return
  }
  
  if {$RtL} {
    set leftMargin [expr $screenX - $lineWidth - $indent]
    
    if {$leftMargin<0} {
      set leftMargin 0
    }
  } else {
    set leftMargin $indent
  }
  
  appendTempImgToTextImg $tempImg $textImg $leftMargin
}

proc prepareTextWidgetAndGetLineWidth {textWidget text} {
  $textWidget delete 1.0 end  
  $textWidget insert 1.0 [string map {_ {}} $text]
  
  if {[regexp {_} $text]} {
    set firstIndex [string first _ $text 0]
    set offset 1
    
    while {$firstIndex > 0} {
      set secondIndex [string first _ $text [expr $firstIndex + 1]]
      
      if {$secondIndex > 0} {
        $textWidget tag add kursiv 1.[expr $firstIndex - $offset] 1.[expr $secondIndex - $offset]
      } else {
        $textWidget tag add kursiv 1.[expr $firstIndex - $offset] 1.end
      }
      
      set firstIndex [string first _ $text [expr $secondIndex + 1]]
      incr offset 2
    }
  }

  #set line width in characters
  set Charno [$textWidget count -chars 1.0 1.end]

  set lineWidth ""
  set extraChars 0
  
  # Wenn lineWidth leer ist, ist der Text grösser als $Charno * standard Zeichengrösse.
  # Solange das der Fall ist, soll das Textfeld vergrössert werden.
  while {$lineWidth == ""} {       
    $textWidget configure -width [expr $Charno + $extraChars]

    #set line width in pixels
    wm state . normal
    update
    set lineWidth [lindex [$textWidget bbox 1.end] 0]
    
    incr extraChars
  }
  
  return $lineWidth
}

proc appendTempImgToTextImg {tempImg textImg leftMargin} {
  global screenX
  
  #adapt textImg width successively
  set tempImgWidth [expr [image width $tempImg] + $leftMargin]

  if {$tempImgWidth > [image width $textImg]} {
      $textImg configure -width [::tcl::mathfunc::min $tempImgWidth $screenX]
      update
  }

  #adapt textImg height successively (minus 1px for frame)
  set imgHeight [expr [image height $textImg] - 1]
  
  #set to 0 for first run
  if {$imgHeight < 0 } {
    set imgHeight 0
  }
 
  $textImg copy $tempImg -to $leftMargin $imgHeight -shrink
  
  image delete $tempImg
}

#Creates today's missing BMPs / Executes text>bmp
proc createBMPs {} {
  global bmpdir platform slideshow

  set heute [clock format [clock seconds] -format %d]
  puts "Checking text pics..."
  
  #Delete old bmp's
  set bmplist [getBMPlist]
  if {$bmplist != ""} {
    foreach bmpFileName $bmplist {
      set bmpFilePath [file join $bmpdir $bmpFileName]
       if {[clock format [file mtime $bmpFilePath] -format %d] != $heute} {
        puts " Deleting $bmpFileName"
        file delete -force $bmpFilePath
      }
    }
  }
    
  #renew lists
  if {$slideshow} {
    set bmplist [getBMPlist]
    set twdFileNames [getTWDlist]
  } else {
  
    #pick 1 random pic+TWD for single pic mode
    set twdFileNames [getRandomTwdFile]
    set bmplist [getRandomBMP]
  }

  #Create today's missing bmp's
  foreach twdFileName $twdFileNames {
    regsub ".twd" $twdFileName ".bmp" bmpFileName
    set bmpFilePath [file join $bmpdir $bmpFileName]
    if {[file exists $bmpFilePath]} {
      puts " $bmpFileName up-to-date"
    } else {
      puts " Creating $bmpFileName"
      if { [catch {text>bmp $bmpFilePath $twdFileName} result] } {
        error $result
      }
    }
  }

  #Withdraw/Iconify window when finished
  wm overrideredirect . 0
  
  if {$platform=="unix"} {
    wm withdraw .
  } else {
    wm iconify .
  }
} ;#end createBMPs
