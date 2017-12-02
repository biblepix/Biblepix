# ~/Biblepix/prog/src/pic/BdfTools.tcl
#T E S T P H A S E 
#Updated 2.12.17

#####################################################################
# FONTBOUNDINGBOX = Gesamtgrösse/Maximalgrösse eines Zeichens 
# Breite | Höhe | Abstand von links | Abstand von unten (Nulllinie)

# BBOX = Position des Zeichens in der Font Boundingbox
# Breite | Höhe | Abstand von links | Abstand von unten

#####################################################################


proc scanBdf {BdfFile} {

  #source ~/Biblepix/prog/src/com/globals.tcl
  set tmpdir /tmp
  set heute {}
  set fontdir /tmp
  
  #Set up files and channels  
  set BdfFontChan [open $tmpdir/$BdfFile]
  set BdfText [read $BdfFontChan]
  close $BdfFontChan

  # A) SCAN BDF FOR GENERAL INFORMATION 
  
  ##get font name + size
  regexp -line {^FONT .*$} $BdfText Fontspec
  regexp -line {^SIZE .*$} $BdfText Fontsize
  regexp -line {^NAME .*$} $BdfText Fontname

  ##get character width, height and offsets
  regexp -line {^FONTBOUNDINGBOX .*$} $BdfText FBBList
    
  ##get number of characters
  regexp -line {^CHARS .*$} $BdfText numCharsList
  set numChars [lindex $numCharsList 1]

  set TclFontFile [string map {.bdf .tcl} $BdfFile]
  set TclFontChan [open $fontdir/$TclFontFile w]
  
  # Save general information to TclFontFile
  puts $TclFontChan "\# $fontdir\/$TclFontFile
\# BiblePix font extracted from $BdfFile
\# Font Specification: $Fontspec
\# Font size: $Fontsize
\# Created $heute
  
\# FONTBOUNDINGBOX INFO
set FBBx [lindex $FBBList 1]
set FBBy [lindex $FBBList 2]
set FBBxoff [lindex $FBBList 3]
set FBByoff [lindex $FBBList 4]
set numChars $numChars
"
    
  # B) SCAN BDF FOR SINGLE CHARACTERS
#set logfile [open /tmp/logfile.tcl w]

  set indexEndChar 0

  for {set charNo 0} {$charNo <= $numChars} {incr charNo} {
    
    #Set next character indices
    set indexBegChar [string first {STARTCHAR} $BdfText $indexEndChar]
    set indexEndChar [expr [string first ENDCHAR $BdfText $indexBegChar] +7]
    
    set charText [string range $BdfText $indexBegChar $indexEndChar]

    # 1. Extract necessary information
    
    ##set Codename (to be used for character name)
    regexp -line {^ENCODING .*$} $charText encList
    set enc [lindex $encList 1]
        
    ##set BBX (for typesetting proc)
    regexp -line {^BBX .*$} $charText BBXList
        
    ##create BITMAP list 
    set indexBegBMP [expr [string first BITMAP $charText] +6]
    set indexEndBMP [expr [string first ENDCHAR $charText] -1]
    set BMPList [string range $charText $indexBegBMP $indexEndBMP]
    
    #Convert bitmap list to binary
    set binlist ""
    foreach line $BMPList {
      lappend binlist [hex2bin $line]
    }
    
    #Colour + format binary bitmap list
    set binlist [colourBinlist $binlist]
    
    # 2. Create character array & append to TclFontFile
    puts $TclFontChan "array set print_$enc \{ 
  BBx [lindex $BBXList 1]
  BBy [lindex $BBXList 2]
  BBxoff [lindex $BBXList 3]
  BByoff [lindex $BBXList 4]
  BITMAP \{ $binlist \}
\}
"
  } ;#END LOOP

  close $TclFontChan
  
#close $logfile
} ;#END PROC scanBdf  

proc hex2bin {hex} {
  binary scan [binary format H* $hex] B* bin
  return $bin
}

# S c h e m a   bei Sonne von links oben:
#    S
#   S#
#  S###
# S#####
#  ###s
#   #s
#   ss
       
