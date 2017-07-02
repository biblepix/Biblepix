#!/usr/bin/tclsh
# ~/?Downloads/BiblePix-Installer.tcl (location unimportant, can be deleted after first use)
# Download file to install BiblePix on a Linux or Windows PC
# Overwrites any old program version
# Version: 2.3
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7jan17

set version 2.3
set bpxurl http://vollmar.ch/bibelpix
set jpegurl http://vollmar.ch/bibelpix/jpeg

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
global bpxurl version noConHttp

	set testtoken [http::geturl $bpxurl/$version/http.tcl -validate 1]
	set error 0
	
	if { [http::error $testtoken] != "" || [http::ncode $testtoken] != 200} {       
		
		#try proxy & test again
		http::config -proxyhost localhost -proxyport 80
		set testtoken [http::geturl $bpxurl/$version/http.tcl -validate 1]
		
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
        
# 3. FETCH Globals, Http, Setup
if { $error } {
	#exit if error
	set httpStatus $noConHttp
        after 5000 {
        exit
        }
}

proc fetchInitialFiles {} {
#fetches Globals, Http, Setup
global bpxurl version
lappend filelist globals.tcl http.tcl biblepix-setup.tcl
	
	foreach filename $filelist {
		set token [http::geturl $bpxurl/$version/$filename]
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
file mkdir $sharedir $guidir $maindir
file mkdir $twddir $sigdir $jpegdir $imgdir $confdir $piddir $windir $unixdir $bmpdir

## fetch jpegs from base
foreach jpegname [array names jpeglist] {
	set jpegpath [lindex [array get jpeglist $jpegname] 1]
	set chan [open $jpegpath w]
	fconfigure $chan -encoding binary -translation binary
	http::geturl $jpegurl/$jpegname -channel $chan
	close $chan
}

## fetch icons ICO & SVG from base
foreach iconname [array names iconlist] {
	set iconpath [lindex [array get iconlist $iconname] 1]
	set chan [open $iconpath w]
	fconfigure $chan -encoding binary -translation binary
	http::geturl $bpxurl/$iconname -channel $chan
	close $chan
}

# 5. FETCH ALL prog files (securely, re-fetching above 3!)
source $srcdir/http.tcl
runHTTP Initial

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
