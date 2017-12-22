# ~/Biblepix/progs/src/pic/hgbild.tcl
# Creates background picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15jun2017

source $Imgtools

proc fgbild>hgbild {hgfile bmpfile} {
#Puts text picture on background image, adding Sun & Shade pixels
global Config platform TwdTIF TwdPNG TwdBMP
global  fontcolor fgrgb sun shade

  #Source config to reset marginleft (rtl/ltr)
  source $Config
  puts "Copying text to background picture..."
    
  fgbild blank
  fgbild read $bmpfile
  hgbild blank
  hgbild read $hgfile
  
  
  set screenx [winfo screenwidth .]
  set imgx [image width fgbild]
  set imgy [image height fgbild]
  set bmpname [file tail $bmpfile]
    
  #Reset marginleft for Arabic & Hebrew
  if {  [string range $bmpname 0 1] == "he" ||
    [string range $bmpname 0 1] == "fa" ||
    [string range $bmpname 0 1] == "ar" ||
    [string range $bmpname 0 1] == "ur"
  } {
    set marginleft [expr $screenx-$imgx-$marginleft]
  }

  # 1.Copy sun pixels -1
  for {set x 0; set zx [expr $marginleft - 1]} {$x<$imgx} {incr x; incr zx} {
    for {set y 0; set zy [expr $margintop - 1]} {$y<$imgy} {incr y; incr zy} {
      set colour [fgbild get $x $y]
      if {$colour==$fgrgb} {
        hgbild put $sun -to $zx $zy
      }
    }
  }

  # 2. Copy shade pixels +1
  for {set x 0; set zx [expr $marginleft + 1]} {$x<$imgx} {incr x; incr zx} {
    for {set y 0; set zy [expr $margintop + 1]} {$y<$imgy} {incr y; incr zy} {
      set colour [fgbild get $x $y]
      if {$colour==$fgrgb} {
        hgbild put $shade -to $zx $zy
      }
    }
  }
    
  # 3. Copy fontcolour pixels 0
  for {set x 0; set zx $marginleft} {$x<$imgx} {incr x; incr zx} {
    for {set y 0; set zy $margintop} {$y<$imgy} {incr y; incr zy} {
      set colour [fgbild get $x $y]
      if {$colour==$fgrgb} {
        hgbild put $fontcolor -to $zx $zy
      }
    }
  }
  
  #Save hgbild as TIFF for Win
  if {$platform=="windows"} {  
    hgbild write $TwdTIF -format TIFF
  
  #Save hagbild as PNG & BMP for Unix (KDE/GNOME need 2 for slideshow) 
  } elseif {$platform=="unix"} {
    hgbild write $TwdBMP -format BMP
    hgbild write $TwdPNG -format PNG
  }
      
} ;#end fgbild>hgbild