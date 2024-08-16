# ~/Biblepix/prog/msg/pt.msg
# German texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
##INFO: Textmenge ca. 1900 W. -
## (100 mcset * 3 W. =) -300 W.
## (Comments) -20 (variables ($) -80 = 1500 W.
# Updated: 14aug24 pv

#UNTRANSLATABLES
set bp {BiblePix}
set dw {'A Palavra'}
mcset pt dw $dw
mcset pt bp $bp

mcset pt bpsetup "Configuração de $bp"
mcset pt refresh "Actualizar"
mcset pt delete "Apagar"
#Buttons
mcset pt ok "Ok"
mcset pt cancel "Cancelar"
mcset pt close "Fechar"
mcset pt save "Guardar"
mcset pt saveSettings "Guardar configuração"
mcset pt random "aleatória"
mcset pt uninst "Desinstalar $bp"
mcset pt welcome "Bem-vindo"
mcset pt bibletexts "Textos bíblicos"
mcset pt desktop "Fundo de tela"
mcset pt photos "Fotos"
mcset pt email "Assinatura de email"
mcset pt terminal "Console"
mcset pt manual "Manual"
# W E L C O M E
mcset pt next "Seguinte \u25bc"
mcset pt welcTit "[mc welcome] á [mc bpsetup]!"
mcset pt welcSubtit1 "O que é $bp?"
mcset pt welcTxt1 "$bp é um programa Tcl que é desenvolvido para o projeto 'Bíblia 2.0' cujo objetivo é divulgar $dw em cada vez mais línguas do mundo. \n\n$dw consiste em dois versículos bíblicos selecionados para cada dia do ano. \n\n$bp pode exibir $dw de várias maneiras em seu computador: "
mcset pt welcSubtit2 "Quais são suas opções?"
mcset pt welcTxt2 "\u27a4 [mc bibletexts]: selecione qualquer número de edições ou idiomas da Bíblia para $dw
\u27a4 [mc desktop]: veja $dw nas suas fotos pessoais
\u27a4 [mc photos]: escolha suas próprias imagens de fundo por $bp
\u27a4 [mc email]: adicione $dw aos seus e-mails
\u27a4 [mc manual]: estude o manual completo do $bp
\u27a4 [mc terminal]: olhe $dw em seus consoles Linux
"
# U N I N S T A L L
mcset pt uninstall "Tem certeza de que deseja remover $bp do seu computador?"
mcset pt uninstalling "$bp será desinstalado agora. Para limpar a respectiva configuração do sistema, você deve responder a qualquer janela de notificação com \"Sim\"!"
mcset pt uninstalled "$bp foi desinstalado com segurança do seu sistema. Para reinstalá-lo, visite-nos em [mc www] e baixe o instalador do $bp."
#  M I S S I N G   P A C K A G E
mcset pt packageRequireMissing "$bp requer a extensão Tcl '%s'. \n Instale-a através de seu painel de controle ou digite em um console:\n\n sudo apt install %s (Debian/Ubuntu)"
#SETUP INTERNATIONAL
mcset pt download "Baixar"
mcset pt downloadingHttp "Baixando arquivos de programa de $bp ..."
mcset pt updatedHttp "Atualizando arquivos de programa de $bp ..."
mcset pt uptodateHTTP "Seus arquivos de programa estão a atualiza-se"
mcset pt noConnHTTP "Não há conexão com a Internet para atualizar o programa. Tente novamente mais tarde"
mcset pt GettingTwd "Obtendo a lista atual de textos bíblicos de [mc www] ..."
mcset pt noTwdFilesFound "Não há arquivos de texto bíblico instalados. Selecione pelo menos 1 arquivo de texto da seção '[mc bibletexts]'"
mcset pt connTwd "Conectado a bible2.net"
mcset pt noConnTwd "Não é possível conectar a bible2.net. Tente novamente mais tarde"
mcset pt f1Tit "Lista de textos bíblicos atual para $dw"
mcset pt TwdLocalTit "Arquivos de texto bíblico instalados para $jahr"
mcset pt TwdRemoteTit "Arquivos de texto bíblico para download"
mcset pt language "Idioma"
mcset pt year "Ano"
mcset pt bibleversion "Edições da Bíblia"
mcset pt biblename "Nome abreviado da versão"
mcset pt f1Txt "$bp oferece $dw em todos os idiomas e edições da Bíblia instaladas no seu computador. Se vários arquivos de texto bíblico estiverem instalados, $bp selecionará um aleatoriamente de cada vez. Se você marcar novos arquivos de texto para download (veja abaixo), eles serão instalados assim que você pressionar o botão '[mc download]'. Preste atenção ao ano (atual ou próximo)! "
#SETUP DESKTOP
mcset pt f2Tit "$dw no fundo da tela"
mcset pt f2Box "Gerar imagem de fundo"
mcset pt f2Farbe "Cor da fonte: "
mcset pt f2Slideshow "Ativar apresentação de slides"
mcset pt f2Interval "Cambio de imagem cada "
mcset pt sec "segundos"
mcset pt f2Introline "Mostrar data"
mcset pt f2Fontsize "Tamanho da fonte: "
mcset pt f2Fontweight "negrito"
mcset pt f2Fontfamily "Tipo de letra: "
mcset pt f2Fontexpl "Adaptar fonte"
mcset pt f2Txt "Se ativado, $bp criará uma imagem de fundo com $dw. A foto é selecionada aleatoriamente da coleção de fotos de $bp (consulte a seção Fotos). Uma nova imagem de fundo está sempre disponível em \n\n\t [file nativename $imgdir] \n\npara ser exibido pelo gerenciador de desktop. \n\nSe vários arquivos de texto bíblico forem instalados, o idioma ou versão da Bíblia muda aleatoriamente com cada mudança de imagem. \n\n$bp normalmente organiza um SLIDE SHOW com uma imagem variável. Se desejar apenas uma imagem por dia, a apresentação de slides pode ser desativada (veja acima). \n\nNa janela POSIÇÃO DO TEXTO você pode mover $dw para a posição desejada na tela. Ao adicionar imagens para a coleção, a posição do texto também pode ser determinada individualmente. \n\nO TAMANHO DA FONTE é definido automaticamente de acordo com a altura da tela. No entanto, você tem a opção de ajustar o tamanho e a espessura (letras maiores = melhor contraste). \n\nVocê também pode determinar a COR DA FONTE permanente ou aleatoriamente. Além disso, $bp pode realizar um ajuste de cor com base no brilho do fundo. Este efeito só tem efeito depois que uma nova foto for gravada. \n\nSe a nova imagem de fundo não aparecer automaticamente, você encontrará uma solução no manual."
# P H O T O S
mcset pt textposlabel "Determinar posição do texto"
mcset pt textposAdjust "Deseja alterar a posição do texto nesta imagem antes de gravá-la?"
mcset pt f6Tit "Organizar fotos por $bp"
mcset pt f6Txt "Aqui você pode arrastar quantas fotos quiser da sua pasta de fotos pessoal para a coleção de fotos de $bp. As fotos devem ser tiradas no formato paisagem e ter uma área de cor uniforme para facilitar a leitura do versículo bíblico. \n\n$bp guarda uma cópia da imagem na pasta de fotos de $bp e altera o formato e o tamanho da imagem se ela não corresponder às dimensões da tela. Neste caso, você tem a opção de determinar a seção apropriada da imagem, bem como a posição desejada do texto bíblico. \n\nEm ningum caso a imagem original é alterada. "
mcset pt f6numPhotosTxt "Imagem"
mcset pt f6Add "Adicionar à coleção de fotos de $bp:"
mcset pt f6Show "Ver coleção de fotos de $bp"
mcset pt f6Find "Procurar novas fotos"
mcset pt f6Del "Eliminar da coleção de fotos $bp:"
# R E S I Z I N G
mcset pt resizeF_txt "Sua foto não corresponde ao tamanho da tela e precisa ser cortada. [mc movePicToResize]"
mcset pt movePicToResize "Mova a seção da imagem como desejar e confirme com OK para gravar"
mcset pt resizingPic "Ajustando o tamanho da imagem à tela \u2014 aguarde um momento ..."
mcset pt movePic "Mover seção de imagem \u21CA"
mcset pt picSchonDa "A foto já está na pasta de imagens de $bp"
# S I G N A T U R E
mcset pt f3Tit "$dw nas suas assinaturas de e-mail"
mcset pt f3Btn "Gerar assinatura de e-mail"
mcset pt f3Sprachen "Idiomas desejados para as minhas assinaturas"
mcset pt f3Txt "Se ativado, $bp adicionará $dw às suas assinaturas de e-mail uma vez por dia para cada arquivo de texto bíblico instalado. Os arquivos de assinatura criados são classificados de acordo com as abreviações de idioma (por exemplo, signature-pt_Portug.txt) na siguenta pasta: \n\n\t $sigdir \n\nVocê pode editar esses arquivos de seu programa de e-mail ou em um editor de texto e adicionar saudações pessoais, endereços, etc. O texto acima da linha que divide ==== não é afetado quando alterna $dw.\n\nTalvez você pode não quera que seus destinatários de e-mail leiam $dw em todos os idiomas que você instalou. Selecione os idiomas desejados no canto superior direito. \n\nPara que $dw apareça nos seus e-mails no futuro, você deve ensinar seu programa de e-mail a usar os arquivos descritos acima (geralmente em Configuração>Assinaturas). Se em vez duma lingua, você escolhe o arquivo
\n\t signature-SURPRISE.txt
\n$dw rotará por acaso.\n\nAlguns programas como Seamonkey Mail, Evolution ou Trojitá gerenciam sinhaturas internamente. Entre eles, $bp pode levar em conta Trojitá e Evolution por enquanto."
# T E R M I N A L
mcset pt f4Tit "$dw nos seus consoles Linux"
mcset pt f4Btn "Gerar $dw para exibir no console"
mcset pt f4Txt "Se ativado, $bp gerará $dw para exibir nos seus consoles. Se vários arquivos de texto bíblico estiverem instalados, o texto muda toda vez que um console é aberto. \n\nO layout e as cores podem ser ajustados editando \n\n\t $confdir/term.conf \n\nPara renderizar em escrita hebraica ou árabe apenas terminais como 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' ou 'Konsole' (KDE) que podem exibir texto bidirecional corretamente podem ser levados em consideração. \n\nPara garantir que $dw apareça automaticamente no console, a configuração de $bp cria uma entrada em\n\n\t ~/.bashrc"

