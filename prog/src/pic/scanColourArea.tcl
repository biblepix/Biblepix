# ~/Biblepix/prog/src/pic/scanColourArea.tcl
# Determines suitable even-coloured text area & colour tint for text
# Sourced by SetupResizePhoto 
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 21may20 pv

#Create small pic from resize canv pic
source $ImgTools
set c .resizePhoto.resizeCanv
set img [image create photo reposCanvSmallPic]
lassign [getCanvSection $c] x1 y1 x2 y2
$img copy resizeCanvPic -subsample 3 -from $x1 $y1 $x2 $y2 

#TODO :uncomment:
#catch {namespace delete colour}

namespace eval colour {}
namespace eval colour::rowarrays {}
namespace eval colour::rowarrays::lum {}

#Create vars for small pic -- TODO move some to Globals?
set colour::img $img
set colour::imgX [image width $img]
set colour::imgY [image height $img]
set colour::minWidth [expr [image width $img] / 5]
set colour::maxHeight [expr [image height $img] / 5]
set colour::colourTol 10
set colour::margin 10
set colour::realWidth [expr $colour::imgX - (2 * $margin)]

namespace eval colour { 

  # scanColourArea    
  ##scans image by desired height
  ##runs scanRow for each line
  proc scanColourArea {} {

    global colour::img
    global colour::margin
    global colour::colourTol
        
    #Limit scanning area by excluding margins
    set begX $margin
    set endX [expr $colour::imgX - $margin]
    set begY $margin
    set endY [expr $colour::imgY - $margin]

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
        set diffr [expr abs([expr $curCArr(r) - $prevCArr(r)])]
        set diffg [expr abs([expr $curCArr(g) - $prevCArr(g)])]
        set diffb [expr abs([expr $curCArr(b) - $prevCArr(b)])]

        array set prevCArr "r $r g $g b $b"

        #add 0 in front of xPos if not matching
        if { $diffr > $colourTol ||
             $diffg > $colourTol ||
             $diffb > $colourTol
        } {
          set xPosValue 0
        } else {
          set xPosValue 1
        }

        #add xPosValue + luminance to match array
        array set rowarrays::$yPos [list $xPos $xPosValue]

        #Add consecutive pixelPositions to 1 matchlist per row
        set lumCode [setLuminanceCode prevCArr]
        array set rowarrays::lum::$yPos [list $xPos $lumCode]

      } ;#END x loop

#puts [array names [namespace current]::rowarrays::$yPos]

    } ;#END y loop
  
  } ;# END scanColourArea

  # findRanges
  ##finds any suitable colour area(s) per row matchList
  ##puts result in colour::matcharrays::$yPos array
  ##called by processPngComment in setupResize
  proc findRanges {} {
    global colour::realWidth
    
    #get unsorted row list - each row has the complete path!
    set rowL [info vars [namespace current]::rowarrays::*]

    foreach row $rowL {
puts $row

      set startIndex 0

      #scan through x indices
      while {$startIndex < $colour::realWidth} {

        set endIndex [findRange $row $startIndex]
        set rangeWidth [expr $endIndex - $startIndex]

        if {$rangeWidth >= $minWidth} {
 puts yesh2
         
          #put startIndex + length in temporary array
          array set matchArr [list $startIndex $rangeWidth]
        
 puts [parray matchArr]
        }

        set startIndex [incr endIndex]
      } ;#END while
      

      #Find startIndex of longest row
      if [array exists matchArr] {
        set maxLength 0
        foreach {startIndex length} [array get matchArr] {
          if {$length > $maxLength} {
            set maxLength $length
            set selectedStartIndex $startIndex
          }
        }

        #make allMatchesArray with $selected beginnings (to be sorted later)
        set yPos [namespace tail $row]
        array set [namespace current]::matchArr [list $yPos $selectedBeg]
      }
    } ;#END foreach row
  } ;#END findRanges

  # findRange
  ##finds any subsequent range chunk per matchList
  ##called by findRanges 
  proc findRange {row startIndex} {
    global colour::realWidth

    set zeroFound 0
    set currIndex $startIndex
    while {!$zeroFound && $currIndex < $colour::realWidth} {
      if ![lindex [array get $row $currIndex] 1] {
        set zeroFound 1
      }

      incr currIndex
    }

    return $currIndex
  } ;#END findRange
   
# doColourScan 
  ##wraps up all scanning processes
  ##outputs xPos+yPos+luminance to calling prog
  ##called by ?
  proc doColourScan {c} {
    source $::ImgTools
     
#    #1. Create small pic for scanning
#    image create photo reposCanvSmallPic
#    lassign [getCanvSection $c] x1 y1 x2 y2
#    reposCanvSmallPic copy resizeCanvPic -subsample 3 -from $x1 $y1 $x2 $y2 
    
    #2. run scanColourArea + create colour::rowarrays ns
    scanColourArea
    
    #3. run sortrowarrays & findRanges + create colour::matcharrays ns
    foreach arr [info vars [array current]::rowarrays::*] {
        set rowL [namespace tail $arr]
    }
    foreach y $rowL {
      set rangeList [findRanges $y]
    }  
    
    #4. Do some evaluation & return xPos, yPos + luminance
    if {$rangeList != ""} { ... }
    
    
        
    #TODO move below to another proc
      proc otherproc {} {
        #A) set to new if found
        #TODO evaluate number of matchlist > write some proc!
        if [?evalmatcharrays] {
          $c move text ..
          $c itemconf text -fg ...
        
        #B) set to standard if none found
        } else {
          $c move text ..
          $c itemconf text -fg ..
        }
      }
  }

} ;#END ::colour namespace



#######################################################################
########## O B S O L E T E ############################################
#######################################################################

# sortrowarrays
  ##set rowL array list & rowtotal?
  ##called by ?resetTextPos+TextColour
  proc sortrowarrays {} {
    namespace eval rowarrays {
      foreach arr [lsort -dictionary [info vars [namespace current]::*]] {
        lappend colour::rowL [namespace tail $arr]
      }
# return $rowL
    }
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
    set rowlist [getMatchingrowarrays]
     
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
  
  

