# ~/Biblepix/prog/src/updateInjection.tcl
# Regulates shift vom version 2.4 to 3.0
# sourced once by biblepix-setup.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 25may21 pv

#Return to Setup if wrong version
if {$version == "2.4"} {

  #Reset progress bar
  pack .updateFrame.pbTitle .updateFrame.progbar
  .updateFrame.progbar start
  set pbTitle $updatingHttp
  set srcdir $srcdir

  # 1 Download new Globals & Http
  set sharedir [file join $srcdir share]
  file mkdir $sharedir
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
  
  # 2 Move any Twd files
  catch {file rename [file join $rootdir Texts] [file join $rootdir BibleTexts]}

  # 3 Delete obsolete directories in rootdir & $srcdir
  set oldDirList ""
  foreach path [glob -directory $rootdir -type d *] {
    lappend oldDirList $path
  }
  foreach path [glob -directory $srcdir -type d *] {
    lappend oldDirList $path
  }

  ##set new directories list for $rootdir
  set newDirList ""
  lappend newDirList [file join $rootdir BibleTexts]
  lappend newDirList [file join $rootdir prog]
  lappend newDirList [file join $rootdir TodaysSignature]
  lappend newDirList [file join $rootdir TodaysPicture]
  lappend newDirList [file join $rootdir Photos]
  lappend newDirList [file join $rootdir Docs]
  ##set new directories list for $srcdir
  lappend newDirList [file join $srcdir share]
  lappend newDirList [file join $srcdir setup]
  lappend newDirList [file join $srcdir sig]
  lappend newDirList [file join $srcdir pic]
  lappend newDirList [file join $srcdir save]
  lappend newDirList [file join $srcdir term]
  
  ##delete obsolete dir paths including all files
  foreach path $oldDirList {
    if {[string first $i $newDirList] == -1} {
      file delete -force $path
    }
  }

  ##delete obsolete single files
  file delete $rootdir/README
  file delete $picdir/hgbild.tcl
  file delete $picdir/textbild.tcl
  file delete $sharedir/BdfBidi.tcl	

  # 4 Exit progbar and return to Setup
  .updateFrame.progbar stop
  pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame
}
