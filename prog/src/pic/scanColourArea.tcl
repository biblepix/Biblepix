# ~/Biblepix/prog/src/pic/scanColourArea.tcl
# Determines suitable even-coloured text area & colour tint for text
# Sourced by SetupResizePhoto 
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 7may20 pv

#TODO :uncomment:
#catch {namespace delete colour}

#TODO FOR TESTING
image create photo xs
source $ImgTools
set c .resizePhoto.resizeCanv
lassign [getCanvSection $c] x1 y1 x2 y2
xs copy resizeCanvPic -subsample 3 -from $x1 $y1 $x2 $y2 

namespace eval colour {

  ##scans image by desired height
  ##runs scanRow for each line
  proc scanColourArea {img} {

  #TODO? furnish these from outside? 
    set colourTol 10
    set margin {10}
    
    #Limit scanning area by excluding margins
    set imgX [image width $img]
    set imgY [image height $img]
    set begX $margin
    set endX [expr $imgX - $margin]
    set begY $margin
    set endY [expr $imgY - $margin]
    set prevxPos [expr $begX - 1]    
    
    #pretend prevC array & prevX for 1st run & LNL (list number per row)
    array set prevCArr {r 0 g 0 b 0}
        
    #Run through rows of row height
    for {set yPos $begY} {$yPos < $endY} {incr yPos} {
        
      #Run through pixels of row width
      for {set xPos $begX} {$xPos < $endX} {incr xPos} {
      
        #Get current rgb
        lassign [$img get $xPos $yPos] r g b
        array set curCArr "r $r g $g b $b"
  
        #Compare current rgb with previous      
        set maxr [expr max($curCArr(r) , $prevCArr(r))]
        set minr [expr min($curCArr(r) , $prevCArr(r))]
        set maxg [expr max($curCArr(g) , $prevCArr(g))]
        set ming [expr min($curCArr(g) , $prevCArr(g))]
        set maxb [expr max($curCArr(b) , $prevCArr(b))]
        set minb [expr min($curCArr(b) , $prevCArr(b))]
      
        #Add consecutive pixelPositions to 1 matchlist per row  
        set diffr [expr $maxr - $minr]
        set diffg [expr $maxg - $ming]
        set diffb [expr $maxb - $minb]
 
        array set prevCArr "r $r g $g b $b"   
        set lumCode [setLuminanceCode prevCArr]

        set prevxPos $xPos 
                                  
        #add 0 in front of xPos if not matching
        if {
          
          $diffr > $colourTol ||
          $diffg > $colourTol ||
          $diffb > $colourTol
                 
        } {
      
          set xPos 0$xPos
         
        }
        
        #add xPos + luminance to match array    
        array set [namespace current]::$yPos "$xPos $lumCode"        
        
        #strip xPos of preceding 0 for next run
        set xPos [string trimleft $xPos 0]
                    
      } ;#END x loop
      
puts $[namespace current]::$yPos

        
    } ;#END y loop
     
  } ;# END scanColourArea

    
  # evalRowlist
  ##scan xPos's of a pixel row for consecutive areas & ... 
  proc evalRowlist {img rowNo} {
  
    set minwidth [expr [image width $img] / 4]
    
#    #scan till next break -TODO to be replaced by findRange/findRanges
#    proc scanRanges {xPos prevxPos} {
#      while {[expr $xPos - $prevxPos] == 1} { 
#        lappend matchL $xPos
#        incr prevxPos
#      }
#      if [info exists matchL] {
#        return $matchL
#      } else {
#        return 0
#      }
#    }

    set rowL [getMatchingRowlist]
    set rowtot [llength $rowL]
 
    #Begin main Y loop
    for {set rowNo [lindex $rowtot 0]} {$rowNo < $rowTot} {incr $rowNo} {
      
      set rowLength [llength [array names [namespace current::$rowNo]]] 
      set xPos [lindex $rowL 0]
      set prevPos [expr $xPos - 1]
        
      #Begin main X loop
      for {set xTot $rowLength} {$xPos < $xTot} {incr xPos} {
      
        set scanRes [scanRanges $xPos $prevxPos]
        
        #add pixpos to matchlist if consecutive
        if {[expr $xPos - $prevxPos] == 1} { 
          lappend matchL $xPos
          incr prevxPos
        }
        
        set scanRes [scanRanges $xPos $prevxPos]       
        
      } ;#END for x

      #Find consecutive matches in row & take largest
      if [info exists matchL] {
        findRanges $matchL
        unset matchL
       }

       
    } ;#END for y

      #TODO set margintop/marginleft colour tint if no ranges found
      if ![info exists colour::matchArr] {
        setTint $marginleft $margintop
      }
  
  } ;#END evalRowlist
  
  
  # getMatchingRowlist
  ##set rowL array list & rowtotal?
  ##called by evalRowlist + ?getAvLuminance
  proc sortRowlists {} {
    foreach arr [lsort -dictionary [info vars [namespace current]::*]] {
      lappend rowL [namespace tail $arr]
    }
    return $rowL
  }

