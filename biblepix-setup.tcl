#!/usr/bin/env tclsh
# ~/Biblepix/prog/src/biblepix-setup.tcl
# Main Setup program for BiblePix, starts Setup dialogue
# Called by User via Windows/Unix Desktop entry
# If called by BiblePix-Installer, this is the first file downloaded + executed
################################################################################
# Version: 3.0
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 20Okt18

package require Tk

#Verify location & source vars
set rootdir [file dirname [info script]]
set srcdir [file join $rootdir prog src]
set Globals "[file join $srcdir share globals.tcl]"

#Set initial FTP message & progress bar
destroy .updateFrame

frame .updateFrame -padx 40 -pady 50 -borderwidth 20
pack .updateFrame -fill y -expand true

label .updateFrame.pbTitle -justify center -bg lightblue -fg black -borderwidth 10 -textvariable pbTitle
ttk::progressbar .updateFrame.progbar -mode indeterminate -length 200

pack .updateFrame.pbTitle .updateFrame.progbar

if {[catch {source $Globals}]} {
  set pbTitle "Update not possible.\nYou must download and rerun the BiblePix Installer from bible2.net."
  after 7000 {exit}

} else {

  #In case of GIT download: makeDirs
  makeDirs

  #Set initial texts if missing
  if {[catch {source -encoding utf-8 $SetupTexts ; setTexts $lang}]} {
    set updatingHttp "Updating BiblePix program files..."
    set noConnHttp "No connection for BiblePix update. Try later."
  }

  # 1.  D O   H T T P  U P D A T E   (if not initial)

  if {[catch {sourceHTTP}]} {
    set pbTitle "Update not possible.\nYou must download and rerun the BiblePix Installer from bible2.net."
    after 7000 {exit}

  } else {

    .updateFrame.progbar start

    if { [info exists InitialJustDone] } {
      set pbTitle $uptodateHttp

    } else {
      set pbTitle $updatingHttp

      catch {runHTTP 0}
    }

    #Copy photos after first run of Installer or if Config missing
    if { [info exists InitialJustDone] || ![file exists $Config] } {
      set pbTitle "Copying & resizing sample photos..."
      source $SetupTools
      copyAndResizeSamplePhotos
      set pbTitle $uptodateHttp
    }

    catch {source $UpdateInjection}
    .updateFrame.progbar stop
    pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame

    # 2. B U I L D  M A I N  G U I

    source $SetupMainFrame
  }
}
