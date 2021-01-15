# ~/Biblepix/prog/src/share/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 2jan21 pv
set version "3.2"
set twdUrl "https://bible2.net/service/TheWord/twd11/current"
set twdBaseUrl "https://bible2.net/service/TheWord/twd11"
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
set progdir [file join $rootdir prog]
set srcdir [file join $progdir src]
array set dirlist "
  confdir [file join $progdir conf]
  docdir [file join $rootdir Docs]
  fontdir [file join $progdir font]
  imgdir [file join $rootdir TodaysPicture]
  maildir [file join $srcdir sig]
  photosDir [file join $rootdir Photos] 
  picdir [file join $srcdir pic]
  progdir [file join $rootdir prog]
  piddir [file join $progdir pid]
  savedir [file join $srcdir save]
  sampleJpgDir [file join $srcdir pic SamplePhotos]
  setupdir [file join $srcdir setup]
  sharedir [file join $srcdir share]
  sigdir [file join $rootdir TodaysSignature]
  srcdir [file join $progdir src]
  termdir [file join $srcdir term]
  twdDir [file join $rootdir BibleTexts]
  unixdir [file join $progdir unix]
  windir [file join $progdir win]
"
#Export single dir names
foreach i [array names dirlist] {
  set ivalues [array get dirlist $i]
  set name [lindex $ivalues 0]
  set path [lindex $ivalues 1]
  set $name $path
}

# makeDirs - TODO: why needed?
##called by Installer & UpdateInjection
proc makeDirs {} {
  global dirlist
  foreach dir [array names dirlist] {
    file mkdir $dirlist($dir)
  }
}

#Set FilePaths array
array set FilePaths "
  AnnotatePng [file join $picdir annotatePng.tcl]
  Globals [file join $sharedir globals.tcl]
  Http [file join $sharedir http.tcl]
  UpdateInjection [file join $srcdir updateInjection.tcl]
  Readme [file join $rootdir README.txt]
  Setup [file join $rootdir biblepix-setup.tcl]
  ManualD [file join $docdir MANUAL_de.txt]
  ManualE [file join $docdir MANUAL_en.txt]
  Biblepix [file join $srcdir biblepix.tcl]
  BdfTools [file join $picdir BdfTools.tcl]
  BdfPrint [file join $picdir BdfPrint.tcl]
  BdfBidi [file join $sharedir BdfBidi.tcl]
  Image [file join $picdir image.tcl]
  ImageAngle [file join $picdir ImageAngle.tcl]
  RotateTools [file join $picdir RotateTools.tcl]
  ScanColourArea [file join $picdir scanColourArea.tcl]
  SetBackgroundChanger [file join $picdir setBackgroundChanger.tcl]
  SetupMainFrame [file join $setupdir setupMainFrame.tcl]
  SetupBuild [file join $setupdir setupBuildGUI.tcl]
  SetupDesktop [file join $setupdir setupDesktop.tcl]
  SetupDesktopPng [file join $setupdir setupDesktop.png]
  SetupEmail [file join $setupdir setupEmail.tcl]
  SetupInternational [file join $setupdir setupInternational.tcl]
  SetupPhotos [file join $setupdir setupPhotos.tcl]
  SetupManual [file join $setupdir setupManual.tcl]
  SetupResizePhoto [file join $setupdir setupResizePhoto.tcl]
  SetupResizeTools [file join $setupdir setupResizeTools.tcl]
  SetupRotate [file join $setupdir setupRotate.tcl]
  SetupTerminal [file join $setupdir setupTerminal.tcl]
  SetupWelcome [file join $setupdir setupWelcome.tcl]
  SetupTools [file join $setupdir setupTools.tcl]
  SetupTexts [file join $setupdir setupTexts.tcl]
  SetupSave [file join $savedir save.tcl]
  SetupSaveLin [file join $savedir saveLin.tcl]
  SetupSaveLinHelpers [file join $savedir saveLinHelpers.tcl]
  SetupSaveWin [file join $savedir saveWin.tcl]
  SetupSaveWinHelpers [file join $savedir saveWinHelpers.tcl]
  Flags [file join $sharedir flags.tcl]
  Http [file join $sharedir http.tcl]
  HttpMock [file join $sharedir httpMock.tcl]
  JList [file join $sharedir JList.tcl]
  ImgTools [file join $picdir ImageTools.tcl]
  LoadConfig [file join $sharedir LoadConfig.tcl]
  TwdTools [file join $sharedir TwdTools.tcl]
  Uninstall [file join $savedir uninstall.tcl]
  Signature [file join $maildir signature.tcl]
  SigTools [file join $maildir SigTools.tcl]
  Config [file join $confdir biblepix.conf]
  Terminal [file join $termdir terminal.tcl]
  TerminalShell [file join $unixdir term.sh]
