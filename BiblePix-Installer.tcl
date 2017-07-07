#!/usr/bin/tclsh
# ~/?Downloads/BiblePix-Installer.tcl (location unimportant, can be deleted after first use)
# Download file to install BiblePix on a Linux or Windows PC
# Overwrites any old program version
# Version: 2.3
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7jul17

set version 2.3
set bpxReleaseUrl "http://vollmar.ch/bibelpix/release"

package require http

#Text messages (when Texts not available)
set downloadingHttp "Downloading BiblePix program files...\nLade BibelPix-Programmdateien herunter..."
set noConHttp "No Internet connection. Try later. Exiting...\nKeine Internetverbindung. Versuchen Sie es später. Abbruch..."
set uptodateHttp "Program files downloaded successfulfy.\nErster Download gelungen!"

#1. SET HOME DIRECTORY & CLEAN OUT

## Set Windows Home & delete any old installation
#  move Config to $LOCALAPPDATA
if { [info exists env(LOCALAPPDATA)] } {
	
	set oldWinHome "$env(USERPROFILE)"
	set newWinHome "$env(LOCALAPPDATA)"
	if { [file exists "[file join $oldWinHome Biblepix]" ] } {
		set confdir "[file join $newWinHome Biblepix prog conf]"
		file mkdir $confdir
		catch {file copy "[file join $oldWinHome Biblepix prog conf biblepix.conf]" "$confdir"}
		catch {file delete -force "[file join $oldWinHome Biblepix]"}
	}
	set rootdir "[file join $newWinHome Biblepix]"
	set srcdir "[file join $rootdir prog src]"

## Set Unix Home & delete any old $tcldir
} else {
	
	set rootdir [file join $env(HOME) Biblepix]
	set srcdir [file join $rootdir prog src]
	catch {file delete -force [file join $rootdir prog tcl]}
}

proc testHttpCon {} {
global bpxReleaseUrl noConHttp

	set testtoken [http::geturl $bpxReleaseUrl/http.tcl -validate 1]
	set error 0
	
	if { [http::error $testtoken] != "" || [http::ncode $testtoken] != 200} {       
		
		#try proxy & test again
		http::config -proxyhost localhost -proxyport 80
		set testtoken [http::geturl $bpxReleaseUrl/http.tcl -validate 1]
		
		if { [http::error $testtoken] != "" || [http::ncode $testtoken] != 200} {        
			set ::httpStatus $noConHttp
			set error 1
		}
	}
	return $error
}

# 2. SET UP PRELIMINARY MESSAGE WINDOW & PROGRESS BAR
package require Tk

pack [frame .if]
label .if.initialL -foreground blue -font "TkCaptionFont 18" -text "BiblePix Installation"
message .if.initialMsg -background lightblue -textvariable httpStatus -width 600 -borderwidth 10 -font "TkTextFont 14"
ttk::progressbar .if.pb -mode indeterminate -length 400
pack .if.initialL .if.initialMsg .if.pb
.if.pb start

set httpStatus $downloadingHttp

set error [testHttpCon]

if { $error } {
	#exit if error
	set httpStatus $noConHttp
        after 5000 {
        exit
        }
}
    
# 3. FETCH Globals, Http

#fetches Globals, Http
proc fetchInitialFiles {} {
	global bpxReleaseUrl
	lappend filelist globals.tcl http.tcl
	
	foreach filename $filelist {
		set token [http::geturl $bpxReleaseUrl/$filename]
		set data [http::data $token]
		if { "[string index $data 0]" == "#"} {
			set chan [open $filename w]
			puts $chan $data
			close $chan
			http::cleanup $token
		}
	}
}

#Create directory structure & source Globals
file mkdir $srcdir
cd $srcdir
fetchInitialFiles

source $srcdir/globals.tcl
makeDirs

# 5. FETCH ALL prog files (securely, re-fetching above 2!)
source $srcdir/http.tcl
runHTTP Initial

downloadFileArray exaJpgArray bpxJpegUrl
downloadFileArray iconArray bpxIconUrl

source $Imgtools
loadExamplePhotos

#delete extra files (refetched!)
file delete $srcdir/globals.tcl $srcdir/http.tcl

#set Status message
set ::InitialJustDone 1 ;#export for Setup
.if.initialMsg configure -bg green
set httpStatus $uptodateHttp

# 5. Run Setup, providing var for not do above again
after 2000 {
	pack forget .if
	set ::httpStatus $httpStatus
	source $Setup
}
