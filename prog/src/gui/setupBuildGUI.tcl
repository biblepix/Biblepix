# ~/Biblepix/prog/src/gui/setupBuildGUI.tcl
# Called by Setup
# Builds complete GUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 19nov16

source -encoding utf-8 $SetupTexts
setTexts $lang
source $Imgtools
setFlags
source $Twdtools

#Create title logo with icon
.b4 config -command {source $SetupSave}
set icon $Icon
catch {
package require Img
image create photo Logo -file $icon -format ICO
.ftop.titelmitlogo configure -compound left -image Logo
}

#Set general X vars (some already present from Setup)
#set wWidth 1000
#set wHeight 550
set tw [expr $wWidth - 50] ;#text width
set px 10
set py 10

#set sensible font sizes
if {$screenheight < 800} {
	set f1 "TkTextFont 10"
} elseif {$screenheight < 1000} {
	set f1 "TkTextFont 11"
} else {
	set f1 "TkTextFont 12"
}

set f2 "TkHeadingFont 12 bold"
set f3 "TkCaptionFont 18"
set f4 "TkCaptionFont 30 bold"
set bg LightGrey
set fg blue


# B U I L D   M A I N   T A G S

# 1. Welcome
catch {source -encoding utf-8 $SetupWelcome}

# 2. International
catch {source -encoding utf-8 $SetupInternational}
set status [getRemoteTWDFileList]

# 3. Desktop
catch {source -encoding utf-8 $SetupDesktop}

#4. E-Mail
catch {source -encoding utf-8 $SetupEmail}

#5. Photos
if { [catch {source -encoding utf-8 $SetupPhotos} ] } {
	if { [catch {package require Img} ] } {
	#put warning in Photos tag window
	message .n.f6.warning -pady 50 -justify center -background red -foreground yellow -text $packageRequireImg
	}
}

#6. Terminal
if {$platform=="unix"} {
	catch {source -encoding utf-8 $SetupTerminal}
}

#7. Readme
catch {source -encoding utf-8 $SetupReadme}

