pack .updateFrame.pbTitle .updateFrame.progbar
.updateFrame.progbar start
set pbTitle $updatingHttp

source $Globals
sourceHTTP
runHTTP 0
source $Globals

.updateFrame.progbar stop
pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame