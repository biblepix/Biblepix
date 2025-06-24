# ~/Biblepix/prog/src/share/globals.tcl
# Sets global permanent variables
# sourced by Setup & Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 14jun25 pv
set version "5.1"
set twdUrl "https://bible2.net/service/TheWord/twd11/current"
set twdBaseUrl "https://bible2.net/service/TheWord/twd11"
set bpxReleaseUrl "http://vollmar.ch/biblepix/release"
set bpxJpegUrl "http://vollmar.ch/biblepix/jpeg"
set bpxIconUrl "http://vollmar.ch/biblepix"
set platform $::tcl_platform(platform)
set os $::tcl_platform(os)
set tclpath [auto_execok tclsh]
set wishpath [auto_execok wish]

#Temporary files (used in setupPhotos, ...)
if {$os == "Linux"} {
  set tempdir "/tmp"
} elseif {$os == "Windows"} {
  set tempdir [file normalize [file join %localappdata% Temp]]
}

#Rootdir location
##Git download (any place on PC)
if [info exists srcdir] {
  set rootdir "[file dirname [file dirname [file normalize $srcdir ]]]"
##Windows
} elseif [info exists ::env(LOCALAPPDATA)] {
  set rootdir "[file normalize [file join $env(LOCALAPPDATA) Biblepix]]"
##Unix
} else {
  set rootdir "[file join $::env(HOME) Biblepix]"
}

#S e t   d i r n a m e s
##make complete pathlist for use in makeDirs
##export name vars for use in all procs
set dirPathL {}
lappend dirPathL [set progdir [file join $rootdir prog]]
lappend dirPathL [set srcdir [file join $progdir src]]
lappend dirPathL [set confdir [file join $progdir conf]]
lappend dirPathL [set docdir [file join $rootdir Docs]]
lappend dirPathL [set fontdir [file join $progdir font]]
lappend dirPathL [set imgdir [file join $rootdir TodaysPicture]]
lappend dirPathL [set maildir [file join $srcdir sig]]
lappend dirPathL [set msgdir [file join $progdir msg]]
lappend dirPathL [set photosdir [file join $rootdir Photos]]
lappend dirPathL [set picdir [file join $srcdir pic]]
lappend dirPathL [set piddir [file join $progdir pid]]
lappend dirPathL [set savedir [file join $srcdir save]]
lappend dirPathL [set sampleJpgDir [file join $srcdir pic SamplePhotos]]
lappend dirPathL [set setupdir [file join $srcdir setup]]
lappend dirPathL [set sharedir [file join $srcdir share]]
lappend dirPathL [set sigdir [file join $rootdir TodaysSignature]]
lappend dirPathL [set termdir [file join $srcdir term]]
lappend dirPathL [set twddir [file join $rootdir BibleTexts]]
lappend dirPathL [set unixdir [file join $progdir unix]]
lappend dirPathL [set windir [file join $progdir win]]

