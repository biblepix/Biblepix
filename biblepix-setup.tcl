#!/usr/bin/env tclsh
# ~/Biblepix/biblepix-setup.tcl
# Main Setup program for BiblePix, starts Setup dialogue
# Called by User via Windows/Unix Desktop entry
# If called by BiblePix-Installer, this is the first file downloaded + executed
################################################################################
# Version: 4.0
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 21oct21 pv
package require Tk

#Verify location & source vars
set rootdir "[file dirname [info script]]"
set Globals "[file join $rootdir prog src share globals.tcl]"

#Set initial FTP message & progress bar
destroy .updateFrame
frame .updateFrame -padx 40 -pady 50 -borderwidth 20
pack .updateFrame -fill y -expand true
label .updateFrame.pbTitle -justify center -bg lightblue -fg black -borderwidth 10 -textvar pbTitle
ttk::progressbar .updateFrame.progbar -mode indeterminate -length 200
pack .updateFrame.pbTitle .updateFrame.progbar

append errText {Update not possible! You must download and rerun the BiblePix Installer from www.vollmar.ch/biblepix} \n {Aktualisierung nicht möglich!Sie müssen den BibelPix-Installer herunterladen und neu laufen lassen.}

#Exit if Globals not found
if [catch {source $Globals} res] {
  lappend pbTitle $errText $res
  .updateFrame.pbTitle conf -bg orange
  after 7000 {exit}

} else {

  #Get current version before update
  set curVersion $version

  #In case of GIT download: makeDirs
  makeDirs

  #Set initial texts if missing
  source $SetupTools
  if [info exists lang] {
    set lang $lang
  } {
    set lang en
  }

  if [catch {setTexts $lang}] {
    set updatingHttp "Updating BiblePix program files..."
    set noConnHttp "No connection for BiblePix update."
  } else {
    set updatingHttp $msg::updatingHttp
    set noConnHttp $msg::noConnHttp
  }

  # 1.  D O   H T T P  U P D A T E   (if not initial)
  if [catch {sourceHTTP} res] {
    set pbTitle $errText
    .updateFrame.pbTitle conf -bg orange
    after 7000 {exit}

  } else {

    .updateFrame.progbar start

    if [info exists InitialJustDone] {
      set pbTitle $msg::uptodateHttp
    } else {
      set pbTitle $msg::updatingHttp
      ##start downloading process; $httpError is validated by SetupMainFrame
      catch {runHTTP 0} httpError
    }

    #Copy photos after first run of Installer or if Config missing
    if { [info exists InitialJustDone] || ![file exists $Config] } {
      #source $SetupTexts
      #source $SetupTools
      after idle {
        catch {NewsHandler::QueryNews $msg::resizingPic orange}
        copyAndResizeSamplePhotos
      }
    }
    .updateFrame.progbar stop
    pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame
  }

  # 2. B U I L D  M A I N  G U I
  source $SetupMainFrame

  #Delete any stale program files/fonts/directories/TWD files
  after idle {deleteOldStuff}
}