"
#Export single FilePaths
foreach i [array names FilePaths] {
  set ivalues [array get FilePaths $i]
  set name [lindex $ivalues 0]
  set path [lindex $ivalues 1]
  set $name $path
}

#Set sample JPEG array
set bpxJpegUrl "http://vollmar.ch/biblepix/jpeg"
array set sampleJpgArray "
  utah.jpg [file join $sampleJpgDir) utah.jpg]
  eire.jpg [file join $sampleJpgDir) eire.jpg]
  lake.jpg [file join $sampleJpgDir) lake.jpg]
  palms.jpg [file join $sampleJpgDir) palms.jpg]
  mountain.jpg [file join $sampleJpgDir) mountain.jpg]
  nevada.jpg [file join $sampleJpgDir) nevada.jpg]
"

#Set Icons array & export
set bpxIconUrl "http://vollmar.ch/biblepix"
array set iconArray "
  biblepix.png [file join $unixdir biblepix.png]
  biblepix.ico [file join $windir biblepix.ico]
"

#Set font size list (in pts)
set fontSizeList {16 20 26 32}

#Set fonts array
foreach ptsize $fontSizeList {
  array set BdfFontPaths "
    Arial${ptsize}  [file join $fontdir Arial${ptsize}.tcl]
    ArialI${ptsize} [file join $fontdir ArialI${ptsize}.tcl]
    ArialB${ptsize} [file join $fontdir ArialB${ptsize}.tcl]
    Times${ptsize}  [file join $fontdir Times${ptsize}.tcl]
    TimesI${ptsize} [file join $fontdir TimesI${ptsize}.tcl]
    TimesB${ptsize} [file join $fontdir TimesB${ptsize}.tcl]
  "
}
#Add Asian fonts to array (1 size!)
array set BdfFontPaths "
  ChinaFont [file join $fontdir asian WenQuanYi_ZenHei_24.tcl]
  ThaiFont [file join $fontdir asian Kinnari_Bold_20.tcl]
"

set WinIcon [lindex [array get iconArray biblepix.ico] 1]
set LinIcon [lindex [array get iconArray biblepix.png] 1]

#Set TWD picture paths
set TwdBMP [file join $imgdir theword.bmp]
set TwdTIF [file join $imgdir theword.tif]
set TwdPNG [file join $imgdir theword.png]

#Miscellaneous vars (sourced by various progs)
set datum [clock format [clock seconds] -format %Y-%m-%d]
set jahr [clock format [clock seconds] -format %Y]
set heute [clock format [clock seconds] -format %d]
set tab "                              "
set ind "     "

#Define font colour rgb arrays
array set BlackArr   {r 6 g 6 b 6}
array set GoldArr    {r 255 g 155 b 0}
array set SilverArr  {r 192 g 192 b 192}
array set BlueArr    {r 0 g 190 b 255}
array set GreenArr   {r 60 g 185 b 120}
#Define colour computing values
set sunfactor 1.8
set shadefactor 0.6
set lumThreshold 85

#Bildformate & DesktopPicturesDir
if {$platform == "unix"} {
  set HOME $env(HOME)
  #DesktopPicturesDir changes with languages > variable in Config & switch in LoadConfig
  set types {
    { {Image Files} {.jpg .jpeg .JPG .JPEG .png .PNG} }
  }

} elseif {$platform == "windows"} {
  #DesktopPicturesDir is always "Pictures"
  set DesktopPicturesDir $env(USERPROFILE)/Pictures
  set types {
    { {Image Files} {.jpg .jpeg .png} }
  }
}

  #-----------------------------------------------------------------------------
  # Show.Modal win ?-onclose script? ?-destroy bool?
  #
  # Displays $win as a modal dialog. 
  #
  # If -destroy is true then $win is destroyed when the dialog is closed. 
  # Otherwise the caller must do it. 
  #
  # If an -onclose script is provided, it is executed if the user terminates the 
  # dialog through the window manager (such as clicking on the [X] button on the 
  # window decoration), and the result of that script is returned. The default 
  # script does nothing and returns an empty string. 
  #
  # Otherwise, the dialog terminates when the global ::Modal.Result is set to a 
  # value. 
  #
  # This proc doesn't play nice if you try to have more than one modal dialog 
  # active at a time. (Don't do that anyway!)
  #
  # Examples:
  #   -onclose {return cancel}    -->    Show.Modal returns the word 'cancel'
  #   -onclose {list 1 2 3}       -->    Show.Modal returns the list {1 2 3}
  #   -onclose {set ::x zap!}     -->    (variations on a theme)
  #
  # source: https://wiki.tcl-lang.org/page/Modal+dialogs

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

#Debug & HttpMock
if { [info exists Debug] && $Debug && [info exists Httpmock] && $Httpmock} {
  proc sourceHTTP {} {
    source $::Http
    source $::HttpMock
  }
} else {
  proc sourceHTTP {} {
    source $::Http
  }
}

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

catch {source $LoadConfig}
