# ~/Biblepix/prog/msg/ROOT.msg
# English & general texts for BiblePix Setup
# sourced by SetupGui
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 28may22 pv

############################################################################################################
## T R A N S L A T O R S : O N L Y   T R A N S L A T E   P H R A S E S   W I T H I N  Q U O T E S   "......"
## e.g.:  of  
##    'mcset yourlanguage code "PHRASE" '    - only replace quoted text in "PHRASE"
############################################################################################################

################################################################################
## U  N  T  R  A  N  S  L  A  T  A  B  L  E  S
## P L E A S E   D O N 'T  T O U C H : 
## - ANY PHRASE STARTING WITH #
## - ANY WORD STARTING WITH $
## - ANY PHRASE WITHIN SQUARE BRACKETS [...]
## - ANY FORMATTING MARKERS LIKE \n \n\n \t \u... etc.
## - ANY PHRASE STARTING WITH 'set'
## - ANY WORD STARTING WITH %
################################################################################

#Untranslatable fix texts for msgcat
mcset {} www {https://biblepix.vollmar.ch}
mcset {} f2ar_txt "\ufe8d\ufedf\ufedc\ufee0\ufee4\ufe94" ;#formatted letter forms!
mcset {} f2he_txt "הדבר"
mcset {} f2ltr1_txt "The Word 每日金句 Калом Cugetarea zilei"
mcset {} f2ltr2_txt "พระคำสำหรับวันศุกร์ Слово An Briathar"
mcset {} RtlInfoHe "טקסט בכתב עברי יוזז לצד הנגדי באופן אוטומטי, אלא אם כן המיקום נקבע בפירוט תוך כדי הוספת תצלום לגלריה."
mcset {} RtlInfoAr "النص باللغة العربية ينتقل تلقائياً للجهة المقابلة."
set grussformel "
Bible & Pix Brothers
Homepage: biblepix.vollmar.ch
"
mcset {} f3Expl "Yours faithfully, $grussformel"
if {$lang == "de"} {
  mcset {} f3Expl "Mit freundlichem Gruss, $grussformel"
}

#############################################################
# All English translations 
# to be sourced by any other language missing
# or for any string that is missing in that language
#############################################################
set bp "BiblePix"
set dw {'The Word'}
mcset {} dw $dw
mcset {} bp $bp

# G E N E R A L
mcset {} ok "Ok"
mcset {} cancel "Cancel"
mcset {} close "Close"
mcset {} save "Save"
mcset {} saveSettings "Save settings"
mcset {} random "accidental"
mcset {} welcome "Welcome"
mcset {} bibletexts "Bible texts"
mcset {} desktop "Desktop background"
mcset {} photos "Photos"
mcset {} email "E-mail signature"
mcset {} terminal "Terminal"
mcset {} manual "Manual"
mcset {} uninst "Uninstall $bp"
mcset {} next "Next \u25bc"
mcset {} packageRequire {
* apt-get install [PACKAGE NAME] (Debian/Ubuntu)
* emerge [PACKAGE NAME] (Gentoo)
}
mcset {} packageRequireMissing "$bp needs the Tcl extension '%s'.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo): [mc packageRequire]"

# U N I N S T A L L
mcset {} uninstall "Do you really want to remove $bp from your computer?"
mcset {} uninstalling "$bp will now be uninstalled. To clear system settings made, you must confirm any upcoming dialogue boxes with \"Yes\"."
mcset {} uninstalled "$bp has been removed safely from your system. To reinstall, visit our website [mc www] and download $bp Installer." 

#### S E T U P DOWNLOAD 
mcset {} download "Download"
mcset {} downloadingHttp "Downloading $bp program files..."
mcset {} downloadingAsianFont "Downloading Asian font files..."
mcset {} downloadComplete "Download completed"
mcset {} updatingHttp "Updating $bp program files..."
mcset {} uptodateHTTP "Your program files are up-to-date."
mcset {} noConnHTTP "No Internet connection for program update, please try later."
mcset {} gettingTwd "Fetching current list of Bible text files from bible2.net..."
mcset {} noTwdFilesFound "No current Bible text files are installed.\nIn the $bp Setup, choose at least \n one language text file from the 'International' section."
mcset {} connTwd "Connection to bible2.net established."
mcset {} noConnTwd "No connection to bible2.net. Try later."
mcset {} bpsetup "$bp Setup"
mcset {} refresh "Update"
mcset {} delete "Delete file"
mcset {} textposlabel "Set general text position"
mcset {} textposAdjust "Do you want to adjust the text position for this picture before saving?"
mcset {} welcTit "Welcome to the $bp setup program!"
mcset {} welcSubtit1 "What is $bp?"
mcset {} welcTxt1 "$bp is a Tcl program developed for the 'Bible 2.0' project which aims to publish $dw in a growing number of languages.\n\n$dw consists of two selected Bible verses for each day of the year.\n\n$bp can display $dw in various ways on your computer."
mcset {} welcSubtit2 "What are your options?"
mcset {} welcTxt2 "\u27a4 [mc bibletexts]: Choose one or several Bible text languages for $dw
\u27a4 [mc desktop]: Get $dw on your personal background images, incl. slide show
\u27a4 [mc photos]: Organise your photos for use in $bp
\u27a4 [mc email]: Get $dw added to your e-mail signatures
\u27a4 [mc terminal]: Display $dw in your Linux terminals
\u27a4 [mc manual]: Study the Complete Guide to the $bp program"
mcset {} f1Tit "Current list of Bible texts for $dw"
mcset {} TwdLocalTit "Bible text files installed for $jahr"
mcset {} TwdRemoteTit "Bible text files for download"
mcset {} language "Language"
mcset {} year "Year"
mcset {} bibleversion "Bible version"
mcset {} biblename "Bible name"
mcset {} f1Txt "$bp will create $dw in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select for download (see below) will be downloaded upon clicking the '[mc download]' button. Pay attention to the year (current or next)!"
mcset {} f2Tit "Put $dw on your background images"
mcset {} f2Box "Create background image"
mcset {} f2Farbe "Font colour: "
mcset {} f2Slideshow "Enable slide show"
mcset {} f2Interval "Slide show interval: "
mcset {} sec "seconds"
mcset {} f2Introline "Show date"
mcset {} f2Fontsize "Font size: "
mcset {} f2Fontweight "bold"
mcset {} f2Fontfamily "Font family: "
mcset {} f2Fontexpl "Adjust Font"
mcset {} f2Txt "If activated, $bp will put $dw on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see [mc photos] section), and a new background image will be put in \n\n\t [file nativename $imgdir] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\n$bp will set up a Slide Show with alternating pictures at a given interval. For only 1 picture per day, unset this feature (see above).\n\nThe TEXT POSITION window allows you to put $dw wherever you like on your screen. Moreover, when adding a photograph to the $bp photo collection, you can position the text individually. \n\nFONT SIZE is set automatically on the basis of the screen height. You may however change letter size and weight to taste (bigger letters = better contrast).\n\nFONT COLOUR can be accidental or set by you. Note that $bp may adjust colour luminance on the basis of background brightness. This takes effect only after a photo has been added to the $bp collection. \n\nShould the new background image fail to appear, please consult the Manual page for a solution."
# S E T U P   P H O T O S 
mcset {} f6Tit "Manage your photos for $bp"
mcset {} f6Txt "Here you can add any suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. Photos should ideally be in landscape format and have some plain-colour surface for good visibility of the Bible text.\n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory. If refitting is required, you will be asked to choose the desired section of the photo as well as the position of future Bible texts.\n\nAt any rate, the original photo remains unchanged."
mcset {} deletedPicMsg "Deleted picture from $bp photo collection:"
mcset {} copiedPicMsg "Copied picture to $bp photo collection:"
mcset {} reposSaved "Picture saved with Info."
mcset {} reposNotSaved "Picture not saved."
mcset {} noPhotosFound "No photos were found in the $bp [mc photos] folder. Please copy some pictures into the folder."
mcset {} rotatePic "Rotate picture"
mcset {} preview90 "\u21B7 Preview 90° rotation"
mcset {} preview180 "\u21BB Preview 180° rotation"
mcset {} computePreview "\u21B6 \u21B7 Preview any rotation"
mcset {} rotateWait "Please wait patiently while rotating original picture..."
mcset {} rotateInfo "Note: by saving and reloading, a picture can be rotated in several steps!"
mcset {} f6numPhotosTxt "Number of pictures: "
mcset {} f6Add "Add to $bp Photo Collection:"
mcset {} f6Show "Show $bp Photo Collection"
mcset {} f6Find "Find new photos"
mcset {} f6Del "Delete from $bp Photo Collection:"
#RESIZING
mcset {} resizeF_txt "The size of your photo does not correspond to the screen size and has to be trimmed. [mc movePicToResize]"
mcset {} movePicToResize "Move picure section to desired position and press Ok to resize."
mcset {} resizingPic "Resizing photo to fit screen \u2014 please wait a moment..."
mcset {} movePic "Move picture section \u21CA"
mcset {} picSchonDa "Photo already in $bp Photos folder"
# S E T U P   S I G N A T U R E
mcset {} f3Tit "Add $dw to your e-mail signatures"
mcset {} f3Btn "Create e-mail signature"
mcset {} f3Sprachen "Desired languages for my signatures"
mcset {} f3Txt "If activated, $bp will add $dw at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en_Englis.txt) in the directory \n\n\t$sigdir \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \n\nYou may not desire $dw to appear in your mails in all languages installed. In the checkboxes top right, please choose those languages you deem appropriate for your mail recipients.\n\nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures).\n\nCertain programs like Seamonkey Mail, Evolution or Trojitá manage signatures internally. Among these $bp can handle Trojitá and Evolution for now."
mcset {} f4Tit  "Display $dw in your Linux terminals"
mcset {} f4Btn "Create $dw for display in terminal"
mcset {} f4Txt "If activated, $bp will create $dw to be displayed at the top of your terminals. If more than one language file are present, Bible text will alternate randomly whenever a new shell is opened. \n\nColours for display etc. may be changed in \n\n\t $confdir/term.conf \n\nNote that in order to display Arabic or Hebrew script correctly, you will need one of the following: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) or 'xfce4-terminal'; these are known to work with bidirectional text.\n\nFor $dw to be displayed automatically in your terminals, $bp Setup makes an entry in ~/.bashrc for your convenience."
# S A V E
mcset {} linChangingDesktop "$bp will now try to register with your Desktop Background. If you can't see a new background picture after that, find a solution in the Manual."
mcset {} winIgnorePopup "Please dismiss (close) any pop-up windows so $bp can finish registration!"
mcset {} winChangingDesktop "$bp will now try to register with your Desktop Background"
mcset {} winChangeDesktopProb "We are having a problem changing your Desktop background.\nPlease right-click on an empty spot on your Desktop and select \"Personalize\" > \"Wallpaper\" either set as single pic path \n\t$TwdBMP or \n\t$TwdPNG \nor else set up a slideshow setting the directory to \n\t$imgdir."
mcset {} linChangeDesktopProb "We are having a problem changing your Desktop settings.\nPlease right-click on your Desktop and find the dialogue for 'Background picture'. There indicate $imgdir as new image path."
mcset {} linNoDesktopFound "No Llinux Desktop detected! Please find out in the manual how to manually set up the $bp background picture."
mcset {} linReloadingDesktop "We shall now try to reload your Desktop. If this fails, please log out and in again for the $bp settings to take effect."

if {$os=="Linux"} {
  mcset {} changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the $bp Setup program anytime by selecting the \"$bp Setup\" icon in the Program Menu"
} else {
  mcset {} changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the $bp Setup program anytime by right-clicking on an free spot on your Desktop and choosing the \"$bp Setup\" icon."
}

mcset {} winRegister "$bp will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
mcset {} winRegisterProb "$bp has not been registered properly on your computer.\nPlease try rerunning Setup, or add \n\t$Biblepix\n to your Autostart folder."
