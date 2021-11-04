# ~/Biblepix/prog/msg/fr.msg
# French texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 4nov21 pv

# U N T R A N S L A T A B L E S
set bp "BiblePix"
set dw {'La Parole'}
mcset fr dw $dw
mcset fr bp $bp
# G E N E R A L
mcset fr bpsetup "Configuration de $bp"
mcset fr refresh "Actualiser"
mcset fr delete "Effacer le fichier"
mcset fr ok "Ok"
mcset fr cancel "Annuler"
mcset fr close "Fermer"
mcset fr save "Enregistrer"
mcset fr saveSettings "Enregistrer les paramètres"
mcset fr random "aléatoire"
mcset fr uninst "Désinstaller $bp"
mcset fr welcome "Bienvenu"
mcset fr bibletexts "Textes bibliques"
mcset fr desktop "Image de fond"
mcset fr photos "Fotos"
mcset fr email "Signature e-mail"
mcset fr terminal "Terminal"
mcset fr manual "Manuel"
mcset fr packageRequireMissing "$bp a besoin de l'extension Tcl '%s'. Veuillez l'installer via votre panneau de configuration ou tapez l'une des commandes suivantes dans une console (comme root ou sudo): [mc packageRequire]"

# W E L C O M E 
mcset fr next "Prochain \u25bc"
mcset fr welcTit "[mc welcome] à la [mc bpsetup]!"
mcset fr welcSubtit1 "Qu'est-ce qui est $bp?"
mcset fr welcTxt1 "$bp est un programme Tcl qui est développé pour le projet 'Bible 2.0'. \n\n'Bible 2.0' vise à diffuser $dw dans un nombre croissant de langues. \n$dw se compose de 2 versets de la Bible sélectionnés pour chaque jour de l'année. \n\n$bp peut visualiser $dw de plusieurs manières sur votre PC:"
mcset fr welcSubtit2 "Quelles sont vos possibilités?"
mcset fr welcTxt2 "\u27a4 [mc bibletexts]: sélectionnez n'importe quel nombre d'éditions et de langues de la Bible pour $dw
\u27a4 [mc desktop] : Regardez $dw dans vos photos personnelles
\u27a4 [mc photos]: Choisissez vos propres images de fond pour $bp
\u27a4 [mc email]: Ajoutez $dw à vos emails
\u27a4 [mc manual] : Étudiez le manuel complet de $bp
\u27a4 [mc terminal] : Regardez $dw dans vos consoles Linux
"
# U N I N S T A L L
mcset fr uninstall "Êtes-vous sûr de vouloir supprimer $bp de votre ordinateur ?"
mcset fr uninstalling "BiblePix va maintenant être désinstallé. Pour supprimer les paramètres système correspondants, vous devez confirmer n'importe quelle fenêtre de notification avec \"Oui\"!"
mcset fr uninstalled "$bp a été supprimé de votre système en toute sécurité. Pour le réinstaller, visitez-nous sur [mc www] et téléchargez le logiciel d'installation de $bp."

#SETUP INTERNATIONAL
mcset fr download "Télécharger"
mcset fr downloadingHttp "Téléchargement des fichiers programme $bp ..."
mcset fr updateHttp "Mise à jour des fichiers programme $bp ..."
mcset fr uptodateHTTP "Vos fichiers de programme sont à jour."
mcset fr noConnHTTP "Pas de connexion Internet pour la mise à jour du programme, veuillez réessayer plus tard."
mcset fr getTwd "Obtention de la liste actuelle des textes bibliques de bible2.net ..."
mcset fr noTwdFilesFound "Aucun fichier de texte biblique actuel n'est installé. \nVeuillez sélectionner au moins 1 fichier dans la section '[mc bibletexts]' dans le configurateur $bp."
mcset fr connTwd "Connexion à bible2.net établie."
mcset fr noConnTwd "Impossible de se connecter à bible2.net. Veuillez réessayer plus tard."
mcset fr f1Tit "Liste des textes bibliques actuels pour $dw"
mcset fr TwdLocalTit "Fichiers textes bibliques installés pour $jahr"
mcset fr TwdRemoteTit "Fichiers de texte biblique à télécharger"
mcset fr language "Langue"
mcset fr year "Année"
mcset fr bibleversion "Edition Bible"
mcset fr biblename "Désignation"
mcset fr f1Txt "$bp fournit $dw dans toutes les langues et éditions de la Bible installées sur votre ordinateur. Si plusieurs fichiers de texte biblique sont installés, $bp en choisira un par hasard. Si vous marquez de nouveaux fichiers de texte biblique à télécharger (voir ci-dessous ), ils seront téléchargés dès que vous appuyez sur le bouton '[mc download]'. Faites attention à l'année (en cours ou prochaine)!"