##make complete file pathlist for use in makeDirs
##export file var names for use in all procs
set filePathL {}
##regular files
lappend filePathL [set AnnotatePng [file join $picdir annotatePng.tcl]]
lappend filePathL [set Globals [file join $sharedir globals.tcl]]
lappend filePathL [set Http [file join $sharedir http.tcl]]
lappend filePathL [set Readme [file join $rootdir README.txt]]
lappend filePathL [set Setup [file join $rootdir biblepix-setup.tcl]]
lappend filePathL [set ManualD [file join $docdir MANUAL_de.md]]
lappend filePathL [set ManualE [file join $docdir MANUAL_en.md]]
lappend filePathL [set Biblepix [file join $srcdir biblepix.tcl]]
lappend filePathL [set BdfTools [file join $picdir BdfTools.tcl]]
lappend filePathL [set BdfPrint [file join $picdir BdfPrint.tcl]]
lappend filePathL [set Bidi [file join $sharedir Bidi.tcl]]
lappend filePathL [set Image [file join $picdir image.tcl]]
lappend filePathL [set Releasenotes [file join $docdir RELEASENOTES.txt]]
lappend filePathL [set RotateTools [file join $picdir RotateTools.tcl]]
lappend filePathL [set SetBackgroundChanger [file join $picdir setBackgroundChanger.tcl]]
lappend filePathL [set SetupMainFrame [file join $setupdir setupMainFrame.tcl]]
lappend filePathL [set SetupBuild [file join $setupdir setupBuildGUI.tcl]]
lappend filePathL [set SetupDesktop [file join $setupdir setupDesktop.tcl]]
lappend filePathL [set SetupDesktopPng [file join $setupdir setupDesktop.png]]
lappend filePathL [set SetupEmail [file join $setupdir setupEmail.tcl]]
lappend filePathL [set SetupInternational [file join $setupdir setupInternational.tcl]]
lappend filePathL [set SetupPhotos [file join $setupdir setupPhotos.tcl]]
lappend filePathL [set SetupPicThread [file join $setupdir setupPicThread.tcl]]
lappend filePathL [set SetupManual [file join $setupdir setupManual.tcl]]
lappend filePathL [set SetupResizePhoto [file join $setupdir setupResizePhoto.tcl]]
lappend filePathL [set SetupResizeTools [file join $setupdir setupResizeTools.tcl]]
lappend filePathL [set SetupRotate [file join $setupdir setupRotate.tcl]]
lappend filePathL [set SetupTerminal [file join $setupdir setupTerminal.tcl]]
lappend filePathL [set SetupWelcome [file join $setupdir setupWelcome.tcl]]
lappend filePathL [set SetupTools [file join $setupdir setupTools.tcl]]
lappend filePathL [set SetupTexts [file join $setupdir setupTexts.tcl]]
lappend filePathL [set Save [file join $savedir save.tcl]]
lappend filePathL [set SaveLin [file join $savedir saveLin.tcl]]
lappend filePathL [set SaveLinHelpers [file join $savedir saveLinHelpers.tcl]]
lappend filePathL [set SaveWin [file join $savedir saveWin.tcl]]
lappend filePathL [set SaveWinHelpers [file join $savedir saveWinHelpers.tcl]]
lappend filePathL [set Flags [file join $sharedir flags.tcl]]
lappend filePathL [set Http [file join $sharedir http.tcl]]
lappend filePathL [set HttpMock [file join $sharedir httpMock.tcl]]
lappend filePathL [set JList [file join $sharedir JList.tcl]]
lappend filePathL [set ImgTools [file join $picdir ImageTools.tcl]]
lappend filePathL [set LoadConfig [file join $sharedir LoadConfig.tcl]]
lappend filePathL [set TwdTools [file join $sharedir TwdTools.tcl]]
lappend filePathL [set Uninstall [file join $savedir uninstall.tcl]]
lappend filePathL [set Signature [file join $maildir signature.tcl]]
lappend filePathL [set SigTools [file join $maildir SigTools.tcl]]
lappend filePathL [set Config [file join $confdir biblepix.conf]]
lappend filePathL [set Terminal [file join $termdir terminal.tcl]]
lappend filePathL [set TerminalShell [file join $unixdir term.sh]]
##icons
lappend filePathL [set LinIcon [file join $unixdir biblepix.png]]
lappend filePathL [set LinIconSvg [file join $unixdir biblepix.svg]]
lappend filePathL [set WinIcon [file join $windir biblepix.ico]]
##Msgcat msg files
lappend filePathL [set ExportTextvars [file join $msgdir exportTextvars.tcl]]
lappend filePathL [set root_msg [file join $msgdir ROOT.msg]]
lappend filePathL [set ar_msg [file join $msgdir ar.msg]]
lappend filePathL [set de_msg [file join $msgdir de.msg]]
lappend filePathL [set en_msg [file join $msgdir en.msg]]
lappend filePathL [set es_msg [file join $msgdir es.msg]]
lappend filePathL [set fr_msg [file join $msgdir fr.msg]]
lappend filePathL [set pt_msg [file join $msgdir pt.msg]]
lappend filePathL [set pl_msg [file join $msgdir pl.msg]]
lappend filePathL [set ru_msg [file join $msgdir ru.msg]]
lappend filePathL [set zh_msg [file join $msgdir zh.msg]]
lappend filePathL [set it_msg [file join $msgdir it.msg]]
#lappend filePathL [set ro_msg [file join $msgdir ro.msg]]

##make complete pathlist for use in makeDirs
##export name vars for use in all procs
##these are downloaded once by Installer
set sampleJpgL {}
lappend sampleJpgL [set Utah [file join $sampleJpgDir utah.jpg]]
lappend sampleJpgL [set Eire [file join $sampleJpgDir eire.jpg]]
lappend sampleJpgL [set Lake [file 	join $sampleJpgDir lake.jpg]]
lappend sampleJpgL [set Palms [file join $sampleJpgDir palms.jpg]]
lappend sampleJpgL [set Mountain [file join $sampleJpgDir mountain.jpg]]
lappend sampleJpgL [set Nevada [file join $sampleJpgDir nevada.jpg]]

