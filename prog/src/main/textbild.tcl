# ~/Biblepix/prog/src/main/textbild.tcl
# Creates text picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 19nov2016 

set screenx [winfo screenwidth .]
set screeny [winfo screenheight .]

#Set window bottom-left, no frame
wm overrideredirect . 1
wm geometry . +0-30

proc text>bmp {bmpfile twdfile} {
global fontsize fontfamily fontweight hghex fghex bmpdir screenx platform Twdtools Bidi os

    #Create & preconfigure empty one-line text widget
    catch {text .t }
    .t configure -background $hghex -foreground $fghex -height 1 -relief flat -borderwidth 0 -pady 0
    pack .t   

    #Create & configure font
    catch {font create BiblepixFont -family $fontfamily}

# B O L D ?
    font configure BiblepixFont -size -$fontsize -weight $fontweight
    .t configure -font BiblepixFont 

    #Get $dw
    source $Twdtools
    set dw [formatImgText $twdfile]
    set RTL 0
    set Leftmargin 0

    #Fix Hebrew
    if { [regexp {[\u05d0-\u05ea]} $dw] } {
        puts "Computing Hebrew text..."
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
        textbild configure -width $screenx
    }
    
    #Split $dw into lines
    set dwsplit [split $dw \n]
    
    #Copy text lines to image    
    foreach zeile $dwsplit {
    
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
       set Leftmargin [expr $screenx - $Lwidth]
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
        cutleft copy textbild -from [expr $screenx - $longestline] 0 -shrink
        textbild blank
        textbild configure -width [image width cutleft]
        textbild copy cutleft
    }
        
    textbild write $bmpfile -format bmp
    textbild blank
           
} ;#END text>bmp

proc checkBMPs {} {
global bmpdir heute platform
puts "Checking text pics..."
	
	#Delete old bmp's
	set bmplist [getBMPlist]
	if {$bmplist != ""} {
		foreach bmpname $bmplist {
			set bmpfile [file join $bmpdir $bmpname]
 			if {[clock format [file mtime $bmpfile] -format %d] != $heute} {
				puts " Deleting $bmpname"
				file delete -force $bmpfile
			}
		}
	}
		
	#renew lists
	set bmplist [getBMPlist]
	set twdlist [getTWDlist]

	#Create today's missing bmp's
		foreach twdfile $twdlist {
			regsub ".twd" $twdfile ".bmp" bmpname
			set bmpfile [file join $bmpdir $bmpname]
			if {[file exists $bmpfile]} {
				puts " $bmpname up-to-date"
			} else {
				puts " Creating $bmpname"
				text>bmp $bmpfile $twdfile
			}
		}

	
    #Withdraw/Iconify window when finished
    wm overrideredirect . 0
	if {$platform=="unix"} {
		wm withdraw .
	} else {
		wm iconify .
	}
} ;#end ckeckBMPs
