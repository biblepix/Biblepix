

proc openReposWin {} {

  set screenX [winfo width .]
  set screenY [winfo height .]
  
  toplevel .reposPhoto -bg beige -padx 20 -pady 20 -height [expr $screenY - 200] -width [expr $screenX - 200]
  canvas .reposPhoto.reposCanv -bg beige -bd 30
#  .resizePhoto.resizeCanv create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}
  
#  .resizePhoto.resizeCanv delete img text
  image create photo reposCanvPic
  
  
  #Make Top & bottom labels
  label .reposPhoto.reposTxtL -text "Textposition ändern" -width 150 -fg red -bg black -font "TkHeaderFont 20 bold"
  label .reposPhoto.reposMsgL -width 50 -textvar reposmsg -fg blue -bg orange -font "TkTextFont 15 bold"
  button .reposPhoto.confirmBtn -text Ok -command {save2png}
  button .reposPhoto.cancelBtn -textvar ::cancel -command {destroy .reposPhoto} 
  
  #Repack whole window
#  pack forget [pack slaves .reposPhoto]
  pack .reposPhoto.reposTxtL
  pack .reposPhoto.reposCanv
  pack .reposPhoto.confirmBtn .reposPhoto.cancelBtn -side right -fill x
  pack .reposPhoto.reposMsgL -fill x -side bottom
  # .resizePhoto.resizeConfirmBtn conf -command {saveFinalImg}

  #Copy cutOrigPic into reposCanv and halve
#  set reposmsg "Haben Sie einen Augenblick Geduld, Bild wird zugeschnitten..."
#  while [catch {image type cutOrigPic}] {
#  puts wirwartennoch...  
#    after 2000
#  }
#  puts fertig!
  update
  
  .reposPhoto.reposCanv create image 0 0 -image reposCanvPic -anchor nw -tags {img mv}
  
  reposCanvPic copy cutOrigPic -subsample 2
  .reposPhoto.reposCanv conf -width [image width reposCanvPic] -height [image height reposCanvPic]

  set ::reposmsg "Verschieben Sie den Text nach Wunsch und speichern Sie dann mit OK.\nDie Textposition und die Schattierung der Textfarbe (heller/dunkler) werden mit dem Bild mitgespeichert."    
  #1. scanArea & put moving text there
  
  #2. Determine brightness & set text colour accordingly
  
  
} ;#End reposWin


