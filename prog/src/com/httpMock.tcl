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

proc runHTTP isInitial {
  sleep 1000
  error "http is mocked"
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
  
  if {![catch {listAllRemoteTWDFiles .nb.international.twdremoteframe.lb}]} {
    .nb.international.status conf -bg green
    set status $connTwd
  } else {
    .nb.international.status conf -bg red
    set status $noConnTwd
  }
  return $status
}

proc downloadTWDFiles {} {
  global twdDir noConnTwd gettingTwd

  if { [catch {set root [getRemoteRoot]}] } {
    NewsHandler::QueryNews "$noConnTwd" red
    return 1
  }

#  NewsHandler::QueryNews "$gettingTwd" orange - falsche Message!
    
  cd $twdDir
  #get hrefs alphabetically ordered
  set urllist [$root selectNodes {//tr/td/a}]
  set hrefs ""

  foreach url $urllist {lappend hrefs [$url @href]}
  set urllist [lsort $hrefs]
  set selectedindices [.nb.international.twdremoteframe.lb curselection] 
      
  foreach item $selectedindices {
    set url [lindex $urllist $item]
    regsub -all {https} $url http url    
    set filename [file tail $url]
    
    NewsHandler::QueryNews "Downloading $filename..." lightblue
    
    set chan [open $filename w]
    fconfigure $chan -encoding utf-8
    http::geturl $url -channel $chan
    close $chan
    
    after 5000 .nb.international.f1.twdlocal insert end $filename
  }
    #deselect all downloaded files
    .nb.international.twdremoteframe.lb selection clear 0 end

}