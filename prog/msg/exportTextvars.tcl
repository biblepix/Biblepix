# Biblepix/prog/msg/exportTextvars.tcl
# Exports all textvars for a language to ::msg namespace, 
# needed for '-textvar' functions in Setup widgets
# (Msgcat can't provide global vars!)
# sourced by setTexts with lang variable
# Updated 14jan22 pv
 
namespace eval msg {
	puts $lang

  set ok [mc ok]
  set dw [mc dw]
  set bp [mc bp]
  set sec [mc sec]
  set bpsetup [mc bpsetup]
  set refresh [mc refresh]
  set delete [mc delete]
  set cancel [mc cancel]
  set close [mc close]
  set save [mc save]
  set saveSettings [mc saveSettings]
  set random [mc random]
  set uninst [mc uninst]
  set welcome [mc welcome]
  set bibletexts [mc bibletexts]
  set desktop [mc desktop]
  set photos [mc photos]
  set email [mc email]
  set terminal [mc terminal]
  set manual [mc manual]
  set next [mc next]
  set welcTit [mc welcTit]
  set welcSubtit1 [mc welcSubtit1]
  set welcSubtit2 [mc welcSubtit2]
  set welcTxt1 [mc welcTxt1]
  set welcTxt2 [mc welcTxt2]
  
  set download [mc download]
  set downloadingHttp [mc downloadingHttp]
  set downloadingAsianFont [mc downloadingAsianFont]
  set downloadComplete [mc downloadComplete]
  set updatingHttp [mc updatingHttp]
  set uptodateHTTP [mc uptodateHTTP]
  set noConnHTTP [mc noConnHTTP]
  set gettingTwd [mc gettingTwd]
  #set noTwdFilesFoundM [mc noTwdFilesFound]
  set connTwd [mc connTwd]
  set noConnTwd [mc noConnTwd]
  set f1Tit [mc f1Tit]
  set TwdLocalTit [mc TwdLocalTit]
  set TwdRemoteTit [mc TwdRemoteTit]
  set language [mc language]
  set year [mc year]
  set bibleversion [mc bibleversion]
  set biblename [mc biblename]
  set f1Txt [mc f1Txt]
  set f2Tit [mc f2Tit]
  set f2Box [mc f2Box]
  set f2Farbe [mc f2Farbe]
  set f2Slideshow [mc f2Slideshow]
  set f2Interval [mc f2Interval]
  set f2Introline [mc f2Introline]
  set f2Fontsize [mc f2Fontsize]
  set f2Fontweight [mc f2Fontweight]
  set f2Fontfamily [mc f2Fontfamily]
  set f2Fontexpl [mc f2Fontexpl]
  set f2Txt [mc f2Txt]
  set textposlabel [mc textposlabel]
  set f6Tit [mc f6Tit]
  set f6Txt [mc f6Txt]
  set f6numPhotosTxt [mc f6numPhotosTxt]
  set f6Add [mc f6Add]
  set f6Show [mc f6Show]
  set f6Find [mc f6Find]
  set f6Del [mc f6Del]
  set resizeF_txt [mc resizeF_txt]
  set resizingPic [mc resizingPic]
  set picSchonDa [mc picSchonDa]
  set f3Tit [mc f3Tit]
  set f3Btn [mc f3Btn]
  set f3Sprachen [mc f3Sprachen]
  set f3Txt [mc f3Txt]
  set f3Expl [mc f3Expl]
  set f4Tit  [mc f4Tit]
  set f4Btn [mc f4Btn]
  set f4Txt [mc f4Txt]
  set reposSaved [mc reposSaved]
  set reposNotSaved [mc reposNotSaved]
  set noPhotosFound [mc noPhotosFound]
  set rotatePic [mc rotatePic]
  set preview90 [mc preview90]
  set preview180 [mc preview180]
  set computePreview [mc computePreview]
  set rotateInfo [mc rotateInfo]
  set deletedPicMsg [mc deletedPicMsg]
  set copiedPicMsg [mc copiedPicMsg]

} ;#END ::msg namespace

