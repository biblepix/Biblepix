# ~/Biblepix/prog/src/save/uninstall.tcl
# sourced by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24jul21 pv

set antwort [tk_messageBox -icon warning -type yesno -message $uninstall]

if {$antwort=="yes"} {
                  
    #Stop any running biblepix.tcl
    foreach pid [glob -nocomplain -tails -directory $piddir *] {
      if {$platform=="windows"} {
        catch {exec cmd.exe /c taskkill /pid $pid}
      } else {
        catch {exec kill $pid}
      }
    }

    NewsHandler::QueryNews "Removing BiblePix from your computer..." red
    
    # L I N U X
    if {$os=="Linux"} {
    
      source $SaveLinHelpers

      #remove Desktop config files (returns no errors!)
      file delete $homeBinFile
      file delete $LinDesktopFile
      file delete $Kde4DesktopFile
      file delete $LinAutostartFile
      file delete $Kde4AutostartFile

      #Remove any cron entries
      if [info exists crontab] {
        catch {setLinCrontab delete}
      }
        
      #Remove any entry in Sway config
      if [file exists $swayConfFile] {
        source $SaveLinHelpers
        catch {setupSwayBackground delete}
      }

    } elseif {$platform=="windows"} {
       
      source $SaveWinHelpers
      
      #Message for sysadmin
      tk_messageBox -type ok -message $uninstalling
      
      #1. restore custom.theme -- !OBSOLETE now! but leaving for now for older installations
      set themepath [file join $env(appdata) Local Microsoft Windows Themes biblepix.theme]
      file delete -force $themepath
      catch {exec cmd /c [file join $windir Custom.theme]}

      #2. Unregister Initial_Wallpaper_Settings, Autorun & ContextMenu 
      catch {regInitialWallpaper delete}
      catch {regAutorun delete}
      catch {regContextMenu delete}

    } ;#end if windows
    
    #Remove Biblepix directory on all platforms (some problems on Win)
    catch {file delete -force $rootdir}
    
    #Final message
    tk_messageBox -type ok -title "Uninstalling BiblePix" -message $uninstalled

    exit
} ;#end if "yes"
