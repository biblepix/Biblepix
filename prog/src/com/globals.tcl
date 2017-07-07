# ~/Biblepix/prog/src/com/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 7jul17

# This variable enables the debuging mode in the hole application if set to 1.
set Debug 1

set version "2.4"
set twdUrl "http://bible2.net/service/TheWord/twd11/current"
set bpxReleaseUrl "http://vollmar.ch/bibelpix/release"

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
}

#Set dirnames
set sigDir [file join $rootdir Email]
set exaJpgDir [file join $rootdir ExamplePhotos]
set imgDir [file join $rootdir Image]
set jpegDir [file join $rootdir Photos]
set progDir [file join $rootdir prog]
set twdDir [file join $rootdir Texts]

set bmpdir [file join $progDir bmp]
set confdir [file join $progDir conf]
set piddir [file join $progDir pid]
set srcdir [file join $progDir src]
set unixdir [file join $progDir unix]
set windir [file join $progDir win]

set sharedir [file join $srcdir com]
set guidir [file join $srcdir gui]
set maildir [file join $srcdir sig]
set maindir [file join $srcdir pic]
set savedir [file join $srcdir save]

proc makeDirs {} {
	global sigDir exaJpgDir imgDir jpegDir progDir twdDir bmpdir confdir piddir srcdir unixdir windir sharedir guidir maildir maindir savedir

	file mkdir $sigDir $exaJpgDir $imgDir $jpegDir $progDir $twdDir
	file mkdir $bmpdir $confdir $piddir $srcdir $unixdir $windir
	file mkdir $sharedir $guidir $maildir $maindir $savedir
}

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
set bpxJpegUrl "http://vollmar.ch/bibelpix/jpeg"
array set exaJpgArray "
	utah.jpg [file join $exaJpgDir utah.jpg]
	eire.jpg [file join $exaJpgDir eire.jpg]
	lake.jpg [file join $exaJpgDir lake.jpg]
	palms.jpg [file join $exaJpgDir palms.jpg]
	mountain.jpg [file join $exaJpgDir mountain.jpg]
	nevada.jpg [file join $exaJpgDir nevada.jpg]
"

#Set Icons array & export
set bpxIconUrl "http://vollmar.ch/bibelpix"
array set iconArray "
	biblepix.svg [file join $unixdir biblepix.svg] 
	biblepix.ico [file join $windir biblepix.ico]
"

set WinIcon [lindex [array get iconArray biblepix.ico] 1]
set LinIcon [lindex [array get iconArray biblepix.svg] 1]

#Set TWD picture paths
set TwdBMP [file join $imgDir theword.bmp]
set TwdTIF [file join $imgDir theword.tif]
set TwdPNG [file join $imgDir theword.png]

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

#Define font colours & sun/shade factors
set gold #daa520
set silver #707585
set blue #4682b4
set green #2e8b57
set sunfactor 2.0
set shadefactor 0.6

#Set colours for text image calculation
##background black
set hghex "#000000"
set hgrgb "0 0 0"
##foreground almost black
set fghex "#000001"
set fgrgb "0 0 1"

source $LoadConfig