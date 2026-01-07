# ~/Biblepix/prog/src/share/httpsTwd.tcl
# Procs called by Installer / Setup für Https-Zugriff auf bible2.net
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 7jan26 pv

# testTlsConn - TODO change name to sth that includes http(s)
##establishes basic Https connexion for downloads from bible2.net,
##i.e. TWD file list & TWD files
##called by updateTwd & downloadTwdFile
proc testTlsConn {} {
global twdListUrl
package require Tk

  if [catch {package require http} err] {
    tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing http http]"
    return 1
  }
  
  #check for tls extra package installed
  if [catch {package require tls} err] {
    tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing tls tcl-tls]"
    return 1
  }
  
  #establish https connexion to bible2.net
  if { [catch {   
    http::register https 443 [list ::tls::socket -autoservername true]} ]
    } {
    NewsHandler::QueryNews "Unable to connect to $twdBaseUrl. Try again later." red
    return 1
   }
   
  #?wohin damit?
  set token [http::geturl $twdListUrl]
  
  NewsHandler::QueryNews "Connection with $twdBaseUrl established." lightgreen
}
 
 #?wohin damit?
 testTlsConn
 
 proc ? {} { 
#TODO da goot nöd! isch jo scho di ganz twd-lischte!!!
#move to proc!
  
    
  if {[http::status $token] != "ok"} {
    NewsHandler::QueryNews "$error" red
    return 1
  }

#TODO move this to another proc?
  set data [http::data $token]

  http::cleanup $token
  http::unregister https

  return $data

} ;#END testTlsConn

## getRemoteRoot -TODO unnecessary, all in fetchTwdList now!
###download TwdRemoteList
###called by listRemoteTWDFiles & downloadTWDFiles
#proc getRemoteRoot {} {
#  global lang TwdRemoteList  
#  
#  #Check for tdom 
#  ##standard in ActiveTcl, Linux distros vary
#  if [catch {package require tdom} err] {
#    package require Tk
#    msgcatInit $lang
#    tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing tDom tdom]"
#    return 1
#  }
#  
#  #Try downloading rootlist twice
#  if [catch downloadTwdList] {
#    downloadTwdList
#  }
# 
#} ;#END getRemoteRoot

 
   
#TODO move this to another proc!
#TODO this is now in downloadTwdFile
#  #Check for tdom 
#  ##standard in ActiveTcl, Linux distros vary
#  if [catch {package require tdom} err] {
#    package require Tk
#    msgcatInit $lang
#    tk_messageBox -type ok -icon error -title "$err" -message "[msgcat::mc packageRequireMissing tDom tdom]"
#    return 1
#  }
	
	
  
#TODO list is in XML!!!!

#} ;#END fetchTwdList

#TODO must be able to be used for any TWD download procedure!
# curl|wget
##check if either installed & fetch ?file?
##called by ? if https not working
proc curl|wget {file} {
   global twdUrl TwdRemoteList
   
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

	#download ?current twd list? to $twddir
  catch {exec $cmd $opt $TwdRemoteList $twdUrl}
  
}



#######################################################################################################################

# downloadTWDFiles
#called by SetupInternational "Download" btn
proc downloadTWDFiles {} {
  global twddir jahr Globals TwdRemoteList

#TODO needs catch?
  set chan [open $TwdRemoteList r]
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
    #downloadTwdFile $filename $jahr

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
##fetches TWD language file OR list from bible2.net
##called by updateTwd ??
proc fetchTwdFile {fileName} {
  global twddir 
  global twdUrl
  global twdBaseUrl
  global jahr

puts $fileName
  
set year $jahr   
set twdFile $fileName
 
  #Determine if list or file
  if [regexp "twd$" $fileName] {
    set url [file join $twdBaseUrl $fileName]
  } else {
    set url $twdUrl
  }
puts "URL $url"
  
  #make file Tcl readable, matching Helmut's URL
set twdFile [file tail $twdFile]
set nameParts [split $twdFile "_"]
lset nameParts 2 "$year.twd"
set fileName [join $nameParts "_"]
set filePath [file join $twddir $fileName]
set url $twdBaseUrl/$fileName
 
  if ![catch testTlsConn] {
puts "FETCHING DATA..."



    fetchHttpData $fileName
    
  } elseif ![catch HttpConn] {
   
      if catch curl|wget $url {
        NewsHandler::QueryNews "Could not download $fileName from bible2.net. \nTry to fetch it manually from $twdUrl." red
      }
  }
  
} ;#END fetchTwdFile

# fetchHttpData
##fetches TWD list|file after testHttpConn is established
##called by fetchTwdFile
proc fetchHttpData {fileName} {
  global twddir twdUrl
  
  set filePath [file join $twddir $fileName]

puts "FILENAME $fileName"
puts "SAVING DATA..." 

#TODO: arregla paths!!!! - ist https registered??? 

  #read out & save to twddir
  set data [http::geturl $twdUrl]
  set chan [open $filePath w]
  fconfigure $chan -encoding utf-8
  puts $chan $data
  close $chan
}



###############################################################################
########## PROCS FOR TWD LIST #################################################
###############################################################################


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


