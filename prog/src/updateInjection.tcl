# ~/Biblepix/prog/src/updateInjection.tcl
# Regulates shift vom version 2.4 to 3.0
# sourced once by biblepix-setup.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 27nov18

##TODO: This file is not functional yet!
##Check HTTP(s) AND integration with biblepix-setup.tcl 

#Return to Setup if wrong version
if {$version != 2.4} {
  return 1
}

#Reset progress bar
pack .updateFrame.pbTitle .updateFrame.progbar
.updateFrame.progbar start
set pbTitle $updatingHttp

# 1 Download and source new Globals
set token [http::geturl $::bpxReleaseUrl/globals.tcl -validate 1]
set sharedir [file join $::srcdir share]
file mkdir $::sharedir
set Globals [file join $sharedir globals.tcl]
downloadFile [file join $sharedir globals.tcl] globals.tcl $token

# Download new http.tcl
set token [http::geturl $::bpxReleaseUrl/http.tcl -validate 1]
downloadFile [file join $sharedir http.tcl] http.tcl $token

source $Globals
makeDirs
sourceHTTP
runHTTP 0
source $Globals

# 2 Run SaveLin/SaveLin to install new Setup path
##TODO: below needs to be tested & completed!
if {$os=="Linux"} {
  set token1 $SaveLin
  set token2 $SaveLinHelpers
} else {
  set token1 $SaveWin
  set token2 $SaveWinHelpers
}

downloadFile ... $token1
downloadFile ... $token2

if {$os=="Linux"} {
  source $SaveLinHelpers
  setupLinMenu
} else {
  source $SaveWinHelpers
  setWinContextMenu
}


# 3 Delete obsolete directories in rootdir & $srcdir

##set current directories list
lappend oldDirList [file normalize [glob -directory $rootdir -type d *]]
lappend oldDirList [file normalize [glob -directory $srcdir -type d *]]
##set new directories list for $rootdir
lappend newDirList [file normalize [file join $rootdir prog]]
lappend newDirList [file normalize [file join $rootdir TodaysSignature]]
lappend newDirList [file normalize [file join $rootdir TodaysPicture]]
lappend newDirList [file normalize [file join $rootdir Photos]]
lappend newDirList [file normalize [file join $rootdir BibleTexts]]
lappend newDirList [file normalize [file join $rootdir Docs]]
## for $srcdir
lappend newDirList [file normalize [file join $srcdir share]]
lappend newDirList [file normalize [file join $srcdir setup]]
lappend newDirList [file normalize [file join $srcdir sig]]
lappend newDirList [file normalize [file join $srcdir pic]]
lappend newDirList [file normalize [file join $srcdir save]]
"
##delete obsolete dir paths including files
foreach dirpath $oldDirList {
  if { ![string match *$dirpath* $newDirList]} {
    file delete -force $dirpath
  }
}
##delete obsolete single files
file delete $rootdir/README
file delete $srcdir/biblepix-setup.tcl
file delete $picdir/hgbild.tcl
file delete $picdir/textbild.tcl

#Exit progbar and return to Setup
.updateFrame.progbar stop
pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame
