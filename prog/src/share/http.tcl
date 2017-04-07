# ~/Biblepix/prog/src/share/http.tcl
# Fetches TWD file list from bible2.net
# called by Installer / Setup
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 22dec2016

package require http

########### PROCS FOR SETUP UPDATE #################

proc setProxy {} {
	if { ![catch package require autoproxy] } {
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
	global bpxurl version
	set testtoken [http::geturl $bpxurl/$version/http.tcl -validate 1]
	set error 0
	
	if { [http::error $testtoken] != "" || [http::ncode $testtoken] != 200} {       
		#try proxy
		setProxy
		#test connexion again
		set testtoken [http::geturl $bpxurl/$version/http.tcl -validate 1]
		
		if { [http::error $testtoken] != "" || [http::ncode $testtoken] != 200} {        
			
			set error 1
		}
	}
	return $error
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
	set Error [catch testHttpCon]
        
	if {$Error} {
		catch {.news configure -bg red}
		set ::ftpStatus $noConnHttp
		set ::news $noConnHttp
				 
	} else {
				
		foreach var [array names filepaths] {
		
			set filepath [lindex [array get filepaths $var] 1]
			set filename [file tail $filepath]
			set token [http::geturl $bpxurl/$version/$filename]
			set data [http::data $token]
	
			#a) overwrite file if "Initial" 
			if {$Initial} {

				if { "[string index $data 0]" == "#"} {
					set chan [open $filepath w]
					fconfigure $chan -encoding utf-8
					http::geturl $bpxurl/$version/$filename -channel $chan
					close $chan                                
				}
			
			#b) save file if size changed
			} else {
				
				set newsize [http::size $token]
								
				if {[file exists $filepath]} {
					set oldsize [file size $filepath]
				} else {
					set oldsize 0
				}

				#first string must be # to distinguish from error messages		
				if { "[string index $data 0]" == "#" } {
					if {$oldsize != $newsize } {
						set chan [open $filepath w]
						fconfigure $chan -encoding utf-8
						http::geturl $bpxurl/$version/$filename -channel $chan
						close $chan
					}

				}
								
			}
		
		} ;#end FOR loop
      
	#Success message (source Texts again for Initial)
	catch {.if.initialMsg configure -bg green}
	catch {.news configure -bg green}
	catch {set ::ftpStatus $uptodateHttp}
	catch {set ::news $uptodateHttp}
	
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
	global lang gettingTwd connTwd noConnTwd
	.news conf -bg lightblue
	set news $gettingTwd
	
	if {![catch {listAllRemoteTWDFiles .n.f1.twdremoteframe.lb}]} {
		.n.f1.status conf -bg green
		set status $connTwd
	} else {
		.n.f1.status conf -bg red
		set status $noConnTwd
	}
	return $status
}

