# ~/Biblepix/prog/src/gui/setupBuildGUI.tcl
# Called by Setup
# Builds complete GUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15dec16

source -encoding utf-8 $SetupTexts
setTexts $lang
source $Setuptools
setFlags
source $Twdtools

#wogehörtdashin?
.b4 config -command {source $SetupSave}

#Create title logo with icon
catch {
package require Img
image create photo Logo -file $WinIcon -format ICO
.ftop.titelmitlogo configure -compound left -image Logo
}

#Set general X vars (some already present from Setup)
#set wWidth 1000
#set wHeight 550
set tw [expr $wWidth - 50] ;#text width
set px 10
set py 10
set bg LightGrey
set fg blue

#Configure Fonts                     ??? -PIXELS ???
font create bpfont1 -family TkTextFont

if {$screenheight < 800} {
	font configure bpfont1 -size 10
} elseif {$screenheight < 1000} {
	font configure bpfont1 -size 11
} else {
	font configure bpfont1 -size 12
}

font create bpfont2 -family TkHeadingFont -size 12 -weight bold
font create bpfont3 -family TkCaptionFont -size 18
#created in Setup
catch {font create bpfont4 -family TkCaptionFont -size 30 -weight bold}



# B U I L D   M A I N   T A G S

# 1. Welcome
catch {source -encoding utf-8 $SetupWelcome}
# source $SetupWelcome
 
# 2. International
catch {source -encoding utf-8 $SetupInternational}
set status [getRemoteTWDFileList]

# 3. Desktop
catch {source -encoding utf-8 $SetupDesktop}
# source $guidir/Desktop.tcl
 
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

