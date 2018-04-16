# ~/Biblepix/prog/tcl/bidi.tcl
# Fixes missing bidi algorithm for Unix and Win Tk Hebrew/Arabic
# called by textbild.tcl and biblepix-setup.tcl
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 1jun16 - fixArabUnix in testing phase!!
#TODO: THIS PROC IS TO REPLACE ALL "fixHebWin/fixArabWin" procs for BDF
proc bidiBdf {dw TwdLang} {
puts $TwdLang
  
  #Format letters for Arabic/Urdu/Farsi
  if {$TwdLang == "ar" ||
      $TwdLang == "ur" ||
      $TwdLang == "fa"
    } {
#    set dw [fixArabUnix $dw]
  }
  
  #All languages: revert digits
  set digits [regexp -all -inline {[0-9]+} $dw]
  foreach zahl $digits {
     regsub $zahl $dw [string reverse $zahl] dw
  }
  
  #Hebrew
  if {$TwdLang=="he"} {
    
    #change chirik to yod for Pi'el
    regsub -all {\U05B4.\U05BC} $dw \U05D9& dw
    
    #change all waw+cholam to waw
    regsub -all {\u05D5\U05B9} $dw \U05D5 dw
    #change all cholam/kubutz to waw
    regsub -all {[\U05B9\U05BB]} $dw \U05D5 dw
    
    #eliminate remaining vowels
    regsub -all {[\u0591-\u05C7]} $dw {} dw
  }
  
  if {$TwdLang=="ar"} {
    #Ar: eliminate all vowels
    regsub -all {[\u064B-\u065F]} $dw {} dw
        set dw [fixArabUnix $dw]
        
        #set all characters right-to-left
  set dwsplit [split $dw \n]
  foreach line $dwsplit {
    append dwneu [string reverse $line]\n
    set dw $dwneu
  }
  }
  
  return $dw
  
} ;#END BdfBidi



proc fixHebWin {dw} {
#Fixes Hebrew word order for Setup Text Window

  global tab ind

  #move tilde to right
  regsub -all -line {(~ )(.*)} $dw {\2 ~} dw

  #Move punctuation marks to left of words
  regsub -all -line {(.*)([.,:;?!])$} $dw {\2\1} dw

  #Move TABs and INDs to right of line
  regsub -all "$tab" $dw {TTT} dw
  regsub -all "$ind" $dw {BBB} dw
  regsub -all -line {(TTT)(.*)} $dw {\2\1} dw
  regsub -all -line {(BBB)(.*)} $dw {\2\1} dw
  regsub -all {TTT} $dw "$tab" dw
  regsub -all {BBB} $dw "$ind" dw

  #Move digits from end of line to beg
  regsub -all -line {(^[0-9]+)(.*)} $dw {\2\1} dw

  return $dw
}

proc fixArabWin {dw} {
#Fixes Arabic punctuation marks for Canvas & Setup Text Window

  global tab ind

  #move tilde to right
  regsub -all -line {(~ )(.*)} $dw {\2 ~} dw

  regsub -all "$tab" $dw {TTT} dw
  regsub -all "$ind" $dw {III} dw

  #move quotes if they are on edge of line
  regsub -all -line {^(III|TTT)([«])(.*)$} $dw {\1\3PLP} dw
  regsub -all -line {^(III|TTT)(.*)([»])([.,:;?!\u060c\u060d\u066b\u066c]?)$} $dw {\1\4PRP\2} dw
  regsub -all  {PLP} $dw "\u00bb" dw
  regsub -all  {PRP} $dw "\u00ab" dw

  #Move punctuation marks to left of words
  regsub -all -line {(.*)([.,:;?!\u060c\u060d\u066b\u066c])([\u00bb]?)$} $dw {\2\1\3} dw

  #Move TABs and INDs to right of line
  regsub -all -line {(TTT)(.*)} $dw {\2\1} dw
  regsub -all -line {(III)(.*)} $dw {\2\1} dw
  regsub -all {TTT} $dw "$tab" dw
  regsub -all {III} $dw "$ind" dw

  #reorder chapter and verse
  regsub -all {([0-9]+):([0-9]+)} $dw {\2:\1} dw

  return $dw
}


