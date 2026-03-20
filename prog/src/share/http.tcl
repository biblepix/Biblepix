# ~/Biblepix/prog/src/share/httpsTwd.tcl
# Procs called by Installer / Setup für Https-Zugriff auf bible2.net
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 18feb26 pv

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

# testTlsConn - TODO change name to sth that includes http(s)
##establishes basic Https connexion for downloads from bible2.net,
##i.e. TWD file list & TWD files
##called by updateTwd
proc testTlsConn {} {
  global twdListUrl TwdRemoteList
  
 #Download TwdRemoteList & use curl|wget if no tls
 if [catch {::http::geturl $twdListUrl -validate 1}] {
  catch {curl|wget $TwdRemoteList $twdListUrl}
  return 0
  }
  
  #Analyse data & write to file
  set chan [open $TwdRemoteList w]
  ::http::geturl $twdListUrl -channel $chan
  close $chan

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
set urllist $::urlL

  foreach item $selectedindices {
    set url [lindex $urllist $item]
    set filename [file tail $url]

    NewsHandler::QueryNews "Downloading $filename..." lightblue

#TODO warum geht das nicht?
    #Download file
fetchTwdFile $filename
      
    after idle .intTwdlocalLB insert end $filename  
    
    #If Chinese or Thai: update font files also 
    set twdlang [string range $filename 0 1]
    if {$twdlang == "zh" || $twdlang == "th"} {
      downloadAsianFont $twdlang
    }
  } ;#END foreach
  
  #deselect all downloaded files
  .twdremoteLB selection clear 0 end

} ;#END downloadTWDFiles

# fetchTwdFile
##fetches TWD language file  ??? OR list from bible2.net
##called by updateTwd ??
proc fetchTwdFile {fileName} {
  global twddir 
  global twdFileUrl
#  global twdListUrl
  global heuer

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


#TODO wohi demit?
# wrapInternetCons
##sets news in statusline
##called by SetupBuild & SetupInternational
##tests http & https and tries to update remote Twd list
proc wrapInternetCons {} {

  .intStatusL conf -bg olive

  if [catch testHttpCon Error] {
    .intStatusL conf -bg red
    set ::news "[mc noConnTwd]"
    return 1
  }
  	
#TODO ne oluyor?
  if ![catch listRemoteTwdFiles] {
    .intStatusL conf -bg lightgreen
    set ::news "[mc connTwd]"
  } else {
    .intStatusL conf -bg red
    set ::news "[mc noConnTwd]"
  }
  
} ;#END wrapInternetCons




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
## Called by Installer & Setup
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
  
  #run update if httpPidfile older than 24 hours
  if { ![file exists $runHttpPid] || 
        [file mtime  $runHttpPid] < [expr [clock seconds] - 86400] } {

  puts "Updating program files..."

    #Download all registered files & fonts
#TODO try threads!
    foreach filepath $filePathList {
      downloadFileFromRelease $filepath $isInitial
    }

    #register today's run by creating empty directory
    file delete -force $runHttpPid
    file mkdir $runHttpPid
    
  }
  
} ;#end runHTTP

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

# downloadFileFromRelease
##downloads Biblepix file
##called by runHTTP
proc downloadFileFromRelease {filePath isInitial} {

  set filename [file tail $filePath]
  puts "Checking $filename ..."

  #get remote 'meta' info (-validate 1)
  set token [http::geturl $::bpxReleaseUrl/$filename -validate 1]
  array set meta [http::meta $token]
  
  if { [http::ncode $token] != 200 } {
    http::cleanup $token
    return
  }

  #a) Overwrite file if "Initial"
  if {$isInitial} {
    downloadFileFromUrl $filePath $::bpxReleaseUrl/$filename

  #b) Overwrite file if remote is newer
  } else {

    catch {set newtime $meta(Last-Modified)}
    catch {clock scan $newtime} newsecs
    catch {file mtime $filePath} oldsecs

    #download if file is new OR times incorrect OR if oldfile is older/non-existent
    if { 
      ![string is digit $newsecs] ||
      ![string is digit $oldsecs] ||
      $oldsecs<$newsecs
    } {
      puts "Updating $filename..."
      downloadFileFromUrl $filePath $::bpxReleaseUrl/$filename
    }
  }

  http::cleanup $token
}

#TODO who needs this?
# downloadFileFromUrl
##called by downloadFileFromRelease
proc downloadFileFromUrl {filePath url} {
  #download file into channel
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


