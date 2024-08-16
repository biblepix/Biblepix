# ~/Biblepix/prog/msg/it.msg
# Italian texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
# INFO: Reintextmenge 1450 Wörter/11000 Zeichen (abzgl. 100 mcset * 3 W. = 300 W.)
# Updated: 29sep21 pv

# U N T R A N S L A T A B L E S
set bp "BiblePix"
set dw {'La Parola'}
mcset it dw $dw
mcset it bp $bp

# G E N E R A L
mcset it bpsetup "Configurazione $bp"
mcset it refresh "Aggiorna"
mcset it delete "Elimina file"
mcset it ok "Ok"
mcset it cancel "Interrompi"
mcset it close "Chiudi"
mcset it save "Salva"
mcset it saveSettings "Salva impostazioni"
mcset it random "casuale"
mcset it uninst "Disinstallare $bp"
mcset it welcome "Benvenuto"
mcset it bibletexts "Testi biblici"
mcset it desktop "Immagine di sfondo"
mcset it photos "Galleria immagini"
mcset it email "Firma e-mail"
mcset it terminal "Consolla"
mcset it manual "Manuale"
mcset it packageRequireMissing "$bp necessita dell'estensione Tcl '%s'. Installarla tramite il pannello di controllo o digitare nella consolle: \n\n sudo apt install %s (Debian/Ubuntu)"
# W E L C O M E
mcset it next "\u25bc Successivo"
mcset it welcTit "Benvenuto nel programma di configurazione di $bp!"
mcset it welcSubtit1 "Che cos'è $bp?"
mcset it welcTxt1 "$bp è un programma Tcl sviluppato per il progetto 'Bibbia 2.0'.\n\n'Bibbia 2.0' ha lo scopo di diffondere $dw in un numero crescente di lingue.\n$dw consiste di 2 specifici versetti biblici per ciascun giorno dell'anno.\n\n$bp è in grado di visualizzare $dw in diversi modi sul vostro PC."
mcset it welcSubtit2 "Cosa potete fare?"
mcset it welcTxt2 "\u27a4 [mc bibletexts] : Selezionare un numero a piacere di edizioni della Bibbia e di relative lingue per $dw
\u27a4 [mc desktop]: Consultare $dw sulle immagini personali
\u27a4 [mc photos]: Selezionare le immagini di sfondo per $bp
\u27a4 [mc email]: Aggiungere $dw alle firme e-mail
\u27a4 [mc manual]: Leggere il manuale completo di $bp
\u27a4 [mc terminal]: Consultare $dw nelle consolle Linux"
# U N I N S T A L L
mcset it uninstall "Si desidera veramente rimuovere $bp dal computer?"
mcset it uninstalling "$bp sarà disinstallato. Per eliminare le impostazioni di sistema è necessario rispondere alle eventuali finestre di avviso con \"Sì\"!"
mcset it uninstalled "$bp è stato rimosso in sicurezza dal sistema. Per installarlo nuovamente consultare il sito [mc www] e scaricare il $bp Installer."
# I N T E R N A T I O N A L
mcset it download "Download"
mcset it downloadingHttp "Download in corso dei file di programma di $bp..."
mcset it downloadingAsianFont "Download in corso dei file di font asiatici..."
mcset it downloadComplete "Download concluso."
mcset it updatingHttp "Aggiornamento in corso dei file di programma di $bp..."
mcset it uptodateHTTP "I file di programma sono stati aggiornati."
mcset it noConnHTTP "Nessuna connessione Internet per l'aggiornamento del programma, riprovare più tardi."
mcset it gettingTwd "Download dell'elenco aggiornato dei testi biblici su bible2.net in corso..."
mcset it noTwdFilesFound "Non vi sono testi biblici aggiornati installati.\nSelezionare nelle impostazioni di $bp almeno 1 file della lingua nella sezione 'International'."
mcset it connTwd "Collegamento a bible2.net realizzato."
mcset it noConnTwd "Nessun collegamento a bible2.net. Riprovare più tardi."
mcset it f1Tit "Elenco attuale dei testi biblici per $dw"
mcset it TwdLocalTit "File dei testi biblici attualmente installati per $jahr"
mcset it TwdRemoteTit "File dei testi biblici da scaricare"
mcset it language "Lingua"
mcset it year "Anno"
mcset it bibleversion "Edizione della Bibbia"
mcset it biblename "Sigla dell'edizione"
mcset it f1Txt "$bp mette a disposizione $dw in tutte le lingue e in tutte le edizioni della Bibbia installate sul computer. Se sono stati installati più file dei testi biblici, $bp ne sceglie ogni volta uno a caso. Se si evidenziano nuovi file di testi biblici da scaricare (vedi sotto), questi saranno scaricati non appena si preme il tasto '[mc download]'. Prestare attenzione all'anno (anno in corso o prossimo anno)!"

