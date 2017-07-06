#~/Biblepix/prog/src/save/setupSaveLinHelpers.tcl
# Sourced by SetupSaveLin
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6jul17

proc setLinCrontab args {
#Detects running crond & installs new crontab
#returns 0 or 1
global Biblepix Setup slideshow tclpath unixdir env

	set cronfileOrig $unixdir/crontab.ORIG
	
	#check for running cron/crond
	catch {exec pidof crond} crondpid
	catch {exec pidof cron} cronpid

	#Exit if crontab not found
	if { [auto_execok crontab] ==""} {
		return 1
	}

	#Exit if cron OR crond not running
	if { 	! [string is digit $cronpid] && 
		! [string is digit $crondpid]
		} {
		return 1
	}	
	
	#if ARGS: Delete any crontab entries & exit
	if {$args != ""}  {
		if {[file exists $cronfileOrig]} {
			exec crontab $cronfileOrig
		} else {
			exec crontab -r
		}
		return 1
	}
	
	
### 1. Prepare crontab text
 
	#Check for user's crontab & save 1st time
	if { 	! [catch {exec crontab -l}] && 
        		! [file exists $cronfileOrig] 
		} { 
		set runningCrontext [exec crontab -l]
		#save only if not B|biblepix
		if {![regexp iblepix $runningCrontext]} {
			set chan [open $cronfileOrig w]
			puts $chan $runningCrontext
			close $chan
		}
	}		

	#Prepare new crontab entry
	set cronScript $unixdir/cron.sh
	set cronfileTmp /tmp/crontab.TMP

	if {$slideshow>0} {			
		set interval [expr $slideshow/60]
		set BPcrontext "*/$interval * * * * $cronScript"	
	} else {
		set BPcrontext "@reboot $cronScript"
	}	
			
	#Check presence of saved crontab
	if {[file exists $cronfileOrig]} {
		set chan [open $cronfileOrig r]
		set crontext [read $chan]
		close $chan
	}

	#Create/append new crontext, save&execute
	if {[info exists crontext]} {
		append crontext \n$BPcrontext
	} else {
		set crontext $BPcrontext
	}
 	set chan [open $cronfileTmp w]
	puts $chan $crontext
	close $chan

	exec crontab $cronfileTmp
	file delete $cronfileTmp
	
	
### 2. Prepare cronscript text
	
	#Check for newest XAUTH file (likely the one in use!)
	set authfiles [glob $env(HOME)/.*thority]

	foreach file $authfiles {
		lappend authfileTimeList [file mtime $file]$file
	}
	#biggest=newest is last
	set sorted [lsort $authfileTimeList]
	regsub -all {[[:digit:]]} [lindex $sorted end] {} XAUTH 
	
	#Check for Xlock file
	if {[file exists /tmp/.X0-lock]} {
		#Gentoo,Ubuntu,openSuse
		set XLOCK /tmp/.X11-unix/X0
	} else {
		#Gentoo, ?Rest
		set XLOCK /tmp/.X0-lock
	}

	#create cronScript text
	set cronScriptText "
	until \[ -S $XLOCK \] ; do
		sleep 30
	done
	while \[ $XAUTH -ot $XLOCK \] ; do 
		sleep 30
	done
	export DISPLAY=:0
	$tclpath $Biblepix
	"
	#save cronscript & make executable
	set chan [open $cronScript w]
	puts $chan $cronScriptText
	close $chan
	file attributes $cronScript -permissions +x


### 3. Set ::crontab global var & delete any previous Autostart entries
	set ::crontab 1
	setLinAutostart delete

	return 0
		
} ;#end setLinCrontab

proc setLinAutostart args {
#Makes Autostart entries for GNOME&KDE
#only executed if setLinCrontab fails
global Biblepix Setup LinIcon tclpath srcdir bp
	
	set KDEdir [glob -nocomplain ~/.kde*]
	set GNOMEautostartDir ~/.config/autostart
	set KDEautostartDir $KDEdir/Autostart
	
	#If args exists, delete any autostart files and exit
	if  {$args != ""} {
		file delete $GNOMEautostartDir/biblepix.desktop
		file delete $KDEautostartDir/biblepix.desktop
		return
	}

	#set Texts
	set desktopText "\[Desktop Entry\]
	Name=$bp Setup
	Type=Application
	Icon=$LinIcon
	Path=$srcdir
	Categories=Settings
	Comment=Configures and runs BiblePix"
	set execText "Exec=$tclpath $Biblepix"

	#make .desktop file for KDE Autostart
	if {[file exists $KDEdir]} {
		file mkdir $KDEautostartDir
		set desktopfile [open $KDEautostartDir/biblepix.desktop w]
		puts $desktopfile "$desktopText"
		puts $desktopfile "$execText"
		close $desktopfile
	}

	#make .desktop file for GNOME Autostart
	file mkdir $GNOMEautostartDir
	set chan [open $GNOMEautostartDir/biblepix.desktop w]
	puts $chan "$desktopText"
	puts $chan "$execText"
	close $chan

	#Delete any BP crontab entry
	setLinCrontab del

	return 0
}

proc setLinMenu {} {
#Makes Menu entries for GNOME&KDE
global LinIcon srcdir Setup wishpath bp

	set tclpath [exec which tclsh]
	set desktoppath ~/.local/share/applications
	
	#set Texts
	set desktopText "\[Desktop Entry\]
	Name=$bp Setup
	Type=Application
	Icon=$LinIcon
	Path=$srcdir
	Categories=Settings
	Comment=Configures and runs BiblePix Setup"
	set execText "Exec=$wishpath $Setup"

	#make .desktop file for GNOME & KDE prog menu
	set chan [open $desktoppath/biblepixSetup.desktop w]
	puts $chan "$desktopText"
	puts $chan "$execText"
	close $chan

}

proc setLinBackground {} {
#Sets background picture/slideshow for KDE / GNOME / XFCE4
global env slideshow srcdir imgdir unixdir Config TwdPNG TwdBMP TwdTIF

	#KDE3
	if {[auto_execok dcop] != ""} {
		dcop kdesktop KDesktopIface setWallpaper $TwdPNG 4
	}
	
	#KDE4-5 - needs min. 1 JPG or PNG for slideshow
	if {[auto_execok kwriteconfig] != ""} {
 		
	 	#if single pic make sure it is renewed at start, later same pic reloaded...
		source $Config
		if {!$slideshow} {set slideshow 120}
             		
		#KDE5
		if {[file exists ~/.config/plasma-org.kde.plasma.desktop-appletsrc]} {
			set rcfile [file join $env(HOME) .config plasma-org.kde.plasma.desktop-appletsrc]
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
	} elseif {[auto_execok gconftool-2] != ""} {
	#The former way to change wallpaper in Gnome2 consists in gconftool-2, 
	#but this tool has no effect in Gnome3
		exec gconftool-2 --direct --type string --set /desktop/gnome/background/picture_options wallpaper
		exec gconftool-2 --direct --type string --set /desktop/gnome/background/picture_filename $TwdPNG
	} 
	
        
# X F C E 4  - knows TIF/BMP/PNG !
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

} ;#END setLinBackground

#Reserve für crontab, not needed now
proc hashtag {} {
			#Check interpreter hashbang in $Biblepix
			set chan [open $Biblepix r]
			set hashbang [gets $chan]
			close $chan

			set tclpath_full "#!$tclpath"

			if {$hashbang != $tclpath_full} {
				set chan [open $Biblepix w]
				#replace 1st line
				regsub -line {.*} $text $tclpath_full text
				puts $chan $text
				close $chan 
			}
				
}
