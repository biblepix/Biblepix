# English texts for msgcat
# ~/Biblepix/prog/msg/en.msg
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 19aug21 pv

############################################################################################################
## T R A N S L A T O R S : O N L Y   T R A N S L A T E   P H R A S E S   W I T H I N  Q U O T E S "......"
## e.g.:  of  
##    mcset yourlanguage code "..."    - only replace quoted text  "....."
############################################################################################################

################################################################################
## U N T R A N S L A T A B L E S
## P L E A S E   D O N 'T  T O U C H : 
## - ANY PHRASE STARTING WITH #
## - ANY WORD STARTING WITH $
## - ANY PHRASE WITHIN SQUARE BRACKETS [...]
## - ANY FORMATTING MARKERS LIKE \n \n\n \t \u... etc.
## - ANY PHRASE STARTING WITH 'set'
## - ANY WORD STARTING WITH %
################################################################################
set bp "BiblePix"
set dw {'Słowo'}
mcset pl bp $bp

# G E N E R A L
mcset pl bpsetup "$bp Setup"
mcset pl ok "Ok"
mcset pl cancel "Cancel"
mcset pl close "Close"
mcset pl save "Save"
mcset pl saveSettings "Save settings"
mcset pl random "accidental"
mcset pl welcome "Welcome"
mcset pl bibletexts "Bible texts"
mcset pl desktop "Desktop background"
mcset pl photos "Photos"
mcset pl email "E-mail signature"
mcset pl terminal "Terminal"
mcset pl manual "Manual"
mcset pl uninst "Uninstall $bp"
mcset pl next "Next \u25bc"
mcset pl packageRequireMissing "$bp needs the Tcl extension '%s'.\nPlease install via system management, or type one of the following commands in a terminal (as root or sudo): [mc packageRequire]"

# U N I N S T A L L
mcset pl uninstall "Do you really want to remove $bp from your computer?"
mcset pl uninstalling "$bp will now be uninstalled. To clear system settings made, you must confirm any upcoming dialogue boxes with \"Yes\"."
mcset pl uninstalled "$bp has been removed safely from your system. To reinstall, visit our website [mc www] and download $bp Installer." 

