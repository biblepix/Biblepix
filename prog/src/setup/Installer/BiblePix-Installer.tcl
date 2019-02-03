#!/usr/bin/tclsh
# ~/?Downloads/BiblePix-Installer.tcl (location unimportant, can be deleted after first use)
# Download file to install BiblePix on a Linux or Windows PC
# Overwrites any old program version
# Version: 3.0
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 3feb19

package require http

set bpxReleaseUrl "http://vollmar.ch/biblepix/release"
set downloadingHttp "Downloading BiblePix program files...\nLade BibelPix-Programmdateien herunter..."
set noConnHttp "No Internet connection. Try later. Exiting...\nKeine Internetverbindung. Versuchen Sie es später. Abbruch..."
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

# 2. DEFINE PROCS

# setProxy
##called by testHttpCon
proc setProxy {} {
  if { [catch {package require autoproxy} ] } {
    set host localhost
    set port 80
  } else {
    autoproxy::init
    set host [autoproxy::cget -host]
    set port [autoproxy::cget -port]
  }
  http::config -proxyhost $host -proxyport $port    
}

# getTesttoken
##called by testHttpCon
proc getTesttoken {} {
  global bpxReleaseUrl

  set testfile "$bpxReleaseUrl/README"    
  set testtoken [http::geturl $testfile -validate 1]
  
  if {[http::error $testtoken] != ""} {
    error "testtoken -> error:" + [http::error $testtoken]
  }
  
  if {[http::ncode $testtoken] != 200} {           
    error "testtoken -> ncode:" + [http::ncode $testtoken]
  }
  
  return $testtoken
}

# testHttpCon
##throws error if test fails
proc testHttpCon {} {
  if { [catch getTesttoken error] } {
    puts "ERROR: BiblePix-Installer.tcl -> testHttpCon: $error"  
    
    #try proxy & retry connexion
    setProxy
    
    if { [catch getTesttoken error] } {
      puts "ERROR: BiblePix-Installer.tcl -> testHttpCon -> proxy: $error"
      error $error
    }
  }
}

# fetchInitialFiles
##fetches Globals + Http
##called further down
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


# 3. SET UP PRELIMINARY MESSAGE WINDOW & PROGRESS BAR
package require Tk

pack [frame .if]
label .if.initialL -foreground blue -font "TkCaptionFont 18" -text "BiblePix Installation"
message .if.initialMsg -background lightblue -textvariable httpStatus -width 600 -borderwidth 10 -font "TkTextFont 14"
ttk::progressbar .if.pb -mode indeterminate -length 400
pack .if.initialL .if.initialMsg .if.pb

set httpStatus $downloadingHttp

if { [catch testHttpCon Error] } {
  #exit if error
  set httpStatus $noConnHttp
  
  puts "ERROR: BiblePix-Installer.tcl: $Error"
  
  after 5000 { exit }


#4. FETCH Globals + Http
} else {
 
  .if.pb start
  
  #Create directory structure & source Globals
  file mkdir $srcdir
  cd $srcdir
  fetchInitialFiles

  source $srcdir/globals.tcl
  makeDirs

  #5. FETCH ALL prog files (securely, re-fetching above 2!)
  source $srcdir/http.tcl

  if { [catch {runHTTP 1} result] } {
  
    #exit if error
    set httpStatus $noConnHttp
    .if.pb stop
    puts "ERROR: BiblePix-Installer.tcl: $result"
    after 5000 { exit }

	} else {
    
		source $Http
    downloadFileArray sampleJpgArray $bpxJpegUrl
    downloadFileArray iconArray $bpxIconUrl

    #delete extra files (refetched!)
    file delete $srcdir/globals.tcl $srcdir/http.tcl
    .if.pb stop

    #set Status message
    set ::InitialJustDone 1 ;#export for Setup
    .if.initialMsg configure -bg green
    set httpStatus $uptodateHttp

    #Run Setup, providing var for not do above again
    after 2000 {
      pack forget .if
      set ::httpStatus $httpStatus
      source $Setup
    }
  }
}
