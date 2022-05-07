# ~/Biblepix/prog/src/share/Bidi.tcl
# Fixes missing bidi algorithm for Unix and Win Tk Hebrew/Arabic
# called by BdfPrint + several Setup widgets
# optional 'args' cuts out vowels (needed for BdfPrint)
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 7may22

namespace eval bidi {
  
  #all Hebrew range
  variable he_range {[\u0590-\u05FF]}
  ##all Arabic range
  variable ar_range {[\u0620-\u06FF]}
  ##all LTR range
  variable ltr_range {[\u0590-\u05FF\u0620-\u06FF]}
  
  #Letters only range, including Hamza & all presentation forms, 
  ##excluding Tatwil, numerals, punctuation & vowels
  #variable ar_letters {[\u0620-\u063F\u0641-\u064A\u0671-\u06D3\uFE81-\uFEFC]}
 
  #All letters, exluding Hamza
  variable ar_letters {[\u0620\u0622-\u063F\u0641-\u064A\u0671-\u06D5\uFE81-\uFEFC]}
 
  ##vowels only range, excluding Fathatân & Hamza
  variable ar_vowels {[\u064C-\u065F]}
  variable ar_numerals {[\u0660-\u0669]}
  
  #################################################
  # A l l   A r a b i c   l e t t e r   l i s t 
  ###########9#####################################
  ## array name = html code of letter's 0 position (absolute form), 
  ## to be printed with the command: 'set char [format %c $htmcode]'
  ### Array values: 
  #### 1. n + letter name
  #### 2. l + left-linking status (0|1) 
  #### 3. i + initial form
  #### 4. m + middle form 
  #### 5. f + final form
  
