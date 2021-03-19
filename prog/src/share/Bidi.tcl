# ~/Biblepix/prog/src/share/Bidi.tcl
# Fixes missing bidi algorithm for Unix and Win Tk Hebrew/Arabic
# called by BdfPrint + several Setup widgets
# ERSETZT BdfBidi !!!
# optional 'args' cuts out vowels (needed for BdfPrint)
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 17mch21

namespace eval bidi {
  #################################################
  # A l l   A r a b i c   l e t t e r   l i s t 
  #################################################
  ## array name = html code of letter's 0 position (absolute form), 
  ## to be printed with the command: 'set char [format %c $htmcode]'
  ### Array values: 
  #### 1. name + linking status 
  #### 2. i + initial form
  #### 3. m + middle form 
  #### 4. f + final form
  
  ##left-linking letters: 
  array set 1576 {ba  1 i \uFE91 m \uFE92 f \uFE90}
  array set 1578 {ta  1 i \uFE97 m \uFE98 f \uFE96}
  array set 1579 {tha 1 i \uFE91 m \uFE9C f \uFE9A}
  array set 1580 {jim 1 i \uFE9F m \uFEA0 f \uFE9E}
  array set 1581 {Ha 1 i \uFEA3 m \uFEA4 f \uFEA2}
  array set 1582 {kha 1 i \uFEA7 m \uFEA8 f \uFEA6}
  array set 1587 {sin 1 i \uFEB3 m \uFEB4 f \uFEB2}
  array set 1588 {shin 1 i \uFEB7 m \uFEB8 f \uFEB6}
  array set 1589 {Sad 1 i \uFEBB m \uFEBC f \uFEBA}
  array set 1590 {Dad 1 i \uFEBF m \uFEC0 f \uFEBE}
  array set 1591 {Ta 1 i \uFEC3 m \uFEC4 f \uFEC2}
  array set 1592 {Za  1 i \uFEC7 m \uFEC8 f \uFEC6}
  array set 1593 {Ayn 1 i \uFECB m \uFECC f \uFECA}
  array set 1594 {Gayn 1 i \uFECF m \uFED0 f \uFECE}
  array set 1601 {fa  1 i \uFED3 m \uFED4 f \uFED2}
  array set 1602 {qaf 1 i \uFED7 m \uFED8 f \uFED6}
  array set 1603 {kaf 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1604 {lam 1 i \uFEDF m \uFEE0 f \uFEDE}
  array set 1605 {mim 1 i \uFEE3 m \uFEE4 f \uFEE2}
  array set 1606 {nun 1 i \uFEE7 m \uFEE8 f \uFEE6}
  array set 1607 {ha  1 i \uFEEB m \uFEEC f \uFEEA}
  array set 1610 {ya  1 i \uFEF3 m \uFEF4 f \uFEF2}
  array set 1574 {ya_hamza 1 i \uFE8B m \uFE8C f \uFE8A}
  ##non left-linking letters
  array set 1583 {dal  0 i \uFEA9 m \uFEAA f \uFEAA}
  array set 1584 {dhal 0 i \uFEAB m \uFEAC f \uFEAC}
  array set 1585 {ra   0 i \uFEAD m \uFEAE f \uFEAE}
  array set 1586 {zayn 0 i \uFEAF m \uFEB0 f \uFEB0}
  array set 1608 {waw  0 i \uFEED m \uFEEE f \uFEEE}
  array set 1572 {waw_hamza 0 i \uFE85 m \uFE86 f \uFE86}
  array set 1575 {alif 0 i \uFE8D m \uFE8E f \uFE8E}
  array set 1571 {alif_hamza_elyon 0 i \uFEF7 m \uFEF8 f \uFEF8}
  array set 1573 {alif_hamza_tahton 0 i \uFEF9 m \uFEFA f \uFEFA}
  array set 1570 {alif_madda 0 i \uFE81 m \uFE82 f \uFE82}
  array set 65275 {lam_alif 0 i \ufefb m \uFEFC f \uFEFC}
  array set 65270 {lam_alif_madda 0 i \ufef5 m \uFEF6 f \uFEF6}
  ##final only letters
  array set 1577 {ta_marbuta 0 f \uFE94}
  array set 1609 {alif_maqsura 0 f \uFEF0}
  #Persian & Urdu special letters
  array set 1662 {pe 1 i \ufb58 m \ufb59 f \ufb57}
  array set 1670 {che 1 i \ufb7c m \ufb7d f \ufb7b}
  array set 1711 {gaf 1 i \ufb94 m \ufb95 f \ufb93}
  array set 1657 {tte 1 i \ufb68 m \ufb69 f \ufb67}
  array set 1705 {kaf_urdu 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1722 {nun_ghunna 1 i \u06ba f \ufb9f}
  array set 1740 {choti_ye 1 i \uFEF3 m \uFEF4 f \uFEF0}
  array set 1746 {bari_ye 1 f \uFBAF}
  array set 1747 {bari_ye_hamza 1 f \uFBB1}
  array set 1729 {he_goal 1 i \uFBA8 m \uFBA9 f \uFBA7} ;#= choti_he with hamza
  array set 1730 {he_goal_hamza 1 f \u06c2}
  array set 1726 {do_chashmi_he 1 i \uFEEB m \uFEEC}
  ##non left-linking
  array set 1688 {zhe 0 m \ufb8b f \ufb8b}
  array set 1672 {dde 0 m \ufb89 f \ufb89}
  array set 1681 {rre 0 m \ufb8d f \ufb8d}
  array set 1731 {te_marbuta_goal 0 f \u06c3} ;#=ta_marbuta?


### P R O C S  ##############################################################

  # devowelise
  ##clears all vowels from Hebrew (he), Arabic (ar), Urdu (ur) or Persian (fa) text
  ##producing readable modern type text from poetic or religious vowelled text
  ##necessary arguments: s = text string / script = 'he' OR 'ar' (including Urdu+Farsi)
  ##called by fixBidi
  proc devowelise {s script} {
        
    #return if empty  
	  if {$s == ""} {
		  return -error "No text found"
	  }

    # H e b r e w
    ##attempts to convert vowelled standard text to "ktiv male" (כתיב מלא) = "modern full spelling"
    ##as common in modern Hebrew, by replacing some vowel signs by the letters Jud (י) or Wav (ו)
    if {$script == "he"} {
      ##Mosche
      regsub -all {מֹשֶה} $s משה s
      ##Yaaqov
      regsub -all {עֲקֹב} $s עקב s
      ##Shlomoh, koh etc. : Cholam+He -> He
      regsub -all {\U05B9\U05D4} $s \U05D4 s
      ##Zion
      regsub -all {צִיּו} $s {ציו} s
      ##Noach
      regsub -all {נֹח} $s {נח} s
      ##kol, ..chol
      regsub -all {כֹּל} $s {כל} s
      regsub -all {כֹל} $s {כל} s
      ##imm.
      regsub -all {ע\u05b4מ\u05bc} $s {עמ} s
      regsub -all {א\u05b4מ\u05bc} $s {אמ} s
      #2. Vorsilbe mi- ohne Jod: mem+chirik+?+dagesh -> mem
      regsub -all {\U05DE\U05B4} $s \U05DE s
      #3. change chirik to yod for Pi'el, excluding Hif'il+Hitpa'el
      regsub -all {הִ} $s {ה} s
      regsub -all {\U05B4.\U05BC} $s \U05D9& s
      #4. Cholam
      ##change all alef+cholam to alef
      regsub -all {\u5D0\u05b9} $s \u5D0 s
      ##change all cholam+alef to alef
      regsub -all {\u05b9\u5D0} $s \u5D0 s
      ##change remaining waw+cholam to waw
      regsub -all {\u05D5\U05B9} $s \U05D5 s
      #5. Kubutz
      #change all cholam/kubutz to waw
      regsub -all {\u05DC\U05B9\u05D0} $s \u05DC\u05D0 s
      regsub -all {[\U05B9\U05BB]} $s \U05D5 s
      #6. Change all Maqaf to Space
      regsub -all {\u05BE} $s { } s
	    #7. Eliminate all remaining vowels
      regsub -all {[\u0591-\u05C7]} $s {} s
    
    # A r a b i c  / U r d u  /  F a r s i
    ##cuts out all vowel signs as common in modern texts
    } elseif {$script == "ar"} {
       ##eliminate all vowels 
       regsub -all {[\u064B-\u065F]} $s {} s
       ##eliminate ltr & rtl markers
       set s [string map {\u200e {} \u200f {}} $s]
       ##substitute fake lam-alif combinations to true ligatures (=special combined letters):
       ##lam-alif / lam-alif-hamza_elyon / lam-alif-hamza_tahton / lam-alif_madda 
       set s [string map {\u0644\u0627 \uFEFB \u0644\u062f \uFEF7 \u0644\u0625 \uFEF9 \u0644\u062m \uFEF5} $s]
    }
    
    return $s
    
  }  ;#END devowelise

  # fixBidi main process
  ##fixes bi-directional text for Tcl/Tk applications
  ##usable with Hebrew/Arabic/Farsi/Urdu 
  ##compulsary args: s (text string) 
  ## vowelled(1/0): 0 = strip of all vowels 
  ## bdf(1/0): 1 = don't reverse line order (BDF printing is from right to left)
  proc fixBidi {s {vowelled 1} {bdf 0}} {

    #Detect Hebrew OR Arabic (incl. Farsi+Urdu) script
    set he_range {[\u0590-\u05FF]}
    set ar_range {[\u0600-\u06FF]}
    if [regexp $he_range $s] {
      set script he
    } elseif [regexp $ar_range $s] {
      set script ar
    }

    #devowelise if $vowelled=0
    if !$vowelled {
      set s [devowelise $s $script]
    }

    #Revert brackets () to fit rtl
    set s [string map {( ) ) (} $s]
    
    #split text into lines
    set linesplit [split $s \n]

    foreach line $linesplit {
     
      #handle text per word
      foreach word $line {
puts $word      


        #add to line unchanged if ASCII
        if [string is ascii $word] {
          lappend newline $word
          continue  

        #leave Hebrew alone
        } elseif {$script == "he"} {
          set newword $word
        #format Arabic script word
        } elseif {$script == "ar"} {
          set newword [formatArabicWord $word]
        }
          
        #reverse bidi word for all languages except if Bdf
        if !$bdf {
          set newword [string reverse $word]
        }

        lappend newline $newword
      }
          
      append newtext $newline \n
      unset newline      
    
    } ;#end foreach line

    return $newtext
    
  } ;#END fixBidi
 
  # formatArabicWord
  ##puts letters of a word into correct form
  ##called by fixBidi
  proc formatArabicWord {word} {

    set letterL [split $word {}]
    puts "letterlist $letterL"

    set pos 1    
    set endpos [llength $letterL]
    set prevLinking 0
    
    #Scan word for coded & non-coded characters
    foreach char $letterL {
      
      set htmcode [scan $char %c]
      
      #A) Skip if not listed
      if ![info exists [namespace current]::$htmcode] {
        incr pos
        continue
      }
      
      #set 1st letter form
      if {$pos == 1} {
        set utfchar [formatArabicLetter $htmcode i $prevLinking]
      #set final letter form  
      } elseif {$pos == $endpos} { 
        set utfchar [formatArabicLetter $htmcode f $prevLinking]
      #set middle letter form    
      } else {
        set utfchar [formatArabicLetter $htmcode m $prevLinking]
      }
      
puts $utfchar      
      append newword [lindex $utfchar 0]
puts $newword
      #set current left-linking status for next letter
      set prevLinking [lindex $utfchar 1]
      incr pos
      
    } ;#END foreach char
    
    puts $newword
    #TODO where has it gone?    
    #return word as ltr
    return $newword
  
  } ;#END formatArabicWord
  
  # getArLetter
  ##returns Arabic character with requested form as UTF 
  ##args: form = i|m|f & linking status of previous letter = 0|1
  proc formatArabicLetter {htmcode form prevLinking} {
    global [namespace current]::$htmcode
    upvar [namespace current]::$htmcode letterArr
    
    foreach name [array names $htmcode] {
      #letter name has min. 2 characters
      if {[string length $name] > 1} {
        set lettername $name
      }
    }
    puts $lettername
    
    if $prevLinking {
      set utfchar $letterArr($form)
    } else {
      set utfchar $letterArr(i)
    }
    
    set curLinking [lindex [array get $htmcode $lettername] 1]
    return "$utfchar $curLinking"
  }
  
} ;#END ::bidi ns