#### S E T U P   G U I ################################
mcset pl download "Download"
mcset pl downloadingHttp "Downloading $bp program files..."
mcset pl updatingHttp "Updating $bp program files..."
mcset pl uptodateHTTP "Your program files are up-to-date."
mcset pl noConnHTTP "No Internet connection for program update, please try later."
mcset pl gettingTwd "Fetching current list of Bible text files from bible2.net..."
mcset pl noTwdFilesFound "No current Bible text files are installed.\nIn the $bp Setup, choose at least \n one language text file from the 'International' section."
mcset pl connTwd "Connection to bible2.net established."
mcset pl noConnTwd "No connection to bible2.net. Try later."
mcset pl refresh "Update"
mcset pl delete "Delete file"
mcset pl textposlabel "Set general text position"
mcset pl textposAdjust "Do you want to adjust the text position for this picture before saving?"
mcset pl welcTit "Welcome to the $bp setup program!"
mcset pl welcSubtit1 "What is $bp?"
mcset pl welcTxt1 "$bp is a Tcl program developed for the 'Bible 2.0' project which aims to publish 'Słowo' in a growing number of languages.\n\n'Słowo' consists of two selected Bible verses for each day of the year.\n\n$bp can display 'Słowo' in various ways on your computer."
mcset pl welcSubtit2 "What are your options?"
mcset pl welcTxt2 "\u27a4 [mc bibletexts]: Choose one or several Bible text languages for 'Słowo'
\u27a4 [mc desktop]: Get 'Słowo' on your personal background images, incl. slide show
\u27a4 [mc photos]: Organise your photos for use in $bp
\u27a4 [mc email]: Get 'Słowo' added to your e-mail signatures
\u27a4 [mc terminal]: Display 'Słowo' in your Linux terminals
\u27a4 [mc manual]: Study the Complete Guide to the $bp program"
mcset pl f1Tit "Current list of Bible texts for 'Słowo'"
mcset pl TwdLocalTit "Bible text files installed for $jahr"
mcset pl TwdRemoteTit "Bible text files for download"
mcset pl language "Language"
mcset pl year "Year"
mcset pl bibleversion "Bible version"
mcset pl biblename "Bible name"
mcset pl f1Txt "$bp will create 'Słowo' in any language or Bible version installed on your computer. If several language files are found, $bp will randomly pick one at each run. Any new language files you select for download (see below) will be downloaded upon clicking the '[mc download]' button. Pay attention to the year (current or next)!"
mcset pl f2Tit "Put 'Słowo' on your background images"
mcset pl f2Box "Create background image"
mcset pl f2Farbe "Font colour: "
mcset pl f2Slideshow "Enable slide show"
mcset pl f2Interval "Slide show interval: "
mcset pl sec "seconds"
mcset pl f2Introline "Show date"
mcset pl f2Fontsize "Font size: "
mcset pl f2Fontweight "bold"
mcset pl f2Fontfamily "Font family: "
mcset pl f2Fontexpl "Adjust Font"
mcset pl f2Txt "If activated, $bp will put 'Słowo' on a background picture every time it runs. The picture will be chosen at random from the $bp Photo Collection (see Photos section), and a new background image will be put in \n\n\t [file nativename $imgdir] \n\nfor the Desktop manager to display.\n\nIf more than one Bible text files are installed, the language (or Bible version) will randomly alternate along with the pictures.\n\n$bp will set up a Slide Show with alternating pictures at a given interval. For only 1 picture per day, unset this feature (see above).\n\nThe TEXT POSITION window allows you to put 'Słowo' wherever you like on your screen. Moreover, when adding a photograph to the $bp photo collection, you can position the text individually. \n\nFONT SIZE is set automatically on the basis of the screen height. You may however change letter size and weight to taste (bigger letters = better contrast).\n\nFONT COLOUR can be accidental or set by you. Note that $bp may adjust colour luminance on the basis of background brightness. This takes effect only after a photo has been added to the $bp collection. \n\nShould the new background image fail to appear, please consult the Manual page for a solution."
# S E T U P   P H O T O S 
mcset pl f6Tit "Manage your photos for $bp"
mcset pl f6Txt "Here you can add any suitable photos from your Pictures directory and put them into the $bp photo collection, or remove them from there. Photos should ideally be in landscape format and have some plain-colour surface for good visibility of the Bible text.\n\nIf the size of a photo does not agree with the screen dimensions, $bp will fit it to size and save it to the $bp Photos directory. If refitting is required, you will be asked to choose the desired section of the photo as well as the position of future Bible texts.\n\nAt any rate, the original photo remains unchanged."
mcset pl f6numPhotosTxt "Number of pictures: "
mcset pl f6Add "Add to $bp Photo Collection:"
mcset pl f6Show "Show $bp Photo Collection"
mcset pl f6Find "Find new photos"
mcset pl f6Del "Delete from $bp Photo Collection:"
#RESIZING
mcset pl resizeF_txt "The size of your photo does not correspond to the screen size and has to be trimmed. [mc movePicToResize]"
mcset pl movePicToResize "Move picure section to desired position and press Ok to resize."
mcset pl resizingPic "Resizing photo to fit screen \u2014 please wait a moment..."
mcset pl movePic "Move picture section \u21CA"
mcset pl picSchonDa "Photo already in $bp Photos folder"
# S E T U P   S I G N A T U R E
mcset pl f3Tit "Add 'Słowo' to your e-mail signatures"
mcset pl f3Btn "Create e-mail signature"
mcset pl f3Sprachen "Desired languages for my signatures"
mcset pl f3Txt "If activated, $bp will add 'Słowo' at the end of your e-mail signatures once a day for any language text files present on your computer. Signature files are stored by language shortcut (e.g. signature-en_Englis.txt) in the directory \n\n\t$sigdir \n\nYou can edit these files from your e-mail program, or in a text editor, and add any personal information (greetings, address etc.) at the top. Any text above the separating line ==== will remain untouched when 'The Word' changes. \n\nYou may not desire 'Słowo' to appear in your mails in all languages installed. In the checkboxes top right, please choose those languages you deem appropriate for your mail recipients.\n\nFinally you must instruct your e-mail program to use these signature files (generally under Options>Signatures).\n\nCertain programs like Seamonkey Mail, Evolution or Trojitá manage signatures internally. Among these $bp can handle Trojitá and Evolution for now."
mcset pl f4Tit  "Display 'Słowo' in your Linux terminals"
mcset pl f4Btn "Create 'Słowo' for display in terminal"
mcset pl f4Txt "If activated, $bp will create 'Słowo' to be displayed at the top of your terminals. If more than one language file are present, Bible text will alternate randomly whenever a new shell is opened. \n\nColours for display etc. may be changed in \n\n\t $confdir/term.conf \n\nNote that in order to display Arabic or Hebrew script correctly, you will need one of the following: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) or 'xfce4-terminal'; these are known to work with bidirectional text.\n\nFor 'Słowo' to be displayed automatically in your terminals, [mc bpsetup] makes an entry in ~/.bashrc for your convenience."
# S A V E
mcset pl linChangingDesktop "$bp will now try to register with your Desktop Background. If you can't see a new background picture after that, find a solution in the Manual."
mcset pl winIgnorePopup "Please dismiss (close) any pop-up windows so $bp can finish registration!"
mcset pl winChangingDesktop "$bp will now try to register with your Desktop Background"
mcset pl winChangeDesktopProb "We are having a problem changing your Desktop background.\nPlease right-click on an empty spot on your Desktop and select \"Personalize\" > \"Wallpaper\" either set as single pic path \n\t$TwdBMP or \n\t$TwdPNG \nor else set up a slideshow setting the directory to \n\t$imgdir."
mcset pl linChangeDesktopProb "We are having a problem changing your Desktop settings.\nPlease right-click on your Desktop and find the dialogue for 'Background picture'. There indicate $imgdir as new image path."
mcset pl linNoDesktopFound "No Llinux Desktop detected! Please find out in the manual how to manually set up the $bp background picture."
mcset pl linReloadingDesktop "We shall now try to reload your Desktop. If this fails, please log out and in again for the $bp settings to take effect."
mcset pl changeDesktopOk "$bp has been configured successfully and will start shortly.\n\nYou can run the [mc bpsetup] program anytime by selecting the [mc bpsetup] icon in the Program Menu (Linux) or by right-click on your Desktop (Windows)."
mcset pl winRegister "$bp will no try to register with your system.\nYou must confirm any dialogue boxes with \"Yes\"."
mcset pl winRegisterProb "$bp has not been registered properly on your computer.\nPlease try rerunning [mc bpsetup], or add \n\t$Biblepix\n to your Autostart folder."
# P H O T O S
mcset pl deletedPicMsg "Deleted picture from $bp photo collection:"
mcset pl copiedPicMsg "Copied picture to $bp photo collection:"
mcset pl reposSaved "Picture saved with Info."
mcset pl reposNotSaved "Picture not saved."
mcset pl noPhotosFound "No photos were found in the $bp [mc photos] folder. Please copy some pictures into the folder."
mcset pl rotatePic "Rotate picture"
mcset pl preview90 "\u21B7 Preview 90° rotation"
mcset pl preview180 "\u21BB Preview 180° rotation"
mcset pl computePreview "\u21B6 \u21B7 Preview any rotation"
mcset pl rotateWait "Please wait patiently while rotating original picture..."
mcset pl rotateInfo "Note: by saving and reloading, a picture can be rotated in several steps!"
