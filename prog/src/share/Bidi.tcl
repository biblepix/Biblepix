# ~/Biblepix/prog/src/share/Bidi.tcl
# Fixes missing bidi algorithm for Unix and Win Tk Hebrew/Arabic
# called by BdfPrint + several Setup widgets
# ERSETZT BdfBidi !!!
# optional 'args' cuts out vowels (needed for BdfPrint)
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 9mch21

namespace eval bidi {

  #All Arabic letter list
  ##left-linking (n=name /l=linking /i=initial pos / m=middle pos / f = final pos (linking!)
  array set 1576 {ba l 1 i \uFE91 m \uFE92 f \uFE90}
  array set 1578 {ta l 1 i \uFE97 m \uFE98 f \uFE96}
  array set 1579 {tha l 1 i \uFE91 m \uFE9C f \uFE9A}
  array set 1580 {jim l 1 i \uFE9F m \uFEA0 f \uFE9E}
  array set 1581 {hha l 1 i \uFEA3 m \uFEA4 f \uFEA2}
  array set 1582 {kha l 1 i \uFEA7 m \uFEA8 f \uFEA6}
  array set 1587 {sin l 1 i \uFEB3 m \uFEB4 f \uFEB2}
  array set 1588 {shin l 1 i \uFEB7 m \uFEB8 f \uFEB6}
  array set 1589 {sad l 1 i \uFEBB m \uFEBC f \uFEBA}
  array set 1590 {dad l 1 1i \uFEBF m \uFEC0 f \uFEBE}
  array set 1591 {tta l 1 i \uFEC3 m \uFEC4 f \uFEC2}
  array set 1592 {za l 1 i \uFEC7 m \uFEC8 f \uFEC6}
  array set 1593 {ayn l 1 i \uFECB m \uFECC f \uFECA}
  array set 1594 {ghayn l 1 i \uFECF m \uFED0 f \uFECE}
  array set 1601 {fa l 1 i \uFED3 m \uFED4 f \uFED2}
  array set 1602 {qaf l 1 i \uFED7 m \uFED8 f \uFED6}
  array set 1603 {kaf l 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1604 {lam l 1 i \uFEDF m \uFEE0 f \uFEDE}
  array set 1605 {mim l 1 i \uFEE3 m \uFEE4 f \uFEE2}
  array set 1606 {nun l 1 i \uFEE7 m \uFEE8 f \uFEE6}
  array set 1607 {ha l 1 i \uFEEB m \uFEEC f \uFEEA}
  array set 1610 {ya l 1 i \uFEF3 m \uFEF4 f \uFEF2}
  array set 1574 {ya_hamza l 1 i \uFE8B m \uFE8C f \uFE8A}
  ##non left-linking (name=0)
  array set 1583 {dal l 0 m \uFEAA f \uFEAA}
  array set 1584 {dhal l 0 m \uFEAC f \uFEAC}
  array set 1585 {ra l 0 m \uFEAE f \uFEAE}
  array set 1586 {zayn l 0 m \uFEB0 f \uFEB0}
  array set 1608 {waw l 0 m \uFEEE f \uFEEE}
  array set 1572 {waw_hamza l 0 m \uFE86 f \uFE86}
  array set 1575 {alif l 0 m \uFE8E f \uFE8E}
  array set 1571 {alif_hamza_elyon l 0 m \uFEF8 f \uFEF8}
  array set 1573 {alif_hamza_tahton l 0 m \uFEFA f \uFEFA}
  array set 1570 {alif_madda l 0 m \uFE82 f \uFE82}
  array set 65275 {lam_alif l 0 m \uFEFC f \uFEFC}
  array set 65270 {lam_alif_madda l 0 m \uFEF6 f \uFEF6}
  ##final only
  array set 1577 {ta_marbuta l 0 f \uFE94}
  array set 1609 {alif_maqsura l 0 f \uFEF0}
  #Persian & Urdu special letters
  array set 1662 {pe l 1 i \ufb58 m \ufb59 f \ufb57}
  array set 1670 {che l 1 i \ufb7c m \ufb7d f \ufb7b}
  array set 1711 {gaf l 1 i \ufb94 m \ufb95 f \ufb93}
  array set 1657 {tte l 1 i \ufb68 m \ufb69 f \ufb67}
  array set 1705 {kaf_urdu l 1 i \uFEDB m \uFEDC f \uFEDA}
  array set 1722 {nun_ghunna l 1 i \u06ba f \ufb9f}
  array set 1740 {choti_ye l 1 i \uFEF3 m \uFEF4 f \uFEF0}
  array set 1746 {bari_ye l 1 f \uFBAF}
  array set 1747 {bari_ye_hamza l 1 f \uFBB1}
  array set 1729 {he_goal l 1 i \uFBA8 m \uFBA9 f \uFBA7} ;#= choti_he with hamza
  array set 1730 {he_goal_hamza l 1 f \u06c2}
  array set 1726 {do_chashmi_he l 1 i \uFEEB m \uFEEC}
  ##non left-linking
  array set 1688 {zhe l 0 m \ufb8b f \ufb8b}
  array set 1672 {dde l 0 m \ufb89 f \ufb89}
  array set 1681 {rre l 0 m \ufb8d f \ufb8d}
  array set 1731 {te_marbuta_goal l 0 f \u06c3} ;#=ta_marbuta?


### P R O C S  ##############################################################



  # devowelise
  ##clears all vowels from Hebrew (he), Arabic (ar), Urdu (ur) or Persian (fa) text
  ##necessary arguments: s = text string / lang = he|ar|ur|fa
  proc devowelise {s lang} {
        
    #return if empty  
	  if {$s == ""} {
		  return -error "No text found"
	  }

    #Rule out language variants
    set lang [string range $lang 0 1]    

    #All languages: revert digits
    set digits [regexp -all -inline {[[:digit:]]+} $s]
    foreach num $digits {
      regsub $num $s [string reverse $num] s
    }

    # H e b r e w
    ##attempts to convert vowelled standard text to "ktiv male" (כתיב מלא) = "modern full spelling"
    ##as common in modern Hebrew, by replacing some vowel signs by the letters Jud (י) or Wav (ו)
    if {$lang == "he"} {
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
    } elseif {$lang=="ar" || $lang == "ur" || $lang == "fa"} {
       ##eliminate all vowels 
       regsub -all {[\u064B-\u065F]} $s {} s
       ##eliminate ltr & rtl markers
       set s [string map {\u200e} {} {\u200f} {} $s]
       ##substitute fake lam-alif combinations to true ligatures (=special combined letters):
       ##lam-alif / lam-alif-hamza_elyon / lam-alif-hamza_tahton / lam-alif_madda 
       set s [string map {\u0644\u0627 \uFEFB \u0644\u062f \uFEF7 \u0644\u0625 \uFEF9 \u0644\u062m \uFEF5} $s]
    }
    
    #Revert brackets () to fit rtl
    set s [string map {( ) ) (} $s]
  
    return $s
    
  }  ;#END devowelise

  # bidi main process
  ##reverts 
  ##with args=devowelise
  proc bidi {s lang args} {

#TODO was ist mit Zahlen und ASCII?
#run per word also for Heb?

    #devowelise if 'args'
    if {$args != ""} {
      set s [devowelise $s $lang]
    }
    
    #split text into lines
    set linesplit [split $s \n]

    foreach line $linesplit {

      #handle Arabic script per word
      if {$lang != "he"} {
        foreach word $line {
          set newword [formatArabicWord $word]
          lappend newline $newword
        }
        set line $newline
        unset newline
      }

      #reverse whole line to rtl
      set revline [string reverse $line]
      append formattedText $revline \n
      unset line revline

    } ;#end foreach line

    return $formattedText
  } ;#END bidi
  
   
  # formatArabicWord
  ##puts letters of a word into correct form
  ##called by bidi?
  proc formatArabicWord {word} {

  #Scan word for coded & non-coded characters
  for {set i 0} {$i<=$endpos} {incr i} { 
    
    set char [lindex $letterL $i]
    set htmcode [scan $letter %c]
    
    #skip non-letter items if $args
    if ![info exists ::bidi::$htmcode] {
      if {$args == ""} {
        append letterL $char
      } else {
        continue
      }
    
    #upvar htmcode array    
    } else {
      upvar $bidi::$htmcode mycode
    }
    
    #scan array for letter name, form & linked info
    set curLinked $mycode(l)
  
    #set 1st letter form
    if {$i == 0} {
      append newword [set \u$htmcode(i)]
      
    #set final letter form  
    } elseif {$i == $endpos} { 
      
      if $prevlinked {
        set char [set \u$codename(f)]
      } else { 
        set char [set \u$codename(i)]
      }
      append newword $char

    #set middle forms (unlinking letters have only 1 form)
    } else {
      
      append newword [set \u$codename(m)]
    
    }
    
    set prevlinked $curLinked
  }

  #return as ltr:
  return $newword
  
  } ;#END formatArabicWord
  
  

} ;#END ::bidi ns

