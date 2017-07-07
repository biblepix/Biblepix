package require http

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

proc runHTTP args {
	sleep 1000
	return 1
} ;#end runHTTP

                
########## PROCS FOR TWD LIST ####################

proc getRemoteRoot {} {
global twdUrl

	#tDom is standard in ActiveTcl, Linux distros vary
	if {[catch {package require tdom}]} {
		package require Tk
		tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $packageRequireTDom
	   exit
	}

	#get twd list
	if {[catch "http::geturl $twdUrl"]} {
		setProxy
	}
	set con [http::geturl $twdUrl]
	set data [http::data $con]
		if {$data==""} {
			setProxy
			set con [http::geturl $twdUrl]
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

