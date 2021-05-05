#!/usr/bin/env tclsh
# ~/Biblepix/prog/src/unix/terminal.tcl
# Creates 'term.sh' Bash script for The Word to be displayed in Linux terminals
# Called once by Biblepix, then Executed as last command by term.sh whenever a terminal opens
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 5may21 pv

if ![info exists dwTerm] {
  set termdir [file dirname [info script]]
  cd $termdir/..
  source [pwd]/share/globals.tcl
  source [pwd]/share/TwdTools.tcl
  set TwdFileName [getRandomTwdFile]
  set dwTerm [getTodaysTwdTerm $TwdFileName]
}

if {! [info exists dwTerm] } {
  puts "Could not renew The Word for the terminal."
  return 1
}

set chan [open $TerminalShell w]
  
puts $chan "#!/bin/bash"
puts $chan "# ~/Biblepix/prog/unix/term.sh"
puts $chan "# Bash script to display 'The Word' in a Linux terminal"
puts $chan "# Recreated on [clock format [clock seconds] -format {%d%b%Y at %H:%M}]\n"
puts $chan ". $confdir/term.conf"
puts $chan $dwTerm
#Last line: executes new session of this script for next terminal session
puts $chan "tclsh $Terminal &"

close $chan
file attributes $TerminalShell -permissions +x