# D E S K T O P
mcset it f2Tit "$dw sull'immagine di sfondo del desktop"
mcset it f2Box "Creare immagine di sfondo"
mcset it f2Farbe "Colore carattere: "
mcset it f2Slideshow "Attivare slideshow"
mcset it f2Interval "Cambio immagine ogni"
mcset it sec "secondi"
mcset it f2Introline "Visualizzare data"
mcset it f2Fontsize "Dimensione carattere: "
mcset it f2Fontweight "grassetto"
mcset it f2Fontfamily "Tipo di carattere: "
mcset it f2Fontexpl "Adattare carattere"
mcset it f2Txt "\nSe questa funzione è attivata, $bp attiva $dw su di un'immagine di sfondo. L'immagine viene scelta dalla galleria di $bp secondo il principio di casualità (vedi sezione [mc photos]). Una nuova immagine di sfondo è ogni volta disponibile per la visualizzazione in \n\n\t [file nativename $imgdir] \n\nper il Desktop Manager. \n\nSe sono stati installati più file dei testi biblici, ad ogni cambio di immagine cambia anche la lingua o la versione della Bibbia secondo il principio di casualità.\n\n$bp configura di default uno SLIDESHOW con una carrellata di immagini. Se si vuole visualizzare solamente 1 immagine al giorno, lo slideshow può essere disattivato (vedi sopra).\n\nNella finestra POSIZIONE TESTO è possibile spostare $dw nel punto desiderato del monitor. Durante l'aggiunta di immagini la posizione del testo può essere determinata anche in maniera personalizzata. \n\nLe DIMENSIONI CARATTERE vengono impostate automaticamente a seconda delle dimensioni del monitor. È tuttavia possibile adattare in qualsiasi momento le dimensioni e lo spessore (lettere più grandi = migliore contrasto).\n\nIl COLORE CARATTERE può essere determinato in modo fisso, oppure lasciato al caso. $bp può inoltre adattare il colore sulla base della luminosità dello sfondo. Questo effetto si attiva solo dopo aver salvato nuove immagini.\n\nSe la nuova immagine di sfondo non compare automaticamente, la relativa soluzione è riportata nel manuale."
# P H O T O S
mcset it textposlabel "Determinare posizione del testo"
mcset it textposAdjust "Si desidera modificare la posizione del testo per questa immagine prima di salvare?"
mcset it f6Tit "Organizzare immagini per $bp"
mcset it f6Txt "Con questa funzione è possibile trascinare un numero a piacere di immagini dalla propria cartella immagini alla galleria di $bp. Le immagini dovranno essere effettuate in formato trasversale e possedere una superficie dal colore quanto più uniforme per una buona leggibilità dei versetti biblici.\n\n$bp salva una copia dell'immagine nella cartella delle immagini di $bp e modifica il formato e le dimensioni dell'immagine se questi non coincidono con le dimensioni del monitor. In questo caso avete la possibilità di determinare autonomamente le dimensioni dell'immagine ritagliandola, e la posizione futura del testo biblico.\n\nL'immagine originale non viene comunque modificata in ogni caso."
mcset it f6numPhotosTxt "Immagine"
mcset it f6Add "Aggiungere alla galleria di $bp:"
mcset it f6Show "Visualizza galleria di $bp"
mcset it f6Find "Cercare nuove immagini"
mcset it f6Del "Eliminare dalla galleria di $bp:"
# R E S I Z I N G
mcset it movePicToResize "Spostare a piacere l'immagine ritagliata, quindi confermare con Ok per salvare."
mcset it resizeF_txt "L'immagine non è adatta per le dimensioni del monitor e dovrà essere tagliata a misura. [mc movePicToResize]"
mcset it resizingPic "Adattare le dimensioni dell'immagine a quelle del monitor \u2014 Si prega di attendere..."
mcset it movePic "Sposta immagine ritagliata \u21CA"
mcset it picSchonDa "Immagine già presente nella cartella delle immagini di $bp"
# S I G N A T U R E
mcset it f3Tit "Impostare $dw sulla firma e-mail"
mcset it f3Btn "Generare firma e-mail"
mcset it f3Sprachen "Lingue desiderate per le mie firme"
mcset it f3Txt "Se questa funzione è attivata, per ciascun file di testo biblico installato $bp aggiunge $dw alle firme e-mail una volta al giorno. I file di firma così generati vengono classificati secondo la sigla della lingua (ad es. signature-it_..txt) nella cartella seguente: \n\n\t$sigdir \n\nÈ possibile modificare questi file nel proprio programma di posta elettronica o in un editor di testo, ed inserire forme di saluto personalizzate, indirizzi ecc. Quando si cambia $dw, il testo al di sopra della linea di separazione ==== rimane invariato. \n\nProbabilmente non si desidera che il destinatario delle e-mail legga $dw in tutte le lingue installate. Selezionare in alto a destra la(e) lingua(e) preferita(e).\n\nPerché $dw compaia in futuro sulle proprie e-mail, occorre impostare il programma di posta elettronica perché utilizzi i file sopra descritti (per lo più alla voce Impostazioni>Firma). Se invece d'una lingua, si scegle il file
\n\t signature-SURPRISE.txt
\n$dw roterà secondo il principio di casualità.\n\nDeterminati programmi come Seamonkey Mail, Evolution o Trojitá gestiscono le firme internamente. Tra questi, $bp è temporaneamente compatibile con Trojitá ed Evolution."
# T E R M I N A L
mcset it f4Tit  "$dw nei terminali Linux"
mcset it f4Btn "Attivare $dw per la visualizzazione nel terminale"
mcset it f4Txt "Se questa funzione è attivata, $bp apre $dw per essere visualizzata nelle consolle. Se sono presenti più file dei testi biblici, il testo cambia ad ogni apertura del terminale. \n\nVisualizzazione e colori possono essere modificati in \n\n\t $confdir/term.conf \n\n.Per la visualizzazione in caratteri ebraici o arabi possono essere utilizzati solamente terminali come 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' o 'Konsole' (KDE), i quali illustrano il testo correttamente in entrambi i sensi. \n\nPerché $dw venga visualizzata automaticamente nel terminale, $bp crea una voce in ~/.bashrc."
# S E T U P S A V E
mcset it linChangingDesktop "$bp sta cercando di modificare le impostazioni del desktop. Se non si vedono nuove immagini di sfondo, consultare il manuale."
mcset it winIgnorePopup "Chiudere la finestra che si apre senza effettuare modifiche, di modo che $bp possa concludere la registrazione!"
mcset it winChangingDesktop "$bp sta cercando di modificare lo sfondo del desktop"
mcset it winChangeDesktopProb "Si è verificato un problema con la modifica dello sfondo del desktop.\nCliccare con il tasto destro del mouse su un campo vuoto del desktop e scegliere \"Adattazione\". Alla voce \"Sfondo\", impostare come immagine singola dello sfondo $TwdBMP o \n$TwdPNG \noppure per lo slideshow\n$imgdir."
mcset it linChangeDesktopProb "Si è verificato un problema con la modifica delle impostazioni del desktop.\nCliccare con il tasto destro del mouse sul desktop e cercare la finestra di dialogo per 'Immagine di sfondo'. Lì indicare '$imgdir' come percorso dell'immagine."

mcset it linNoDesktopFound "Nessun desktop Linux trovato! Cercare una soluzione nel manuale per la configurazione manuale dell'immagine di sfondo per $bp."
mcset it linReloadingDesktop "Tentativo in corso di scansionare nuovamente il desktop. Se il tentativo fallisce, effettuare brevemente il logout e poi nuovamente il login perché le impostazioni di $bp diventino efficaci."
if {$os=="Linux"} {
  mcset it changeDesktopOk "$bp è stato configurato sul computer e sarà avviato ora.\n\nIl programma di configurazione $bp può essere avviato in qualsiasi momento selezionando nel menu di programma il simbolo $bp."
} else {
  mcset it changeDesktopOk "$bp è stato configurato sul computer e sarà avviato ora.\n\nIl programma di configurazione $bp può essere avviato in qualsiasi momento cliccando sul desktop con il tasto destro del mouse e selezionando il simbolo $bp."
}
mcset it winRegister "Ora $bp deve essere registrato nel sistema.\nConfermare eventuali finestre di avviso con \"Sì\"!"
mcset it winRegisterProb "$bp non è stato installato correttamente sul computer.\nAvviare nuovamente l'installazione, oppure aggiungere '$Biblepix' in \"Programmi avviati automaticamente\"."
# P H O T O S
mcset it reposSaved "Immagine salvata con informazioni."
mcset it reposNotSaved "Immagine non salvata."
mcset it noPhotosFound "Non sono state trovate immagini nella cartella delle immagini di $bp. Copiare alcune immagini nella cartella."
mcset it rotatePic "Ruotare immagine"
mcset it preview90 "\u21B7 Anteprima rotazione di 90°"
mcset it preview180 "\u21BB Anteprima rotazione di 180°"
mcset it computePreview "\u21B6 \u21B7 Anteprima rotazione a piacere"
mcset it rotateWait "Si prega di attendere la conclusione della rotazione dell'immagine originale..."
mcset it rotateInfo "Attenzione: l'immagine può essere ruotata in più fasi salvandola e ricaricandola!"
mcset it deletedPicMsg "Immagine eliminata dall'album di $bp:"
mcset it copiedPicMsg "Nuova immagine copiata nell'album di $bp:"
