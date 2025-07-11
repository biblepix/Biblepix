# ~/Biblepix/prog/msg/en.msg
# English texts for BiblePix Setup
# sourced by SetupGui
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 15aug24 pv

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
mcset en www {https://biblepix.vollmar.ch}
mcset en f2ar_txt "\ufe8d\ufedf\ufedc\ufee0\ufee4\ufe94" ;#formatted letter forms!
mcset en f2he_txt "הדבר"
mcset en f2ltr1_txt "The Word 每日金句 Калом"
mcset en f2ltr2_txt "พระคำสำหรับวันศุกร์ Слово An Briathar"
mcset en RtlInfoHe "טקסט בכתב עברי יוזז לצד הנגדי באופן אוטומטי."
mcset en RtlInfoAr "النص باللغة العربية ينتقل تلقائياً للجهة المقابلة."
set grussformel "
Bible & Pix Brothers
Homepage: biblepix.vollmar.ch
"

#############################################################
# All English translations
# to be sourced by any other language missing
# or for any string that is missing in that language
#############################################################
set bp "BiblePix"
set dw {'The Word'}
mcset en dw $dw
mcset en bp $bp

# G E N E R A L
mcset en ok "Ok"
mcset en cancel "Cancel"
mcset en close "Close"
mcset en save "Save"
mcset en saveSettings "Save settings"
mcset en random "accidental"
mcset en welcome "Welcome"
mcset en bibletexts "Bible texts"
mcset en desktop "Desktop background"
mcset en photos "Photos"
mcset en email "E-mail signature"
mcset en terminal "Terminal"
mcset en manual "Manual"
mcset en uninst "Uninstall $bp"
mcset en next "Next \u25bc"
mcset en packageRequireMissing "$bp needs the Tcl extension '%s'. \n Please install via system management, or type in a terminal: \n\n sudo apt install %s (Debian/Ubuntu)"

# U N I N S T A L L
mcset en uninstall "Do you really want to remove $bp from your computer?"
mcset en uninstalling "$bp will now be uninstalled. To clear system settings made, you must confirm any upcoming dialogue boxes with \"Yes\"."
mcset en uninstalled "$bp has been removed safely from your system. To reinstall, visit our website [mc www] and download $bp Installer."

#### S E T U P DOWNLOAD
mcset en download "Download"
mcset en downloadingHttp "Downloading $bp program files..."
mcset en downloadingAsianFont "Downloading Asian font files..."
mcset en downloadComplete "Download completed"
mcset en updatingHttp "Updating $bp program files..."
mcset en uptodateHTTP "Your program files are up-to-date."
mcset en noConnHTTP "No Internet connection for program update, please try later."
mcset en gettingTwd "Fetching current list of Bible text files from bible2.net..."
mcset en noTwdFilesFound "No current Bible text files are installed. In the [mc bpsetup], please choose at least one language text file from the '[mc bibletexts]' section for download."
mcset en connTwd "Connection to bible2.net established."
mcset en noConnTwd "No connection to bible2.net. Try later."
mcset en bpsetup "$bp Setup"
mcset en refresh "Update"
mcset en delete "Delete file"
mcset en textposlabel "Set general text position"
mcset en textposAdjust "Do you want to adjust the text position for this picture before saving?"
mcset en welcTit "Welcome to the $bp setup program!"
mcset en welcSubtit1 "What is $bp?"
mcset en welcTxt1 "$bp is a Tcl program developed for the 'Bible 2.0' project which aims to publish $dw in a growing number of languages.\n\n$dw consists of two selected Bible verses for each day of the year.\n\n$bp can display $dw in various ways on your computer."
mcset en welcSubtit2 "What are your options?"
mcset en welcTxt2 "\u27a4 [mc bibletexts]: Choose one or several Bible text languages for $dw
\u27a4 [mc desktop]: Get $dw on your personal background images, incl. slide show
\u27a4 [mc photos]: Organise your photos for use in $bp
\u27a4 [mc email]: Get $dw added to your e-mail signatures
\u27a4 [mc terminal]: Display $dw in your Linux terminals
\u27a4 [mc manual]: Study the Complete Guide to the $bp program"
mcset en f1Tit "Current list of Bible texts for $dw"
mcset en TwdLocalTit "Bible text files installed for $jahr"
mcset en TwdRemoteTit "Bible text files for download"
mcset en language "Language"
mcset en year "Year"
mcset en bibleversion "Bible version"
mcset en biblename "Bible name"
mcset en f1Txt "$bp will create $dw in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select for download (see below) will be downloaded upon clicking the '[mc download]' button. Pay attention to the year (current or next)!"
mcset en f2Tit "Put $dw on your background images"
mcset en f2Box "Create background image"
mcset en f2Farbe "Font colour: "
mcset en f2Slideshow "Enable slide show"
mcset en f2Interval "Slide show interval: "
mcset en sec "seconds"
mcset en f2Introline "Show date"
mcset en f2Fontsize "Font size: "
mcset en f2Fontweight "bold"
mcset en f2Fontfamily "Font family: "
mcset en f2Fontexpl "Adjust Font"
mcset en f2Txt "If activated, $bp will put $dw on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see [mc photos] section), and a new background image will be put in \n\n\t [file nativename $imgdir] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\n$bp will set up a Slide Show with alternating pictures at a given interval. For only 1 picture per day, unset this feature (see above).\n\nThe TEXT POSITION window allows you to put $dw wherever you like on your screen. Moreover, when adding a photograph to the $bp photo collection, you can position the text individually. \n\nFONT SIZE is set automatically on the basis of the screen height. You may however change letter size and weight to taste (bigger letters = better contrast).\n\nFONT COLOUR can be accidental or set by you. Note that $bp may adjust colour luminance on the basis of background brightness. This takes effect only after a photo has been added to the $bp collection. \n\nShould the new background image fail to appear, please consult the Manual page for a solution."
# S E T U P   P H O T O S
mcset en f6Tit "Manage your photos for $bp"
mcset en f6Txt "Here you can add any number of suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. Photos should ideally be in landscape format and have some plain-colour surface for good visibility of the Bible text.\n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory. If refitting is required, you will be asked to choose the desired section of the photo as well as the position of future Bible texts.\n\nAt any rate, the original photo remains unchanged."
mcset en deletedPicMsg "Deleted picture from $bp photo collection:"
mcset en copiedPicMsg "Copied picture to $bp photo collection:"
mcset en reposSaved "Picture saved with Info."
mcset en reposNotSaved "Picture not saved."
mcset en noPhotosFound "No photos were found in the $bp [mc photos] folder. Please copy some pictures into the folder."
mcset en rotatePic "\u21BB Rotate picture"
mcset en preview90 "\u21BA Preview 90° rotation"
mcset en preview180 "\u21BB Preview 180° rotation"
mcset en computePreview "\u21B6 \u21B7 Preview any rotation"
mcset en rotateWait "Please wait patiently while rotating original picture..."
mcset en rotateInfo "Note: by saving and reloading, a picture can be rotated in several steps!"
mcset en f6numPhotosTxt "Photo"

mcset en f6Add "\U1F4BE Add to $bp Photo Collection"

mcset en f6Show "Show $bp Photo Collection"
mcset en f6Find "Find new photos"
mcset en f6Del "Delete from $bp Photo Collection:"
#RESIZING
mcset en resizeF_txt "The size of your photo does not correspond to the screen size and has to be trimmed. [mc movePicToResize]"
mcset en movePicToResize "Move picure section to desired position and press Ok to resize."
mcset en resizingPic "Resizing photo to fit screen \u2014 please wait a moment..."
mcset en movePic "Move picture section \u21CA"
mcset en picSchonDa "Photo already in $bp Photos folder"
# S E T U P   S I G N A T U R E
mcset en f3Tit "Add $dw to your e-mail signatures"
mcset en f3Btn "Create e-mail signature"
mcset en f3Sprachen "Desired languages for my signatures"
mcset en f3Txt "If activated, $bp will add $dw at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en_Englis.txt) in the directory \n\n\t$sigdir \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \n\nYou may not desire $dw to appear in your mails in all languages installed. In the checkboxes top right, please choose those languages you deem appropriate for your mail recipients.\n\nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures). If instead of a language, you choose the file
\n\t signature-SURPRISE.txt
\n$dw will rotate at random.\n\nCertain programs like Seamonkey Mail, Evolution or Trojitá manage signatures internally. Among these $bp can handle Trojitá and Evolution for now."
mcset en f4Tit  "Display $dw in your Linux terminals"
mcset en f4Btn "Create $dw for display in terminal"
mcset en f4Txt "If activated, $bp will create $dw to be displayed at the top of your terminals. If more than one language file are present, Bible text will alternate randomly whenever a new shell is opened. \n\nColours for display etc. may be changed in \n\n\t $confdir/term.conf \n\nNote that in order to display Arabic or Hebrew script correctly, you will need one of the following: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) or 'xfce4-terminal'; these are known to work with bidirectional text.\n\nFor $dw to be displayed automatically in your terminals, $bp Setup makes an entry in ~/.bashrc for your convenience."
# S A V E
mcset en linChangingDesktop "$bp will now try to register with your Desktop Background. If you can't see a new background picture after that, find a solution in the Manual."
mcset en winIgnorePopup "Please dismiss (close) any pop-up windows so $bp can finish registration!"
mcset en winChangingDesktop "$bp will now try to register with your Desktop Background"
mcset en winChangeDesktopProb "We are having a problem changing your Desktop background.\nPlease right-click on an empty spot on your Desktop and select \"Personalize\" > \"Wallpaper\" either set as single pic path \n\t$TwdBMP or \n\t$TwdPNG \nor else set up a slideshow setting the directory to \n\t$imgdir."
mcset en linChangeDesktopProb "We are having a problem changing your Desktop settings.\nPlease right-click on your Desktop and find the dialogue for 'Background picture'. There indicate $imgdir as new image path."
mcset en linNoDesktopFound "No Llinux Desktop detected! Please find out in the manual how to manually set up the $bp background picture."
mcset en linReloadingDesktop "We shall now try to reload your Desktop. If this fails, please log out and in again for the $bp settings to take effect."

if {$os=="Linux"} {
  mcset en changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the $bp Setup program anytime by selecting the \"$bp Setup\" icon in the Program Menu"
} else {
  mcset en changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the $bp Setup program anytime by right-clicking on an free spot on your Desktop and choosing the \"$bp Setup\" icon."
}

mcset en winRegister "$bp will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
mcset en winRegisterProb "$bp has not been registered properly on your computer.\nPlease try rerunning Setup, or add \n\t$Biblepix\n to your Autostart folder."
