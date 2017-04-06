# ~/Biblepix/prog/src/share/uninstall.tcl
# sourced by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6apr17

set msg1 "Do you really want to remove BiblePix from your computer?"
set msg1DE "Wollen Sie wirklich BiblePix von Ihrem Computer entfernen?"
if {$lang=="de"} {set msg1 $msg1DE}
set antwort [tk_messageBox -icon warning -type yesno -message $msg1]

if {$antwort=="yes"} {
	               		
		#Stop any running biblepix.tcl
		foreach pid [glob -nocomplain -tails -directory $piddir *] {
			if {$platform=="windows"} {
				exec cmd.exe /c taskkill /pid $pid
			} else {
				exec kill $pid
			}
		}

		.news conf -bg red
		set news "Removing BiblePix from your computer..."
		after 5000 {}
		
		# L I N U X
		if {$os=="Linux"} {
                
			#remove Desktop files
			file delete -force ~/.local/share/applications/Biblepix
			file delete -force ~/.config/autostart/biblepix.desktop
			file delete -force ~/.kde/share/icons/biblepix.svg
			file delete -force ~/.kde/Autostart/biblepix.desktop
			file delete -force ~/.icons/biblepix.svg
		
                	#purge .bashrc
		       	set bashfile ~./bashrc
                        
                        if {[file exists $bashfile]} {
                        	set chan [open $bashfile r]
                                set readfile [read $chan]
                                close $chan
                                
				if {[regexp Biblepix $readfile]} {
					regsub -line {^.*Biblepix.*} $readfile {} readfile
					set writefile [open $bashfile w]
                                        puts $writefile $readfile
					close $writefile
                                }
                        }
                        
                        #restore KDE5 settings
                        set KDErestore "$unixdir/KDErestore.sh"
                        
			if {[file exists $KDErestore]} {
				file attributes $KDErestore -permissions +x
                              exec bash $unixdir/KDErestore.sh
                        }
                        
			
		} elseif {$platform=="windows"} {
			
			#Message for sysadmin
			set msg1 "BiblePix will now be uninstalled. To clear system settings made, you must confirm any upcoming dialogue boxes with \"Yes\"."
			set msg1DE "BiblePix wird nun deinstalliert. Zum Löschen der Systemeinstellungen müssen Sie allfällige Benachrichtigungsfenster unbedingt mit \"Ja\" beantworten!"
			if {$lang=="de"} {set meser $msg1DE} {set meser $msg1}
			tk_messageBox -type ok -message $meser
			
			#1. restore custom.theme
			set themepath [file join $env(appdata) Local Microsoft Windows Themes biblepix.theme]
			file delete -force $themepath
			catch {exec cmd /c [file join $windir Custom.theme]}

			#2. unregister Autorun
			setWinAutorun delete
			
			#3. unregister Context Menu
			setWinContextMenu delete

		} ;#end if windows
		           
		#Remove Biblepix directory on all platforms (some problems on Win)
		catch {file delete -force $rootdir}
                
                #Final message
                set msg "BiblePix has been removed safely from your system. To reinstall, visit our website, www.bible2.net, and download the BiblePix Setup program."
                set msgDE "BibelPix ist sicher von Ihrem System entfernt worden. Um es neu zu installieren, besuchen Sie uns auf www.bible2.net und laden Sie das BibelPix Setup herunter."
		if {$lang=="de"} {set msg $msgDE}
                
                tk_messageBox -type ok -title "Uninstalling BiblePix" -message $msg
                
            	exit
	
        
} ;#end if "yes"
