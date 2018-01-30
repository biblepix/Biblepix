# ~/Biblepix/prog/src/gui/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 26jan18

#Disable all tabs & main buttons
#foreach tab [.n tabs] {.n tab $tab -state disabled}
#.b4 conf -state disable
#.b5 conf -state disable

#Pack .resizeF in nb.photos
#.n tab nb.photos -state normal
#.n select 4

.nb add [frame .resizeF] -text "Photo Resize"
#pack [frame .resizeF] -in .nb.resize
.nb select .resizeF

label .resizeF.tit -textvar resizeF_tit -font bpfont3
message .resizeF.txt -textvar resizeF_txt
pack .resizeF.tit .resizeF.txt -anchor w -in .resizeF
pack .imgCanvas -in .resizeF -side left

#Create buttons
button .resizeConfirmBtn
button .resizeCancelBtn
.resizeConfirmBtn configure -text Ok -command {doResize} -bg green
.resizeCancelBtn configure -textvar ::cancel -command {restorePhotosTab}
pack .resizeCancelBtn .resizeConfirmBtn -in .resizeF -side right
  
  #Create selection frame/ area chooser ???
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]

  set factor [expr $imgX. / $screenX]

  #limit move capability to y
  set x 0
  set y "%y"

  if {[expr $imgY. / $factor] < $screenY} {
    set factor [expr $imgY. / $screenY]

    #limit move capability to x
    set y 0
    set x "%x"
  }

  ##set cutting coordinates for cutFrame
  set canvCutX2 [expr $screenX * $factor]
  set canvCutY2 [expr $screenY * $factor]

  # 2. Create AreaChooser with cutting coordinates
#  createPhotoAreaChooser .imgCanvas $canvCutX2 $canvCutY2

  #TODO: Rahmen kann über Bild hinausgehen !!!
  .imgCanvas bind mv <1> {movestart %W %x %y}
  .imgCanvas bind mv <B1-Motion> "move %W $x $y"