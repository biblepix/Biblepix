# ~/Biblepix/prog/src/setup/setupPicThread.tcl
# Adds threading capability for faster image loading in Setup/Photos
# Setup will work even without this feature
# Updated 23may24 

#package require Thread

#check vars set by SetupBuildGUI
#return if missing
catch {set picL $canvpic::picL} err
catch {set imgdir $canvpic::picdir} err
if [info exists err] {
  return 1
}
if { [info vars canvpic::canvX] == "" || $canvpic::canvX < 500} {
  setPhotosCanvSize
}

tsv::set canvas canvX $canvpic::canvX 
tsv::set canvas canvY $canvpic::canvY
tsv::set picL pics $picL
tsv::set dirs imgdir $imgdir

puts "PicThread loaded..."

if ![info exists ::tpoolId] {
  set ::tpoolId  [tpool::create]
}

#only 1 tpool needed, too many pools tend to overload CPU
tpool::post $::tpoolId {
  
  package require Img
   
  #retrieve global vars
  set picL [tsv::get picL pics]
  set imgdir [tsv::get dirs imgdir]
  set dirname [file tail $imgdir]
  set canvX  [tsv::get canvas canvX]
  set canvY  [tsv::get canvas canvY]
   
  foreach pic $picL {

    #only create pic if not loaded before
    if [tsv::exists $dirname $pic] {
      continue
    }

    puts "tpool loading $pic"
 
    image create photo $pic
    $pic read [file join $imgdir $pic]

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
    tsv::set [file tail $imgdir] $pic [thumb data]
    
    #Cleanup pool to free memory
    ##i.e. keep only data strings
    ##these should remain in tpool during all of Setup
    ##so we don't delete tpool!
    image delete $pic
    image delete thumb

  } ;#END foreach pic

} ;#END tpool

