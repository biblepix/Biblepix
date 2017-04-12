# ~/Biblepix/prog/src/share/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 12apr17

set Debug 0

set version "2.3"
set twdurl "http://bible2.net/service/TheWord/twd11/current"
set bpxurl "http://vollmar.ch/bibelpix"
set platform $tcl_platform(platform)
set os $tcl_platform(os)

#Set rootdir from $srcdir as provided by calling progs
proc setRootDir {srcdir} {
	cd $srcdir
	cd ../..
	return [pwd]
}

if { [info exists srcdir] } {
	#set
	set rootdir "[setRootDir $srcdir]"

} else {
	#reset
	if { [info exists env(LOCALAPPDATA)] } {
		set rootdir "[file join $env(LOCALAPPDATA) Biblepix]"
	} else {
		set rootdir "[file join $env(HOME) Biblepix]"
	}
	set srcdir [file join $rootdir prog src]
}


#Set dirnames
set twddir [file join $rootdir Texts]
set sigdir [file join $rootdir Email]
set jpegdir [file join $rootdir Photos]
set imgdir [file join $rootdir Image]
set progdir [file join $rootdir prog]
set confdir [file join $progdir conf]
set bmpdir [file join $progdir bmp]
set piddir [file join $progdir pid]
set windir [file join $progdir win]
set unixdir [file join $progdir unix]
set guidir [file join $srcdir gui]
set maindir [file join $srcdir main]
set sharedir [file join $srcdir share]

#SET ARRAYS FOR DOWNLOAD

#Set filepaths array
array set filepaths "
Readme [file join $rootdir README]
Biblepix [file join $srcdir biblepix.tcl]
Setup [file join $srcdir biblepix-setup.tcl]
Image [file join $maindir image.tcl]
Hgbild [file join $maindir hgbild.tcl]
Textbild [file join $maindir textbild.tcl]
Signature [file join $maindir signature.tcl]
Uninstall [file join $maindir uninstall.tcl]
SetupMainFrame [file join $guidir setupMainFrame.tcl]
SetupBuild [file join $guidir setupBuildGUI.tcl]
SetupDesktop [file join $guidir setupDesktop.tcl]
SetupEmail [file join $guidir setupEmail.tcl]
SetupInternational [file join $guidir setupInternational.tcl]
SetupPhotos [file join $guidir setupPhotos.tcl]
SetupReadme [file join $guidir setupReadme.tcl]
SetupSave [file join $guidir setupSave.tcl]
SetupTerminal [file join $guidir setupTerminal.tcl]
SetupWelcome [file join $guidir setupWelcome.tcl]
Bidi [file join $sharedir bidi.tcl]
Flags [file join $sharedir flags.tcl]
JList [file join $sharedir JList.tcl]
Globals [file join $sharedir globals.tcl]
Http [file join $sharedir http.tcl]
Imgtools [file join $sharedir imgtools.tcl]
Twdtools [file join $sharedir twdtools.tcl]
Setuptools [file join $sharedir setupTools.tcl]
SetupTexts [file join $sharedir setupTexts.tcl]
SetupSaveLin [file join $sharedir setupSaveLin.tcl]
SetupSaveLinHelpers [file join $sharedir setupSaveLinHelpers.tcl]
SetupSaveWin [file join $sharedir setupSaveWin.tcl]
SetupSaveWinHelpers [file join $sharedir setupSaveWinHelpers.tcl ]
Config [file join $confdir biblepix.conf]
Terminal [file join $unixdir term.sh]
"

#Export single filepaths               
foreach i [array names filepaths] {
	set ivalues [array get filepaths $i]
	set name [lindex $ivalues 0]
	set path [lindex $ivalues 1]
	set $name $path
}

#Set JPEGs array
array set jpeglist "
	utah.jpg [file join $jpegdir utah.jpg]
	eire.jpg [file join $jpegdir eire.jpg]
	lake.jpg [file join $jpegdir lake.jpg]
	palms.jpg [file join $jpegdir palms.jpg]
	mountain.jpg [file join $jpegdir mountain.jpg]
	nevada.jpg [file join $jpegdir nevada.jpg]
"

#Set Icons array & export
array set iconlist "
	biblepix.svg [file join $unixdir biblepix.svg] 
	biblepix.ico [file join $windir biblepix.ico]
"
set WinIcon [lindex [array get iconlist biblepix.ico] 1]
set LinIcon [lindex [array get iconlist biblepix.svg] 1]

#Set TWD picture paths
set TwdBMP [file join $imgdir theword.bmp]
set TwdTIF [file join $imgdir theword.tif]
set TwdPNG [file join $imgdir theword.png]

