# ~/Biblepix/prog/src/pic/textbild.tcl
# Creates text picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 26Sep17 

#Set window bottom-left, no frame
wm overrideredirect . 1
wm geometry . +0-0

#Create font only once
catch {font create BiblepixFont -family $fontfamily}

proc text>bmp {bmpFilePath twdFileName} {
global fontsize fontfamily fontweight hghex fghex bmpdir platform Twdtools Bidi os

  set screenX [winfo screenwidth .]

  #Create & preconfigure empty one-line text widget
  catch {text .t }
  .t configure -background $hghex -foreground $fghex -height 1 -relief flat -borderwidth 0 -pady 0
  pack .t   

  #Configure font
  font configure BiblepixFont -size -$fontsize -weight $fontweight
  
  #force non-bold for Chinese
  if  {[string range $twdFileName 0 1] == "zh"} {
    font configure BiblepixFont -weight normal
  }
  
  .t configure -font BiblepixFont 

  #Get $dw
  source $Twdtools
  
  # TODO im Fehlerfall die TWD-Datei neu herunterladen
  set dw [formatImgText $twdFileName]
  
  set RTL 0
  set Leftmargin 0

  #Fix Hebrew
  if { [regexp {[\u05d0-\u05ea]} $dw] } {
    puts "Computing Hebrew text..."

    #force non-bold
    font configure BiblepixFont -weight normal
    set RTL 1
    source $Bidi

    if {$os == "Windows NT"} {
      set dw [fixHebWin $dw]
    } else {
      set dw [fixHebUnix $dw]
    }
  }

  #Fix Arabic
  if { [regexp {[\u0600-\u076c]} $dw] } {
    puts "Computing Arabic text..."
    
    #force non-bold
    font configure BiblepixFont -weight normal       
    set RTL 1
    source $Bidi
    
    if {$os == "Windows NT"} {
      set dw [fixArabWin $dw]
    } else {
      set dw [fixArabUnix $dw]
    }
  }
    
  #Create textbild with 0 width, define width for RTL
  image create photo textbild 
  
  if {$RTL} {
      textbild configure -width $screenX
  }
  
  #Split $dw into lines
  set dwsplit [split $dw \n]
  
  puts $dwsplit
  
  #Copy text lines to image    
  foreach zeile $dwsplit {
    puts $zeile
  
    #create text line
    .t delete 1.0 end
    .t insert 1.0 $zeile

    #set line width in characters
    set Charno [.t count -chars 1.0 1.end]
    .t configure -width $Charno

    #set line width in pixels
    wm state . normal
    update
    set Lwidth [lindex [.t bbox 1.end] 0]

    #set longest line for RTL
    lappend Linelength $Lwidth

    #copy text line to image if width not 0
    if { [catch "image create photo tmpbild -data .t -format window -width $Lwidth"] } {
      continue
    }

    if {$RTL} {
      set Leftmargin [expr $screenX - $Lwidth]
      
      if {$Leftmargin<0} {
        set Leftmargin 0
      }
    }
  
    #adapt textbild height successively (minus 1px for frame)
    set imgheight [expr [image height textbild] -1]
    
    #set to 0 for first run
    if {$imgheight<0} {set imgheight 0}
    update

    #adapt textbild width successively
    if {!$RTL} {
        set textbildwidth [image width textbild]
        set tmpbildwidth [image width tmpbild]
    
        if {$tmpbildwidth > $textbildwidth} {
            textbild configure -width $tmpbildwidth
            update
        }
    }
   
    textbild copy tmpbild -to $Leftmargin $imgheight -shrink
  }  ;#end foreach
     
  #Cut out left whitespace for RTL
  if {$RTL} {
    set longestline [lindex [lsort -integer $Linelength] end]
    image create photo cutleft
    cutleft copy textbild -from [expr $screenX - $longestline] 0 -shrink
    textbild blank
    textbild configure -width [image width cutleft]
    textbild copy cutleft
  }
      
  textbild write $bmpFilePath -format bmp
  textbild blank           
} ;#END text>bmp

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
