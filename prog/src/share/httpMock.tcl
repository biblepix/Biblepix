# ~/Biblepix/prog/src/share/httpMock.tcl
# Skips updating process for program files during Setup
# by altering runHttp to do nothing
# Called in LoadConfig if variable $Httpmock set to 1 in Config
# Updated: 5jan23 pv

proc runHTTP 0 {
  after 1000
  puts "ATTENTION: Httpmock variable is set to 1 in Config!"
  error "HTTP updating process is being mocked"
}
