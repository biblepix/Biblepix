# Chinese texts for msgcat
# ~/Biblepix/prog/msg/zh.msg
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
##INFO: Textmenge ca. 1900 W. -
## (100 mcset * 3 W. =) -300 W.
## (Comments) -20 (variables ($) -80 = 1500 W.
# Updated: 14nov21 pv

############################################################################################################
## T R A N S L A T O R S : O N L Y   T R A N S L A T E   P H R A S E S   W I T H I N  Q U O T E S   "......"
## e.g.:  of  
##    'mcset yourlanguage code "PHRASE" '    - only replace quoted text in "PHRASE"
############################################################################################################

################################################################################
## U  N  T  R  A  N  S  L  A  T  A  B  L  E  S
## P L E A S E   D O N 'T  T O U C H : 
## - ANY PHRASE STARTING WITH #
## - ANY WORD STARTING WITH $
## - ANY PHRASE WITHIN SQUARE BRACKETS [...]
## - ANY FORMATTING MARKERS LIKE \n \n\n \t \u... etc.
## - ANY PHRASE STARTING WITH 'set'
## - ANY WORD STARTING WITH %
################################################################################

set bp "圣经图文"
set dw "金句"
mcset zh dw 金句
mcset zh bp $bp

# G E N E R A L 一般
mcset zh ok "确认"
mcset zh cancel "取消"
mcset zh close "关闭"
mcset zh delete "删除"
mcset zh save "保存"
mcset zh saveSettings "保存设置"
mcset zh random "随机"
mcset zh welcome "欢迎"
mcset zh bibletexts "圣经文本"
mcset zh desktop "桌面背景"
mcset zh photos "照片"
mcset zh email "电子邮件签名"
mcset zh terminal "终端"
mcset zh manual "手册"
mcset zh uninst "卸载$bp"
mcset zh next "下一个 \u25bc"
mcset zh packageRequireMissing "$bp 需要 Tcl 扩展'%s'.\n请通过系统管理安装或在终端中键入以下命令之一(以root或sudo): [mc packageRequire]"

# U N I N S T A L L卸载
mcset zh uninstall "您真的想从您的电脑中删除$bp吗?"
mcset zh uninstalling "$bp现在将被卸载。要清除所做的系统设置，您必须用\"是\"来确认所有将要出现的对话框."
mcset zh uninstalled "$bp已经从您的系统中安全删除.要想重新安装,请访问我们的网站 [mc www] 并下载$bp安装程序." 

