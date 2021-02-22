#!/bin/bash
# ~/Biblepix/prog/unix/term.sh
# Bash script to display 'The Word' in a Linux terminal
# Recreated on 02Jan2021 at 17:06

. /home/pv/Biblepix/prog/conf/term.conf
echo -e ${titbg}${tit}"* La Palabra para sábado, 2 enero 2021 *"
echo -e ${txt}"     En los cielos está mi testigo"
echo -e ${txt}"     y mi testimonio en las alturas."
echo -e ${ref}${tab}"Job 16,19"
echo -e ${txt}"     Cuando mi alma desfallecía en mí,"
echo -e ${txt}"     me acordé de Jehová,"
echo -e ${txt}"     y mi oración llegó hasta ti,"
echo -e ${txt}"     hasta tu santo templo."
echo -e ${ref}${tab}"Jonás 2,7"
tclsh /home/pv/Biblepix/prog/src/term/terminal.tcl &
