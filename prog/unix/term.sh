#!/bin/bash
# ~/Biblepix/prog/unix/term.sh
# Bash script to display 'The Word' in a Linux terminal
# Recreated on 15May2019 at 12:07

. /home/pv/Biblepix/prog/conf/term.conf
echo -e ${titbg}${tit}"* An Briathar do Dé Céadaoin, 15 Bealtaine, 2019 *"
echo -e ${txt}"     Is follas iad gníomhartha na colainne,"
echo -e ${txt}"     mar atá drúis gáirsiúlacht agus graostacht;"
echo -e ${txt}"     íoladhradh agus asarlaíocht; eascairdeas, achrann, agus formad;"
echo -e ${txt}"     fearg, bruíonta, clampar agus faicsin, éad, (murdail, )"
echo -e ${txt}"     meisce, ragairne, agus a leithéid eile."
echo -e ${ref}${tab}"Galataigh 5:19-21"
echo -e ${txtrst}${int}"     Dúirt an Tiarna le Cháin:"
echo -e ${txt}"     Mura ndéana tú an mhaith,"
echo -e ${txt}"     nach shin é an peaca ar an tairseach agat"
echo -e ${txt}"     agus craos air chugat ach go gcaithfir é a cheansú?"
echo -e ${ref}${tab}"Geineasas 4:7"
tclsh /home/pv/Biblepix/prog/src/term/terminal.tcl &