#Set permissible BpFonts LIN+WIN
array set BpFonts {
	{Arial Unicode MS} {}
	{DejaVu Sans} {}
	{New Century Schoolbook} {}
	{Nimbus Mono L} {}
	{Open Sans} {}
	Impact {}
	Lucida {}
	{Liberation Mono} {}
	{Microsoft Sans Serif} {}
	{Lucida Sans Unicode} {}
	Tahoma {}
	Terminus {}
	Verdana {}
}

#Set miscellaneous vars (sourced by various progs)
set datum [clock format [clock seconds] -format %Y-%m-%d]
set jahr [clock format [clock seconds] -format %Y]
set heute [clock format [clock seconds] -format %d]
set tab "                              "
set ind "     "

#Global functions
proc uniqkey { } {
    set key   [ expr { pow(2,31) + [ clock clicks ] } ]
    set key   [ string range $key end-8 end-3 ]
    set key   [ clock seconds ]$key
    return $key
}

proc sleep { ms } {
    set uniq [ uniqkey ]
    set ::__sleep__tmp__$uniq 0
    after $ms set ::__sleep__tmp__$uniq 1
    vwait ::__sleep__tmp__$uniq
    unset ::__sleep__tmp__$uniq
}

# TODO extract to an other file
#Source Config & add defaults to Config if missing
if { [catch {source $Config}] } {
	file mkdir $confdir
}

if { ![info exists lang] } {
	set lang en

   	if {$platform=="windows"} {
		package require registry
		if { ! [catch "set userlang [registry get [join {HKEY_LOCAL_MACHINE System CurrentControlSet Control Nls Language} \\] InstallLanguage]" ] } {
			#code 4stellig, alle Deutsch enden mit 07
			if {  [string range $userlang 2 3] == 07 } {
				set lang de
			}
		}
   	} elseif {$platform=="unix"} {
		if {[info exists env(LANG)] && [string range $env(LANG) 0 1] == "de"} {
				 set lang de
		}
   	}
	set chan [open $Config a]
	puts $chan "set lang $lang"
	close $chan
}

if {![info exists enableintro]} {
	set enableintro 1
	set chan [open $Config a]
	puts $chan "set enableintro $enableintro"
	close $chan
}
if {![info exists enablepic]} {
	set enablepic 1
	set chan [open $Config a]
	puts $chan "set enablepic $enablepic"
	close $chan
}
if {![info exists enablesig]} {
	set enablesig 0
	set chan [open $Config a]
	puts $chan "set enablesig $enablesig"
	close $chan
}
if {![info exists slideshow]} {
	set slideshow 300
	set chan [open $Config a]
	puts $chan "set slideshow $slideshow"
	close $chan
}
#Set fontfamily
if {![info exists fontfamily]} {
	if {$platform=="unix"} {
		set fontfamily {TkTextFont}
	} else {
		set fontfamily {Arial Unicode MS}
	}
	set chan [open $Config a]
	puts $chan "set fontfamily \{$fontfamily\}"
	close $chan
}		 
#Set fontsize (must exist and be digits)
if {![info exists fontsize] || ![regexp {[[:digit:]]} $fontsize] } {
	set fontsize 25
	set chan [open $Config a]
	puts $chan "set fontsize $fontsize"
	close $chan
}
#Set fontweight
if {![info exists fontweight]} {
	if {$platform=="unix"} {
 		set fontweight normal
        } else {
	        set fontweight bold
        }
    set chan [open $Config a]
    puts $chan "set fontweight $fontweight"
    close $chan
}
#Set fontcolortext
if {![info exists fontcolortext]} {
	set fontcolortext blue
	set chan [open $Config a]
	puts $chan "set fontcolortext $fontcolortext"
	close $chan
}
#Set marginleft
if {![info exists marginleft]} {
	set marginleft 30
	set chan [open $Config a]
	puts $chan "set marginleft $marginleft"
	close $chan
}
#Set margintop
if {![info exists margintop]} {
	set margintop 30
	set chan [open $Config a]
	puts $chan "set margintop $margintop"
	close $chan
}

#Define font colours + shade factors
set blue {#483d8b}
set gold {#daa520}
#set green {#005000}
#green changed to green-blue because of bad contrast to most backgrounds
set green {#008d78}
set silver {#707585}
set sunfactor 2.0
set shadefactor 0.6

#Set current font colour
if {$fontcolortext == "blue"} {
	set fontcolor $blue
} elseif {$fontcolortext == "gold"} {
	set fontcolor $gold
} elseif {$fontcolortext == "green"} {
	set fontcolor $green
} elseif {$fontcolortext == "silver"} {
	set fontcolor $silver
} else {
	set fontcolor $blue
}

#Set colours for text image calculation
##background black
set hghex "#000000"
set hgrgb "0 0 0"
##foreground almost black
set fghex "#000001"
set fgrgb "0 0 1"
