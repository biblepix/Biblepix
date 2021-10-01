# ~/Biblepix/prog/msg/ar.msg
# Arabic texts in msgcat format
# sourced by SetupMainFrame
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 29sep21 pv

#Provide rearranging Ar/He letters if Linux
if {$os == "XXLinux"} {
  source $Bidi
  proc fix {input} {
    return [bidi::fixBidi $input]
  }
} else {
  proc fix {input} {
    return $input
  }
}

# U N T R A N S L A T A B L E S
set dw {'الكلمة'}
mcset ar dw $dw
mcset ar bp BiblePix

# G E N E R A L
mcset ar bpsetup [fix "BiblePix قم بإعداد موقع"]
mcset ar refresh [fix "تحديث"]
mcset ar delete [fix "حذف ملف"]
mcset ar ok [fix "موافق"] 
mcset ar cancel [fix "إلغاء"]
mcset ar close [fix "إغلاق"]
mcset ar save [fix "حفظ"]
mcset ar saveSettings [fix "حفظ الاعدادات"]
mcset ar random [fix "عشوائى"]
mcset ar uninst [fix "BiblePix إلغاء التثبيت"]
mcset ar welcome [fix "أهلا وسهلا"]
mcset ar bibletexts [fix "نصوص الكتاب المقدس"]
mcset ar desktop [fix "خلفية شاشة"]
mcset ar photos [fix "صور"]
mcset ar email [fix "توقيع البريد الإلكتروني"]
mcset ar terminal [fix "Linux محطة"]
mcset ar manual [fix "دليل الاعداد"]

set s {Tcl '%s'.}
mcset ar packageRequireMissing "
يتطلب BiblePix امتداد $s  
يرجى تثبيته عبر لوحة التحكم الخاصة بك أو كتابة أحد الأوامر التالية في وحدة التحكم (as root oder sudo): [mc packageRequire]
"
# W E L C O M E 
mcset ar next [fix "Nächstes \u25bc"]
mcset ar welcTit [fix "مرحبًا بك في برنامج إعداد BiblePix !"]
mcset ar welcSubtit1 [fix "ما هو برنامج BiblePix ؟"]
mcset ar welcTxt1 [fix "BiblePix هو برنامج Tcl تم تطويره لمشروع الكتاب المقدس 2.0 ، والذي يهدف إلى نشر الكلمة في عدد متزايد من اللغات.
 الكلمة يتكون من آيتين مختارين من الكتاب المقدس لكل يوم من أيام السنة.
يمكن أن يعرض موقع BiblePix الكلمة بعدة طرق على جهاز الكمبيوتر الشخصي الخاص بك : "
]
mcset ar welcSubtit2 [fix "ما هي خياراتك؟"]
mcset ar welcTxt2 [fix "[mc bibletexts] : اختر المفضل لديك من إصدارات ولغات الكتاب المقدس $dw \u27a4 \n [mc desktop]: شاهد $dw مع صورك الشخصية \u27a4 \n [mc photos]:  اختر صور الخلفية الخاصة بك لـ BiblePix \u27a4 \n [mc email]:  أضف $dw إلى رسائلك الإلكترونية \u27a4 \n [mc manual]: ادرس دليل BiblePix الكامل \u27a4 \n [mc terminal]: انظر إلى $dw في وحدات تحكم Linux الخاصة بك"
]

# U N I N S T A L L
mcset ar uninstall [fix "هل تريد حقاًإزالة BiblePix من جهاز الكمبيوتر الخاص بك؟"]
#mcset ar uninstalling {سيتم الآن إلغاء تثبيت BiblePix. لحذف إعدادات النظام ، يجب الرد على أي نافذة إشعار بـ نعم} ‬
mcset ar uninstalled [fix "تمت إزالة BiblePix بأمان من نظامك. لإعادة تثبيته ، قم بزيارتنا على [mc www] وقم بتنزيل مثبت BiblePix."]

# I N T E R N A T I O N A L

