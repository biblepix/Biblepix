# ~/Biblepix/prog/src/share/setupSave.tcl
# Records settings & downloads TWD files
# called by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated : 19nov16 

#Make sure either $twddir or SELECTED contain $jahr-TWD files,
# else stop saving process & return to Setup!
set SELECTED_TWD_FILES [.n.f1.twdremoteframe.lb curselection]

# A: If SELECTED NOT EMPTY: Start TWD download
if { $SELECTED_TWD_FILES != ""} {

	if { [catch {set root [getRemoteRoot]}] } {
		.news config -bg red
		set news $noConnTwd
	

	} else {

		.news config -bg orange
		set news $gettingTwd
		cd $twddir
		#get hrefs alphabetically ordered
		set urllist [$root selectNodes {//tr/td/a}]
    
	    #??? warum nötig, siehe Bedingung oben!
		set hrefs ""
		foreach url $urllist {lappend hrefs [$url @href]}
		set urllist [lsort $hrefs]
		set selectedindices [.n.f1.twdremoteframe.lb curselection] 
		  
		foreach item $selectedindices {
			set url [lindex $urllist $item]
			set filename [file tail $url]
			.news config -bg lightblue
			set news "Downloading $filename...\n"
			set chan [open $filename w]
			fconfigure $chan -encoding utf-8
			http::geturl $url -channel $chan
			close $chan
			after 1000
			.n.f1.f1.twdlocal insert end $filename
		}

	} ;#END TWD DOWNLOAD

}

# return to International section if LOCAL empty
if { [catch {glob $twddir/*$jahr.twd}] } {
		
		.n select .n.f1
		.news configure -bg red
		set news $noTWDFilesFound

# else continue with writing Config
} else {

	#2. R E W R I T E   C O N F I G

	#Fetch status variables
	set imgstatus [set imgyesState]
	set sigstatus [set sigyesState]
	set introlinestatus [set introlineState]
	set fontcolourstatus [.n.f2.topframe2.rechts.f2.spin get]
	set fontsizestatus [.n.f2.topframe2.rechts.f3.spin get]
	set fontweightstatus [set fontweightState]
	set fontfamilystatus [.n.f2.topframe2.rechts.f4.spin get]
	set slidestatus [.n.f2.topframe1.sagh.f5.spin get]
	#Fetch textpos coordinates
	lassign [.n.f2.topframe1.orta.textposcanv coords mv] x y - -
	set marginleftstatus [expr int($x*10)]
	set margintopstatus [expr int($y*10)]

	#Write all settings to config
	set chan [open $Config w]
	puts $chan "set lang $lang"
	puts $chan "set enableintro $introlinestatus"
	puts $chan "set enablepic $imgstatus"
	puts $chan "set enablesig $sigstatus"
	puts $chan "set slideshow $slidestatus"
	puts $chan "set fontfamily \{$fontfamilystatus\}"
	puts $chan "set fontsize $fontsizestatus"
	if {$fontweightstatus==1} {
		puts $chan "set fontweight bold"
	} else {
		puts $chan "set fontweight normal"
	}
	puts $chan "set fontcolortext $fontcolourstatus"
	puts $chan "set marginleft $marginleftstatus"
	puts $chan "set margintop $margintopstatus"
	close $chan

	#Finish
	after 2000 {
		.news config -bg green
		set news "Changes recorded. Exiting..."
	}

	#leere das gesamte Fenster, weil es wiederverwendet wird.
	after 2000 {	
		pack forget .n .fbottom .ftop
	}

	#######  I N S T A L L   R O U T I N E S   WIN / LINUX / MAC

	# 1. puts biblepix-setup.tcl & biblepix.tcl in Desktop program menu
	# 2. puts biblepix.tcl in Autostart
	# 3. sets Desktop background image & slide show


	if {$os == "Windows NT"} {
		source -encoding utf-8 $SetupSaveWin
	} elseif {$os == "Linux"} {
		source -encoding utf-8 $SetupSaveLin
	}


	#Delete previous bmp's & start biblepix
	if {$enablepic} {
		#create random BMP if $imgdir empty
		if { [glob -nocomplain $imgdir/*.bmp] == "" } {
			package require Img
			set jpegpath [getRandomJPG]
			set quickimg [image create photo -file $jpegpath]
			$quickimg write $TwdBMP -format bmp
		}
		foreach file [glob -nocomplain -directory $bmpdir *] {
			file delete -force $file
		}

		source $Biblepix
	}

	#Delete any old JPGs from $imgdir (pre 2.2)
	file delete [glob -nocomplain $imgdir/*.jpg]

	#Delete any old TWD files
	set vorjahr [expr {$jahr - 1}]
	set oldtwdlist [glob -nocomplain -directory $twddir *$vorjahr.twd]
	if {[info exists oldtwdlist]} {
		.news config -bg lightblue
		set ::news "Deleting old language files..."
		
		foreach file $oldtwdlist {
			file delete $file
		}
		after 2000 {
			.news config -bg green
			set ::news "Old TWD files deleted."
		}

	}

	#Finish WERDEN DIESE BEFEHLE NOCH AUSGEFÜHRT???
	.news configure -bg red
	set news "Exiting Setup..."
	after 3000 {exit}
	
	#Withdraw Tk window
	if {$platform=="unix"} {
		wm withdraw .
	} else {
		wm iconify .
	}
} ;#END WRITE CONFIG


