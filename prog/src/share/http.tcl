# ~/Biblepix/prog/src/share/httpsTwd.tcl
# Procs called by Installer / Setup für Https-Zugriff auf bible2.net
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 5apr26 pv

#Check http
if [catch {package require http} err] {
  package require Tk
  tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing http http]"
  return 1
}

#Check tls
if [catch {package require tls} err] {
  package require Tk
  tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing tls tcl-tls]"
  return 1
}

#Register https

::http::register https 443 {::tls::socket -autoservername true}

# testTlsConn
##establishes basic Https connexion for downloads from bible2.net,
##i.e. TWD file list & TWD files
##called by updateTwd
proc testTlsConn {} {
  global twdListUrl TwdRemoteList
#  set ::http::defaultCharset utf-8
  
 #Download TwdRemoteList & use curl|wget if no tls
 if {[::http::geturl $twdListUrl -validate 1] != 200} {
  catch {curl|wget $TwdRemoteList $twdListUrl}
  return 0
  }
  
  #Analyse data & write to file
  set chan [open $TwdRemoteList w]
  fconfigure $chan -encoding binary
  ::http::geturl $twdListUrl -channel $chan
  close $chan
  #OLD WAY - encoding binary seems to do the trick:
  #fconfigure $chan -encoding utf-8
  #set token [http::geturl $twdListUrl]
  #set text [http::data $token]
  #puts $chan $text

} ;#END testTlsConn


# curl|wget - the $file var isn't even used!!!!!!!!!!!!
##check if either installed & fetch file
##called by ? if https not working
proc curl|wget {file url} {
   
	if {[auto_execok curl] != ""} {
	  set cmd "curl"
	  set opt "-o"
	#  set checkconn "-I"
	} elseif {[auto_execok wget] != ""} {
		set cmd "wget"
		set opt "-O"
	#	set checkconn "--spider"
		
	} else {
		NewsHandler::QueryNews "Cannot download file list from bible2.net.\nPlease install 'curl' or 'wget' on your PC and try again." red
		return 1
	}

  #Download file
  catch {exec $cmd $opt $file $url}

} ;#END curl|wget 

# downloadTWDFiles

#called by SetupInternational "Download" btn
proc downloadTWDFiles {} {
  global twddir heuer Globals TwdRemoteList

#TODO schon getestet!
#  testTlsConn

set selectedindices [.twdremoteLB curselection]
#set urllist $::urlL

  foreach item $selectedindices {
  
  #  set url [lindex $urllist $item]
  #  set filename [file tail $url]
  set L [.twdremoteLB get $item]  
  append filename [lindex $L 0] _
  append filename [lindex $L 1] _
  append filename [lindex $L 2] .twd
  
  NewsHandler::QueryNews "Downloading $filename..." lightblue

    #Download file
    fetchTwdFile $filename
    after idle .intTwdlocalLB insert end $filename  
    
    #If Chinese or Thai: update font files also 
    set twdlang [string range $filename 0 1]
    if {$twdlang == "zh" || $twdlang == "th"} {
      downloadAsianFont $twdlang
    }
    
    unset filename
  } ;#END foreach
  
  #deselect all downloaded files
  .twdremoteLB selection clear 0 end

} ;#END downloadTWDFiles

# fetchTwdFile
##fetches TWD language file from bible2.net
##called by updateTwd ??
proc fetchTwdFile {fileName} {
  global twddir twdFileUrl heuer

puts $fileName
  
  set year $heuer   
  set twdFile $fileName

  #make file Tcl readable, matching Helmut's URL
  set twdFile [file tail $twdFile]
  set nameParts [split $twdFile "_"]
  lset nameParts 2 "$year.twd"
  set fileName [join $nameParts "_"]
  set filePath [file join $twddir $fileName]
  set url $twdFileUrl/$fileName
   
  #TODO... 
    if ![catch testTlsConn] {
puts "FETCHING DATA..."

    fetchHttpData $fileName
    
  } elseif ![catch HttpConn] {
   
      if [catch {curl|wget $fileName $url}] {
        NewsHandler::QueryNews "Could not download $fileName from bible2.net. \nTry to fetch it manually from $twdUrl." red
      }
  }
  
} ;#END fetchTwdFile

# fetchHttpData
##fetches TWD list|file after testHttpConn is established
##called by fetchTwdFile
proc fetchHttpData {fileName} {
  global twddir twdListUrl twdFileUrl
    
  set filePath [file join $twddir $fileName]

puts "FILENAME $fileName"
puts "SAVING DATA..." 

set url $twdFileUrl/$fileName

set chan [open $filePath w]
fconfigure $chan -encoding utf-8

#TODO curl etc.already handled?
#This prog is called by fetchTwdFile, not testTlsConn > reason for failure??? 
::http::geturl $url -channel $chan
close $chan
  
} ;#END fetchHttpData



#######################################
#TODO >https.tcl
#######################################
###############################################################################################
#######  B I B L E P I X   H T T P   R E L E A S E    D O W N L O A D  ########################
###############################################################################################


## b a s i c    h t t p    p r o c s