mcset ar download [fix "تحميل"]
mcset ar downloadingHttp [fix "تحميل ملفات برنامج BiblePix ..."]
mcset ar downloadingAsianFont [fix "تحميل ملفات الخطوط الآسيوية ..."]
mcset ar downloadComplete [fix "إنتهاء التحميل."]
mcset ar updatingHttp [fix "تحديث ملفات برنامج BiblePix ..."]
mcset ar uptodateHTTP [fix "ملفات برنامجك على أخر تحديث‫.‬"]
mcset ar noConnHTTP [fix "لا يوجد اتصال بالإنترنت لتحديث البرنامج ، يرجى المحاولة لاحقًا."]
mcset ar gettingTwd [fix "احصل على قائمة نص الكتاب المقدس الحديثة من bible2.net ..."]
mcset ar noTwdFilesFound [fix "لم يتم تثبيت أي ملفات نصية للكتاب المقدس حاليًا.  الرجاء تحديد  ملف لغة واحد على الأقل من قسم [mc bibletexts] ي إعداد BiblePix."]
mcset ar connTwd [fix "تم إنشاء الاتصال بـ bible2.net."]
mcset ar noConnTwd [fix "لا يوجد اتصال بـ bible2.net. من فضلك حاول في وقت لاحق."]
mcset ar f1Tit [fix "قائمة نصوص الكتاب المقدس الحالية لـ $dw"]
mcset ar TwdLocalTit [fix "تم تثبيت ملفات نصية للكتاب المقدس لمدة $jahr"]
mcset ar TwdRemoteTit [fix "ملفات نصية من الكتاب المقدس للتحميل"]
mcset ar language [fix "اللغة"]
mcset ar year [fix "العام"]
mcset ar bibleversion [fix "طبعة الكتاب المقدس"]
mcset ar biblename [fix "اسم الكتاب المقدس"]

#set f1Txt "يوفر موقع BiblePix $dw بجميع اللغات وإصدارات الكتاب المقدس المثبتة على جهاز الكمبيوتر الخاص بك. تم تثبيت عدة ملفات نصية للكتاب المقدس ، سيختار BiblePix واحدًا عشوائيًا. إذا حددت ملفات نصية جديدة للكتاب المقدس لتنزيلها (انظر أدناه) ، فسيتم تنزيلها بمجرد الضغط على الزر [mc download]. نتبه إلى تاريخ العام (الحالي أو العام المقبل)!‫
#"
#mcset ar f1Txt "[fix $f1Txt]"

# D E S K T O P
mcset ar f2Tit [fix "الكلمة على خلفية صورة سطح المكتب"]
mcset ar f2Box [fix "توليد صورة الخلفية"]
mcset ar f2Fontcolor [fix "لون الخط: "]
mcset ar f2Slideshow [fix "تنشيط عرض الشرائح"]
mcset ar f2Interval [fix "تغيير كل الصور "]
mcset ar sec [fix "ثوانى"]
mcset ar f2Introline [fix "عرض التاريخ"]
mcset ar f2Fontsize [fix "حجم الخط‫:‬ "]
mcset ar f2Fontweight [fix "سميك"]
mcset ar f2Fontfamily [fix " نوع الخط‫:‬ "]
mcset ar f2Fontexpl [fix "ضبط الخط"]

mcset ar f2Txt [fix "إذا تم التنشيط ، فإن BiblePix $dw يستحضر صورة خلفية. \nسيتم اختيار الصورة عشوائيًا من مجموعة صور BiblePix (انظر القسم [mc photos]).\nصورة خلفية جديدة دائمًا في \n\t[file nativename $imgdir] \n متاح للعرض بواسطة مدير سطح المكتب. \n إذا تم تثبيت عدة ملفات نصية للكتاب المقدس ، تتغير اللغة أو إصدار الكتاب المقدس بشكل عشوائي مع كل تغيير للصورة. \n يقوم BiblePix بإعداد عرض الشرائح مع صورة متغيرة بشكل افتراضي يتم عرض صورة واحدة يوميًا ، يمكن إلغاء تنشيط عرض الشرائح (انظر أعلاه). \n في نافذة [mc textposlabel] ، يمكنك تحريك dw$ إلى الموضع المطلوب على الشاشة. عند إضافة الصور ، يمكن أيضًا تحديد موضع النص بشكل فردي.  يتم تعيين [mc f2Fontsize] تلقائيًا بناءً على ارتفاع الشاشة. ومع ذلك ، لديك خيار تكييف الحجم والسمك (الأحرف الكبيرة = تباين أفضل). \n يمكنك إما إصلاح [mc f2Fontcolor] أو تركت للصدفة. يمكن أن يقوم BiblePix أيضًا بتعديل اللون بناءً على سطوع الخلفية. لا يسري هذا التأثير إلا بعد حفظ الصور الجديدة. \n إذا لم تظهر صورة الخلفية الجديدة تلقائيًا ، فستجد حلاً في الدليل‫.‬"]

