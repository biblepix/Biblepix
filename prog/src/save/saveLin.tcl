# ~/Biblepix/prog/src/save/saveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30mch20

source $SetupSaveLinHelpers
source $SetupTools
source $SetBackgroundChanger

set Error 0
set hasError 0

#Check / Amend Linux executables - TODO: Test again
catch {formatLinuxExecutables} Error
puts "LinExec: $Error"

##################################################
# 1 Set up Linux A u t o s t a r t for all Desktops
##################################################
if [catch {setupLinAutostart} Err] {
  puts $Err
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
}


####################################################
# 2 Set up Menu entries for all Desktops
####################################################

# Check running desktop
##returns 1 if GNOME
##returns 2 if KDE
##returns 3 if XFCE4
##returns 4 if Wayland/Sway
##returns 0 if no running desktop detected
set runningDesktop [detectRunningLinuxDesktop]

#Install crontab autostart if no Desktop found - TODO: Test again
#TODO: apologize for not making menu entry...
if {$runningDesktop == 0} {
  puts "No Running Desktop found"
  catch {setupLinCrontab} Error0
  puts "Crontab: $Error0"
}

#Install Menu entries for all desktops - no error handling
catch setupLinMenu Error
#puts "LinMenu $Error"
catch setupKdeActionMenu Error
#puts "KdeAction $Error"


#################################################
# 3 Set up Linux terminal -- TODO? error handling?
#################################################
if {$enableterm} {
  catch setupLinTerminal Error
  puts "Terminal: $Error"
}

#Exit if no picture desired
if {!$enablepic} {
  return 0
}


#####################################################
## 4 Set up Desktop Background Image - with error handling
#####################################################

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop

set GnomeErr [setupGnomeBackground]
set KdeErr   [setupKdeBackground]
set XfceErr  [setupXfceBackground]

#Create OK message for each successful desktop configuration
if {$GnomeErr==0} {
  lappend desktopList GNOME /
}
if {$KdeErr==0} {
  lappend desktopList {KDE Plasma} /
}
if {$XfceErr==0} {
  lappend desktopList XFCE4
}
#puts "desktopList: $desktopList"

#Create Ok message if desktopList not empty
if [info exists desktopList] {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopList: $changeDesktopOk" 

#Create Error message if no desktop configured
} else {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
}


########################################################
# 5 Try reloading KDE & XFCE Desktops - no error handling
# Gnome(1) & Sway(4) need no reloading
########################################################
if {$runningDesktop !=2 && $runningDesktop !=3} {
  return "Desktop needs no reloading"
} elseif {$runningDesktop==2} {
  set desktopName "KDE Plasma"
} elseif {$runningDesktop==3} {
  set desktopName "XFCE4"
}

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopName: $linReloadingDesktop"

#Run progs end finish
if {$runningDesktop==2} {
  catch reloadKdeDesktop Error
  puts "reloadKde $Error"
  
} elseif {$runningDesktop==3} {
  catch reloadXfceDesktop Error
  puts "runningDesktop $Error"
}



#TODO Check with Live Install CD!!!
#
#Provide correct "Images" path for Unix/Linux languages
proc setLinDesktopPicturesDir {} {

  #ru
  if { [file exists $HOME/Снимки] } {
    set DesktopPicturesDir $HOME/Снимки
  #hu
  } elseif { [file exists $HOME/Képek] } {
    set DesktopPicturesDir $HOME/Képek
  #tr
  } elseif { [file exists $HOME/Resimler] } {
    set DesktopPicturesDir $HOME/Resimler
  #uz
  } elseif { [file exists $HOME/Suratlar] } {
    set DesktopPicturesDir $HOME/Suratlar
  #ar صور
  } elseif { [file exists [file join $HOME صور ]] } {
    set DesktopPicturesDir "[file join $HOME صور ]"
  #zh 图片
  } elseif { [file exists [file join $HOME 图片 ]] } {
    set DesktopPicturesDir "[file join $HOME 图片 ]"

  #General Ima(ge) | Bil(der) etc.
  } elseif {
      ![catch {glob Imag*} result] ||
      ![catch {glob Immag*} result] ||
      ![catch {glob Imág*} result] ||
      ![catch {glob Pict*} result] ||
      ![catch {glob Bil*} result] } {
    set DesktopPicturesDir $HOME/$result
  #All else: set to $HOME
  } else {
    set DesktopPicturesDir $HOME
  }
  
  #TODO 2. Versuch:
    if [file isdirectory ~/Bilder]   {set dirlist(photosDir) [file join $HOME Bilder]}
    if [file isdirectory ~/Képek]    {set dirlist(photosDir) [file join $HOME Képek]}
    if [file isdirectory ~/Resimler] {set dirlist(photosDir) [file join $HOME Resimler]}
    if [file isdirectory ~/Suratlar] {set dirlist(photosDir) [file join $HOME Suratlar]}
    if [file isdirectory ~/Immagini] {set dirlist(photosDir) [file join $HOME Immagini]}
    if [file isdirectory ~/Images]   {set dirlist(photosDir) [file join $HOME Images]}
    if [file isdirectory ~/Imagini]  {set dirlist(photosDir) [file join $HOME Imagini]}
    if [file isdirectory ~/Imágenes] {set dirlist(photosDir) [file join $HOME Imágenes]}
    if [file isdirectory ~/Billeder] {set dirlist(photosDir) [file join $HOME Billeder]}
    if [file isdirectory [file join $HOME תמונות]] {set dirlist(photosDir) [file join $HOME תמונות]}
    if [file isdirectory [file join $HOME رسوم]] {set dirlist(photosDir) [file join $HOME رسوم]}
    if [file isdirectory [file join $HOME Снимки]] {set dirlist(photosDir) [file join $HOME Снимки]}
    if [file isdirectory [file join $HOME Суратлар]] {set dirlist(photosDir) [file join $HOME Снимки]}
    if [file isdirectory [file join $HOME Obrazy]] {set dirlist(photosDir) [file join $HOME Obrazy]}
    
    #verify these!
    if [file isdirectory [file join $HOME ภาพ]] {set dirlist(photosDir) [file join $HOME ภาพ]}
    if [file isdirectory [file join $HOME 圖片]] {set dirlist(photosDir) [file join $HOME 圖片]}
  
} ;#END setLinDesktopPicturesDir

return 0
