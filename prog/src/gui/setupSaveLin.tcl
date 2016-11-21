# ~/Biblepix/prog/src/gui/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 16nov2016

## REMOVE ANY OLD BIBLEPIX INSTALLATIONS
 
file delete -force ~/.biblepix
#check .bashrc for old entry and remove
set chan [open ~/.bashrc]
set readfile [read $chan]
close $chan
set string1 {biblepix}
set string2 {prog/bash}

if {[regexp $string1 $readfile] || [regexp $string2 $readfile]} {
	regsub -all -line "^$string1.*$" $readfile {} readfile
        regsub $string2 $readfile {prog/unix} readfile
        set chan [open ~/.bashrc w]
	puts $chan $readfile
	close $chan
}

#move any old jpegs to $picsdir
set jpglist [glob -nocomplain -directory $rootdir *.jpg *.jpeg *.JPG *.JPEG] 
foreach file $jpglist {
	file copy -force $file $picsdir
	file delete -force $file
}

#Set Desktop entries for GNOME & KDE

#Create .desktop file for KDE/Gnome Autostart & program menu
set KDEdir [glob -nocomplain ~/.kde*]
set desktoppath ~/.local/share/applications
set GNOMEautostartpath ~/.config/autostart
set KDEautostartpath $KDEdir/Autostart
set tclpath [exec which tclsh]

set desktopText "\[Desktop Entry\]
Name=BiblePix Setup
Type=Application
Icon=$unixdir/biblepix.svg
Path=$srcdir
Categories=Settings
Comment=Configures and runs BiblePix"

#make sure common dirs exist
file mkdir $desktoppath $GNOMEautostartpath

#make .desktop file for KDE Autostart
if {[file exists $KDEdir]} {
    file mkdir $KDEautostartpath
    set desktopfile [open $KDEautostartpath/biblepix.desktop w]
    puts $desktopfile "$desktopText"
    puts $desktopfile "Exec=$tclpath biblepix.tcl"
    close $desktopfile
}

#make .desktop file for GNOME & KDE prog menu (removing old file!)
file delete $desktoppath/biblepix.desktop
set desktopfile [open $desktoppath/biblepixSetup.desktop w]
puts $desktopfile "$desktopText"
puts $desktopfile "Exec=$tclpath biblepix-setup.tcl"
close $desktopfile
 
#make .desktop file for GNOME Autostart
set desktopfile [open $GNOMEautostartpath/biblepix.desktop w]
puts $desktopfile "$desktopText"
puts $desktopfile "Exec=$tclpath biblepix.tcl"
close $desktopfile


