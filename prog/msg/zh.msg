# English texts for msgcat
# ~/Biblepix/prog/msg/zh.msg
# sourced by SetupMainFrame
# Sets Chinese texts in BiblePix-Setup
# Author: Peter Vollmar, biblepix.vollmar.ch
##INFO: Textmenge ca. 1900 W. -
## (100 mcset * 3 W. =) -300 W.
## (Comments) -20 (variables ($) -80 = 1500 W.
# Updated: 19aug21 pv

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

set bp "圣经图文"
set dw "金句"
mcset zh dw 金句
mcset zh bp $bp

# G E N E R A L
mcset zh ok "Ok"
mcset zh cancel "Cancel"
mcset zh close "Close"
mcset zh delete "Delete file"
mcset zh save "Save"
mcset zh saveSettings "Save settings"
mcset zh random "accidental"
mcset zh welcome "Welcome"
mcset zh bibletexts "Bible texts"
mcset zh desktop "Desktop background"
mcset zh photos "Photos"
mcset zh email "E-mail signature"
mcset zh terminal "Terminal"
mcset zh manual "Manual"
mcset zh uninst "Uninstall $bp"
mcset zh next "Next \u25bc"
mcset zh packageRequireMissing "$bp needs the Tcl extension '%s'.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo): [mc packageRequire]"

# U N I N S T A L L
mcset zh uninstall "Do you really want to remove $bp from your computer?"
mcset zh uninstalling "$bp will now be uninstalled. To clear system settings made, you must confirm any upcoming dialogue boxes with \"Yes\"."
mcset zh uninstalled "$bp has been removed safely from your system. To reinstall, visit our website [mc www] and download $bp Installer." 

