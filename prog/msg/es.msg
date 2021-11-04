# ~/Biblepix/prog/msg/es.msg
# Spanish texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
#INFO: Textmenge - 100 mcset * 3 W. = 300 W.
# Updated: 4nov21 pv

# U N T R A N S L A T A B L E S
set bp {BiblePix}
set dw {'La Palabra'}
mcset es dw $dw
mcset es bp $bp

mcset es bpsetup "Configuración de $bp"
mcset es refresh "Actualizar"
mcset es delete "Borrar"
#Buttons
mcset es ok "Ok"
mcset es cancel "Abortar"
mcset es close "Cerrar"
mcset es save "Guardar"
mcset es saveSettings "Guardar configuración"
mcset es random "aleatorio"
mcset es uninst "Desinstalar $bp"
mcset es welcome "Bienvenido"
mcset es bibletexts "Textos bíblicos"
mcset es desktop "Fondo de pantalla"
mcset es photos "Fotos"
mcset es email "Firma de correo electrónico"
mcset es terminal "Consola"
mcset es manual "Manual"

# W E L C O M E 
mcset es next "Siguiente \u25bc"
mcset es welcTit "¡Bienvenido a la [mc bpsetup]!"
mcset es welcSubtit1 "¿Qué es $bp?"
mcset es welcTxt1 "$bp es un programa Tcl que es desarrollado para el proyecto 'Biblia 2.0' \n\n'Biblia 2.0' tiene como objetivo difundir $dw en un número creciente de idiomas. \n $dw consta de 2 versículos bíblicos seleccionados para cada día del año. \n\n$bp puede visualizar $dw de muchas formas en tu ordenardor:"
mcset es welcSubtit2 "¿Cuáles son tus opciones?"
mcset es welcTxt2 "\u27a4 [mc bibletexts]: selecciona cualquier número de ediciones o idiomas de la Biblia para $dw
\u27a4 [mc desktop]: mira $dw en tus fotos personales
\u27a4 [mc photos]: elige tus propias imágenes de fondo para $bp
\u27a4 [mc email]: agrega $dw a tus correos electrónicos
\u27a4 [mc manual]: estudia el manual completo de $bp
\u27a4 [mc terminal]: mira $dw en tus consolas Linux
"
# U N I N S T A L L
mcset es uninstall "¿Estás seguro de que deseas eliminar $bp de tu ordenador?"
mcset es uninstalling "$bp ahora se desinstalará. Para borrar la configuración respectiva del sistema, debes responder a cualquier ventana de notificación con \"Sí\"!"
mcset es uninstalled "$bp ha sido desinstalado de forma segura de tu sistema. Para volver a instalarlo, visítanos en [mc www] y descarga el instalador de $bp."
#  M I S S I N G   P A C K A G E
mcset es packageRequireMissing "$bp requiere la extensión Tcl '%s'. \nInstálala a través de tu panel de control o escribe uno de los siguientes comandos en una consola (como root o sudo): [mc packageRequire]"
#SETUP INTERNATIONAL
mcset es download "Descargar"
mcset es downloadingHttp "Descargando archivos de programa de $bp ..."
mcset es updatedHttp "Actualizando archivos de programa de $bp ..."
mcset es uptodateHTTP "Tus archivos de programa están actualizados"
mcset es noConnHTTP "No hay conexión a Internet para actualizar el programa. Inténtalo más tarde"
mcset es GettingTwd "Obteniendo la lista actual de textos bíblicos de [mc www] ..."
mcset es noTwdFilesFound "No hay archivos de texto bíblicos actuales instalados. Por favor, selecciona al menos 1 archivo de texto de la sección '[mc bibletexts]'"
mcset es connTwd "Conectado a bible2.net"
mcset es noConnTwd "No se puede conectar a bible2.net. Inténtalo más tarde"
mcset es f1Tit "Lista de textos bíblicos actual para $dw"
mcset es TwdLocalTit "Archivos de textos bíblicos instalados para $jahr"
mcset es TwdRemoteTit "Archivos de textos bíblicos para descargar"
mcset es language "Idioma"
mcset es year "Año"
mcset es bibleversion "Ediciones de la Biblia"
mcset es biblename "Nombre corto de la versión"
mcset es f1Txt "$bp ofrece $dw en todas las lenguas y ediciones de la Biblia instaladas en tu ordenardor. Si están instaladas varios archivos de textos bíblicos, $bp seleccionará cada vez uno al azar. Si marcas nuevos archivos de texto para descargar (ver más abajo), esos serán instalados en cuanto presiones el botón '[mc download]'. Presta atención al año (corriente o próximo)!"
#SETUP DESKTOP
mcset es f2Tit "$dw en el fondo de escritorio"
mcset es f2Box "Generar imagen de fondo"
mcset es f2Farbe "Color de fuente: "
mcset es f2Slideshow "Activar presentaci³n de diapositivas"
mcset es f2Interval "Cambio de imagen cada "
mcset es sec "segundos"
mcset es f2Introline "Mostrar fecha"
mcset es f2Fontsize "Tamaño de fuente: "
mcset es f2Fontweight "en negrilla"
mcset es f2Fontfamily "Fuente: "
mcset es f2Fontexpl "Adaptar fuente"
mcset es f2Txt "Si está activado, $bp creará una imagen de fondo con $dw. La foto se selecciona al azar de la colección de fotos de $bp (ver la sección Fotos). Siempre hay una nueva imagen de fondo disponible en \n\n\t [file nativename $imgdir] \n\npara que la muestre el administrador de escritorio. \n\nSi están instalados varios archivos de textos bíblicos, el idioma o la versión de la Biblia cambia al azar con cada cambio de imagen. \n\n$bp organiza normalmente una PRESENTACION DE DIAPOSITIVAS con una imagen cambiante. Si se desea solo una imagen por día, la presentación de diapositivas se puede desactivar (ver arriba). \n\nEn la ventana POSICIÓN DE TEXTO puedes mover $dw a la posición deseada en la pantalla. Al agregar imágenes a la colección, la posición del texto también se puede determinar individualmente. \n\nEl TAMAÑO DE LA FUENTE se establece automáticamente según la altura de la pantalla. Sin embargo, tú tienes la opción de ajustar el tamaño y el grosor (letras más grandes = mejor contraste). \n\n Puedes también determinar el COLOR DE LA FUENTE de forma permanente o aleatoria. Además $bp puede realizar un ajuste de color basado en el brillo del fondo. Este efecto solo tiene efecto después de que se haya guardado una foto nueva. \n\nSi la nueva imagen de fondo no aparece automáticamente, encontrarás una solución en el manual."
# S E T U P   P H O T O S 
mcset es textposlabel "Determinar la posición del texto"
mcset es textposAdjust "¿Deseas cambiar la posición del texto de esta imagen antes de guardarla?"
mcset es f6Tit "Organizar fotos para $bp"
mcset es f6Txt "Aquí puedes arrastrar tantas fotos como desees de su carpeta de fotos personal a la colección de fotos de $bp. Las fotos deben ser tomadas en formato apaisado y tener un área de color uniforme para facilitar la lectura del versículo bíblico. \n\n$bp guarda una copia de la imagen en la carpeta de fotos de $bp y cambia el formato y el tamaño de la imagen si no coincide con las dimensiones de la pantalla. En este caso, tú tienes la opción de determinar la sección de imagen adecuada, así como la posición deseada del texto bíblico. \n\nDe toda manera, la imagen original permanece sin cambios."
mcset es f6numPhotosTxt "Número de imágenes: "
mcset es f6Add "Añadir a la colección de fotos de $bp:"
mcset es f6Show "Ver colección de fotos de $bp"
mcset es f6Find "Buscar nuevas fotos"
mcset es f6Del "Borrar de la colección de fotos de $bp:"
#RESIZING
mcset es resizeF_txt "Tu foto no coincide con el tamaño de la pantalla y debe recortarse. [mc movePicToResize]"
mcset es movePicToResize "Mueve la sección de la imagen como desees y confirma con OK para guardar"
mcset es resizingPic "Ajustando el tamaño de la imagen a la pantalla \u2014 por favor ten paciencia por un momento ..."
mcset es movePic "Mover sección de imagen \u21CA"
mcset es picSchonDa "La foto ya está en la carpeta de imágenes de $bp"

