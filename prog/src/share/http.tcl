# ~/Biblepix/prog/src/share/http.tcl
# called by Installer / Setup
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2aug21 pv
package require http

# checkTls
##needed for TWD downloads from https://bible2.net
##called by downloadTWDFile
proc checkTls {} {
  if [catch {package require tls}] {
    package require Tk
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $msg::packageRequireTls
    return 1
  }
}

###############################################################################
########### PROCS FOR SETUP UPDATE ############################################
###############################################################################

# runHTTP
## Main program for BiblePix Http download
## Called by Installer & Setup
proc runHTTP isInitial {
  #Test connexion & start download
  if [catch testHttpCon Error] {
    set ::ftpStatus $msg::noConnHttp
    catch {NewsHandler::QueryNews $::noConnHttp red}
    puts "ERROR: http.tcl -> runHTTP($isInitial): $Error"
    error $Error

  } else {

    global filePathL fontPathL
    set filePathList [list {*}$filePathL {*}$fontPathL]

    #Download all registered files & fonts
    foreach filepath $filePathList {
    
      ##avoid Chinese if not needed (rechecked in downloadTwdFile)
      if {$filepath == $::ChinaFont} {
        continue
      }
    downloadFileFromRelease $filepath $isInitial
    }

    #Success message (source Texts again for Initial)
    catch {.if.initialMsg configure -bg lightgreen}
    catch {NewsHandler::QueryNews $msg::uptodateHttp blue}
    catch {set ::ftpStatus $msg::uptodateHttp}
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

proc downloadTwdFile {twdFile year} {
  global twddir
  
  checkTls
  
  set twdFile [file tail $twdFile]
  set nameParts [split $twdFile "_"]
  lset nameParts 2 "$year.twd"
  set fileName [join $nameParts "_"]

  set filePath $twddir/$fileName
  set url $::twdBaseUrl/$fileName

  #Register SSL connection
  http::register https 443 [list ::tls::socket -tls1 1]

  set chan [open $filePath w]
  fconfigure $chan -encoding utf-8
  set token [http::geturl $url -channel $chan]
  close $chan

  if {[http::status $token] != "ok"} {
    error "No Internet connection"
  }

  http::cleanup $token
  http::unregister https
}

#TODO called by?
proc getDataFromUrl {url} {

  #Register SSL connection
  http::register https 443 [list ::tls::socket -tls1 1]

  set token [http::geturl $url]

  if {[http::status $token] != "ok"} {
    error "No Internet connection"
  }

  set data [http::data $token]

  http::cleanup $token
  http::unregister https

  return $data
}


###############################################################################
########## PROCS FOR TWD LIST #################################################
###############################################################################

proc getRemoteRoot {} {

#TODO outsource below!
  #These are standard in ActiveTcl, Linux distros vary
  if [catch {package require tdom}] {
    package require Tk
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $msg::packageRequireTDom
    return 1
  }

  if [catch {package require tls}] {
    package require Tk
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $msg::packageRequireTls
    return 1
  }

  #Register SSL connection
  http::register https 443 [list ::tls::socket -tls1 1]

  set token [http::geturl $::twdUrl]
  set data [http::data $token]
  
  http::cleanup $token
  http::unregister https
  return [dom parse -html $data]
}

proc listRemoteTWDFiles {lBox} {
  global os
  
  set root [getRemoteRoot]
  $lBox delete 0 end

  #set langlist
  set file [ $root selectNodes {//tr/td[text()="file"]} ]
  set space { }
  set spaceLang 21
  set spaceName 60

  foreach node $file {
    set yearNode [$node nextSibling]
    set langNode [$yearNode nextSibling]
    set nameNode [$langNode nextSibling]
    set versionNode [$nameNode nextSibling]
    set year [$yearNode text]
    set lang [$langNode text]
    set name [$nameNode text]
    set version [$versionNode text]

    #Set RtL languages from right to left (Windows should handle this without our help)
    if {$os == "Linux" && [isBidi $version]} {
      set version [bidi::fixBidi $version]
      ##eliminate LF char
      regsub {[\u000A]} $version {} version
    }
    
    ##start building line
    append nameline $lang
    
    ##compute tab lengths for Monospace font
    for {set i [string length $lang]} {$i < $spaceLang} {incr i} {
      append nameline $space
    }

    append nameline $year [string repeat $space 10]
    append nameline $name

    ##compute tab lengths for Monospace font
    for {set i [string length $name]} {$i < $spaceName} {incr i} {
      append nameline $space
    }

    append nameline $version

    lappend sortlist $nameline
    unset nameline
  }

  set sortlist [lsort $sortlist]
  foreach line $sortlist {
    $lBox insert end $line
  }
}

# getRemoteTWDFileList
#TODO called by?......
proc getRemoteTWDFileList {} {
  if [catch testHttpCon Error] {
    .internationalF.status conf -bg red
    set status $msg::noConnTwd
    puts "ERROR: http.tcl -> getRemoteTWDFileList(): $Error"
  } else {
    if ![catch {listRemoteTWDFiles .twdremoteLB}] {
      .internationalF.status conf -bg lightgreen
      set status $msg::connTwd
    } else {
      .internationalF.status conf -bg red
      set status $msg::noConnTwd
    }
  }
  return $status
}

#TODO called by?
proc downloadTWDFiles {} {
  global twddir jahr
  
  if [catch {set root [getRemoteRoot]}] {
    NewsHandler::QueryNews $msg::noConnTwd red
    return 1
  }
  
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

    if [regexp zh- $url] {
      set filePath $::ChinaFont
      downloadFileFromRelease $filePath 0
    }

    #Download file & recreate Twd lists
    downloadTwdFile $filename $jahr
    after 3000
    .internationalF.f1.twdlocal insert end $filename
  }
  #deselect all downloaded files
  .twdremoteLB selection clear 0 end
}


###############################################################################
########## BASIC PROCS ########################################################
###############################################################################

# testHttpCon
##tests Http Connexion, returns error if connexion fails
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
