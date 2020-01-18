# ~/Biblepix/prog/src/share/http.tcl
# called by Installer / Setup
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 18jan20

package require http

###############################################################################
########### PROCS FOR SETUP UPDATE ############################################
###############################################################################

# runHTTP
## Main program for BiblePix Http download
## Called by Installer, Setup, UpdateInjection
proc runHTTP isInitial {
  #Test connexion & start download
  if { [catch testHttpCon Error] } {
    set ::ftpStatus $::noConnHttp
    catch {NewsHandler::QueryNews $::noConnHttp red}

    puts "ERROR: http.tcl -> runHTTP($args): $Error"
    error $Error

  } else {

  #Download all registered files
    foreach varName [array names ::FilePaths] {
      set filePath [lindex [array get ::FilePaths $varName] 1]
      downloadFile $filePath $isInitial
    }

  #Download all registered fonts
    foreach varName [array names ::BdfFontPaths] {
      if {$varName == "ChinaFont"} {
        continue
      }
      set filePath [lindex [array get ::BdfFontPaths $varName] 1]
      downloadFile $filePath $isInitial
    }
      
    #Success message (source Texts again for Initial)
    catch {.if.initialMsg configure -bg green}
    catch {NewsHandler::QueryNews $::uptodateHttp green}
    catch {set ::ftpStatus $::uptodateHttp}

  } ;#end if main condition
  
} ;#end runHTTP

# downloadFileArray
##Called by Installer for sampleJpgArray & iconArray
proc downloadFileArray {fileArrayName url} {
  upvar $fileArrayName fileArray
  foreach fileName [array names fileArray] {
    puts $fileName
    set filePath [lindex [array get fileArray $fileName] 1]
    set chan [open $filePath w]

    fconfigure $chan -encoding binary -translation binary
    http::geturl $url/$fileName -channel $chan

    close $chan
  }
}

# downloadFile
##called by runHTTP
proc downloadFile {filePath isInitial} {
  set filename [file tail $filePath]

  puts $filename

  #get remote 'meta' info (-validate 1)
  set token [http::geturl $::bpxReleaseUrl/$filename -validate 1]
  array set meta [http::meta $token]
  
  if { [http::ncode $token] != 200 } {
    http::cleanup $token
    return
  }

  #a) Overwrite file if "Initial"
  if {$isInitial} {
    downloadFileIntoDir $filePath $filename

  #b) Overwrite file if remote is newer
  } else {

    catch {set newtime $meta(Last-Modified)}
    catch {clock scan $newtime} newsecs
    catch {file mtime $filePath} oldsecs

    #download if times incorrect OR if oldfile is older/non-existent
    if { ! [string is digit $newsecs] ||
         ! [string is digit $oldsecs] ||
         $oldsecs<$newsecs } {
      downloadFileIntoDir $filePath $filename
    }
  }

  http::cleanup $token
}

# downloadFileIntoDir
##called by downloadFile
proc downloadFileIntoDir {filePath fileName} {
  #download file into channel
  #puts $filePath

  set chan [open $filePath w]
  fconfigure $chan -encoding utf-8
  set token [http::geturl $::bpxReleaseUrl/$fileName -channel $chan]
  close $chan

  #Retry download if status not ok
  if { [http::status $token] != "ok" } {
    puts "Error status $fileName, retrying download..."
    http::cleanup $token

    set chan [open $filePath w]
    fconfigure $chan -encoding utf-8
    set token [http::geturl $::bpxReleaseUrl/$fileName -channel $chan]
    close $chan
  }
  
  http::cleanup $token
}


###############################################################################
########## PROCS FOR TWD LIST #################################################
###############################################################################

proc getRemoteRoot {} {
  #These are standard in ActiveTcl, Linux distros vary
  if [catch {package require tdom}] {
    package require Tk
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $::packageRequireTDom
    return 1
  }
  if [catch {package require tls}] {
    package require Tk
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $::packageRequireTls
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
  set root [getRemoteRoot]
  $lBox delete 0 end

  #set langlist
  set file [ $root selectNodes {//tr/td[text()="file"]} ]
  set spaceSize 12

  foreach node $file {
    set jahrN [$node nextSibling]
    set langN [$jahrN nextSibling]
    set versionN [[$langN nextSibling] nextSibling]
    set jahrT [$jahrN text]
    set langT [$langN text]
    set ausgabeT [$versionN text]

    #This should work for all LtR languages
    set bidiRange [regexp {[\u05D0-\u06FC]} $ausgabeT]
    if {$bidiRange} {
      set ausgabeT [string reverse $ausgabeT]
      set digits [regexp -all -inline {[[:digit:]]+} $ausgabeT]
      foreach zahl $digits {
        regsub $zahl $ausgabeT [string reverse $zahl] ausgabeT
      }
    }

    set name " $langT"
    for {set i [string length $langT]} {$i < $spaceSize} {incr i} {append name " "}
    append name "$jahrT        $ausgabeT"
    lappend sortlist $name
  }

  set sortlist [lsort $sortlist]

  foreach line $sortlist {
    $lBox insert end $line
  }
}

proc getRemoteTWDFileList {} {
  if { [catch testHttpCon Error] } {
    .internationalF.status conf -bg red
    set status $::noConnTwd

    puts "ERROR: http.tcl -> getRemoteTWDFileList(): $Error"
    error $Error
  } else {
  
#  listRemoteTWDFiles .internationalF.twdremoteframe.lb
  
    if {![catch {listRemoteTWDFiles .internationalF.twdremoteframe.lb}]} {
      .internationalF.status conf -bg green
      set status $::connTwd
    } else {
      .internationalF.status conf -bg red
      set status $::noConnTwd
    }
    return $status
  }
}

proc downloadTWDFiles {} {
  if { [catch {set root [getRemoteRoot]}] } {
    NewsHandler::QueryNews $::noConnTwd red
    return 1
  }

#  NewsHandler::QueryNews "$::gettingTwd" orange - falsche Message!

  cd $::dirlist(twdDir)
  #get hrefs alphabetically ordered
  set urllist [$root selectNodes {//tr/td/a}]
  set hrefs ""

  foreach url $urllist {lappend hrefs [$url @href]}
  set urllist [lsort $hrefs]
  set selectedindices [.internationalF.twdremoteframe.lb curselection]

  foreach item $selectedindices {
    set url [lindex $urllist $item]

    # https mit http ersetzen
    # TODO soon to be removed
    set indexOfSInHttps [expr [string first https $url] + 4]
    set url [string replace $url $indexOfSInHttps $indexOfSInHttps]

    set filename [file tail $url]

    NewsHandler::QueryNews "Downloading $filename..." lightblue

    if [regexp zh- $url] {
      set filePath $::BdfFontPaths(ChinaFont)
      downloadFile $filePath 0
    }

    set chan [open $filename w]
    fconfigure $chan -encoding utf-8
    http::geturl $url -channel $chan
    close $chan

    after 3000 .internationalF.f1.twdlocal insert end $filename
  }
  #deselect all downloaded files
  .internationalF.twdremoteframe.lb selection clear 0 end
}


###############################################################################
########## BASIC PROCS ########################################################
###############################################################################

# testHttpCon
##tests Http Connexion, returns error if connexion fails
##called by runHTTP
proc testHttpCon {} {
  if { [catch getTesttoken error] } {
    puts "ERROR: http.tcl -> testHttpCon: $error"

    #try proxy & retry connexion
    setProxy

    if { [catch getTesttoken error] } {
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
