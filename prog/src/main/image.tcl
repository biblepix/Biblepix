# ~/Biblepix/progs/src/main/image.tcl
# Initiates main image process, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 13dec2016 

package require Tk

#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)
if { [catch {package require Img}] } {
	source -encoding utf-8 $Texts
	setTexts $lang
	tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg
	exit
}

#Source procs only once, to be re-run multiple times
if {[info procs createBMPs] == ""} {
	source $Textbild
}
createBMPs

if {[info procs checkImgSize] == ""} {
	source $Hgbild
}

#Select & create random background JPEG
set hgfile [getRandomJPG]
image create photo hgbild -file $hgfile
checkImgSize

#Select & create random foreground BMP
set bmpfile [file join $bmpdir [getRandomBMP]]
image create photo fgbild -file $bmpfile

#Put text on background pic
fgbild>hgbild $hgfile $bmpfile