namespace eval msgbox {
set textposAdjust [mc textposAdjust]
  set movePicToResize [mc movePicToResize]
  set resizingPic [mc resizingPic]
  set movePic [mc movePic]
	set uninstall [mc uninstall]
  set uninstalling [mc uninstalling]
  set uninstalled [mc uninstalled]
	set noTwdFilesFound [mc noTwdFilesFound]
	set changeDesktopOk [mc changeDesktopOk]
	set winIgnorePopup [mc winIgnorePopup]
	set rotateWait [mc rotateWait]
	set winChangingDesktop [mc winChangingDesktop]
 	set winChangeDesktopProb [mc winChangeDesktopProb]
  set winRegister [mc winRegister]
  set winRegisterProb [mc winRegisterProb]
  set linChangingDesktop [mc linChangingDesktop]
  set linChangeDesktopProb [mc linChangeDesktopProb]
  set linNoDesktopFound [mc linNoDesktopFound]
  set linReloadingDesktop [mc linReloadingDesktop]
} ;#END ::msgbox namespace

# msgBidi
#Fix Arabic & Hebrew
##runs throu msg:: & msgbox:: namespaces 
##setting each message with reqW
##called here below
proc msgbidi {} {
  source $::Bidi
	set ::reqW 60

	#A) Run through msg:: namespace
  foreach var [info vars msg::*] {
    set T [set $var]
          
		if [regexp f1Txt $var] {	
  		set reqW 150
 		} else {
  		set reqW $::reqW
  	}    
     
     #args vovelled|bdf|reqW
   # if [catch {set $var [bidi::fixBidi $T 1 0 $reqW]} res] {
   #   puts "PROBLEMTEXT $var: $T"
   #   puts $res
   # }
   	catch {set $var [bidi::fixBidi $T 1 0 $reqW]}
  }

	#B) Run through msgbox:: namespace
  foreach var [info vars msgbox::*] {  
    set T [set $var]
    set reqW 25
    catch {set $var [bidi::fixBidi $T 1 0 $reqW]}
  }
}

if [isRtL $lang] {
  msgbidi    
}

# setWidgetDirection
##A)sets direction of text widgets to right/left-justifying
##B)packs them as west/east-anchoring
##called by setTexts

#TODO this shouldn't be called unless a direction change has previously occurred!!!!!!!!!!!!!!!
proc setWidgetDirection {dir} {
	global flagL tabL
	
  #set anchor + side vars
  if {$dir == "right"} {
    set anc e
    set side right
  } {
    set anc w
    set side left
  }
  
  #A) Switch main title direction
  .mainTitleL conf -compound $side
  pack .mainTitleL -side $side
  
#TODO ? Revert Notebook tab order
proc çalishmiyor {} {
foreach nbtab $tabL {
	.nb forget $nbtab
}
set tabL [lreverse $tabL]
foreach tab $nbtabL {
	.nb add $nbtab
}
}
	 
  #B) Switch widget justification 
  foreach w [winfo children .] {
    if { [winfo class $w] == "Label" ||
          [winfo class $w] == "Message" ||
          [winfo class $w] == "Checkbutton"
    } {
        $w conf -justify $dir
        pack $w -anchor $anc
    }
  }
	##correct some centered titles
	pack .textposTit .fontAdaptTit -anchor center
	
	#C) Switch frames & horizontal widgets
	
	##Welcome
	pack .welcomeLeftMainF -side $side
	
	##Desktop
	pack .desktopLeftF -side $side -anchor $anc
	##revert left/right for some widgets
	if {$side == "right"} {
		set umgekehrt "left"
  } else {
		set umgekehrt "right"
	}

	##revert flag direction	
  foreach i $flagL {
  	pack $i -side $umgekehrt
  }

	pack .slideBtn -side $side
	pack .slideSecTxt -side $umgekehrt
	pack .slideSpin -side $umgekehrt
	pack .slideTxt -side $umgekehrt
	pack .fontcolorTxt .fontcolorSpin .randomfontcolorCB -side $side
	pack .fontsizeSpin .fontsizeTxt -side $side
	pack .fontfamilyTxt .fontfamilySpin .fontweightBtn -side $side
	
	##Photos
	pack .phLeftF -side $side
	
	##Mail
	pack .mailLeftF -side $side
	#TODO zis aynt workin:
	#foreach w [slaves .mailTop2F] {
	#	pack $w -side $umgekehrt
	#}
	#pack .mailTop2F ?
	#pack .mailDesiredLangL -side $umgekehrt
	
	##Terminal (catch for Windows)
	catch {pack .termLeftF -side $side}
	
} ;#END setWidgetDirection