## Set background picture/slideshow if $enablepic
if {$enablepic} {

# MAKE AUTOSTART ENTRIES
	tk_messageBox -type ok -title "BiblePix Installation" -message $linChangeDesktop

	#KDE3
	if {[auto_execok dcop] != ""} {
		dcop kdesktop KDesktopIface setWallpaper $TwdPNG 4
	}
	
	#KDE4-5 - needs min. 1 JPG or PNG for slideshow
	if {[auto_execok kwriteconfig] != ""} {
 		
	 	#if single pic make sure it is renewed at start, later same pic reloaded...
		source $config
		if {!$slideshow} {set slideshow 120}
             		
		#KDE5
		if {[file exists ~/.config/plasma-org.kde.plasma.desktop-appletsrc]} {
			set rcfile [file join $HOME .config plasma-org.kde.plasma.desktop-appletsrc]
			set oks "org.kde.slideshow"

			for {set g 1} {$g<100} {incr g} {
            
				if {[exec kreadconfig --file $rcfile --group Containments --group $g --key activityId] != ""} {
                
					#1.Save current settings for uninstall (only 1 group)
					set KDErestore $unixdir/KDErestore.sh

					if {![file exists $KDErestore]} { 

						set wallpaperplugin [exec kreadconfig --file $rcfile --group Containments --group $g --key wallpaperplugin]
						set Image [exec kreadconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General --key Image]
						set SlidePaths [exec kreadconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General -key SlidePaths]

						set chan [open $KDErestore w]
						puts $chan "\#\!bin\/bash"
						puts $chan wallpaperplugin=$wallpaperplugin
						puts $chan Image=$Image
						puts $chan SlidePaths=$SlidePaths
						puts $chan "kwriteconfig --file $rcfile --group Containments --group $g --key wallpaperplugin $wallpaperplugin"
						puts $chan "kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General --key Image $Image"
						puts $chan "kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General --key SlidePaths $SlidePaths"
						puts $chan "kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $wallpaperplugin --group General --key Image $Image"
						puts $chan "kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $wallpaperplugin --group General --key SlidePaths $SlidePaths"
						close $chan
					}

					#2.Set up slideshow or single pic (no path vars wegen bash!)
					##1.[Containments][$g] >wallpaperplugin - must be slideshow, bec. single pic never renewed!
					exec kwriteconfig --file $rcfile --group Containments --group $g --key wallpaperplugin $oks
					##2.[Containments][$g][Wallpaper][General] >Image+SlidePaths
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General --key Image file://$TwdPNG
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group General --key SlidePaths $imgdir 
					##3.[Containments][7][Wallpaper][org.kde.slideshow][General] >SlideInterval+SlidePaths+height+width
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlidePaths $imgdir
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key SlideInterval $slideshow
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key height [winfo screenheight .]
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key width [winfo screenwidth .]
					#FillMode 6=centered
					exec kwriteconfig --file $rcfile --group Containments --group $g --group Wallpaper --group $oks --group General --key FillMode 6
				}
			}
            
		#if not KDE5
		} else {
                    
			#KDE4
			if {$slideshow} {
				set slidepaths $imgdir
				set mode Slideshow
			} else {
				set slidepaths ""
				set mode SingleImage
			}
        
			for {set g 1} {$g<200} {incr g} {
	                #paths ausgeschrieben!
				if {[exec kreadconfig --file plasma-desktop-appletsrc --group Containments --group $g --key wallpaperplugin] != ""} {
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --key mode $mode
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key slideTimer $slideshow
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key slidepaths $slidepaths
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key userswallpapers ''
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpaper $TwdPNG
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpapercolor 0,0,0
				    exec kwriteconfig --file plasma-desktop-appletsrc --group Containments --group $g --group Wallpaper --group image --key wallpaperposition 0
				}
			}
		}
            
	} ;#END setup KDE4-5
	
	#Restart KDE4+5
        
     ##determine which version is running
	if {! [catch {exec pidof plasmashell}] } {
		set plasmaversion "plasmashell"
	} elseif {! [catch {exec pidof plasma-desktop}] } {
		set plasmaversion "plasma-desktop"
	}
    
    	if { [info exists plasmaversion] } {    
		
		set antwort [tk_messageBox -type yesno -message $KDErestart]

		if {$antwort=="yes"} {

			#determine kill prog
			if {[auto_execok kquitapp5] != ""} {
				set quitprog kquitapp5
			} elseif {[auto_execok kquitapp] != ""} {
				set quitprog kquitapp
			} else {
				set quitprog killall
			}
    
			#kill any running KDE
			wm withdraw .
			exec $quitprog $plasmaversion
			exec $plasmaversion
		}
    	}
	
	
	
	#GNOME3 -needs no slideshow, needs BMP
	if {[auto_execok gsettings] != ""} {
		exec gsettings set org.gnome.desktop.background picture-uri file://$TwdBMP
	
#GNOME2 -needs no slideshow, needs PNG
#The former way to change wallpaper in Gnome2 consists in use gconftool-2, but this tool has no effect in Gnome3.

	} elseif {[auto_execok gconftool-2] != ""} {
		exec gconftool-2 --direct --type string --set /desktop/gnome/background/picture_options wallpaper
		exec gconftool-2 --direct --type string --set /desktop/gnome/background/picture_filename $TwdPNG
	} 
	
#X F C E 4  - knows TIFF/BMP/PNG !
#detects pic change, so no slideshow necessary! ??????????????????

	if {[auto_execok xfconf-query]!=""} {
		for {set s 0} {$s<5} {incr s} {
			for {set m 0} {$m<5} {incr m} {
				catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-path -s $TwdBMP" err
				catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-style -s 3" err
				catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-show -s true" err
					if {$slideshow} {
						set backdropdir ~/.config/xfce4/desktop
						file mkdir $backdropdir
						set imglist $backdropdir/backdrop.list
						set chan [open $imglist w]
						puts $chan "$TwdBMP\n$TwdTIF"
						close $chan
						catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create last-image-list -s $imglist" err
						catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create backdrop-cycle-enable -s true" err
						catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create backdrop-cycle-timer [expr $slideshow/60]" err	
							if {$err!=""} {continue}
						}
				}
			}
		#reload XFCE4 desktop if running
		if {! [catch "exec pidof xfdesktop"] }  {
            wm withdraw .
            exec xfdesktop --reload
		}
	}
	
} ;#end if enablepic


#Finish - wird's noch gelesen?
.news configure -bg lightblue
set news "Exiting Setup..."
tk_messageBox -type ok -message $changeDesktopOk
