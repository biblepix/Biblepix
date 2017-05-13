# ~/Biblepix/prog/src/share/http.tcl
# Fetches TWD file list from bible2.net
# called by Installer / Setup
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 28apr17

package require http

########### PROCS FOR SETUP UPDATE #################

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

proc testHttpCon {} {
#returns 0 or 1
	global bpxurl version
	set testfile "$bpxurl/release/README"
	catch {set testtoken [http::geturl $testfile -validate 1]}

	proc getTesttoken {} {
	global testtoken
	if { 
		! [info exists testtoken] || 
		[http::error $testtoken] != "" || 
		[http::ncode $testtoken] != 200
		} {set error 1} else {set error 0}
	}

	set error [getTesttoken]
	
	#try proxy & retry connexion
	if {$error} {
		setProxy
		set error [getTesttoken]
	}	
	
	
puts "error: $error"	
	return $error
}

proc downloadFile {filepath filename token} {
global bpxurl version
#download file into channel unless error message
	if { "[http::ncode $token]"==200} {
		set chan [open $filepath w]
		fconfigure $chan -encoding utf-8
		http::geturl $bpxurl/$version/$filename -channel $chan
		close $chan
		http::cleanup $token
	}
}

proc runHTTP args {
	#args can be "Initial" or empty
	global filepaths bpxurl version lang uptodateHttp noConnHttp
	set Initial 0
	set Error 0
		
	if {$args!=""} {
		set Initial 1
	}
     
	#Test connexion & start download
	catch testHttpCon Error
      puts "Error: $Error"
 
	if {$Error != 0} {
		set ::ftpStatus $noConnHttp
		NewsHandler::QueryNews "$noConnHttp" red
				 
	} else {
				
		foreach var [array names filepaths] {
		
			set filepath $filepaths($var)
			set filename [file tail $filepath]

			#get remote 'meta' info (-validate 1)			
			set token [http::geturl $bpxurl/release/$filename -validate 1]
			array set meta [http::meta $token]
			
			#a) Overwrite file if "Initial" 
			if {$Initial} {

				downloadFile $filepath $filename $token
			
			#b) Overwrite file if remote is newer
			} else {
				
				set newtime $meta(Last-Modified)
				catch {clock scan $newtime} newsecs
				catch {file mtime $filepath} oldsecs

puts "New Time: $newsecs\nOld Time: $oldsecs\n"
				#download if times incorrect OR if oldfile is older/non-existent
				if {	! [string is digit $newsecs] || 
					! [string is digit $oldsecs] ||
					$oldsecs<$newsecs 
				} {
					downloadFile $filepath $filename $token
				}
			}

		} ;#end FOR loop
      
	#Success message (source Texts again for Initial)
	catch {.if.initialMsg configure -bg green}
	catch {NewsHandler::QueryNews "$uptodateHttp" green}
	catch {set ::ftpStatus $uptodateHttp}
	
	} ;#end main condition

	return $Error

} ;#end runHTTP

                
########## PROCS FOR TWD LIST ####################

proc getRemoteRoot {} {
global twdurl

	#tDom is standard in ActiveTcl, Linux distros vary
	if {[catch {package require tdom}]} {
		package require Tk
		tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $packageRequireTDom
	   exit
	}

	#get twd list
	if {[catch "http::geturl $twdurl"]} {
		setProxy
	}
	set con [http::geturl $twdurl]
	set data [http::data $con]
		if {$data==""} {
			setProxy
			set con [http::geturl $twdurl]
			set data [http::data $con]
		}
	return [dom parse -html $data]
}

proc listAllRemoteTWDFiles {lBox} {
	set root [getRemoteRoot]
	$lBox delete 0 end
	
	#set langlist
	set file [ $root selectNodes {//tr/td[text()="file"]} ]
	set spaceSize 12
	
	foreach node $file {
		set jahr [$node nextSibling]
		set lang [$jahr nextSibling]
		set version [[$lang nextSibling] nextSibling]
		set langText [$lang text]
		
		set name " $langText"
		for {set i [string length $langText]} {$i < $spaceSize} {incr i} {append name " "}		
		append name "[$jahr text]        [$version text]"
		
		lappend sortlist $name
	}
	
	set sortlist [lsort $sortlist]

	foreach line $sortlist {
		$lBox insert end $line
	}
}

proc getRemoteTWDFileList {} {
	global lang connTwd noConnTwd
	
	if {![catch {listAllRemoteTWDFiles .n.f1.twdremoteframe.lb}]} {
		.n.f1.status conf -bg green
		set status $connTwd
	} else {
		.n.f1.status conf -bg red
		set status $noConnTwd
	}
	return $status
}