# S E T U P   S I G N A T U R E
mcset es f3Tit "$dw en tus firmas de correo electrónico"
mcset es f3Btn "Generar firma de correo electrónico"
mcset es f3Sprachen "Idiomas deseados para mis firmas"
mcset es f3Txt "Si está activado, $bp agregará $dw a tus firmas de e-mail una vez al día para cada archivo de texto bíblico instalado. Los archivos de firmas creados se ordenan según las abreviaturas del idioma (por ejemplo, firma-es_ReinaV.txt) en la siguiente carpeta : \n\n\t $sigdir \n\nPuedes editar estos archivos desde tu programa de correo electrónico o en un editor de texto y agregar saludos personales, direcciones, etc. El texto sobre la línea divisoria ==== no se ve afectado al cambiar de $dw. \n\nTal vez no desees que los destinatarios de tu correo lean $dw en todos los idiomas que has instalado. Selecciona los idiomas que desees en la esquina superior derecha. \n\nPara que $dw aparezca en tus correos en el futuro, debes enseñarle a tu programa de correo a usar los archivos descritos anteriormente (generalmente en Configuración>Signaturas). Si en lugar de una lengua, seleccionas el fichero 
\n\t signature-SURPRISE.txt
\n$dw rotará por casualidad. \n\nCiertos programas como Seamonkey Mail, Evolution o Trojitá administran las firmas internamente. Entre ellos $bp puede tomar en cuenta a Trojitá y Evolution por el momento."
#SETUP TERMINAL
mcset es f4Tit "$dw en tus consolas de Linux"
mcset es f4Btn "Generar $dw para mostrar en la consola"
mcset es f4Txt "Si está activado, $bp generará $dw para mostrar en tus consolas. Si están instalados varios archivos de textos bíblicos, el texto cambia cada vez que se abre una consola. \n\nEl diseño y los colores pueden ser ajustados a gusto en \n\n\t $confdir/term.conf \n\nPara la representación en escritura hebrea o árabe solo terminales como 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' o 'Konsole' (KDE) que pueden visualizar texto bidireccional correctamente, pueden ser tomados en cuenta. \n\nPara garantizar que $dw aparezca automáticamente en la consola, el $bp Setup hace una entrada en ~/.bash_profile."