# Colour a single bitmap character
proc colourBinlist {binlist} {
  
  # Vorarbeit: alle Zeilen gleich lang
  #add ^0 to all original lines if at least 1 line is ^1
  foreach line $binlist {
    if {[regexp ^1 $line]} {
    set lineBeg1 1
    break
    }
  }
  
  if {[info exists lineBeg1]} {
    foreach line $binlist {
      regsub ^1 $line 01 newline
      lappend tmpBinlist $newline
    }
  puts "Adding 0 at beginning of line..."
      
  } else {
  
    set tmpBinlist $binlist
  }

  
  foreach line $tmpBinlist {

    #1. Sun left: change any 0|1 into 2|1 (sun=2)
    regsub -all 01 $line 21 line
      
    #2. Shade right: change any 1|0 pixel into 1|3 (shade=3)
    regsub -all 10 $line 13 line
    regsub 1$ $line 13 line ;#TODO: this is adding an extra 0 !
        
    lappend newBinlist $line
        
  } ;#END loop 
  
  
  # 3. Add sun line at top
  set firstline [lindex $binlist 0]
  set newFirstline [string map {1 2} $firstline]
  ## um 1 n.links versetzen
  regsub ^0 $newFirstline {} newFirstline
  regsub .$ $newFirstline &0 newFirstline
  append Binlist "$newFirstline " $newBinlist
  
  # 4. Add shade line at bottom
  set lastline [lindex $binlist end]
  set newLastline [string map {1 3} $lastline]
  ## um 1 n.rechts versetzen
  regsub ^0 $newLastline 00 newLastline
  regsub 0$ $newLastline {} newLastline
  append Binlist " $newLastline"
     
  # 5. Correct any spurious sun or shade pixels
  ## eliminate current sun/shade pixel if previous line's pixels are more left
  foreach line $Binlist {
    set curSunPos [string first 2 $line]
    set curShaPos [string last 3 $line]

    if {[info exists prevSunPos] && $curSunPos>$prevSunPos} {

      set line [string map {02 00} $line]
      set correctedBinlist [lreplace $Binlist end end $line]

    } elseif {[info exists prevShaPos] && $curShaPos>$prevShaPos} {
            
      set line [string map {13 10} $line]
      set correctedBinlist [lreplace $Binlist end end $line]

    }
    #reset prev to current
    set prevSunPos $curSunPos
    set prevShaPos $curShaPos
  
  }
  
  if {[info exists correctedBinlist]} {
    set Binlist $correctedBinlist
  }
  
  return $Binlist
} 



#### R E S E R V E #############################################################

#Zeichengrösse multiplizieren oder verkleinern - NOT NEEDED :-)
proc resizeBdfChar {binlist} {
  #1. in Breite: jedes Zeichen verdoppeln
  foreach pix [split $binlist {}] {
    append doubleSpaceBinlist [string repeat $pix 2]
  }

  #2. Add sun and shade pixels here
  set doubleSpaceBinlist [addSunAndShade]
  
  
#### bis hier gehts - $doubleSpaceBinlist is proper list!


  #3. in Höhe: jede Zeile verdoppeln
  foreach line $doubleSpaceBinlist {
    lappend doubledBinlist $line
    lappend doubledBinlist $line
  }

#TODO - keine Liste mehr!
puts $doubledBinlist
return

  #c) Add sun line before first sunny line (symbol=2) -TODO: eliminate 0000 lines!
  ##find first line with 2
  for {set index 0} {$index<=[llength $doubleSpaceBinlist]} {incr index} {
    if {[regexp 2 [lindex $doubleSpaceBinlist $index]]} {
      return $index}
    }
  ##insert new line (hardly first!) - TODO don't add line (s.u.)
  #set newList [linsert $double??List $index $sunline]
  
  set sunLine [lindex $doubledBinlist $index]
  ##1 nach links versetzen
  set sunLine [string replace $firstLine 0 0 {}]
  set sunLine [string replace $firstLine end end {00}]
  set newSunline [string map {1 2} $firstLine]  
  
  ##add line at top - TODO NO!
  set doubledBinlist [lappend doubledBinlist $newFirstline $doubledBinlist]
##### TODO: REPLACE SUN-LINE WITH 1 LINE PREVIOUS TO INDEXED LINE !!!




  #d) Add shade line at bottom - TODO : no! S.O.
  set lastLine [lindex $doubledBinlist end]
  set newLastline [string map {1 3} $lastLine]
  ##1 nach rechts versetzen
  string replace $newLastline 0 0 {00}
  string replace $newLastline end end {}
  ##add line at end
  lappend doubledBinlist $newLastline

}; #END double



# P r e p a r e   p r i n t   p r o c

proc printChar {bitmap image} {
#Zeilenweise Pixelpositionen in Listen speichern
  set 1 black
  set 2 yellow
  set 3 grey
  
  set zeilenmenge [llength $bitmap]
  set linelength [llength $pixlist]
  set linelength [llength [split 
  
  #TODO: Joel das funktioniert nicht, weiss nicht warum
  #wichtig für dich: du kannst mit [set 1] z.B. einen Variablentausch vornehmen
  for {set x 0} {$x<[llength [lindex  $bitmap} {incr x} {
  
    for {set y 0} {$y<$zeilenmenge} {incr y} {
      set zeile 
      set pixlist [split $zeile {}]      
      if {[set pix]!=0} {
        $image put [set $pix] -to $x $y
      }
    }
  }

  
} ;#END PROC

