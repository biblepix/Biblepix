# ~/Biblepix/prog/src/setup/setupBuildGUI.tcl
# Called by Setup
# Builds complete GUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2aug21 pv

setFlags
source $TwdTools

set setupTwdFileName [getRandomTwdFile]
if {$setupTwdFileName == ""} {
  set setupTwdText $msg::noTwdFilesFound
} else {
  set setupTwdText [getTodaysTwdText $setupTwdFileName]
}

#Create title logo with icon
if [catch {package require Img} ]  {
  NewsHandler::QueryNews $packageRequireImg red
} else {
  image create photo Logo -file $WinIcon -format ICO
  wm iconphoto . -default Logo
  .ftop.titelmitlogo configure -compound left -image Logo
}

#Configure Fonts
font create bpfont1 -family TkTextFont
if {$wHeight < 700} {
  font configure bpfont1 -size 10
} elseif {$wHeight < 900} {
  font configure bpfont1 -size 11
} else {
  font configure bpfont1 -size 12
}
font create bpfont2 -family TkHeadingFont -size 12 -weight bold
font create bpfont3 -family TkCaptionFont -size 18

#TODO this must be tested for Ar. and Hebrew on all platforms!
font create twdwidgetfont
set avfontsize [font conf bpfont1 -size]
font conf twdwidgetfont -family TkTextFont -size [expr int($avfontsize * 1.3)]
##created later? in Setup
catch {font create bpfont4 -family TkCaptionFont -size 30 -weight bold}


# B U I L D   M A I N   T A G S

# 1. Welcome
if { [info exists Debug] && $Debug } {
  source $SetupWelcome
} else {
  catch {source $SetupWelcome}
}

# 2. International
if { [info exists Debug] && $Debug } {
  source $SetupInternational
} else {
  catch {source $SetupInternational}
}
set status "No Internet connexion"
catch {set status [getRemoteTWDFileList]}
updateTwd

# 3. Desktop
if { [info exists Debug] && $Debug } {
  source $SetupDesktop
} else {
  catch {source $SetupDesktop}
}

#4. E-Mail
if { [info exists Debug] && $Debug } {
  source $SetupEmail
} else {
  catch {source $SetupEmail}
}

#5. Photos
if { [info exists Debug] && $Debug } {
  source $SetupPhotos
} else {

  if [catch {source $SetupPhotos} ] {
    if [catch {package require Img}] {
      NewsHandler::QueryNews $packageRequireImg red
    }
  }
}

#Preset number of photos (to be changed later by proc)
set numPhotos [llength [glob $photosdir/*]]

#6. Terminal
if {$platform=="unix"} {
  if { [info exists Debug] && $Debug } {
    source $SetupTerminal
  } else {
    catch {source $SetupTerminal}
  }
}

#7. Manual
if { [info exists Debug] && $Debug } {
  source $SetupManual
} else {
  catch {source $SetupManual}
}