# S E T U P S A V E
#Changing Desktops Info
mcset pt linChangingDesktop "$bp irá agora tentar alterar as configurações do seu desktop. Se você não vir uma nova imagem de fundo depois, encontrará uma solução no manual."
mcset pt winIgnorePopup "Por favor, feche qualquer pop-up sem fazer nenhuma alteração para que $bp possa completar o registro!"
mcset pt winChangingDesktop "$bp agora tentará mudar o plano de fundo do seu desktop."
mcset pt winChangeDesktopProb "Ocorreu um problema ao alterar o plano de fundo o desktop. \nClique com o botão direito em um campo vazio da área de trabalho e procure a opção \"Personalizar\". Para a opção \"Plano de fundo\", especifique \n\t $TwdBMP ou \n\t $TwdPNG \npor uma imagem de fundo única, ou para slides: \n\t $imgdir "
mcset pt linChangeDesktopProb "Tivemos um problema ao alterar as configurações do desktop. Clique com o botão direito na área de trabalho e encontre a caixa de diálogo 'Imagem de fundo' e especifique '$imgdir' como o caminho da imagem."
mcset pt linNoDesktopFound "Nenhum desktop Linux foi encontrado! Procure no manual uma solução para definir a imagem de fundo $bp manualmente."
mcset pt linReloadingDesktop "Agora tentaremos recarregar sua área de trabalho. Se isso falhar, você deve fazer logout e login novamente para que a configuração $bp tenha efeito."
mcset pt changeDesktopOk "$bp está configurado no seu computador e irá iniciar agora. \n\nVocê pode iniciar o programa de configuração a qualquer momento selecionando o símbolo $bp no menu do programa (Linux) ou selecionando o ícone $bp no seu desktop com o botão direito (Windows)."
mcset pt winRegister "$bp agora deve ser registrado em seu sistema. Confirme qualquer janela de notificação com \"Sim\"!"
mcset pt winRegisterProb "$bp ainda não está instalado corretamente no seu computador. Reinicie a instalação ou adicione \n\t $Biblepix \n ao Autostart (Programas iniciados automaticamente)"
# P H O T O S
mcset pt reposSaved "Imagem gravada com informações"
mcset pt reposNotSaved "Imagem não gravada"
mcset pt noPhotosFound "Não se encontram fotos na pasta de fotos de $bp. Copie algumas imagens à pasta"
mcset pt rotatePic "Girar imagem"
mcset pt preview90 "\u21B7 prevista rotação 90°"
mcset pt preview180 "\u21BB Prevista rotação 180°"
mcset pt computePreview "\u21B6 \u21B7 Prevista qualquer rotação"
mcset pt rotateWait "Por favor, seja paciente até que a rotação da imagem original seja concluída ..."
mcset pt rotateInfo "Atenção: gravando e recarregando uma imagem, issa pode ser girada em várias etapas!"
mcset pt deletedPicMsg "Imagem limpada do álbum de fotos $bp:"
mcset pt copiedPicMsg "Nova imagem copiada à álbum de fotos $bp:"
