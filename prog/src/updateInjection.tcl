pack .updateFrame.pbTitle .updateFrame.progbar
.updateFrame.progbar start
set pbTitle $updatingHttp

set token [http::geturl $::bpxReleaseUrl/globals -validate 1]
set sharedir [file join $::srcdir share]
file mkdir $::sharedir
set Globals [file join $sharedir globals.tcl]
downloadFile [file join $sharedir globals.tcl] globals.tcl $token
set token [http::geturl $::bpxReleaseUrl/http -validate 1]
downloadFile [file join $sharedir http.tcl] http.tcl $token

source $Globals
makeDirs
sourceHTTP
runHTTP 0
source $Globals

.updateFrame.progbar stop
pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame