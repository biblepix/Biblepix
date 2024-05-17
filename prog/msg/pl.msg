# Polish texts for msgcat
# ~/Biblepix/prog/msg/pl.msg
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 13nov21 pv

############################################################################################################
## T R A N S L A T O R S : O N L Y   T R A N S L A T E   P H R A S E S   W I T H I N  Q U O T E S "......"
## e.g.:  of  
##    mcset yourlanguage "..."    - only replace quoted text  "....."
############################################################################################################

################################################################################
## U N T R A N S L A T A B L E S
## P L E A S E   D O N 'T  T O U C H : 
## - ANY PHRASE STARTING WITH #
## - ANY WORD STARTING WITH $
## - ANY PHRASE WITHIN SQUARE BRACKETS [...]
## - ANY FORMATTING MARKERS LIKE \n \n\n \t \u... etc.
## - ANY PHRASE STARTING WITH 'set'
################################################################################
set bp "BiblePix"
set dw {'Słowo'}
mcset pl bp $bp

# G E N E R A L
mcset pl bpsetup "$bp Instalacja"
mcset pl ok "Ok"
mcset pl cancel "Anuluj"
mcset pl close "Zamknij"
mcset pl save "Zapisz"
mcset pl saveSettings "Zapisz ustawienia"
mcset pl random "losowy"
mcset pl welcome "Witaj"
mcset pl bibletexts "Teksty Biblijne"
mcset pl desktop "Tło pulpitu"
mcset pl photos "Zdjęcia"
mcset pl email "Podpis e-mail"
mcset pl terminal "Terminal"
mcset pl manual "Ręczny"
mcset pl uninst "Odinstaluj $bp"
mcset pl next "Następny \u25bc"
mcset pl packageRequireMissing "$bp potrzebuje rozszerzenia Tcl '%s'.\nProszę zainstalować program przy użyciu menadżera systemu lub poprzez wybranie jednej z następujących komend w terminalu programisty (jako root lub sudo): [mc packageRequire]"

# U N I N S T A L L
mcset pl uninstall "Czy napewno chcesz usunąć $bp z Twojego komputera?"
mcset pl uninstalling "$bp zostanie odinstalowany. W celu wyczyszczenia wprowadzonych ustawień systemowych, należy zaznaczyć we wszystkich pojawiających się oknach dialogowych \"Tak\"."
mcset pl uninstalled "$bp został bezpiecznie usunięty z twojego komputera. W celu ponownej instalacji odwiedź naszą stronę [mc www] i pobierz pakiet instalacyjny $bp"