#Set font size list (in pts)
lappend fontSizeL 12 16 20 24 28 32
set fontPathL {}

foreach ptsize $fontSizeL {
  lappend fontPathL [set Arial${ptsize}  [file join $fontdir Arial${ptsize}.tcl]]
  lappend fontPathL [set ArialI${ptsize} [file join $fontdir ArialI${ptsize}.tcl]]
  lappend fontPathL [set ArialB${ptsize} [file join $fontdir ArialB${ptsize}.tcl]]
  lappend fontPathL [set Times${ptsize}  [file join $fontdir Times${ptsize}.tcl]]
  lappend fontPathL [set TimesI${ptsize} [file join $fontdir TimesI${ptsize}.tcl]]
  lappend fontPathL [set TimesB${ptsize} [file join $fontdir TimesB${ptsize}.tcl]]
}

#Append regular Chinese fonts to fontPathL if $twddir has Chinese file
##bold & italic construed in LoadConfig
if ![catch {glob -tails -directory $twddir zh*} ] {
  ##append regular (italic same as regular, managed in LoadConfig))
  foreach ptsize $fontSizeL {
    lappend fontPathL [set Chinafont${ptsize}  [file join $fontdir Wenquanyi${ptsize}.tcl]]
  }
} 
#Append Thai fonts to fontPathL if twddir has Thai file
if ![catch {glob -tails -directory $twddir th*} ] {
  foreach ptsize $fontSizeL {  
    lappend fontPathL [set Thaifont${ptsize}  [file join $fontdir Garuda${ptsize}.tcl]]
    lappend fontPathL [set ThaifontB${ptsize} [file join $fontdir GarudaB${ptsize}.tcl]]
    lappend fontPathL [set ThaifontI${ptsize} [file join $fontdir GarudaI${ptsize}.tcl]]
  }
}
  
#Set TWD picture paths
set TwdBMP [file join $imgdir theword.bmp]
set TwdTIF [file join $imgdir theword.tif]
set TwdPNG [file join $imgdir theword.png]

#Miscellaneous vars (sourced by various progs)
set datum [clock format [clock seconds] -format %Y-%m-%d]
set jahr [clock format [clock seconds] -format %Y]
set heute [clock format [clock seconds] -format %d]
set ind [string repeat \u00A0 3]
set tab [string repeat $ind 4]

#Define font colour names 
set fontcolourL {Earth Gold Leaf Sea Silver Slate}

##define rgb arrays; l=luminance (sum of rgb)
array set SeaArr {r 30 g 100 b 244}
array set EarthArr {r 160 g 105 b 0}
array set GoldArr  {r 230 g 195 b 0}
array set LeafArr {r 43 g 135 b 87}
array set SilverArr {r 150 g 150 b 150}
array set SlateArr {r 112 g 128 b 144}
#array set SlateArr {r 120 g 120 b 120}

#Define font shade values for above mean colours
set sunFactor 0.45
set shadeFactor -0.45

#Thresholds to define where a background should be considered "dark" or "bright"
##and by what factor font shades should yet be adjusted up or down for changed luminacy (standard=2)
set darkThreshold 80
set brightThreshold 180
## 0 = colour / 0.1-9 = whiter / -0.1-9 = blacker
set lumFactor1 -0.2
set lumFactor3 0.2

#Bildformate & DesktopPicturesDir
##the 'types' variable is used by tk_getOpenFile and scanPicdir
if {$platform == "unix"} {
  set HOME $::env(HOME)
  ##Note:DesktopPicturesDir changes with languages > variable in Config & switch in LoadConfig
  lappend picTypes jpg jpeg JPG JPEG png PNG bmp BMP gif GIF ppm tif tiff TIF TIFF
    
} elseif {$platform == "windows"} {
  #DesktopPicturesDir is always "Pictures"
  set DesktopPicturesDir $::env(USERPROFILE)/Pictures
  lappend picTypes jpg jpeg png bmp gif ppm tif tiff
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
# makeDirs
##called by Installer
proc makeDirs {} {
  global dirPathL
  foreach dirpath $dirPathL {
    file mkdir $dirpath
  }
}

catch {source $LoadConfig}