# D E S K T O P
mcset fr f2Tit "$dw sur l'image de fond"
mcset fr f2Box "Générer une image de fond"
mcset fr f2Farbe "Couleur de la police: "
mcset fr f2Slideshow "Activer le diaporama"
mcset fr f2Interval "Changement d'image tous les "
mcset fr sec "secondes"
mcset fr f2Introline "Afficher la date"
mcset fr f2Fontsize "Taille de la police: "
mcset fr f2Fontweight "gras"
mcset fr f2Fontfamily "Police de charactères: "
mcset fr f2Fontexpl "Adapter la police"
mcset fr f2Txt "Si activé, $bp fait apparaître $dw sur une image de fond. La photo est sélectionnée au hasard dans la collection de photos $bp (voir section [mc photos]). Une nouvelle image de fond est toujours disponible dans \n\n\t [file nativename $imgdir] \n\npour l'affichage par le gestionnaire de bureau.\n\nSi plusieurs fichiers texte de la Bible sont installés, la langue ou la version de la Bible change au hasard à chaque changement d'image.\n\nPar défaut, $bp installe un DIAPORAMA avec une image changeante. Si une seule image par jour est désirée, le diaporama peut être désactivé (voir ci-dessus).\n\nDans la fenêtre POSITION TEXTE, vous pouvez déplacer $dw à la position désirée sur l'écran. Lors de l'ajout d'images à la collection, la position du texte peut être déterminée individuellement. \n\nLa TAILLE DE LA POLICE est automatiquement définie selon la hauteur de l'écran. Cependant, vous avez la possibilité d'adapter la taille et l'épaisseur individuellement (lettres plus grosses = meilleures contraste). \n\nLa COULEUR DE LA POLICE, vous pouvez la déterminer de manière permanente ou aléatoire. $bp peut également effectuer un ajustement des couleurs en fonction de la luminosité de l'arrière-plan. Cet effet n'entre en jeu qu'après avoir enregistré de nouvelles photos. \n\nSi la nouvelle image de fond n'apparaît pas automatiquement, vous trouverez une solution dans le manuel. "

# P H O T O S 
mcset fr textposlabel "Déterminer la position du texte"
mcset fr textposAdjust "Voulez-vous changer la position du texte pour cette image avant de l'enregistrer?"
mcset fr f6Tit "Organiser les photos pour $bp"
mcset fr f6Txt "Ici, vous pouvez copier autant de photos que vous le souhaitez de votre dossier d'images personnel à la collection de photos de $bp. Les photos doivent être prises au format paysage et avoir une zone de couleur uniforme pour une lisibilité facile du verset de la Bible. \n\n$bp enregistre une copie de l'image dans le dossier photo $bp et modifie le format et la taille de l'image si elle ne correspond pas aux dimensions de l'écran. Dans ce cas, vous avez la possibilité de déterminer la section d'image appropriée et l'avenir position du texte de la Bible vous-même. \n\nL'image originale reste inchangée dans tous les cas. "
mcset fr f6numPhotosTxt "Nombre d'images: "
mcset fr f6Ajouter "Ajouter à la collection de photos $bp:"
mcset fr f6Show "Afficher la collection de photos $bp"
mcset fr f6Find "Trouver de nouvelles photos"
mcset fr f6Del "Supprimer de la collection de photos $bp:"
#RESIZING
mcset fr movePicToResize "Déplacez la section d'image comme vous le souhaitez et confirmez avec OK pour l'enregistrer."
mcset fr resizeF_txt "Votre photo ne correspond pas à la taille de l'écran et doit être recadrée. [mc movePicToResize]"
mcset fr resizingPic "Nous allons ajuster la taille de l'image à celle de l'écran \u2014 s'il vous plaît patientez un instant ..."
mcset fr movePic "Déplacer la section de l'image \u21CA"
mcset fr picSchonDa "Photo déjà dans le dossier image $bp"

# S I G N A T U R E
mcset fr f3Tit "$dw sur vos signatures email"
mcset fr f3Btn "Générer une signature électronique"
mcset fr f3Sprachen "Langues désirées pour mes signatures"
mcset fr f3Txt "Si activé, $bp ajoute $dw à vos signatures électroniques une fois par jour pour chaque fichier texte biblique installé. Les fichiers de signature créés sont triés par abréviations de langue (par exemple signature-fr_Segond.txt) et enregistrés dans le dossier suivant: \n\n\t $sigdir \n\nVous pouvez modifier ces fichiers à partir de votre programme de messagerie ou dans un éditeur de texte et ajouter des salutations personnelles, des adresses, etc. Le texte au-dessus de la ligne de séparation ==== reste inchangé lors du changement de $dw. \n\nPeut-être que vous ne voulez pas que vos destinataires de courrier lisent $dw dans toutes les langues que vous avez installées. Sélectionnez la ou les langues que vous voulez dans le coin supérieur droit. \n\nPour que $dw aparaisse sur vos mails à l'avenir, vous devez instruer votre logiciel de courrier électronique à utiliser les fichiers décrits ci-dessus (généralement sous Paramètres>Signature). Si, au lieu d'une langue, vous choisissez le fichier
\n\tsignature-SURPRISE.txt
\n$dw tournera par hasard.
\nCertains programmes tels que Seamonkey Mail, Evolution ou Trojitá gèrent les signatures en interne. Pour le moment, $bp en peut prendre en compte Trojitá et Evolution."