# testHttpCon
##tests Http connexion with vollmar.ch BP release, returns error if connexion fails
##called by runHTTP
proc testHttpCon {} {

  catch {.intStatusL conf -bg lightgreen}
  
  if [catch getTesttoken error] {
    puts "ERROR: http.tcl -> testHttpCon: $error"

    #try proxy & retry connexion
    setProxy

    if [catch getTesttoken error] {
      puts "ERROR: http.tcl -> testHttpCon -> proxy: $error"
      error $error
    }
  }
}

# getTesttoken
##called by testHttpCon
proc getTesttoken {} {
  global bpxReleaseUrl
  
  set testfile "$bpxReleaseUrl/README.txt"
  set testtoken [http::geturl $testfile -validate 1]

  if {[http::error $testtoken] != ""} {
    error [string cat "testtoken -> error:" [http::error $testtoken]]
  }

  if {[http::ncode $testtoken] != 200} {
    error [string cat "testtoken -> ncode:" [http::ncode $testtoken]]
  }

  return $testtoken
}

# setProxy
##called by testHttpCon
proc setProxy {} {
  if [catch {package require autoproxy}] {
    set host localhost
    set port 80
  } else {
    autoproxy::init
    set host [autoproxy::cget -host]
    set port [autoproxy::cget -port]
  }

  http::config -proxyhost $host -proxyport $port
}


# runHTTP
## Main program for BiblePix Http download
## isInitial must be set to 0 or 1
## Called by Installer & Setup & Biblepix
#TODO try threads?

proc runHTTP isInitial {
  global filePathL fontPathL piddir

  #Test connexion & start download
  if [catch testHttpCon Error] {
    puts "ERROR: http.tcl -> runHTTP($isInitial): $Error"
    error $Error
    return 1
  } 
  
  set filePathList [list {*}$filePathL {*}$fontPathL]
  set runHttpPid [file join $piddir runHttpPid]
  
  foreach filepath $filePathList {
   
   #run update if httpPidfile older than 24 hours
     if { $isInitial ||
       ![file exists $runHttpPid] || 
        [file mtime  $runHttpPid] < [expr [clock seconds] - 86400] } {

       fetchProgfile $filepath
    }
  }

  #register today's run by creating empty directory
  file delete -force $runHttpPid
  file mkdir $runHttpPid
  
} ;#end runHTTP

# fetchProgfile
##downloads Biblepix program file from release
##called by runHTTP
proc fetchProgfile {filePath} {

  global bpxReleaseUrl
  
  set filename [file tail $filePath]
  set urlname [file join $bpxReleaseUrl $filename]
  
  #Test file before downloading (Info: 'ncode' 200 = OK, 404 = not there)
  set token [http::geturl $urlname -validate 1]
  if { [http::ncode $token] != 200 } {
    http::cleanup $token
    return 1
  }

  #Download file
  puts "Updating $filename..."

  set chan [open $filePath w]
  fconfigure $chan -encoding binary
  http::geturl $urlname -channel $chan
  close $chan
}



# downloadFileFromUrl
##called by downloadFileFromRelease
proc downloadFileFromUrl-ALT {filePath url} {
  #download file into channel

#TODO check syntax!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# MSG files are sometimes truncated!!!!!!!!!!!!!!!!!!
  set chan [open $filePath w]
  fconfigure $chan -encoding utf-8
  set token [http::geturl $url -channel $chan]
  close $chan

  #Retry download if status not ok
  if { [http::status $token] != "ok" } {
    
    puts "Error status $url, retrying download..."
    http::cleanup $token

    set chan [open $filePath w]
    fconfigure $chan -encoding utf-8
    set token [http::geturl $url -channel $chan]
    close $chan
  }
  http::cleanup $token
}



#TODO save to extra directory
# downloadSampleJpegs
##Called by Installer for sample Jpg List
proc downloadSampleJpegs {sampleJpgL url} {
  
  foreach filePath $sampleJpgL {
    set fileName [file tail $filePath]
    set chan [open $filePath w]
    fconfigure $chan -encoding binary -translation binary
    http::geturl $url/$fileName -channel $chan
    close $chan
  }
}

# downloadAsianFont
##updates Chinese or Thai fonts if required
##called by downloadTWDFiles 
proc downloadAsianFont {twdlang} {
  global fontSizeL fontdir

  #Create Asian font lists (Global fontpathL not yet updated)
  if {$twdlang == "zh"} {
    foreach ptsize $fontSizeL {
      lappend asiafontL [file join $fontdir Wenquanyi${ptsize}.tcl]
    }

  } elseif {$twdlang == "th"} {
     foreach ptsize $fontSizeL {  
       lappend asiafontL [file join $fontdir Kinnari${ptsize}.tcl]
       lappend asiafontL [file join $fontdir KinnariB${ptsize}.tcl]
       lappend asiafontL [file join $fontdir KinnariI${ptsize}.tcl]
     }
  }

  NewsHandler::QueryNews "[mc downloadingAsianFont]" orange
  
  #Download fonts if new
  foreach filepath $asiafontL {
    downloadFileFromRelease $filepath 0
  }
  NewsHandler::QueryNews "[mc downloadComplete]" lightgreen
}


