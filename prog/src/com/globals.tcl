# ~/Biblepix/prog/src/com/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 28feb18

# This variable enables Debugging Mode in the whole application if set to 1.
set Debug 0
set Mocking 0

set version "2.4.1"
set twdUrl "http://bible2.net/service/TheWord/twd11/current"
set bpxReleaseUrl "http://vollmar.ch/biblepix/release"

set platform $tcl_platform(platform)
set os $tcl_platform(os)
set tclpath [auto_execok tclsh]
set wishpath [auto_execok wish]

if { [info exists srcdir] } {
  #set
  set rootdir "[file dirname [file dirname [file normalize $srcdir ]]]"  
} else {
  #reset
  if { [info exists env(LOCALAPPDATA)] } {
    set rootdir "[file join $env(LOCALAPPDATA) Biblepix]"
  } else {
    set rootdir "[file join $env(HOME) Biblepix]"
  }
}

#S e t   d i r n a m e s
set sigDir [file join $rootdir Email]
set sampleJpgDir [file join $rootdir SamplePhotos]
set imgDir [file join $rootdir Image]

#TODO: jpegDir > photosDir
set photosDir [file join $rootdir Photos]
set jpegDir $photosDir

set progDir [file join $rootdir prog]
set twdDir [file join $rootdir Texts]

set bmpdir [file join $progDir bmp]
set confdir [file join $progDir conf]
set fontdir [file join $progDir font]
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
  global sigDir sampleJpgDir imgDir jpegDir progDir twdDir bmpdir confdir piddir srcdir unixdir windir sharedir guidir maildir maindir savedir
  file mkdir $sigDir $imgDir $jpegDir $sampleJpgDir $progDir $twdDir
  file mkdir $bmpdir $confdir $piddir $srcdir $unixdir $windir
  file mkdir $sharedir $guidir $maildir $maindir $savedir
}

#SET ARRAYS FOR DOWNLOAD

#Set filepaths array
array set filepaths "
  Readme [file join $rootdir README.txt]
  UpdateInjection [file join $srcdir updateInjection.tcl]
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
  SetupResizePhoto [file join $guidir setupResizePhoto.tcl]
  SetupTerminal [file join $guidir setupTerminal.tcl]
  SetupWelcome [file join $guidir setupWelcome.tcl]
  Setuptools [file join $guidir setupTools.tcl]
  SetupTexts [file join $guidir setupTexts.tcl]
  TestBildGUI [file join $guidir testbild.png]
  SetupSave [file join $savedir setupSave.tcl]
  SetupSaveLin [file join $savedir setupSaveLin.tcl]
  SetupSaveLinHelpers [file join $savedir setupSaveLinHelpers.tcl]
  SetupSaveWin [file join $savedir setupSaveWin.tcl]
  SetupSaveWinHelpers [file join $savedir setupSaveWinHelpers.tcl]
  Bidi [file join $sharedir bidi.tcl]
  Flags [file join $sharedir flags.tcl]
  Http [file join $sharedir http.tcl]
  JList [file join $sharedir JList.tcl]
  Globals [file join $sharedir globals.tcl]
  Imgtools [file join $sharedir imgtools.tcl]
  LoadConfig [file join $sharedir LoadConfig.tcl]
  Twdtools [file join $sharedir twdtools.tcl]
  Uninstall [file join $savedir uninstall.tcl]
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

if { $Debug && $Mocking} {
  set Http [file join $sharedir httpMock.tcl]
} else {
  set Http [file join $sharedir http.tcl]
}

#Set JPEGs array
set bpxJpegUrl "http://vollmar.ch/biblepix/jpeg"
array set sampleJpegArray "
  utah.jpg [file join $sampleJpgDir utah.jpg]
  eire.jpg [file join $sampleJpgDir eire.jpg]
  lake.jpg [file join $sampleJpgDir lake.jpg]
  palms.jpg [file join $sampleJpgDir palms.jpg]
  mountain.jpg [file join $sampleJpgDir mountain.jpg]
  nevada.jpg [file join $sampleJpgDir nevada.jpg]
"

#Set Icons array & export
set bpxIconUrl "http://vollmar.ch/biblepix"
array set iconArray "
  biblepix.png [file join $unixdir biblepix.png] 
  biblepix.ico [file join $windir biblepix.ico]
"

set WinIcon [lindex [array get iconArray biblepix.ico] 1]
set LinIcon [lindex [array get iconArray biblepix.png] 1]

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

#TODO: These Tk VARS don-t belong HERE, biblepix.tcl must run outside of Tk, these are Setup vars that must reside somewhere else!
#set screenX [winfo screenwidth .]
#set screenY [winfo screenheight .]
#set factor [expr $screenX./$screenY]
#set photosCanvX 650
#set photosCanvY [expr round($photosCanvX/$factor)]
#set photosCanvMargin 6

#Global functions
proc uniqkey {} {
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

#Bildformate & DesktopPicturesDir
if {$platform == "unix"} {
  set HOME $env(HOME)
  set types {
    { {Image Files} {.jpg .jpeg .JPG .JPEG .png .PNG} }
  }
  #General Im(age) | Bil(der) etc.
  if {![catch {glob Im*} res] || ![catch {glob Bil*} res]} {
    set DesktopPicturesDir $HOME/$res  
  #ru
  } elseif { [file exists $HOME/Снимки] } {
    set DesktopPicturesDir $HOME/Снимки
  #hu
  } elseif { [file exists $HOME/Képek] } {
    set DesktopPicturesDir $HOME/Képek
  #tr
  } elseif { [file exists $HOME/Resimler] } {
    set DesktopPicturesDir $HOME/Resimler
  #ar صور 
  } elseif { [file exists [file join $HOME صور ]] } {
    set DesktopPicturesDir "[file join $HOME صور ]"
  #zh 图片
  } elseif { [file exists [file join $HOME 图片 ]] } {
    set DesktopPicturesDir "[file join $HOME 图片 ]"
  #all else: set to $HOME
  } else {  
    set DesktopPicturesDir $HOME
  }
  
} elseif {$platform == "windows"} {
  #DesktopPicturesDir is always "Pictures"
  set DesktopPicturesDir $env(USERPROFILE)/Pictures
  set types {
    { {Image Files} {.jpg .jpeg .png} }
  }
}

proc Show.Modal {win args} {
  set ::Modal.Result {}
  array set options [list -onclose {} -destroy 0 {*}$args]
  wm transient $win .
  wm protocol $win WM_DELETE_WINDOW [list catch $options(-onclose) ::Modal.Result]
  set x [expr {([winfo width  .] - [winfo reqwidth  $win]) / 2 + [winfo rootx .]}]
  set y [expr {([winfo height .] - [winfo reqheight $win]) / 2 + [winfo rooty .]}]
  wm geometry $win +$x+$y
  raise $win
  focus $win
  grab $win
  tkwait variable ::Modal.Result
  grab release $win
  if {$options(-destroy)} {destroy $win}
  return ${::Modal.Result}
}

catch {source $LoadConfig}