#### S E T U P   G U I 设置 ################################
mcset zh download "下载"
mcset zh downloadingHttp "下载$bp程序文件..."
mcset zh updatingHttp "更新$bp程序文件..."
mcset zh uptodateHTTP "您的程序文件是目前最新的."
mcset zh noConnHTTP "程序更新没有网络连接，请您稍后再试."
mcset zh gettingTwd "从bible2.net获取当前的圣经文本文件列表..."
mcset zh noTwdFilesFound "没有安装当前的圣经文本文件.\n在$bp设置中,从'[mc bibletexts]'部分至少选择一种语言文本文件."
mcset zh connTwd "已经建立与bible2.net的连接."
mcset zh noConnTwd "没有连接到bible2.net. 请稍后再试."
mcset zh bpsetup "$bp设置"
mcset zh refresh "更新"
mcset zh textposlabel "设置一般文本位置"
mcset zh textposAdjust "保存前要调整此张图片的文本位置吗?"
mcset zh welcTit "欢迎使用$bp安装程序!"
mcset zh welcSubtit1 "什么是$bp?"
mcset zh welcTxt1 "$bp是为'Bible 2.0'项目开发的Tcl程序.该项目旨在\n以越来越多的语言发布金句.\n\n金句由全年每天两节精选的圣经经文组成.\n\n$bp可以在您的计算机上以各种方式显示金句."
mcset zh welcSubtit2 "您有哪些选择?"
mcset zh welcTxt2 "\u27a4 [mc bibletexts]: 为金句选择一种或多种圣经文本语言.
\u27a4 [mc desktop]: 在您的个人背景图片上获取金句,包括幻灯放映. 
\u27a4 [mc photos]: 整理您的照片以供$bp使用
\u27a4 [mc email]: 将金句添加到您的电子邮件签名中
\u27a4 [mc terminal]: 在Linux终端显示金句 
\u27a4 [mc manual]: 学习$bp程序的完整指南
"
mcset zh f1Tit "当前金句圣经文本列表"
mcset zh TwdLocalTit "为$jahr安装的圣经文本文件"
mcset zh TwdRemoteTit "供下载的圣经文本文件"
mcset zh language "语言"
mcset zh year "年"
mcset zh bibleversion "圣经版本"
mcset zh biblename "圣经名称"
mcset zh f1Txt "$bp将用计算机上安装的任何语言或圣经版本创建金句.如果找到多个语言文件,$bp将在每次运行时随机选择一个.您选择的任何新语言文件(见下文),点击'[mc download]'后即可下载.请注意年份(当前或明年)!"
mcset zh f2Tit "将金句放在您的背景图片上"
mcset zh f2Box "创建背景图像"
mcset zh f2Farbe "字体颜色: "
mcset zh f2Slideshow "激活幻灯"
mcset zh f2Interval "幻灯片间隔 "
mcset zh sec "秒"
mcset zh f2Introline "显示日期"
mcset zh f2Fontsize "字体大小: "
mcset zh f2Fontweight "粗体"
mcset zh f2Fontfamily "字体系列: "
mcset zh f2Fontexpl "调整字体"
mcset zh f2Txt "\n如果激活,$bp每次运行都会将金句放在背景图片.图片将从$bp照片集中随机选择(参阅照片部分),并将新的背景图像放入\n\n\t [file nativename $imgdir] \n\n以供桌面管理器显示.\n\n如果安装了多个圣经文本文件,语言(或圣经版本) 将随图片随机交替.\n\n$bp将在给定的时间间隔内设置交替图片的幻灯片.请取消一天一张图片的设置功能(见上文).\n\n文本位置窗口允许您将金句放在屏幕上任何您喜欢的位置.此外,在将照片添加到$bp照片集时,您可以单独定位文本.\n\n字体大小是根据屏幕高度自动设置的.但是,您可以根据需要更改字体大小和粗细(更大的字体=更好的对比度).\n\n字½的颜色可能是偶然的,也可能是您设置的.请注意,$bp可能会根据背景亮度调整颜色亮度.这仅在将照片添加到$bp后才生效.\n\n如果新的背景图片无法显示,请参阅手册寻求解决方案."
# S E T U P   P H O T O S 照设置片
mcset zh f6Tit "为$bp管理您的照片"
mcset zh f6Txt "在这里您可以从您的图片目录中添加合适的照片并将其放入$bp照片集,或从那里将其删除.理想情况下,照片最好是横向格式并具单一色彩表面,以便获得圣经文本的良好可见度.\n\n如果照片尺寸与屏幕不符,$bp将使其调整到适合尺寸并将其保存到$bp照片目录.如果需要修改,将要求您选择照片的所需部分以及未来圣经文本的位置.\n\n无论如何,原始照片保持不变."
mcset zh f6numPhotosTxt "图片数目"
mcset zh f6Add "添加到$bp照片集:"
mcset zh f6Show "显示$bp照片集"
mcset zh f6Find "寻找新照片"
mcset zh f6Del "从$bp照片及删除:"
mcset zh deletedPicMsg "从$bp照片集中删除的图片:"
mcset zh copiedPicMsg "将图片复制到照片集:"
mcset zh reposSaved "图片与信息一并保存."
mcset zh reposNotSaved "图片未保存."
mcset zh noPhotosFound "在$bp照片文件夹中未找到照片.请复制一些照片到文件夹."
#RESIZING & ROTATING 调整大小和旋转
mcset zh rotatePic "旋转图片"
mcset zh preview90 "\u21B7 预览90°旋转"
mcset zh preview180 "\u21BB 预览180°旋转"
mcset zh computePreview "\u21B6 \u21B7 预览任何旋转"
mcset zh rotateWait "旋转原图请耐心等待..."
mcset zh rotateInfo "提示:通过保存和重新加载，图片可以分几步旋转!"
mcset zh resizeF_txt "您的照片尺寸与屏幕尺寸不符.必须进行修剪. [mc movePicToResize]"
mcset zh movePicToResize "将图像部分移动到所需位置,然后通过按确定来更改大小."
mcset zh resizingPic "调整照片大小以适应屏幕.请稍等..."
mcset zh movePic "移动图片部分\u21CA"
mcset zh picSchonDa "照片已在$bp照片文件夹中"
# S E T U P   S I G N A T U R E  设置签名	
mcset zh f3Tit "在您的电子邮件签名中添加金句"
mcset zh f3Btn "创建电子邮件签名"
mcset zh f3Sprachen "我的签名所需的语言"
mcset zh f3Txt "如果激活,$bp将每天一次在您的电子邮件签名末尾为您计算机上的任何语言文本文件添加金句.签名文件通过语言快捷方式储存(例如 signature-zh-Hans_C.txt)在目录\n\n\t$sigdir \n\n您可以通过电子邮件程序或文本编辑这些文件,并在顶部添加个人信息(问候语,地址等.) 当文本“金句”更改时,分隔线 ==== 上方的任何文本都将保持不变.\n\n您可能不希望金句出现在您安装的所有语言的邮件中.在右上角的复选框中,请选择您认为适合邮件收件人的语言.\n\n最后,您必须指示您的电子邮件程序使用这些签名文件(通常在选 > 签名下).
如果您选择这个文件
\n\tsignature-SURPRISE.txt
\n“金句”会随机旋转。
\n\n某些程序,如 Seamonkey Mail、Evolution 或 Trojitá 在内部管理签名.其中$bp现在可以处理 Trojitá 和 Evolution."
mcset zh f4Tit  "在您的Linux终端中显示金句"
mcset zh f4Btn "创建金句以在终端中显示"
mcset zh f4Txt "如果激活,$bp将创建金句显示在您的终端顶部. 如果存在多个语言文件,每当打开新外壳时圣经文本将随机更变. \n\n显示颜色等可能在\n\n\t $confdir/term.conf中更改\n\n请注意,为了正确显示阿拉伯语或希伯来语脚本,您将需要以下内容之一: 'QTerminal', 'mlterm', 'gnome-terminal', 'Konsole' (KDE) 或 'xfce4-terminal'; 已知这些可以处理双向文本.\n\n为了在终端自动显示金句,$bp Setup在~/.bashrc中为您提供了一个条目."
# S A V E 保存
mcset zh linChangingDesktop "$bp现在将尝试使用您的桌面背景进行注册.如果之后看不到新的背景图片,请您参阅手册以获取解决方案."
mcset zh winIgnorePopup "请关闭(关闭)所有弹出窗口,以便$bp可以完成注册!"
mcset zh winChangingDesktop "$bp现在将尝试使用您的桌面背景进行注册"
mcset zh winChangeDesktopProb "我们在更改您的桌面背景遇到了问题.\nP请用右键点击您桌面上的空白区域并选择\"个性化\".\n在 \"壁纸\"要么设置为单个图片路径 $TwdBMP 或 \n$TwdPNG \ 要么设置幻灯片，将目录设置为 \n$imgdir."
mcset zh linChangeDesktopProb "我们在更¹您的桌面设置遇到了问题.\n请用右键点击您桌面并找到'背景图像'对话框. 将$imgdir作为新的图像路径."
mcset zh linNoDesktopFound "没有找到Llinux桌面!请参阅手册以了解如何手动设置$bp背景图."
mcset zh linReloadingDesktop "我们现在将尝试重新加载您的桌面.如果失败,请注销并重新登陆以使$bp设置生效."

mcset zh changeDesktopOk "$bp已成功配置，将很快启动.\n\n您可以随时运行$bp安装程序,方法是在程序菜单(Linux)中选择 \"$bp Setup\" 图标或右键单击您的桌面(窗口)."
mcset zh winRegister "$bp将不会尝试在您的系统中注册.\n您必须用\"是\"确认所有对话框."
mcset zh winRegisterProb "$bp未在您的计算机上正确注册.\n请尝试重新运行安装程序,或将\n$$bp\n添加到您的自动文件夹中."