# P H O T O S 
mcset ar textposlabel [fix "تحديد موضع النص"]
mcset ar textposAdjust [fix "هل تريد تغيير موضع النص لهذه الصورة قبل الحفظ؟"]
mcset ar f6Tit [fix "تنظيم الصور لـ BiblePix"]
mcset ar f6Txt [fix "
هنا يمكنك سحب أي عدد تريده من الصور من مجلد الصور الشخصية الخاص بك إلى مجموعة صور BiblePix. يجب أن تكون الصور بتنسيق أفقي ولها منطقة ذات ألوان متساوية لسهولة قراءة آية الكتاب المقدس.
يحفظ BiblePix ملفًا نسخة من الصورة في مجلد صور BiblePix وتغيير تنسيق الصورة وحجمها إذا كانت لا تتطابق مع أبعاد الشاشة. في هذه الحالة ، لديك خيار تحديد قسم الصورة المناسب والموقع المستقبلي لنص الكتاب المقدس بنفسك.
تظل §لصورة الأصلية دون تغيير على أي حال‫.‬ 
"]
mcset ar f6numPhotosTxt [fix "عدد الصور‫:‬ "]
mcset ar f6Add [fix "للإضافة إلى مكتبة صور BiblePix:"]
mcset ar f6Show [fix "عرض مكتبة صور BiblePix"]
mcset ar f6Find [fix "البحث عن صور جديدة"]
mcset ar f6Del [fix "للحذف من مكتبة صور BiblePix"]

# R E S I Z I N G
mcset ar movePicToResize [fix "حرك قسم الصورة حسب الرغبة وأكد بـ [mc ok] للحفظ."
mcset ar resizeF_txt [fix "صورتك لا تتناسب مع حجم الشاشة ويجب تصغيرها. [mc movePicToResize]"

mcset ar resizingPic [fix "يتم ضبط حجم الصورة على الشاشة \u2014 يرجى التحلي بالصبر للحظة ..."

mcset ar movePic [fix "تحريك قسم الصورة \u21CA"]
mcset ar picSchonDa [fix "الصورة موجودة بالفعل في ملف صور BiblePix"]

# S I G N A T U R E
mcset ar f3Tit [fix "$dw على توقيعات بريدك الإلكتروني"]
mcset ar f3Btn [fix "إنشاء توقيع البريد الإلكتروني"]
mcset ar f3Sprachen [fix "اللغات المرغوبة لتوقيعي"]
mcset ar f3Txt [fix "
إذا تم تنشيطه ، فإن BiblePix يضيف dw$ إلى توقيعات البريد الإلكتروني مرة واحدة يوميًا لكل ملف نصي للكتاب المقدس مثبت. يتم فرز ملفات التوقيع التي تم إنشاؤها وفقًا لاختصارات اللغة (على سبيل المثال ، signature-ar_NewAra.txt) في المجلد التالي:
\t$sigdir
يمكنك تحرير هذه الملفات من برنامج البريد الإلكتروني الخاص بك أو في محرر نصوص وإضافة تحيات شخصية وعناوين وما إلى ذلك في الأعلى. النص الموجود أعلى السطر الفاصل ==== يظل غير متأثر عند التبديل من dw$. 
 ربما إذا كنت لا تريد أن يقرأ مستلمو البريد الخاص بك dw$ بجميع اللغات التي قمت بتثبيتها ، فحدد اللغة (اللغات) التي تريدها في الزاوية اليمنى العليا. \ n \ n لديك لتعليم برنامج البريد الخاص بك استخدام الملفات الموضحة أعلاه (عادةً ضمن الإعدادات> التوقيع).
تقوم برامج معينة مثل Seamonkey Mail أو Evolution أو Trojitá بإدارة التوقيعات داخليًا. يمكن أن يأخذ BiblePix مؤقتًا Trojitá و Evolution في الاعتبار‫.‬ 
"
]
# T E R M I N A L
mcset ar f4Tit [fix "$dw in Ihren Linux-Terminals"
mcset ar f4Btn [fix "$dw zur Anzeige im Terminal erzeugen"
mcset ar f4Txt "Wenn aktiviert, erzeugt BiblePix $dw für die Anzeige in Ihren Konsolen. Sind mehrere Bibeltextdateien vorhanden, wechselt der Text bei jedem Öffnen eines Terminals. 
Darstellung und Farben können in \n\n\t $confdir/term.conf \n\ngeändert werden.
Für die Darstellung in hebräischer oder arabischer Schrift kommen nur Terminals wie 'QTerminal', 'mlterm', 'gnome-terminal', 'xfce4-terminal' oder 'Konsole' (KDE) in Frage, welche bidirektionellen Text korrekt anzeigen. 
Damit $dw automatisch im Terminal angezeigt wird, macht das BiblePix-Setup einen Eintrag in ~/.bashrc."

# S E T U P S A V E   T E X T S
mcset ar linChangingDesktop [fix "يحاول موقع BiblePix الآن تغيير إعدادات سطح المكتب. إذا لم تشاهد صورة خلفية جديدة بعد ذلك ، فستجد حلاً في الدليل‫.‬"]
mcset ar winIgnorePopup [fix "الرجاء إغلاق النافذة المنبثقة دون إجراء أي تغييرات حتى يتمكن BiblePix من إكمال التسجيل‫!‬"]
mcset ar winChangingDesktop [fix "يحاول تطبيق BiblePix الآن تغيير خلفية سطح المكتب لديك"]

#mcset ar winChangeDesktopProb [fix {
#واجهتنا مشكلة في تغيير خلفية سطح المكتب.
#انقر بزر الماوس الأيمن فوق حقل فارغ على سطح المكتب و "\ تخصيص "\ . ضمن "\ الخلفية "\، اضبط صورة الخلفية على
#  $TwdBMP
#أو  
#  $TwdPNG
#ولا لعرض الشرائح  
#$imgdir . 
#}]

mcset ar linChangeDesktopProb [fix "واجهتنا مشكلة في تغيير إعدادات سطح المكتب. الرجاء النقر بزر الماوس الأيمن فوق سطح المكتب والعثور على مربع الحوار 'صورة الخلفية' . أدخل $imgdir كمسار للصورة."]

mcset ar linNoDesktopFound [fix "لم يتم العثور على سطح مكتب Linux! راجع الدليل لايجاد حل لإعداد صورة خلفية BiblePix يدويًا."]

mcset ar linReloadingDesktop [fix "نحاول الآن قراءة مساحة العمل الخاصة بك مرة أخرى. إذا فشل ذلك ، فسيتعين عليك تسجيل الخروج لفترة وجيزة ثم تسجيل الدخول مرة أخرى حتى يتم تفعيل إعدادات BiblePix."]

if {$os=="Linux"} {
  mcset ar changeDesktopOk [fix "تم إعداد BiblePix على جهاز الكمبيوتر الخاص بك وسيبدأ الآن. يمكنك بدء برنامج الإعداد $bp في أي وقت بتحديد رمز $bp في قائمة البرنامج."]
} else {
  mcset ar changeDesktopOk [fix "تم إعداد BiblePix على جهاز الكمبيوتر الخاص بك وسيبدأ الآن. يمكنك بدء برنامج الإعداد $bp في أي وقت عن طريق النقر بزر الماوس الأيمن على سطح المكتب وتحديد رمز $bp."]
}

mcset ar winRegister [fix "يجب الآن تسجيل BiblePix على نظامك.  الرجاء تأكيد أي نوافذ إعلام بـ 'نعم'‫!‬"]
mcset ar winRegisterProb [fix "لم يتم تثبيت BiblePix بشكل صحيح على جهاز الكمبيوتر الخاص بك. ابدأ الإعداد مرة أخرى أو أضف $bp إلى تشغيل البرامج تلقائيًا ؛
"
]
mcset DE winRegisterProb [fix "BiblePix ist auf Ihrem Computer noch nicht korrekt installiert.\nStarten Sie das Setup nochmals oder fügen Sie \n$Biblepix\n in \"Automatisch gestartete Programme\" an."]

# P H O T O S
mcset ar reposSaved [fix "تم حفظ الصور بالمعلومات‫.‬"]
mcset ar reposNotSaved [fix "لم يتم حفظ الصور‫.‬"]
mcset ar noPhotosFound [fix "لم يتم العثور على صور في ملف صور BiblePix. الرجاء نسخ بعض الصور في الملف"]
mcset ar rotatePic [fix "تدوير الصورة"]
mcset ar preview90 [fix "\u21BB معاينة 90 درجة استدارة"]
mcset ar preview180 [fix "\u21BB معاينة 180 درجة استدارة"]
mcset ar computePreview [fix "\u21B6 \u21B7 معاينة أفضل تدوير"]
mcset ar rotateWait "[fix يرجى التحلي بالصبر لبعض الوقت حتى يتم تدوير الصورة الأصلية ‫...‬"]
mcset ar rotateInfo "[fix انتبه: عن طريق حفظ وإعادة تحميل صورة يمكن استدارتها في عدة خطوات‫!‬"]
mcset ar deletedPicMsg [fix "تم حذف الصورة من ألبوم صور BiblePix:"]
mcset ar copiedPicMsg [fix "تم نسخ صورة جديدة إلى ألبوم صور BiblePix:"]

