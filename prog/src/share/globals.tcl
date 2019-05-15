# ~/Biblepix/prog/src/share/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 10may19
set version "3.1"
set twdUrl "https://bible2.net/service/TheWord/twd11/current"
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
array set dirlist "
  sigDir [file join $rootdir TodaysSignature]
  imgDir [file join $rootdir TodaysPicture]
  photosDir [file join $rootdir Photos]
  progDir [file join $rootdir prog]
  twdDir [file join $rootdir BibleTexts]
  docDir [file join $rootdir Docs]
  confdir [file join $progDir conf]
  fontdir [file join $progDir font]
  piddir [file join $progDir pid]
  srcdir [file join $progDir src]
  unixdir [file join $progDir unix]
  windir [file join $progDir win]
  sharedir [file join $srcdir share]
  guidir [file join $srcdir setup]
  maildir [file join $srcdir sig]
  picdir [file join $srcdir pic]
  savedir [file join $srcdir save]
  sampleJpgDir [file join $picdir SamplePhotos]
  termdir [file join $srcdir term]
"

# makeDirs - TODO: why needed?
##called by Installer & UpdateInjection
proc makeDirs {} {
  file mkdir $::sigDir $::imgDir $::jpegDir $::sampleJpgDir $::progDir $::twdDir $::docDir
  file mkdir $::confdir $::piddir $::srcdir $::unixdir $::windir
  file mkdir $::sharedir $::guidir $::maildir $::picdir $::savedir
  if {$::platform=="unix"} {
    file mkdir $::termdir
  }
}

#SET ARRAYS FOR DOWNLOAD

#Set FilePaths array
array set FilePaths "
  Globals [file join $sharedir globals.tcl]
  Http [file join $sharedir http.tcl]
  UpdateInjection [file join $srcdir updateInjection.tcl]
  Readme [file join $rootdir README.txt]
  Setup [file join $rootdir biblepix-setup.tcl]
  ManualD [file join $docDir MANUAL_de.txt]
  ManualE [file join $docDir MANUAL_en.txt]
  Biblepix [file join $srcdir biblepix.tcl]
  BdfTools [file join $picdir BdfTools.tcl]
  BdfPrint [file join $picdir BdfPrint.tcl]
  BdfBidi [file join $sharedir BdfBidi.tcl]
  Image [file join $picdir image.tcl]
  SetBackgroundChanger [file join $picdir setBackgroundChanger.tcl]
  SetupMainFrame [file join $guidir setupMainFrame.tcl]
  SetupBuild [file join $guidir setupBuildGUI.tcl]
  SetupDesktop [file join $guidir setupDesktop.tcl]
  SetupDesktopPng [file join $guidir setupDesktop.png]
  SetupEmail [file join $guidir setupEmail.tcl]
  SetupInternational [file join $guidir setupInternational.tcl]
  SetupPhotos [file join $guidir setupPhotos.tcl]
  SetupReadme [file join $guidir setupReadme.tcl]
  SetupResizePhoto [file join $guidir setupResizePhoto.tcl]
  SetupTerminal [file join $guidir setupTerminal.tcl]
  SetupWelcome [file join $guidir setupWelcome.tcl]
  SetupTools [file join $guidir setupTools.tcl]
  SetupTexts [file join $guidir setupTexts.tcl]
  SetupSave [file join $savedir save.tcl]
  SetupSaveLin [file join $savedir saveLin.tcl]
  SetupSaveLinHelpers [file join $savedir saveLinHelpers.tcl]
  SetupSaveWin [file join $savedir saveWin.tcl]
  SetupSaveWinHelpers [file join $savedir saveWinHelpers.tcl]
  Flags [file join $sharedir flags.tcl]
  Http [file join $sharedir http.tcl]
  HttpMock [file join $sharedir httpMock.tcl]
  JList [file join $sharedir JList.tcl]
  ImgTools [file join $sharedir imgTools.tcl]
  LoadConfig [file join $sharedir LoadConfig.tcl]
  TwdTools [file join $sharedir TwdTools.tcl]
  Uninstall [file join $savedir uninstall.tcl]
  Signature [file join $maildir signature.tcl]
  SigTrojita [file join $maildir sigTrojita.tcl]
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
set TwdBMP [file join $imgDir theword.bmp]
set TwdTIF [file join $imgDir theword.tif]
set TwdPNG [file join $imgDir theword.png]

#Miscellaneous vars (sourced by various progs)
set datum [clock format [clock seconds] -format %Y-%m-%d]
set jahr [clock format [clock seconds] -format %Y]
set heute [clock format [clock seconds] -format %d]
set tab "                              "
set ind "     "

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

#Define font colours & colour computing values
set gold #ff9b00
set silver #c0c0c0
set blue #00bfff
set green #3cb978
set brightnessThreshold 170
set sunfactor 1.8
set shadefactor 0.6

#Bildformate & DesktopPicturesDir
if {$platform == "unix"} {
  set HOME $env(HOME)
  set types {
    { {Image Files} {.jpg .jpeg .JPG .JPEG .png .PNG} }
  }

  #ru
  if { [file exists $HOME/Снимки] } {
    set DesktopPicturesDir $HOME/Снимки
  #hu
  } elseif { [file exists $HOME/Képek] } {
    set DesktopPicturesDir $HOME/Képek
  #tr
  } elseif { [file exists $HOME/Resimler] } {
    set DesktopPicturesDir $HOME/Resimler
  #uz
  } elseif { [file exists $HOME/Suratlar] } {
    set DesktopPicturesDir $HOME/Suratlar
  #ar صور
  } elseif { [file exists [file join $HOME صور ]] } {
    set DesktopPicturesDir "[file join $HOME صور ]"
  #zh 图片
  } elseif { [file exists [file join $HOME 图片 ]] } {
    set DesktopPicturesDir "[file join $HOME 图片 ]"

  #General Ima(ge) | Bil(der) etc.
  } elseif {
      ![catch {glob Imag*} result] ||
      ![catch {glob Immag*} result] ||
      ![catch {glob Imág*} result] ||
      ![catch {glob Pict*} result] ||
      ![catch {glob Bil*} result] } {
    set DesktopPicturesDir $HOME/$result
  #All else: set to $HOME
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

if { [info exists Debug] && $Debug && [info exists httpmock] && $httpmock} {
  proc sourceHTTP {} {
    source $::Http
    source $::HttpMock
  }
} else {
  proc sourceHTTP {} {
    source $::Http
  }
}

catch {source $LoadConfig}
