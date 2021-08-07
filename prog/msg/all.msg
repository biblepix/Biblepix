#Biblepix/prog/msg/all.msg
# loaded by msgcat for untranslatables
# sourced by setTexts with lang variable
# Updated 7aug21 pv

#Untranslatable fix texts for msgcat
mcset $lang f2ar_txt "\ufe8d\ufedf\ufedc\ufee0\ufee4\ufe94" ;#formatted letter forms!
mcset $lang f2he_txt "הדבר"
mcset $lang f2ltr1_txt "The Word 每日金句 Калом"
mcset $lang f2ltr2_txt "พระคำสำหรับวันศุกร์ Слово An Briathar"
mcset $lang RtlInfoHe "טקסט בכתב עברי יוזז לצד הנגדי באופן אוטומטי."
mcset $lang RtlInfoAr "النص باللغة العربية ينتقل تلقائياً للجهة المقابلة."
mcset $lang packageRequireImg_fix "\n* apt-get install libtk-img (Debian/Ubuntu)\n* emerge tkimg (Gentoo)\n* zypper install tkimg (openSUSE)\n* yum install tkimg (Fedora)\n* urpmi tkimg (Mandriva)"
mcset $lang packageRequireTDom_fix "\n* apt-get install tdom (Debian/Ubuntu)\n* emerge tdom (Gentoo)\n* zypper install tdom (openSUSE)\n* yum install tdom (Fedora)\n* urpmi tdom (Mandriva)"
mcset $lang packageRequireTls_fix "\n* apt-get install tcl-tls (Debian/Ubuntu)\n* emerge dev-tcltk/tls (Gentoo)"
mcset $lang packageRequireLibtcl_fix "\n*apt-get install libtcl (Debian/Ubuntu)\n* emerge libtcl (Gentoo)\n* zypper install libtcl (openSUSE)\n* yum install libtcl (Fedora)\n* urpmi libtcl (Mandriva)"
set grussformel "
Bible & Pix Brothers
Homepage: biblepix.vollmar.ch
"
mcset $lang f3Expl "Yours faithfully, $grussformel"
if {$lang == "de"} {
  mcset $lang f3Expl "Mit freundlichem Gruss, $grussformel"
}

#Set textvars for ::msg namespace
##Msgcat can't provide global vars!
namespace eval msg {

set packageRequireImg [mc packageRequireImg]
set packageRequireTDom [mc packageRequireTDom]
set packageRequireTls [mc packageRequireTls]
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
set uninstall [mc uninstall]
set uninstalling [mc uninstalling]
set uninstalled [mc uninstalled]
set packageRequireImg [mc packageRequireImg]
set packageRequireTDom [mc packageRequireTDom]
set packageRequireTls [mc packageRequireTls]
set downloadingHttp [mc downloadingHttp]
set updatingHttp [mc updatingHttp]
set uptodateHTTP [mc uptodateHTTP]
set noConnHTTP [mc noConnHTTP]
set gettingTwd [mc gettingTwd]
set noTwdFilesFound [mc noTwdFilesFound]
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
set textposAdjust [mc textposAdjust]
set f6Tit [mc f6Tit]
set f6Txt [mc f6Txt]
set f6numPhotosTxt [mc f6numPhotosTxt]
set f6Add [mc f6Add]
set f6Show [mc f6Show]
set f6Find [mc f6Find]
set f6Del [mc f6Del]
set resizeF_txt [mc resizeF_txt]
set movePicToResize [mc movePicToResize]
set resizingPic [mc resizingPic]
set movePic [mc movePic]
set picSchonDa [mc picSchonDa]
set f3Tit [mc f3Tit]
set f3Btn [mc f3Btn]
set f3Sprachen [mc f3Sprachen]
set f3Txt [mc f3Txt]
set f3Expl [mc f3Expl]
set f4Tit  [mc f4Tit]
set f4Btn [mc f4Btn]
set f4Txt [mc f4Txt]
set winIgnorePopup [mc winIgnorePopup]
set winChangingDesktop [mc winChangingDesktop]
set winChangeDesktopProb [mc winChangeDesktopProb]
set winRegister [mc winRegister]
set winRegisterProb [mc winRegisterProb]
set linChangingDesktop [mc linChangingDesktop]
set linChangeDesktopProb [mc linChangeDesktopProb]
set linNoDesktopFound [mc linNoDesktopFound]
set linReloadingDesktop [mc linReloadingDesktop]
set changeDesktopOk [mc changeDesktopOk]
set reposSaved [mc reposSaved]
set reposNotSaved [mc reposNotSaved]
set noPhotosFound [mc noPhotosFound]
set rotatePic [mc rotatePic]
set preview90 [mc preview90]
set preview180 [mc preview180]
set computePreview [mc computePreview]
set rotateWait [mc rotateWait]
set rotateInfo [mc rotateInfo]
set deletedPicMsg [mc deletedPicMsg]
set copiedPicMsg [mc copiedPicMsg]

} ;#END ::msg namespace
