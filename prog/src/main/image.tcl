# ~/Biblepix/progs/src/main/image.tcl
# Initiates main image process, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 2nov2016 

package require Tk

#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)
if { [catch {package require Img}] } {
	source -encoding utf-8 $Texts
	setTexts $lang
	tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg
	exit
}

source $Textbild
checkBMPs

source $Hgbild
checkImgSize
fgbild>hgbild $bmpfile

