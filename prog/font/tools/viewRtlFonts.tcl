#!/usr/bin/tclsh
## ~/Biblepix/prog/src/fonts/tools/checkRtlFonts.tcl
## Gathers all available fonts and shows vovelled Arabic OR Hebrew text
## syntax: 'source [file]; then: 'show he' | 'show ar'
## Updated 17apr21 pv

source ~/Biblepix/prog/src/share/globals.tcl
source $BdfBidi
package require Tk

#Setup text widget + scrollbar
pack [text .t -wrap none -yscrollcommand {.sb set}] -side left -fill both -expand 1
pack [scrollbar .sb -command {.t yview} -orient vertical] -side right -fill y

proc show lang {
  set count 0
  set tabwidth 0
  set heT {שִׂימוּ לְבַבְכֶם לְכָל־הַדְּבָרִים}
  set arT {ثُمَّ عَادَ حَيًّا بِالرُّوحِ}

  .t delete 1.0 end
      
  if {$lang == "he"} {
    set t [bidi::fixBidi $heT]
  } elseif {$lang == "ar"} {
    set t [bidi::fixBidi $arT]
  }
  
  foreach family [lsort -dictionary [font families]] {
    .t tag configure f[incr count] -font [list $family 18]
    .t insert end ${family}:\t {} \
    $t f$count  
    set w [font measure [.t cget -font] ${family}:]
    if {$w+5 > $tabwidth} {
      set tabwidth [expr {$w+5}]
      .t configure -tabs $tabwidth
    }
  }
}

