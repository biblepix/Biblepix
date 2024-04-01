package require Thread

#TODO for testing
#set imgdir /home/pv/Bilder/Caniço23-24
#set picL [glob -tails -directory $imgdir *.png]
set picL $canvpic::picL
set imgdir $canvpic::picdir

#these were set by SetupBuildGUI
#but if not...
if {$canvpic::canvX < 500} {
  setPhotosCanvSize
}
tsv::set canvas canvX $canvpic::canvX 
tsv::set canvas canvY $canvpic::canvY
tsv::set picL pics $picL
tsv::set dirs imgdir $imgdir

#TODO TODO TODO
tsv::set scaleFactor \[scaleFactor somepic\]

puts "PicThread loaded..."

#TODO? scheint nicht nötig:
set threadId [thread::create]

#das auch nicht?:
#thread::send $threadId {

#only 1 tpool needed, too many pools tend to overload CPU
tpool::post [tpool::create] {
  
  package require Img
   
  #retrieve global vars
  set picL [tsv::get picL pics]
  set imgdir [tsv::get dirs imgdir]
  set canvX  [tsv::get canvas canvX]
  set canvY  [tsv::get canvas canvY]
   
  foreach pic $picL {

      puts "tpool $pic"
 
    image create photo $pic
    $pic read [file join $imgdir $pic]

##This workED! for testing:
#$pic write /tmp/$pic -format PNG
#adhena!
#continue

    #Compute scale factor for each pic
    set imgX [image width $pic]
    #set factor [expr ceil($imgX. / $canvX)]
    set factor [expr round($imgX / $canvX)]

  set imgY [image height $pic]
  if {[expr $imgY / $factor] > $canvY} {
    set factor [expr round($imgY / $canvY)]
  }

    image create photo thumb
    thumb copy $pic -subsample $factor

    
#thumb write /tmp/$pic -format JPEG

    tsv::set data $pic [thumb data]
    
#TODO OK zis is working now!
#set ch [open /tmp/factor.txt w]
#puts $ch $factor
#close $ch
 
    #Create thumbnail & save data to tsv var
    
#TODO testing -ko
#thumb write /tmp/$pic -format PNG
#adhena halleluja!



    #Cleanup pool to free memory
    ##i.e. keep only data strings
    ##these should remain in tpool during all of Setup
    ##so no need to delete thread/tpool!
    $pic blank
    thumb blank

  } ;#END foreach pic

} ;#END tpool

#} ;#END Thread
