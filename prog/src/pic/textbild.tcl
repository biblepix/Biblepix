# ~/Biblepix/prog/src/pic/textbild.tcl
# Creates text picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 26Sep17 

#Set window bottom-left, no frame
wm overrideredirect . 1
wm geometry . +0-30

set screenX [winfo screenwidth .]

#Create font only once
catch {font create BiblepixFont}
catch {font create BiblepixItalicFont -slant italic}

proc text>bmp {bmpFilePath twdFileName} {
global fontsize fontfamily fontweight hghex fghex Twdtools enabletitle ind

  #Configure font
  font configure BiblepixFont -family $fontfamily -size -$fontsize -weight $fontweight
  font configure BiblepixItalicFont -family $fontfamily -size -$fontsize -weight $fontweight
  
  set twdLanguage [string range $twdFileName 0 1]
  set ::maxLineWidth 0
  set indent 0
  set RTL 0
  
  #force non-bold for Chinese
  if {$twdLanguage == "zh"} {
    font configure BiblepixFont -weight normal
    font configure BiblepixItalicFont -weight normal
  }
  
  #force non-bold and set RTL for Hebrew & Arabic
  if {$twdLanguage == "he" || $twdLanguage == "ar" || $twdLanguage == "ur" || $twdLanguage == "fa"} {
    font configure BiblepixFont -weight normal
    font configure BiblepixItalicFont -weight normal
    set RTL 1    
  }
  

  #Create & preconfigure empty one-line text widget
  catch {text .textImgTextWidget }
  .textImgTextWidget configure -background $hghex -foreground $fghex
  .textImgTextWidget configure -height 1 -pady 0
  .textImgTextWidget configure -relief flat -borderwidth 0
  .textImgTextWidget configure -font BiblepixFont 
  .textImgTextWidget tag configure kursiv -font BiblepixItalicFont
  pack .textImgTextWidget

  source $Twdtools
  
  set twdDomDoc [parseTwdFileDomDoc $twdFileName]  
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  set textImg [image create photo]
  
  if {$RTL} {  
      $textImg configure -width $screenX
  }
  
  if {$enabletitle} {
    set twdTitle [getTwdTitle $twdTodayNode]
    addTextLineTotextImg $twdTitle $textImg $twdLanguage $RTL 0
    set indent [font measure BiblepixFont $ind]
  }
  
  set parolNode [getTwdParolNode 1 $twdTodayNode]  
  addParolTotextImg $parolNode $textImg $twdLanguage $RTL $indent
  
  set parolNode [getTwdParolNode 2 $twdTodayNode]  
  addParolTotextImg $parolNode $textImg $twdLanguage $RTL $indent

  #Cut out left whitespace for RTL
  if {$RTL} {
    set tempBild [image create photo]
    $tempBild copy $textImg -from [expr $screenX - $maxLineWidth] 0 -shrink
    $textImg blank
    $textImg configure -width [image width $tempBild]
    $textImg copy $tempBild
    $tempBild blank
  }
      
  $textImg write $bmpFilePath -format bmp
  $textImg blank           
} ;#END text>bmp

proc addParolTotextImg {parolNode textImg twdLanguage RTL indent} {
  global tab
  
  set intro [getParolIntro $parolNode]
  if {$intro != ""} {
    addTextLineTotextImg $intro $textImg $twdLanguage $RTL $indent
  }
  
  set text [getParolText $parolNode]
  set textLines [split $text \n]  
   
  foreach line $textLines {
    addTextLineTotextImg $line $textImg $twdLanguage $RTL $indent
  }
  
  set ref [getParolRef $parolNode]
  addTextLineTotextImg $ref $textImg $twdLanguage $RTL [font measure BiblepixFont $tab]
}

proc addTextLineTotextImg {text textImg twdLanguage RTL indent} {
  global screenX maxLineWidth os 
  
  set lineWidth [prepareTextWidgetAndGetLineWidth .textImgTextWidget $text $twdLanguage]
  
  set ::maxLineWidth [::tcl::mathfunc::max $maxLineWidth $lineWidth]
  
  if { [catch {set tempBild [image create photo -data .textImgTextWidget -format window -width $lineWidth]}] } {
    puts "tempBild could not be created. Line skipped"
    return
  }
  
  if {$RTL} {
    set leftMargin [expr $screenX - $lineWidth - $indent]
    
    if {$leftMargin<0} {
      set leftMargin 0
    }
  } else {
    set leftMargin $indent
  }
  
  appendTempBildTotextImg $tempBild $textImg $leftMargin  
}

proc prepareTextWidgetAndGetLineWidth {textWidget text twdLanguage} {
  global Bidi
  
  #Fix Hebrew
  if {$twdLanguage == "he"} {
    puts "Computing Hebrew text..."
    source $Bidi

    if {$os == "Windows NT"} {
      set text [fixHebWin $text]
    } else {
      set text [fixHebUnix $text]
    }
  }

  #Fix Arabic
  if {$twdLanguage == "ar" || $twdLanguage == "ur" || $twdLanguage == "fa"} {
    puts "Computing Arabic text..."
    source $Bidi
    
    if {$os == "Windows NT"} {
      set text [fixArabWin $text]
    } else {
      set text [fixArabUnix $text]
    }
  }
  
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

proc appendTempBildTotextImg {tempBild textImg leftMargin} {
  global screenX
  
  #adapt textImg width successively
  set tempBildWidth [image width $tempBild]

  if {$tempBildWidth > [image width $textImg]} {
      $textImg configure -width [::tcl::mathfunc::min $tempBildWidth $screenX]
      update
  }

  #adapt textImg height successively (minus 1px for frame)
  set imgHeight [expr [image height $textImg] - 1]
  
  #set to 0 for first run
  if {$imgHeight < 0 } {
    set imgHeight 0
  }
 
  $textImg copy $tempBild -to $leftMargin $imgHeight -shrink
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
    set twdFileNames [getRandomTWDFile]
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
        puts $result
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