  proc chooseLongestRange {} {    
      #choose longest range
      if [array exists ranges] {
        foreach name [array names ranges] {
          lassign [array get ranges $name] beg end
          array set matchArr "$name [expr $end - $beg]"
          
        }
      }
      foreach name [array names matchArr] {
        set res [array get matchArr $name]
        append rangeLengthList $res ,
      }
    
    
      set longestRange [expr max($rangeLengthList)]
      
    
  }
  
  #TODO run this only after area coords are clear, will be much easier to program!
  # setAvLuminance
  ##sets average luminance values of pixel arrays of 
  ##A) selected colour area / 
  ##B) margintop+marginleft + 200 pixels in each direction
  ##called by ?
  proc getAvLuminance {} {
    global margintop marginleft
    
    #TODO Make sure 0... values are excluded!
    set rowlist [getMatchingRowlists]
     
    #A) TODO same as B - but define margintop and lmarginleft as starting point 
    #TODO I think you should resort to the already calculated matching ranges for this! s.o.
    if {$rowlist == ""} {
    
      return ? ?
    }
    
    #B)  
    foreach rowArr $rowlist {
      #get pixel array per row
      set arrNames [array names colour::$rowArr]
      
      foreach pixArr $arrNames {
        lappend lumL [lindex [array get pixArr] 1]
      }
    }
    
    set avLuminance [calcAverage $lumL]
    return $avLuminance
    
  } ;#END getAvLuminance
  
    

  # findRanges
  ##finds any suitable colour area(s) per row matchList
  ##puts result in colour::matchArr
  ##called by evalRowlist ?after each X run?    
  proc findRanges {matchL} {
  
  #TODO Testing - nur für 1 Reihe, dann brauchen wir Longest für alle Reihen!!!! 
    array unset ::matchArr
    set end [llength $matchL]
    
    #TODO warum krieg ich 010 ?
    set startIndex [string trimleft [lindex $matchL 0] 0]
    
    #scan through indeces, excluding non-matching 0.. digits
    while {$startIndex < $end } {
      set endIndex [findRange $matchL $startIndex $end]
puts $endIndex      
      
      array set ::matchArr "Beg $startIndex End $endIndex"
      set startIndex [incr endIndex]
    }
  }

  # findRange
  ##finds any subsequent range chunk per matchList
  ##called by findRanges 
  proc findRange {matchL startIndex end} {

    set prevIndex $startIndex
    set currentArr [incr [lindex $startIndex]]
    set currentIndex [incr startIndex]
    
    #Conditions for adding to currentIndex: 
    #A: index before end / B: array doesn't start with 0 / C: difference to previous index is 1
    while {
      $currentIndex < $end &&
      [string index $currentArr 0] != 0 &&
      [expr $currentIndex - $prevIndex] == 1

    } {
puts yesh

      set prevIndex $currentIndex
      
      set currentArr [incr [lindex $currentIndex]]
 #incr currentIndex
    }

    return $currentIndex
  }


} ;#END ::colour namespace