# T E R M I N A L
mcset fr f4Tit "$dw dans vos terminaux Linux"
mcset fr f4Btn "Générer $dw pour l'affichage dans le terminal"
mcset fr f4Txt "Si activé, $bp génère $dw pour l'affichage dans vos consoles. S'il y a plusieurs fichiers texte biblique, le texte changera à chaque ouverture d'un terminal. \n\nLe dessin et les couleurs peuvent être modifiés dans \n\n\t ${confdir}/term.conf \n\nQuant au texte en écriture hébraïque ou arabe, seuls les terminaux comme 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' ou 'Console ' (KDE) qui s'y connaissent en textes bidirectionneaux, savent l'afficher correctement. \n\nPour s'assurer que $dw s'affiche automatiquement dans le terminal, le configurateur $bp crée une entrée dans ~/.bashrc."

# S A V E
mcset fr linChangingDesktop "$bp essaie maintenant de modifier les paramètres de votre bureau. Si vous ne voyez pas de nouvelle image d'arrière-plan par la suite, vous trouverez une solution dans le manuel."
mcset fr winIgnorePopup "Veuillez fermer toute fenêtre qui s'ouvre sans apporter de modifications, afin que $bp puisse terminer l'enregistrement!"
mcset fr winChangingDesktop "$bp essaie maintenant de changer l'arrière-plan de votre bureau"
mcset fr winChangeDesktopProb "Nous avons eu un problème pour changer l'arrière-plan du bureau. \nCliquez avec le bouton droit sur un champ vide de votre bureau et choisissez \"Personnaliser\" > \"Arrière-plan\". Là vous pouvez définisser \n$TwdBMP ou \n$TwdPNG \npour image de fond unique, ou \n$imgdir \npour diaporama "
mcset fr linChangeDesktopProb "Nous avons eu un problème lors de la modification des paramètres du bureau. \nVeuillez cliquer avec le bouton droit sur votre bureau et trouver la boîte de dialogue pour 'Image d'arrière-plan'. Entrez \n$imgdir \ncomme chemin d'accès à l'image."
mcset fr linNoDesktopFound "Aucun bureau Linux trouvé! Recherchez dans le manuel une solution pour configurer manuellement l'image d'arrière-plan $bp."
mcset fr linReloadingDesktop "Nous essayons maintenant de recharger votre espace de travail. Si cela échoue, vous devez vous déconnecter et vous reconnecter brièvement pour que les paramètres de $bp prennent effet."
mcset fr changeDesktopOk "$bp a été configuré sur votre ordinateur et va maintenant être démarré. \n\nVous pouvez démarrer le programme d'installation ${bp} à tout moment en sélectionnant l'icône ${bp} dans le menu de programme (Linux) ou en cliquant avec le bouton droit sur le bureau ou vous sélectionnez l'icône ${bp} (Windows). "
mcset fr winRegister "$bp doit maintenant être enregistré sur votre système. \nVous devez confirmer toute fenêtre de notification avec \"Oui\"!"
mcset fr winRegisterProb "$bp n'est pas encore correctement installé sur votre ordinateur. \nDémarrez l'installation à nouveau ou ajoutez \n$Biblepix \n aux programmes démarrés automatiquement de votre système."

# P H O T O S
mcset fr reposSaved "Image enregistrée avec info."
mcset fr reposNotSaved "Image pas enregistrée."
mcset fr noPhotosFound "Aucune photo n'a été trouvée dans le dossier photos $bp. Veuillez copier quelques images au dossier."
mcset fr rotatePic "Faire pivoter l'image"
mcset fr preview90 "\u21B7 Aperçu rotation 90°"
mcset fr preview180 "\u21BB aperçu rotation 180°"
mcset fr computePreview "\u21B6 \u21B7 Aperçu de rotation libre"
mcset fr rotateWait "Veuillez patienter un moment jusqu'à ce que la rotation de l'image originale soit terminée ..."
mcset fr rotateInfo "Attention : en sauvegardant et en rechargeant une image peut être tournée en plusieurs étapes!"
mcset fr deletePicMsg "Image supprimée de l'album photo $bp :"
mcset fr copiedPicMsg "Nouvelle image copiée dans l'album photo $bp :"