#### S E T U P   G U I ################################
mcset pl download "Pobierz"
mcset pl downloadingHttp "Pobieranie plików programu $bp"
mcset pl updatingHttp "Aktualizacja plików programu $bp"
mcset pl uptodateHTTP "Twój program został zaktualizowany"
mcset pl noConnHTTP "Brak wymaganego do aktualizacji plików połączenia z Internetem. Proszę spróbować później"
mcset pl gettingTwd "Pobieram aktualną listę tekstów Biblijnych z bible2.net..."
mcset pl noTwdFilesFound "Brak zainstalowanych aktualnych plików z tekstami Biblijnymi.\nW ustawieniach $bp wybierz przynajmniej \n jeden plik tekstowy z sekcji 'International'."
mcset pl connTwd "Połączono z bible2.net."
mcset pl noConnTwd "Brak połączenia z bible2.net. Spróbuj ponownie później."
mcset pl refresh "Aktualizacja"
mcset pl delete "Usuń plik"
mcset pl textposlabel "Ustaw ogólną pozycję tekstu"
mcset pl textposAdjust "Czy chcesz dostosować pozycję tekstu do tego zdjęcia przed zapisaniem?"
mcset pl welcTit "Witaj w instalatorze programu $bp!"
mcset pl welcSubtit1 "Czym jest $bp?"
mcset pl welcTxt1 "$bp jest programem Tcl stworzonym w ramach projektu 'Bible 2.0', którego celem jest szerzenie ‘Słowa’ w coraz to większej ilości języków. \n\n'Słowo' zawiera dwa wybrane wersety Biblii na każdy dzień roku. \n\n$bp może wyświetlać 'Słowo' w różnych wersjach na twoim komputerze." 
mcset pl welcSubtit2 "Jakie są twoje opcje?"
mcset pl welcTxt2 "\u27a4 [mc bibletexts]: Wybierz tekst Biblii w jednym lub kilku językach dla 'Słowo'
\u27a4 [mc desktop]: Wybierz 'Słowo' na swoje spersonalizowane tło ekranu, również jako pokaz slajdów
\u27a4 [mc photos]: Uporządkuj swoje zdjęcia w celu użycia ich przez $bp
\u27a4 [mc email]: Użyj 'Słowa' jako podpisu pod swoim e-mail\'em
\u27a4 [mc terminal]: Wyświetl 'Słowo' w swoim terminalu Linux
\u27a4 [mc manual]: Zapoznaj się z Kompletną Instrukcją programu $bp
"
mcset pl f1Tit "Aktualna lista tekstów Biblijnych dla 'Słowo'"
mcset pl TwdLocalTit "Pliki z tekstami Biblijnymi zainstalowane dla  $jahr"
mcset pl TwdRemoteTit "Pliki z tekstami Biblijnymi do pobrania"
mcset pl language "Język"
mcset pl year "Rok"
mcset pl bibleversion "Wersja Biblii"
mcset pl biblename "Nazwa Biblii"
mcset pl f1Txt "$bp stworzy 'Słowo' w dowolnym języku lub wersji Biblii zainstalowanych na twoim komputerze. Jeśli program wykryje kilka wersji językowych plików, $bp wybierze losowo jedną z nich. Każdy nowy język, który zostanie wybrany do pobrania (zobacz poniżej) będzie pobrany poprzez kliknięcie przycisku '[mc download]'. Zwróć uwagę na rok (obecny lub następny)!"
mcset pl f2Tit "Ustaw 'Słowo' na twojej tapecie"
mcset pl f2Box "Utwórz tapetę"
mcset pl f2Farbe "Kolor czcionki: "
mcset pl f2Slideshow "Uruchom pokaz slajdów"
mcset pl f2Interval "Interwał pokazu slajdów: "
mcset pl sec "sekundy"
mcset pl f2Introline "Pokaż datę"
mcset pl f2Fontsize "Rozmiar czcionki: "
mcset pl f2Fontweight "pogrubienie"
mcset pl f2Fontfamily "Rodzaj czcionki: "
mcset pl f2Fontexpl "Dostosuj czcionkę"
mcset pl f2Txt "Przy każdym uruchomieniu $bp umieści 'Słowo' na tle pulpitu. Zdjęcie będzie wybrane  losowo z Kolekcji Zdjęć $bp (zobacz Sekcja Zdjęć), a nowe tło ekranu będzie umieszczone w \n\n\t [file nativename $imgdir] \n\ndo wyświetlenia przez menedżera pulpitu.\n\nJeśli zainstalowano więcej niż jeden pakiet językowy, język (lub wersja Bilbii) będzie zmieniać się wraz z kolejnymi zdjęciami. \n\n$bp uruchomi pokaz slajdów ze zmieniającymi się zdjęciami w ustawionych wcześniej interwałach. W celu ustawienia tylko jednego zdjęcia na dzień, odznacz tę opcję (zobacz powyżej).\n\nOkno POZYCJI TEKSTU pozwoli Ci umieścić 'Słowo' w dowolnym miejscu na Twoim ekranie. Ponadto, dodając zdjęcia do kolekcji zdjęć $bp masz możliwość ustawienia tekstów indywidualnie.\n\nROZMIAR CZCIONKI  jest ustawiany automatycznie uwzględniając wysokość ekranu. Jednakże, masz możliwość zmiany rozmiaru i wagi czcionki według własnego uznania (większe litery = lepszy kontrast).\n\nKOLOR CZCIONKI może być losowy albo ustawiony przez użytkownika. $bp może dostosować luminację kolorów na podstawie jasności ekranu. Ta operacja ma miejsce tylko w przypadku gdy zdjęcie jest zawarte w kolekcji $bp.  \n\nJeśli nowe tło pulpit nie pojawi się natychmiast, należy szukać rozwiązania w Instrukcji Strony."
# S E T U P   P H O T O S 
mcset pl f6Tit "Zarządzaj swoimi zdjęciami w $bp"
mcset pl f6Txt "Tutaj możesz dodać wybrane zdjęcia ze swojego katalogu zdjęć i umieścić je w kolekcji zdjęć $bp, lub je z tej kolekcji usunąć. Zdjęcia powinny być w formacie poziomym i posiadać proste (wyraźne) kolory w celu uzyskania najlepszej widoczności tekstu Biblijnego.\n\nJeśli rozmiar zdjęcia nie jest zgodny z wymiarami ekranu, $bp dopasuje je i zachowa w katalogu zdjęć $bp. Jeżeli wymagana jest zmiana wymiarów, program poprosi o wybranie odpowiedniej sekcji zdjęcia oraz pozycji kolejnych tekstów Biblijnych.\n\nNiezależnie od tego, oryginalny format zdjęcia pozostaje niezmieniony."
mcset pl f6numPhotosTxt "Zdjęć"
mcset pl f6Add "Dodaj do Kolekcji zdjęć $bp:"
mcset pl f6Show "Pokaż Kolekcję zdjęć $bp"
mcset pl f6Find "Znajdź nowe zdjęcia"
mcset pl f6Del "Usuń z Kolekcji zdjęć $bp:"
#RESIZING
mcset pl resizeF_txt "Rozmiar zdjęcia nie odpowiada rozmiarowi ekranu i musi zostać przycięte. [mc movePicToResize]"
mcset pl movePicToResize "Przenieś sekcję zdjęcia do wybranej pozycji i kliknij Ok w celu zmiany rozmiaru."
mcset pl resizingPic "Trwa zmiana rozmiaru zdjęcia w celu dopasowania go do rozmiaru ekranu \u2014 proszę czekać..."
mcset pl movePic "Przenieś sekcję zdjęcia \u21CA"
mcset pl picSchonDa "Zdjęcie należy już do kolekcji zdjęć $bp"
# S E T U P   S I G N A T U R E
mcset pl f3Tit "Ustaw 'Słowo' jako podpis swojego e-maila"
mcset pl f3Btn "Stwórz podpis e-mail"
mcset pl f3Sprachen "Języki wybrane do moich podpisów"
mcset pl f3Txt "Program $bp doda 'Słowo' na końcu Twojego podpisu e-mail raz na dzień w każdym języku obecnym na twoim komputerze. Pliki podpisów są przechowywane przy pomocy skrótów językowych (np. podpis_English.txt) w katalogu \n\n\t$sigdir \n\nMasz możliwość edytowania tych plików z poziomu Twojej skrzynki mailowej, lub w edytorze tekstowym, oraz możliwość dodania dowolnej osobistej wiadomości na początku podpisu (pozdrowienia, adresy itd.) Każdy tekst powyżej linii separacyjnej  ==== pozostanie niezmieniony po każdej zmianie 'Słowa'. \n\nMożesz nie chcieć, aby 'Słowo' pojawiało się w różnych wersjach językowych. W polach wyboru w prawym górnym rogu wybierz języki, które są odpowiednie dla odbiorców Twoich wiadomości e-mail.\n\nPamiętaj, aby ustawić w swojej skrzynce mailowej wybrane pliki podpisów (zwykle poprzez Opcje>Podpisy).
\nJeśli zamiast języka wybierzesz plik 
\n\t signature-SURPRISE.txt
\nobraca się 'Słowo' losowo.\n\nNiektóre skrzynki tj. Seamonkey Mail, Evolution lub Trojitá zarządzają podpisami wewnętrznie. Spośród wyżej wymienionych, na dzień dzisiejszy $bp współpracuje z Trojitá oraz Evolution."
mcset pl f4Tit  "Wyświetl 'Słowo' w terminalu Linux"
mcset pl f4Btn "Utwórz 'Słowo' do wyswietlenia w terminalu"
mcset pl f4Txt "Po uruchomieniu $bp utworzy 'Słowo' do wyświetlenia na górze Twojego terminalu. Jeśli zainstalowano więcej niż jeden pakiet językowy, teksty Biblijne będą zmieniane losowo przy każdym uruchomieniu nowego okna. \n\nWyświetlane kolory itp. mogą być zmieniane w \n\n\t $confdir/term.conf \n\nAby wyświetlić poprawnie zapis w języku Arabskim lub Hebrajskim potrzebny będzie jeden z następujących: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) lub 'xfce4-terminal'; te sprawdzają się w pracy z tekstem dwukierunkowym.\n\nW celu wyświetlenia 'Słowa' automatycznie w Twoich terminalach, [mc bpsetup] tworzy wpis w ~/.bashrc dla Twojej wygody."
# S A V E
mcset pl linChangingDesktop "$bp spróbuje teraz połączyć się z Twoim tłem pulpitu. Jeśli nie wyświetla się nowe tło pulpitu, szukaj rozwiązania problemu w Instrukcji."
mcset pl winIgnorePopup "Proszę odrzuć (zamknij) wszystkie wyskakujące okna, aby $bp mógł dokończyć rejestrację!"
mcset pl winChangingDesktop "$bp spróbuje teraz połączyć się z Twoim tłem pulpitu" 
mcset pl winChangeDesktopProb "Wystąpił problem podczas próby zmiany Twojego tła pulpitu. \nProszę kliknąć prawym przyciskiem myszy na puste miejsce na pulpicie i wybrać \"Personalizuj\" > \"Tapeta\" i ustaw pojedynczą ścieżkę dla zdjęcia \n\t$TwdBMP lub \n\t$TwdPNG \nlub zmień ustawienia w katalogu pokazu slajdów na \n\t$imgdir."
mcset pl linChangeDesktopProb "Wystąpił problem podczas próby zmiany Twoich ustawień pulpitu.\nProszę kliknąć prawym przyciskiem myszy na pulpit i znaleźć 'Tło obrazu'. Tam wprowadź $imgdir jako nową ścieżkę obrazu."
mcset pl linNoDesktopFound "Nie wykryto systemu Linux. Informacje na temat manualnego ustawiania zdjęcia w tle programu $bp znajdują się w Instrukcji."
mcset pl linReloadingDesktop "Teraz nastąpi próba odświeżenia Twojego pulpitu. W razie niepowodzenia, prosimy o wylogowanie się i ponowne zalogowanie w celu uruchomienia ustawień programu $bp."
mcset pl changeDesktopOk "$bp został pomyślnie skonfigurowany i za chwilę zostanie uruchomiony.\n\nMożesz włączyć program [mc bpsetup] w każdej chwili wybierając ikonę [mc bpsetup] w Menu Programów (Linux) lub poprzez kliknięcie prawym przyciskiem myszy na pulpit (Windows)."
mcset pl winRegister "$bp spróbuje teraz połączyć się z Twoim systemem.\nPotwierdź pojawiające się okna dialogowe zaznaczając \"Tak\"." 
mcset pl winRegisterProb "$bp nie został pomyślnie zainstalowany na Twoim komputerze.\nSpróbuj ponownie uruchomić [mc bpsetup], lub dodać \n\t$Biblepix\n do folderu Autostartu."
# P H O T O S
mcset pl deletedPicMsg "Usunięto zdjęcie z kolekcji zdjęć $bp:"
mcset pl copiedPicMsg "Skopiowano zjęcie do kolekcji zdjęć $bp:"
mcset pl reposSaved "Zdjęcie zapisane wraz ze Szczegółami."
mcset pl reposNotSaved "Zdjęcie nie zostało zapisane."
mcset pl noPhotosFound "Nie odnaleziono zdjęć w folderze [mc photos] programu $bp. Proszę o skopiowanie zdjęć do folderu."
mcset pl rotatePic "Obróć zdjęcie"
mcset pl preview90 "\u21B7 Podgląd rotacji o 90°"
mcset pl preview180 "\u21BB Podgląd rotacji o 180°"
mcset pl computePreview "\u21B6 \u21B7 Podgląd każdej rotacji"
mcset pl rotateWait "Proszę cierpliwie czekać aż program obróci oryginalne zdjęcie..."
mcset pl rotateInfo "Uwaga: poprzez zapisywanie i odświeżanie, zdjęcie może być obrócone kilkukrotnie!"
