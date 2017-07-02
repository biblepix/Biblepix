# ~/Biblepix/prog/src/com/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 2jul17

# This variable enables the debuging mode in the hole application if set to 1.
set Debug 1

set version "2.4"
set twdurl "http://bible2.net/service/TheWord/twd11/current"
set bpxurl "http://vollmar.ch/bibelpix"
set platform $tcl_platform(platform)
set os $tcl_platform(os)
set tclpath [auto_execok tclsh]
set wishpath [auto_execok wish]

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
set maildir [file join $srcdir sig]
set maindir [file join $srcdir pic]
set sharedir [file join $srcdir com]
set savedir [file join $srcdir save]

#SET ARRAYS FOR DOWNLOAD

if { $Debug } {
	set Http [file join $sharedir httpMock.tcl]
} else {
	set Http [file join $sharedir http.tcl]
}

#Set filepaths array
array set filepaths "
Readme [file join $rootdir README]
Biblepix [file join $srcdir biblepix.tcl]
Setup [file join $srcdir biblepix-setup.tcl]
Image [file join $maindir image.tcl]
Hgbild [file join $maindir hgbild.tcl]
Textbild [file join $maindir textbild.tcl]
SetupMainFrame [file join $guidir setupMainFrame.tcl]
SetupBuild [file join $guidir setupBuildGUI.tcl]
SetupDesktop [file join $guidir setupDesktop.tcl]
SetupEmail [file join $guidir setupEmail.tcl]
SetupInternational [file join $guidir setupInternational.tcl]
SetupPhotos [file join $guidir setupPhotos.tcl]
SetupReadme [file join $guidir setupReadme.tcl]
SetupTerminal [file join $guidir setupTerminal.tcl]
SetupWelcome [file join $guidir setupWelcome.tcl]
Setuptools [file join $guidir setupTools.tcl]
SetupTexts [file join $guidir setupTexts.tcl]
SetupSave [file join $savedir setupSave.tcl]
SetupSaveLin [file join $savedir setupSaveLin.tcl]
SetupSaveLinHelpers [file join $savedir setupSaveLinHelpers.tcl]
SetupSaveWin [file join $savedir setupSaveWin.tcl]
SetupSaveWinHelpers [file join $savedir setupSaveWinHelpers.tcl ]
Bidi [file join $sharedir bidi.tcl]
Flags [file join $sharedir flags.tcl]
JList [file join $sharedir JList.tcl]
Globals [file join $sharedir globals.tcl]
Imgtools [file join $sharedir imgtools.tcl]
LoadConfig [file join $sharedir LoadConfig.tcl]
Twdtools [file join $sharedir twdtools.tcl]
Uninstall [file join $sharedir uninstall.tcl]
Signature [file join $maildir signature.tcl]
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

#Source Config or LoadConfig for defaults
if { [catch {source $Config}] } {
	file mkdir $confdir
	source $LoadConfig
}

#Define font colours & sun/shade factors
set gold #daa520
set silver #707585
set blue #4682b4
set green #2e8b57
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