# S E T U P S A V E   T E X T S
#Changing Desktops Info
if {$os=="Linux"} {
  mcset en changeDesktopOk "$bp está configurado en tu ordenardor y ahora se iniciará. \n\nPuedes iniciar el programa de configuración en cualquier momento seleccionando el símbolo $bp en el menú del programa."
} else {
  mcset en changeDesktopOk "$bp está configurado en tu ordenardor y ahora se iniciará. \n\nPuedes iniciar el programa de configuración en cualquier momento seleccionando sobre tu escritorio el icono $bp con clic derecho."
}
mcset es linChangingDesktop "$bp ahora intentará cambiar la configuración de tu escritorio. Si no ves una nueva imagen de fondo después, encontrarás una solución en el manual."
mcset es winIgnorePopup "¡Por favor, cierra cualquier ventana emergente sin hacer ningún cambio para que $bp pueda completar el registro!"
mcset es winChangingDesktop "$bp ahora intentará cambiar el fondo de tu escritorio."
mcset es winChangeDesktopProb "Tuvimos un problema al cambiar el fondo del escritorio. \nHaz clic derecho en un campo vacío de tu escritorio y busca la opción \"Personalizar\". Para la opción \"Fondo\" especifica \n\t$TwdBMP o \n\t$TwdPNG \ncomo imagen de fondo única, o para diapositivas: \n\t$imgdir"
mcset es linChangeDesktopProb "Tuvimos un problema al cambiar la configuración del escritorio. Haz clic derecho en tu escritorio y busca el cuadro de diálogo 'Imagen de fondo' y especifica $imgdir como ruta de la imagen."
mcset es linNoDesktopFound "¡No se ha encontrado ningún escritorio Linux! Busca en el manual una solución para configurar la imagen de fondo de $bp manualmente."
mcset es linReloadingDesktop "Ahora intentaremos recargar tu espacio de trabajo. Si esto falla, debes cerrar la sesión y volver a iniciarla para que la configuración de $bp tenga efecto."
mcset es winRegister "$bp ahora debe estar registrado en tu sistema. Confirma cualquier ventana de notificación con \"Sí\"!"
mcset es winRegisterProb "$bp aún no está instalado correctamente en tu ordenador. Vuelve a iniciar la instalación o agrega \n\t$Biblepix \na \"Programas iniciados automáticamente\""
#PHOTOS
mcset es reposSaved "Imagen guardada con información"
mcset es reposNotSaved "Imagen no guardada"
mcset es noPhotosFound "No hemos encontrado fotos en la carpeta de fotos $bp. Copia algunas imágenes a la carpeta"
mcset es rotatePic "Girar imagen"
mcset es preview90 "\u21B7 Vista previa de rotación de 90°"
mcset es preview180 "\u21BB Vista previa de rotación de 180°"
mcset es computePreview "\u21B6 \u21B7 Vista previa de cualquier rotación"
mcset es rotateWait "Por favor, ten paciencia hasta que se complete la rotación de la imagen original..."
mcset es rotateInfo "Atención: guardando y recargando una imagen se puede rotar en varios pasos!"
mcset es deletedPicMsg "Imagen borrada del álbum de fotos de $bp:"
mcset es copiedPicMsg "Nueva imagen copiada al álbum de fotos de $bp:"
