# ~/Biblepix/prog/src/updateInjection.tcl
# Regulates shift vom version 2.4 to 3.0
# sourced once by biblepix-setup.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 3dec18

#Return to Setup if wrong version
if {$version == "2.4"} {

  #Reset progress bar
  pack .updateFrame.pbTitle .updateFrame.progbar
  .updateFrame.progbar start
  set pbTitle $updatingHttp

  # 1 Download new Globals & Http
  set sharedir [file join $::srcdir share]
  file mkdir $::sharedir
  set Globals [file join $sharedir globals.tcl]

  set token [http::geturl $::bpxReleaseUrl/globals.tcl -validate 1]  
  downloadFile [file join $sharedir globals.tcl] globals.tcl $token
  set token [http::geturl $::bpxReleaseUrl/http.tcl -validate 1]
  downloadFile [file join $sharedir http.tcl] http.tcl $token

  source $Globals
  makeDirs
  sourceHTTP
  runHTTP 1
  source $Globals

  # 2 Run SaveWin/SaveLin to install new Setup path
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
  ##set new directories list for $srcdir
  lappend newDirList [file normalize [file join $srcdir share]]
  lappend newDirList [file normalize [file join $srcdir setup]]
  lappend newDirList [file normalize [file join $srcdir sig]]
  lappend newDirList [file normalize [file join $srcdir pic]]
  lappend newDirList [file normalize [file join $srcdir save]]
  ##delete obsolete dir paths including all files
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

  # 4 Exit progbar and return to Setup
  .updateFrame.progbar stop
  pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame
}