#### S E T U P   G U I ################################
mcset zh download "Download"
mcset zh downloadingHttp "Downloading $bp program files..."
mcset zh updatingHttp "Updating $bp program files..."
mcset zh uptodateHTTP "Your program files are up-to-date."
mcset zh noConnHTTP "No Internet connection for program update, please try later."
mcset zh gettingTwd "Fetching current list of Bible text files from bible2.net..."
mcset zh noTwdFilesFound "No current Bible text files are installed.\nIn the $bp Setup, choose at least one language text file from the '[mcset bibletexts]' section."
mcset zh connTwd "Connection to bible2.net established."
mcset zh noConnTwd "No connection to bible2.net. Try later."
mcset zh bpsetup "$bp Setup"
mcset zh refresh "Update"
mcset zh textposlabel "Set general text position"
mcset zh textposAdjust "Do you want to adjust the text position for this picture before saving?"
mcset zh welcTit "Welcome to the $bp setup program!"
mcset zh welcSubtit1 "What is $bp?"
mcset zh welcTxt1 "$bp is a Tcl program developed for the 'Bible 2.0' project which aims to publish 金句\nin a growing number of languages.\n\n金句 consists of two selected Bible verses for each day of the year.\n\n$bp can display 金句 in various ways on your computer."
mcset zh welcSubtit2 "What are your options?"
mcset zh welcTxt2 "\u27a4 [mc bibletexts]: Choose one or several Bible text languages for 金句
\u27a4 [mc desktop]: Get 金句 on your personal background images, incl. slide show
\u27a4 [mc photos]: Organise your photos for use in $bp
\u27a4 [mc email]: Get 金句 added to your e-mail signatures
\u27a4 [mc terminal]: Display 金句 in your Linux terminals
\u27a4 [mc manual]: Study the Complete Guide to the $bp program"
mcset zh f1Tit "Current list of Bible texts for 金句"
mcset zh TwdLocalTit "Bible text files installed for $jahr"
mcset zh TwdRemoteTit "Bible text files for download"
mcset zh language "Language"
mcset zh year "Year"
mcset zh bibleversion "Bible version"
mcset zh biblename "Bible name"
mcset zh f1Txt "$bp will create 金句 in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select for download (see below) will be downloaded upon clicking the '[mc download]' button. Pay attention to the year (current or next)!"
mcset zh f2Tit "Put 金句 on your background images"
mcset zh f2Box "Create background image"
mcset zh f2Farbe "Font colour: "
mcset zh f2Slideshow "Enable slide show"
mcset zh f2Interval "Slide show interval: "
mcset zh sec "seconds"
mcset zh f2Introline "Show date"
mcset zh f2Fontsize "Font size: "
mcset zh f2Fontweight "bold"
mcset zh f2Fontfamily "Font family: "
mcset zh f2Fontexpl "Adjust Font"
mcset zh f2Txt "\nIf activated, $bp will put 金句 on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see Photos section), and a new background image will be put in \n\n\t [file nativename $imgdir] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\n$bp will set up a Slide Show with alternating pictures at a given interval. For only 1 picture per day, unset this feature (see above).\n\nThe TEXT POSITION window allows you to put 金句 wherever you like on your screen. Moreover, when adding a photograph to the $bp photo collection, you can position the text individually. \n\nFONT SIZE is set automatically on the basis of the screen height. You may however change letter size and weight to taste (bigger letters = better contrast).\n\nFONT COLOUR can be accidental or set by you. Note that $bp may adjust colour luminance on the basis of background brightness. This takes effect only after a photo has been added to the $bp collection. \n\nShould the new background image fail to appear, please consult the Manual page for a solution."
# S E T U P   P H O T O S 
mcset zh f6Tit "Manage your photos for $bp"
mcset zh f6Txt "Here you can add any suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. Photos should ideally be in landscape format and have some plain-colour surface for good visibility of the Bible text.\n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory. If refitting is required, you will be asked to choose the desired section of the photo as well as the position of future Bible texts.\n\nAt any rate, the original photo remains unchanged."
mcset zh f6numPhotosTxt "Number of pictures: "
mcset zh f6Add "Add to $bp Photo Collection:"
mcset zh f6Show "Show $bp Photo Collection"
mcset zh f6Find "Find new photos"
mcset zh f6Del "Delete from $bp Photo Collection:"
mcset zh deletedPicMsg "Deleted picture from $bp photo collection:"
mcset zh copiedPicMsg "Copied picture to $bp photo collection:"
mcset zh reposSaved "Picture saved with Info."
mcset zh reposNotSaved "Picture not saved."
mcset zh noPhotosFound "No photos were found in the $bp Photos folder. Please copy some pictures into the folder."
#RESIZING & ROTATING
mcset zh rotatePic "Rotate picture"
mcset zh preview90 "\u21B7 Preview 90° rotation"
mcset zh preview180 "\u21BB Preview 180° rotation"
mcset zh computePreview "\u21B6 \u21B7 Preview any rotation"
mcset zh rotateWait "Please wait patiently while rotating original picture..."
mcset zh rotateInfo "Note: by saving and reloading, a picture can be rotated in several steps!"
mcset zh resizeF_txt "The size of your photo does not correspond to the screen size and has to be trimmed. [mc movePicToResize]"
mcset zh movePicToResize "Move picure section to desired position and press Ok to resize."
mcset zh resizingPic "Resizing photo to fit screen \u2014 please wait a moment..."
mcset zh movePic "Move picture section \u21CA"
mcset zh picSchonDa "Photo already in $bp Photos folder"
# S E T U P   S I G N A T U R E
mcset zh f3Tit "Add 金句 to your e-mail signatures"
mcset zh f3Btn "Create e-mail signature"
mcset zh f3Sprachen "Desired languages for my signatures"
mcset zh f3Txt "If activated, $bp will add 金句 at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en_Englis.txt) in the directory \n\n\t$sigdir \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \n\nYou may not desire 金句 to appear in your mails in all languages installed. In the checkboxes top right, please choose those languages you deem appropriate for your mail recipients.\n\nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures).\n\nCertain programs like Seamonkey Mail, Evolution or Trojitá manage signatures internally. Among these $bp can handle Trojitá and Evolution for now."
mcset zh f4Tit  "Display 金句 in your Linux terminals"
mcset zh f4Btn "Create 金句 for display in terminal"
mcset zh f4Txt "If activated, $bp will create 金句 to be displayed at the top of your terminals. If more than one language file are present, Bible text will alternate randomly whenever a new shell is opened. \n\nColours for display etc. may be changed in \n\n\t $confdir/term.conf \n\nNote that in order to display Arabic or Hebrew script correctly, you will need one of the following: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) or 'xfce4-terminal'; these are known to work with bidirectional text.\n\nFor 金句 to be displayed automatically in your terminals, $bp Setup makes an entry in ~/.bashrc for your convenience."
# S A V E
mcset zh linChangingDesktop "$bp will now try to register with your Desktop Background. If you can't see a new background picture after that, find a solution in the Manual."
mcset zh winIgnorePopup "Please dismiss (close) any pop-up windows so $bp can finish registration!"
mcset zh winChangingDesktop "$bp will now try to register with your Desktop Background"
mcset zh winChangeDesktopProb "We are having a problem changing your Desktop background.\nPlease right-click on an empty spot on your Desktop and select \"Personalize\".\nUnder \"Wallpaper\" either set as single pic path $TwdBMP or \n$TwdPNG \nor else set up a slideshow setting the directory to \n$imgdir ."
mcset zh linChangeDesktopProb "We are having a problem changing your Desktop settings.\nPlease right-click on your Desktop and find the dialogue for 'Background picture'. There indicate $imgdir as new image path."
mcset zh linNoDesktopFound "No Llinux Desktop detected! Please find out in the manual how to manually set up the $bp background picture."
mcset zh linReloadingDesktop "We shall now try to reload your Desktop. If this fails, please log out and in again for the $bp settings to take effect."
mcset zh changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the $bp Setup program anytime by selecting the \"$bp Setup\" icon in the Program Menu (Linux) or by right-click on your Desktop (Windows)."
mcset zh winRegister "$bp will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
mcset zh winRegisterProb "$bp has not been registered properly on your computer.\nPlease try rerunning Setup, or add \n$$bp\n to your Autostart folder."
