# ~/Biblepix/prog/src/share/http.tcl
# Procs called by Installer / Setup
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6dec25 pv

#TODO wohin damit?
package require http

# runCurl
## check if curl/wget installed and return cmd
## sourced by getTwdList & downloadTwdFile
## replaces http & tls
## saves to local tempfile
#proc runCurl {} {
#  global tempdir
#  
#  set tempF [file join $tempdir twd]


#	#set cmd "curl --output $tempF $url"
#	set cmd "curl -o $tempF https:\/\/bible2.net/service/TheWord/twd11/current"
#		
#	#Check for curl or wget
#	if {[auto_execok curl] == ""} {
#	
#		if {[auto_execok wget] != ""} {
#		  set cmd "wget --output-document=$tempF $url"
#			
#		} else {
#			NewsHandler::QueryNews "Cannot download file from bible2.net.\nPlease install 'curl' or 'wget' on your PC and try again." red
#			return 1
#			
#		}
#	}
#  return "$cmd"
#}

# downloadTwdList
## downloads remote TWD list to local file in $twddir
##called by getRemoteRoot
proc downloadTwdList {} {
   global twdUrl TwdRemoteList
	
	#Check for curl or wget
	if {[auto_execok curl] != ""} {
	  set cmd "curl"
	  set opt "-o"
	} elseif {[auto_execok wget] != ""} {
		set cmd "wget"
		set opt "-O"
	} else {
		NewsHandler::QueryNews "Cannot download file list from bible2.net.\nPlease install 'curl' or 'wget' on your PC and try again." red
		return 1
	}

	#download current twd list to $twddir
  exec $cmd $opt $TwdRemoteList $twdUrl

} ;#END downloadTwdList


###############################################################################
########### PROCS FOR SETUP UPDATE ############################################
###############################################################################

# runHTTP
## Main program for BiblePix Http download
## Called by Installer & Setup
## isInitial must be set to 0 or 1
proc runHTTP isInitial {
  #Test connexion & start download
  if [catch testHttpCon Error] {

    puts "ERROR: http.tcl -> runHTTP($isInitial): $Error"
    error $Error

    return 1
    
  } else {

    global filePathL fontPathL
    set filePathList [list {*}$filePathL {*}$fontPathL]

    #Download all registered files & fonts
    foreach filepath $filePathList {
      downloadFileFromRelease $filepath $isInitial
    }

    return 0
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

#######################################################################################################################

# downloadTWDFiles
#called by SetupInternational "Download" btn
#TODO don't confuse with downloadTwdFile !!!
proc downloadTWDFiles {} {
  global twddir jahr Globals TwdRemoteList
  
#  if [catch {set root [getRemoteRoot]}] {
#    NewsHandler::QueryNews "[mc noConnTwd]" red
#    return 1
#  }

  set chan [open /home/pv/Biblepix/BibleTexts/twdRemoteList r]
  #set chan [open $TwdRemoteList r]
  fconfigure $chan -encoding utf-8
  set data [read $chan]
  close $chan

  set root [dom parse -html $data]
  
  cd $twddir
  #get hrefs alphabetically ordered
  set urllist [$root selectNodes {//tr/td/a}]
  set hrefs ""

  foreach url $urllist {lappend hrefs [$url @href]}
  set urllist [lsort $hrefs]
  set selectedindices [.twdremoteLB curselection]

  foreach item $selectedindices {
    set url [lindex $urllist $item]
    set filename [file tail $url]

    NewsHandler::QueryNews "Downloading $filename..." lightblue

    #Download file & recreate Twd lists
    downloadTwdFile $filename $jahr
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

# downloadTwdFile
## fetches TWD language file for $year from bible2.net
## TODO??? called by updateTwd
proc downloadTwdFile {twdFile year} {
  global twddir twdBaseUrl
  
  #make file Tcl readable, matching Helmut's URL
  set twdFile [file tail $twdFile]
  set nameParts [split $twdFile "_"]
  lset nameParts 2 "$year.twd"
  set fileName [join $nameParts "_"]

puts $fileName

  set filePath [file join $twddir $fileName]
  set url $twdBaseUrl/$fileName
puts $url
 
  #Check for curl or wget
	if {[auto_execok curl] != ""} {
	  set cmd "curl"
	  set opt "-o"
	} elseif {[auto_execok wget] != ""} {
		set cmd "wget"
		set opt "-O"
	} else {
		NewsHandler::QueryNews "Cannot download file list from bible2.net.\nPlease install 'curl' or 'wget' on your PC and try again." red
		return 1
	}
 
  catch {exec $cmd $opt $filePath $url}
  
} ;#END downloadTwdFile


#TODO is this used anywhere????
# getDataFromUrl
##called by updateTwd
#proc getDataFromUrl {url} {

#  #Register SSL connection
#  http::register https 443 [list ::tls::socket -tls1 1]

##TODO this throws error each time I run Setup!
#  set token [http::geturl $url]
#  if {[http::status $token] != "ok"} {
#    error "No Internet connection"
#  }

#  set data [http::data $token]

#  http::cleanup $token
#  http::unregister https

#  return $data
#}


###############################################################################
########## PROCS FOR TWD LIST #################################################
###############################################################################

# getRemoteRoot
##download TwdRemoteList
##called by listRemoteTWDFiles & downloadTWDFiles
proc getRemoteRoot {} {
  global lang TwdRemoteList  
  
  #Check for tdom 
  ##standard in ActiveTcl, Linux distros vary
  if [catch {package require tdom} err] {
    package require Tk
    msgcatInit $lang
    tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing tDom tdom]"
    return 1
  }
  
  #Try downloading rootlist twice
  if [catch downloadTwdList] {
    downloadTwdList
  }
  
#  #check for current or previous list
#  if ![file exists $TwdRemoteList] {
#    return 1
#  }
  
} ;#END getRemoteRoot


# getRemoteTWDFileList
##called by SetupInternational
##returns status for display in .news
#TODO who needs this???
proc getRemoteTWDFileList {} {

#TODO this test is only valid for vollmar.ch !!!
#  if [catch testHttpCon Error] {
#    .intStatusL conf -bg red
#    set status "[mc noConnTwd]"
#    puts "ERROR: http.tcl -> getRemoteTWDFileList(): $Error"
#    
#  } else {  }
  
  	source $::Bidi
  	
    if ![catch listRemoteTwdFiles] {
      .intStatusL conf -bg lightgreen
      set status "[mc connTwd]"
    } else {
      .intStatusL conf -bg red
      set status "[mc noConnTwd]"
    }
  
  return $status
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

###############################################################################
########## BASIC PROCS ########################################################
###############################################################################

# testHttpCon
##tests Http connexion with vollmar.ch BP release, returns error if connexion fails
##called by runHTTP
proc testHttpCon {} {
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
  set testfile "$::bpxReleaseUrl/README.txt"
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