  ##left-linking letters: 
  array set 1576 {n ba  l 1 i \uFE91 m \uFE92 f \uFE90}
  array set 1578 {n ta  l 1 i \uFE97 m \uFE98 f \uFE96}
  array set 1579 {n tha l 1 i \uFE9B m \uFE9C f \uFE9A}
  array set 1580 {n jim l 1 i \uFE9F m \uFEA0 f \uFE9E}
  array set 1581 {n Ha  l 1 i \uFEA3 m \uFEA4 f \uFEA2}
  array set 1582 {n kha l 1 i \uFEA7 m \uFEA8 f \uFEA6}
  array set 1587 {n sin l 1 i \uFEB3 m \uFEB4 f \uFEB2}
  array set 1588 {n shin l 1 i \uFEB7 m \uFEB8 f \uFEB6}
  array set 1589 {n Sad l 1 i \uFEBB m \uFEBC f \uFEBA}
  array set 1590 {n Dad l 1 i \uFEBF m \uFEC0 f \uFEBE}
  array set 1591 {n Ta l 1 i \uFEC3 m \uFEC4 f \uFEC2}
  array set 1592 {n Za  l 1 i \uFEC7 m \uFEC8 f \uFEC6}
  array set 1593 {n Ayn l 1 i \uFECB m \uFECC f \uFECA}
  array set 1594 {n Gayn l 1 i \uFECF m \uFED0 f \uFECE}
  array set 1601 {n fa  l 1 i \uFED3 m \uFED4 f \uFED2}
  array set 1602 {n qaf l 1 i \uFED7 m \uFED8 f \uFED6}
  array set 1603 {n kaf l 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1604 {n lam l 1 i \uFEDF m \uFEE0 f \uFEDE}
  array set 1605 {n mim l 1 i \uFEE3 m \uFEE4 f \uFEE2}
  array set 1606 {n nun l 1 i \uFEE7 m \uFEE8 f \uFEE6}
  array set 1607 {n ha  l 1 i \uFEEB m \uFEEC f \uFEEA}
  array set 1610 {n ya  l 1 i \uFEF3 m \uFEF4 f \uFEF2}
  array set 1574 {n ya_hamza l 1 i \uFE8B m \uFE8C f \uFE8A}
  ##non left-linking letters
  array set 1583 {n dal  l 0 i \uFEA9 m \uFEAA f \uFEAA}
  array set 1584 {n dhal l 0 i \uFEAB m \uFEAC f \uFEAC}
  array set 1585 {n ra   l 0 i \uFEAD m \uFEAE f \uFEAE}
  array set 1586 {n zayn l 0 i \uFEAF m \uFEB0 f \uFEB0}
  array set 1608 {n waw  l 0 i \uFEED m \uFEEE f \uFEEE}
  array set 1572 {n waw_hamza l 0 i \uFE85 m \uFE86 f \uFE86}
  
  ##Alif & ligatures
  array set 1575 {n alif l 0 i \uFE8D m \uFE8E f \uFE8E}
  array set 1649  {n alif_wasla l 0 i \uFB50 m \uFB51 f \uFB51}
  array set 1570  {n alif_madda l 0 i \uFE81 m \uFE82 f \uFE82}
  array set 1571  {n alif_hamza_elyon l 0 i \uFE83 m \uFE84 f \uFE84}
  array set 1573  {n alif_hamza_tahton l 0 i \uFE87 m \uFE88 f \uFE88}
  array set 65275 {n lam_alif_abs l 0 i \ufefb m \uFEFC f \uFEFC}
  array set 65276 {n lam_alif_linked l 0 m \uFEFC f \uFEFC}
  array set 65270 {n lam_alif_madda l 0 i \ufef5 m \uFEF6 f \uFEF6}
  array set 65271 {n lam_alif_hamza_elyon l 0 i \uFEF7 m \uFEF8 f \uFEF8}
  array set 65273 {n lam_alif_hamza_tahton l 0 i \uFEF9 m \uFEFA f \UFEFA}
  array set 64716 {n lam_mim l 1 i \uFCCC f \uFC42}
  ##final only letters 
  array set 1577 {n ta_marbuta l 0 m \uFE93 f \uFE94}
  array set 1609 {n alif_maqsura l 0 \m \uFEF0 f \uFEF0}
  
  #Persian special letters
  array set 1740 {n farsi-ye l 1 i \uFBFE m \uFBFF f \uFBFD} ;#Ya without dots in final form = ar. Ya_maqsura
  array set 1662 {n pe l 1 i \ufb58 m \ufb59 f \ufb57}
  array set 1670 {n che l 1 i \ufb7c m \ufb7d f \ufb7b}
  array set 1711 {n gaf l 1 i \ufb94 m \ufb95 f \ufb93}
  array set 1657 {n tte l 1 i \ufb68 m \ufb69 f \ufb67}
  
  #Urdu special letters
  array set 1705 {n kaf_urdu l 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1722 {n nun_ghunna l 1 i \u06ba m \u06ba f \ufb9f}
  array set 1740 {n choti_ye l 1 i \uFEF3 m \uFEF4 f \uFEF0}
  array set 1746 {n bari_ye l 1  i \uFBAF m \uFBAF f \uFBAF}
  array set 1747 {n bari_ye_hamza l 1 i \uFBB1 m \uFBB1 f \uFBB1}
  
  ##choti_he + choti_he with hamza
  array set 1729 {n he_goal l 1 i \uFBA8 m \uFBA9 f \uFBA7} 
  
  array set 1730 {n he_goal_hamza l 1 i \u06c2 m \u06c2 f \u06c2}
  
  array set 1726 {n do_chashmi_he l 1 i \uFEEB m \uFEEC f \uFEEC}
  
  ##Urdu non left-linking
  array set 1688 {n zhe l 0 i \ufb8b m \ufb8b f \ufb8b}
  array set 1672 {n dde l 0 i \ufb89 m \ufb89 f \ufb89}
  array set 1681 {n rre l 0 i \ufb8d m \ufb8d f \ufb8d}
  array set 1731 {n te_marbuta_goal l 0 i \u06c3 m \u06c3 f \u06c3} ;#=ta_marbuta?

  
### P R O C S  ##############################################################

  # fixBidi main process - called by several displaying widgets
  ##fixes bi-directional text for Tcl/Tk applications
  ##usable with Hebrew/Arabic/Farsi/Urdu 
  ##compulsary args: s (text string)
  ##optional args: 
  
  ## 1. reqW: required line width of widget (default: 60)
  ## 2. vowelled(1/0): 0 = strip of all vowels 
  ## 3. bdf(1/0): (don't) reverse line order (BDF printing is from right to left)
  ##called by BiblePix Setup program
  proc fixBidi {s {vowelled 1} {bdf 0} {reqW 0} } {

    global os
    global [namespace current]::he_range
    global [namespace current]::ar_range
    global [namespace current]::ar_numerals
    global [namespace current]::ar_vowels
     
    #Detect Hebrew OR Arabic script (incl. Farsi+Urdu!)
    if [regexp $he_range $s] {
      set lang he
    } elseif [regexp $ar_range $s] {
      set lang ar
    }

    #return text unchanged if $lang not identified
    if ![info exists lang] {
      return $s
    }
    
    #Devowelise if $vowelled=0, 
    ##NOTE: double-vowel Fathatân is not cleared since listed as regular letter (see above) 
    ##TODO?: Why is Alif-Waw stripped in Urdu? 
    if !$vowelled {
      set s [devowelise $s $lang]
    }

    if {$lang=="ar"} {   
      #Map lam-alif and lam-mim double letters to common ligatures
      ##allowing 0 or more vowels between 2 consonants
      regsub -all {\u0644[\u064B-\u065F]*\u0627} $s \uFEFB s ;#lam-alif
      regsub -all {\u0644[\u064B-\u065F]*\u0623} $s \uFEF7 s ;#lam-alif-hamza_elyon
      regsub -all {\u0644[\u064B-\u065F]*\u0625} $s \uFEF9 s ;#lam-alif-hamza_tahton
      regsub -all {\u0644[\u064B-\u065F]*\u0622} $s \uFEF5 s ;#lam-alif-madda
      set s [string map {\u064B\u0627 \u0627\u064B} $s]
    
    } elseif {$lang=="he"} {
      #substitue Maqaf with space
      regsub -all {[\u05BE]} $s { } s
    }
    
    # G E N E R A L  O P E R A T I O N S  F O R   B O T H   L A N G S

    #Eliminate control characters:
    ##left/right/Ar. letter signs
    regsub -all {[\U061C\U200E\U200F]} $s {} s
    ##all quotation marks since Tcl thinks they're for them!
    regsub -all {[\u0022\u0027\u00AB\u00BB\u2018\u2019]} $s {} s
    #Revert brackets	
    set s [string map {( ) ) (} $s]

    #Split text into lines
    set linesplit1 [split $s \u000A]

    foreach line $linesplit1 {
    
    #If Setup: Compute line length & fit to any required width
    ##this works with BiblePix Bdf & Twd texts
      if {$bdf || !$reqW} {
      
        lappend linesplit2 $line
      
      } elseif $reqW {

        set curW [string length $line]
        
        #A) width ok: append line
        if {$curW <= $reqW} {
          lappend linesplit2 $line

        #B) width too long: split line & append
        } else {

          foreach line [splitLine $line $reqW] {
            lappend linesplit2 $line
          }
        }      
        
      } ;#END if bdf/reqW 

    } ;#END foreach line I


    #Start restrucuring words line per line
    foreach line $linesplit2 {

      #handle text per word
      foreach word $line {

        #add to line pre-reverted if ASCII (=probably a number)
        #TODO reverting is only needed if Bdf! - why?
        if [string is ascii $word] {
          lappend newline [string reverse $word]
          continue  

        #leave Hebrew alone
        } elseif {$lang == "he"} {
          
          set newword $word

        #format Arabic script word
        } elseif {$lang == "ar"} {

          #pre-revert Arabic numerals, no formatting #TODO may not be needed at all!
          if [regexp $ar_numerals $word] {}
          
          if [string is digit $word] {
            
            set newword [string reverse $word]

          } else {

            set newword [formatArabicWord $word]

          }
        }
        lappend newline $newword
      
      } ;#END foreach word
        
      #Revert Hebrew+Arabic text line for Setup widgets
      if {$os=="Linux" && !$bdf} {
        set newline [string reverse $newline]
      }
      #append with trailing break
      set br \u000A
      append newtext $newline $br
      unset newline
        
    } ;#END foreach line II
    
    #F i n a l   o p e r a t i o n s
    ##remove any unwanted formatting chars: \ { } & remove trailing break
    set newtext [string map { \{ {} \} {} \\ {} } $newtext]
    set newtext [string trimright $newtext $br]
      
    return $newtext
    
  } ;#END fixBidi
 
  # splitLine
  ##splits up any over-long text line into several usable lines defined by reqW,
  ##based on counting words per line
  ##called by fixBidi if $reqW is given
  proc splitLine {line reqW} {

    set wortmenge [llength $line]
    set linelength 0
    
    for {set lineI 0;set wordI 0} {$wordI < $wortmenge} {incr wordI} {

      set word [lindex $line $wordI]
      lappend newline $word

      set linelength [string length $newline] 
      
      if {$linelength > $reqW} {
        array set linesArr "$lineI [list $newline]"  
        incr lineI
        unset newline
      }
#puts $word
    }
    
    #Add final line to array - ?catch for empty line?
    catch {array set linesArr "$lineI [list $newline]"}

    #Lines array auswerten
    set arrL [array names linesArr]
    
    foreach arrName $arrL {
        lappend splitL $linesArr($arrName)
    }

    #Return split text as list of lines
    return $splitL
    
  } ;#END splitLine

  # formatArabicWord
  ##puts letters of a word into correct form
  ##called by fixBidi
  proc formatArabicWord {word} {
    global [namespace current]::ar_letters
    set newword ""
    set pos 0    
    set prevLinking 0
    
    #Get 1st und last Arabic letter positions
    set letterL [split $word {}]
    set arLetterL [lsearch -all -regexp $letterL $ar_letters]
    set firstLetterPos [lindex $arLetterL 0]
    set lastLetterPos [lindex $arLetterL end]

    #Scan word for coded & non-coded characters
    foreach char $letterL {
      
      set htmcode [scan $char %c]

      #A) Skip if not listed
      if ![info exists [namespace current]::$htmcode] {
        append newword $char
        incr pos
        continue
      }

      #B) Evaluate form from position:

      ##set 1st letter form
      if {$pos == $firstLetterPos} {
        set utfchar [formatArabicLetter $htmcode i $prevLinking]
      ##set final letter form  
      } elseif {$pos == $lastLetterPos} { 
        set utfchar [formatArabicLetter $htmcode f $prevLinking]
      ##set middle letter form    
      } else {
        set utfchar [formatArabicLetter $htmcode m $prevLinking]
      }

      #set current left-linking status for next letter
      global [namespace current]::$htmcode
      upvar [namespace current]::$htmcode letterArr
      set prevLinking $letterArr(l)
      
      incr pos
      append newword $utfchar
     
    } ;#END foreach char

    #return word as ltr
    return $newword
  
  } ;#END formatArabicWord
  
  # formatArabicLetter
  ##returns Arabic character with requested form as UTF 
  ##args: form = i|m|f & linking status of previous letter = 0|1
  ##called by formatArabicWord
  proc formatArabicLetter {htmcode form prevLinking} {
    global [namespace current]::$htmcode
    upvar [namespace current]::$htmcode letterArr
    set lettername $letterArr(n)
        
    #A) absolute or final form, depending on prevLinking status 
    if {$form == "f"} {
      if !$prevLinking {
        ##absolute
        set utfchar [format %c $htmcode]
      } else {
        ##final
        set utfchar $letterArr(f)
      }
      
    #B) any form if prevLinking
    } elseif $prevLinking {
      set utfchar $letterArr($form) 
   
    #C) initial if not prevLinking and not final
    } else {
      set utfchar $letterArr(i)
    }
    return $utfchar
  }
  
  # devowelise
  ##clears all vowel signs from Hebrew (he), Arabic (ar), Urdu (ur) or Persian (fa) text
  ##producing readable modern type text from poetic or religious vowelled text
  ##necessary arguments: s = text string / lang = 'he' OR 'ar' (including Urdu+Farsi)
  ##called by fixBidi
  proc devowelise {s lang} {
    global [namespace current]::ar_vowels        

    # A r a b i c 
    ##cuts out all vowel signs as common in modern texts
    ##excluding Fathatân & Hamza (see vowel range above)
    if {$lang == "ar"} {
      regsub -all $ar_vowels $s {} newtext
      
    # H e b r e w
    } elseif {$lang == "he"} {
      
      set newtext [chaser>male $s]
      
    }
    return $newtext
  }
  
  # chaser>male
  ##attempts to convert vowelled standard text in "ktiv chaser" to "ktiv male" (כתיב מלא) = "modern full spelling"
  ##as common in modern Hebrew, by replacing some vowel signs by the letters Jud (י) or Wav (ו)
  ##called by devowelise
  proc chaser>male s {

  #TODO Heb. double waw if ...? נתודה>>נתוודה   | usw.  עולה > עוולה
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
    
    #TODO warum wird nicht: זהר > זוהר
    #? Schwa -TODO testing new rule geth gar nicth!!
    #change schwa+waw to double waw
    regsub -all {\u05B0\u05D5} $s \u05D5\u05D5 s
    
    #4. Cholam
    ##change all alef+cholam to alef
    regsub -all {\u5D0\u05b9} $s \u5D0 s
    ##change all cholam+alef to alef
    regsub -all {\u05b9\u5D0} $s \u5D0 s
    ##change remaining waw+cholam to waw
    regsub -all {\u05D5\U05B9} $s \U05D5 s
    
    #5. Kubutz
    ##change all cholam/kubutz to waw
    regsub -all {\u05DC\U05B9\u05D0} $s \u05DC\u05D0 s
    regsub -all {[\U05B9\U05BB]} $s \U05D5 s
    
    #6. Change all Maqaf to Space
    regsub -all {\u05BE} $s { } s
    
    #7. Eliminate all remaining vowels
    regsub -all {[\u0591-\u05C7]} $s {} s

    return $s
    
  } ;#END chaser>male

} ;#END ::bidi ns