#ARGS is used for no-vowel-signs in BDF method
proc fixHebUnix {dw args} {
#Fixes Hebrew for Unix canvas
  
  #eliminate all vowel signs if args not empty
  if {$args != ""} {
    regsub -all {[\u0591-\u05C7]} $dw {} dw
  } else {
    #delete all Dagesh's because of wrong positioning
    regsub -all {\u05BC} $dw {} dw
  }
  
  #set all characters right-to-left
  set dwsplit [split $dw \n]
  foreach line $dwsplit {
    append dwneu [string reverse $line]\n
  }
  set dw $dwneu

  #revert digits back
  set zahlen [regexp -all -inline {[0-9]+} $dw]
  foreach zahl $zahlen {
     regsub $zahl $dw [string reverse $zahl] dw
  }
  #Reposition punctuation marks
  regsub -all {([.,:;?!])( )} $dw {\1} dw
  #Delete last \n
  set dw [string range $dw 0 end-1]
  return $dw
}




###############################################################################

#############################################################################


proc fixArabUnix {dw args} {
#Sets Arabic text right-to-left and in correct letter form
#added Persion & Urdu 5/16

#eliminate all vowel signs if $args not empty
if {$args != ""} {
  regsub -all {[\u064B-\u065F]} $dw {} dw
}

#Assign UTF letter codes & forms
#1.Initial / 2.Middle / 3.Final-linked

# Preliminary substitution of special letters:
#lam-alif / lam-alif-hamza_elyon/tahton / lam-alif_madda / ltr marker / rtl marker
set dw [string map {\u0644\u0627 \uFEFB \u0644\u0623 \uFEF7 \u0644\u0625 \uFEF9 \u0644\u0622 \uFEF5 \u200e {} \u200f {} } $dw]

#List of letters with HTML Code
array set ::huruf {
1575 alif
1576 ba
1578 ta
1579 tha
1580 jim
1581 hha
1582 kha
1583 dal
1584 dhal
1585 ra
1586 zayn
1608 waw
1587 sin
1588 shin
1589 sad
1590 dad
1591 tta
1592 za
1593 ayn
1594 ghayn
1601 fa
1602 qaf
1603 kaf
1604 lam
1605 mim
1606 nun
1607 ha
1610 ya
1574 ya_hamza
1572 waw_hamza
1571 alif_hamza_elyon
1573 alif_hamza_tahton
1570 alif_madda
65275 lam_alif
65271 lam_alif_hamza_elyon
1573 lam_alif_hamza_tahton
1570 lam_alif_madda 
1577 ta_marbuta 
1609 alif_maqsura
1662 pe
1670 che
1711 gaf
1688 zhe
1657 tte
1672 dde
1681 rre
1705 kaf_urdu
1722 nun_ghunna
1740 choti_ye
1746 bari_ye
1747 bari_ye_hamza
1729 he_goal
1730 he_goal_hamza
1731 te_marbuta_goal
1726 do_chashmi_he
}

#List of single letters with forms: 
#0=non-left-linking (NL) 1=initial 2=middle 3=final-linked
#Left-linkers
array set ::ba  {1 \uFE91 2 \uFE92 3 \uFE90}
array set ::ya  {1 \uFEF3 2 \uFEF4 3 \uFEF2}
array set ::ya_hamza {1 \uFE8B 2 \uFE8C 3 \uFE8A}
array set ::ta  {1 \uFE97 2 \uFE98 3 \uFE96}
array set ::lam {1 \uFEDF 2 \uFEE0 3 \uFEDE}
array set ::kaf {1 \uFEDB 2 \uFEDC 3 \uFEDA}
array set ::mim {1 \uFEE3 2 \uFEE4 3 \uFEE2}
array set ::nun {1 \uFEE7 2 \uFEE8 3 \uFEE6}
array set ::tha {1 \uFE91 2 \uFE9C 3 \uFE9A}
array set ::jim {1 \uFE9F 2 \uFEA0 3 \uFE9E}
array set ::hha {1 \uFEA3 2 \uFEA4 3 \uFEA2}
array set ::kha {1 \uFEA7 2 \uFEA8 3 \uFEA6}
array set ::sin {1 \uFEB3 2 \uFEB4 3 \uFEB2}
array set ::shin {1 \uFEB7 2 \uFEB8 3 \uFEB6}
array set ::sad {1 \uFEBB 2 \uFEBC 3 \uFEBA}
array set ::dad {1 \uFEBF 2 \uFEC0 3 \uFEBE}
array set ::tta {1 \uFEC3 2 \uFEC4 3 \uFEC2}
array set ::za  {1 \uFEC7 2 \uFEC8 3 \uFEC6}
array set ::ayn {1 \uFECB 2 \uFECC 3 \uFECA}
array set ::ghayn {1 \uFECF 2 \uFED0 3 \uFECE}
array set ::fa  {1 \uFED3 2 \uFED4 3 \uFED2}
array set ::qaf {1 \uFED7 2 \uFED8 3 \uFED6}
array set ::ha  {1 \uFEEB 2 \uFEEC 3 \uFEEA}
#Persian & Urdu
array set ::pe  {1 \ufb58 2 \ufb59 3 \ufb57}
array set ::che {1 \ufb7c 2 \ufb7d 3 \ufb7b}
array set ::gaf {1 \ufb94 2 \ufb95 3 \ufb93}
array set ::tte {1 \ufb68 2 \ufb69 3 \ufb67}
array set ::zhe {0 NL 2 \ufb8b 3 \ufb8b}
array set ::dde {0 NL 2 \ufb89 3 \ufb89}
array set ::rre {0 NL 2 \ufb8d 3 \ufb8d}

array set ::kaf_urdu     {1 \uFEDB 2 \uFEDC 3 \uFEDA}
array set ::choti_ye      {1 \uFEF3 2 \uFEF4 3 \uFEF0}
array set ::bari_ye     {3 \uFBAF}
array set ::bari_ye_hamza   {3 \uFBB1}
array set ::nun_ghunna     {1 \u06ba 3 \ufb9f}
#he_goal = choti_he - with hamza only final?
array set ::he_goal     {1 \uFBA8 2 \uFBA9 3 \uFBA7}
array set ::he_goal_hamza   {3 \u06c2}
array set ::do_chashmi_he   {1 \uFEEB 2 \uFEEC}

#Non-left-linkers (pos. 0)
array set ::alif {0 NL 2 \uFE8E 3 \uFE8E}
array set ::alif_madda {0 NL 2 \uFE82 3 \uFE82}
array set ::alif_hamza_elyon {0 NL 2 \uFE84 3 \uFE84}
array set ::alif_hamza_tahton {0 NL 2 \uFE88 3 \uFE88}
array set ::waw {0 NL 2 \uFEEE 3 \uFEEE}
array set ::waw_hamza {0 NL 2 \uFE86 3 \uFE86}
array set ::dal  {0 NL 2 \uFEAA 3 \uFEAA}
array set ::dhal {0 NL 2 \uFEAC 3 \uFEAC}
array set ::ra {0 NL 2 \uFEAE 3 \uFEAE}
array set ::zayn {0 NL 2 \uFEB0 3 \uFEB0}
#Ligatures (pos. 0)
array set ::lam_alif {0 NL 2 \uFEFC 3 \uFEFC}
array set ::lam_alif_hamza_tahton {0 NL 2 \uFEFA 3 \uFEFA}
array set ::lam_alif_hamza_elyon {0 NL 2 \uFEF8 3 \uFEF8}
array set ::lam_alif_madda {0 NL 2 \uFEF6 3 \uFEF6}
#Final only letters
array set ::ta_marbuta {3 \uFE94}
array set ::alif_maqsura {3 \uFEF0}

proc formatLetter {letter index} {
# Converts an Arabic letter to desired form
# Indices: 1=initial 2=middle 3=final-linked
  variable ::huruf
  set newletter ""
  set lettername ""

  #set lettername if in array
  set htmcode [scan $letter %c]
        catch { set lettername $::huruf($htmcode) }
      #set lettername [string index [array get ::huruf $htmcode] end]
      
  #set & export array variable
  variable ::$lettername
  upvar ::$lettername harf
  
#puts "
#LETTERNAME+INDEX: $lettername $index"

  #1.Skip non-letters, leaving $linkinfo empty
  if {$lettername==""} {
    set newletter $letter

  #2.Reformat letter
  } else {
    
    #set $linkinfo
    if { [array get harf 0] == "" } {
      set linkinfo 1
    } else {
      set linkinfo 0
    }

    #skip if form (1) not found in array
    if { [catch {set newletter $harf($index)}] } {
      set newletter $letter

    #replace form
    } else {

      set newletter [string map "$letter $newletter" $letter]


    }

  }


  #return letter +/- left-linking value
  lappend fulletter $newletter
  catch {lappend fulletter $linkinfo}

#puts "LETTER+INDEX: $fulletter  I$index"
#catch {puts "N E W L E T T E R: $newletter"}

  return $fulletter

} ;#end formatLetter


proc formatWord {word} {

set wordlength [string length $word]

#Skip if short
  if {$wordlength<2} { 
#puts "SHORT: $word"

#Skip if ascii & revert
  } elseif { [string is ascii $word] } {

  set word [string reverse $word]

#puts "ASCII: $word"

# M A I N
  } else {

#1. Set first letter to initial form
  set firstpos 0
  set first_letter [string index $word $firstpos]
  set htmfirst [scan $first_letter %c]
  #skip non-letters {" etc.}
  while { [array names ::huruf $htmfirst] == ""} {
    incr firstpos
    set first_letter [string index $word $firstpos]
    set htmfirst [scan $first_letter %c]
  }
  set fulletter [formatLetter $first_letter 1]
  set first_letter [lindex $fulletter 0]
  set linkinfo [lindex $fulletter 1]
  set word [string replace $word $firstpos $firstpos $first_letter]

#puts "\nword w/first: $word"


#2. Set middle part to medium form

  #set full word & midword lengths
  set midlength [expr $wordlength-1]
  set last_char [string index $word end]
  set htmlast [scan $last_char %c]

  #reduce wordlength to exclude last_letter & non-letters
  while { [array names ::huruf $htmlast] == ""} {
    incr midlength -1
    set last_char [string index $word $midlength]
    set htmlast [scan $last_char %c]
  }

  #scan $midword from 2nd to 2nd-but-last letter
  for {set letterpos 1} {$letterpos<$midlength} {incr letterpos} {
    set letter [string index $word $letterpos]

#puts "LINKINFO-PREV:  $linkinfo"
    if {$linkinfo==0} {
      set index 1
    } else {
      set index 2
    }

    set fulletter [formatLetter $letter $index]
    set newletter [lindex $fulletter 0]
    
    #set linkinfo only if real letter
    if { [lindex $fulletter 1] != ""} {
      set linkinfo [lindex $fulletter 1]
      set word [string replace $word $letterpos $letterpos $newletter]
    }

  } ;#end for

#puts "word w/middle: $word"



#3. Set last letter to final form if previous is linking

    if {$linkinfo==1} {
      set last_letter_full [formatLetter $last_char 3]
      set last_letter [lindex $last_letter_full 0]

#POSITION BESTIMMEN!!!!!!!!!!!!!!!
      #set pos [string length $midlength]
      #Pos stimmt nicht, regsub + string match auch nicht gut...
      #set word [string replace $word $pos $pos $last_letter]
      #
      regsub $last_char $word $last_letter word

#puts "lastchar: $last_char"
#puts "lastletter: $last_letter"
  }
#puts "word w/last: $word"

  } ;#end main

set linkinfo 0

  return $word

} ;#end formatWord



# S T A R T  M A I N  P R O C E S S

#split $dw into lines
  set dwsplit [split $dw \n]

  foreach line $dwsplit {

    foreach word $line {

    #Skip digits & pre-reverse if longer than ??????????????

  set newword [formatWord $word]
  append newline "$newword "

    } ;#end foreach word

    set line [string reverse $newline]\n
    append dwneu $line
    unset newline

  } ;#end foreach line

regsub -all {~} $dwneu {~                       } dwneu
return $dwneu

} ;#end fixArabUnix

