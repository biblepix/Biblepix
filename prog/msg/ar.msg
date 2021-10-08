# ~/Biblepix/prog/msg/ar.msg
# Arabic texts in msgcat format
# sourced by SetupTools:[setTexts]
# Author: Peter Vollmar, biblepix.vollmar.ch
# Updated: 8oct21 pv

# U N T R A N S L A T A B L E S
set dw {الكلمة}
mcset ar dw $dw
mcset ar bp BiblePix

# G E N E R A L
mcset ar bpsetup " قم بإعداد موقع BiblePix"
mcset ar refresh "تحديث"
mcset ar delete "حذف ملف"
mcset ar ok "موافق" 
mcset ar cancel "إلغاء"
mcset ar close "إغلاق"
mcset ar save "حفظ"
mcset ar saveSettings "حفظ الاعدادات"
mcset ar random "عشوائى"
mcset ar uninst " إلغاء التثبيت BiblePix"
mcset ar welcome "أهلا وسهلا"
mcset ar bibletexts "نصوص الكتاب المقدس"
mcset ar desktop "خلفية شاشة"
mcset ar photos "صور"
mcset ar email "توقيع البريد الإلكتروني"
mcset ar terminal "محطة Linux"
mcset ar manual "دليل الاعداد"
mcset ar packageRequireMissing "يتطلب BiblePix امتداد Tcl '%s' يرجى تثبيته عبر لوحة التحكم الخاصة بك أو كتابة أحد الأوامر التالية في وحدة التحكم (root أو sudo): [mc packageRequire]"

# W E L C O M E 
mcset ar next "بعد \u25bc"
mcset ar welcTit "مرحبًا بك في برنامج إعداد BiblePix !"
mcset ar welcSubtit1 "ما هو برنامج BiblePix ؟"
mcset ar welcTxt1 "BiblePix هو برنامج Tcl تم تطويره لمشروع الكتاب المقدس 2.0 ، والذي يهدف إلى نشر الكلمة في عدد متزايد من اللغات. \n الكلمة يتكون من آيتين مختارين من الكتاب المقدس لكل يوم من أيام السنة. \nيمكن أن يعرض موقع BiblePix الكلمة بعدة طرق على جهاز الكمبيوتر الشخصي الخاص بك"
mcset ar welcSubtit2 "ما هي خياراتك؟"
mcset ar welcTxt2 "\u21E6[mc bibletexts]: اختر المفضل لديك من إصدارات ولغات الكتاب المقدس \n\u21E6 خلفية شاشة: شاهد $dw مع صورك الشخصية \n\u21E6  [mc photos]: اختر صور الخلفية الخاصة بك لـ BiblePix \n\u21E6 [mc email]: أضف $dw إلى رسائلك الإلكترونية \n\u21E6 [mc manual]: ادرس دليل BiblePix الكامل \n\u21E6[mc terminal] : انظر إلى $dw في وحدات تحكم Linux الخاصة بك"

# U N I N S T A L L
mcset ar uninstall "هل تريد حقاًإزالة BiblePix من جهاز الكمبيوتر الخاص بك؟"
mcset ar uninstalling "سيتم الآن إلغاء تثبيت لحذف إعدادات النظام bp$ يجب ال±د على أي نافذة إشعار بـنعم"
mcset ar uninstalled "تمت إزالة BiblePix بأمان من نظامك. لإعادة تثبيته ، قم بزيارتنا على [mc www] وقم بتنزيل مثبت BiblePix."

# I N T E R N A T I O N A L
mcset ar download "تحميل"
mcset ar downloadingHttp "تحميل ملفات برنامج BiblePix ..."
mcset ar downloadingAsianFont "تحميل ملفات الخطوط الآسيوية ..."
mcset ar downloadComplete "إنتهاء التحميل."
mcset ar updatingHttp "تحديث ملفات برنامج BiblePix ..."
mcset ar uptodateHTTP "ملفات برنامجك على أخر تحديث‫.‬"
mcset ar noConnHTTP "لا يوجد اتصال بالإنترنت لتحديث البرنامج ، يرجى المحاولة لاحقًا."
mcset ar gettingTwd "احصل على قائمة نص الكتاب المقدس الحديثة من bible2.net ..."
mcset ar noTwdFilesFound "لم يتم تثبيت أي ملفات نصية للكتاب المقدس حاليًا.  الرجاء تحديد  ملف لغة واحد على الأقل من قسم [mc bibletexts] في إعداد BiblePix."
mcset ar connTwd "تم إنشاء الاتصال بـ bible2.net."
mcset ar noConnTwd "لا يوجد اتصال بـ bible2.net. من فضلك حاول في وقت لاحق."
mcset ar f1Tit "قائمة نصوص الكتاب المقدس الحالية لـ $dw"
mcset ar TwdLocalTit "تم تثبيت ملفات نصية للكتاب المقدس لمدة $jahr"
mcset ar TwdRemoteTit "ملفات نصية من الكتاب المقدس للتحميل"
mcset ar language "اللغة"
mcset ar year "العام"
mcset ar bibleversion "طبعة الكتاب المقدس"
mcset ar biblename "اسم الكتاب المقدس"

mcset ar f1Txt "يوفر موقع BiblePix $dw بجميع اللغات وإصدارات الكتاب المقدس المثبتة على جهاز الكمبيوتر الخاص بك. تم تثبيت عدة ملفات نصية للكتاب المقدس ، سيختار BiblePix واحدًا عشوائيًا. إذا حددت ملفات نصية جديدة للكتاب المقدس لتنزيلها (انظر أدناه) ، فسيتم تنزيلها بمجرد الضغط على الزر [mc download]. نتبه إلى تاريخ العام (الحالي أو العام المقبل)!‫"

# D E S K T O P
mcset ar f2Tit "الكلمة على خلفية صورة سطح المكتب"
mcset ar f2Box "توليد صورة الخلفية"
mcset ar f2Farbe "لون الخط: "
mcset ar f2Slideshow "تنشيط عرض الشرائح"
mcset ar f2Interval "تغيير كل الصور "
mcset ar sec "ثوانى"
mcset ar f2Introline "عرض التاريخ"
mcset ar f2Fontsize "حجم الخط‫:‬ "
mcset ar f2Fontweight "سميك"
mcset ar f2Fontfamily "نوع الخط‫:‬ "
mcset ar f2Fontexpl "ضبط الخط"
mcset ar textposlabel "تحديد موضع النص"
mcset ar f2Txt "إذا تم التنشيط ، فإن BiblePix $dw يستحضر صورة خلفية.سيتم اختيار الصورة عشوائيًا من مجموعة صور BiblePix (انظر القسم [mc photos]). صورة خلفية جديدة دائمًا في \n\t [file nativename $imgdir] \nمتاح للعرض بواسطة مدير سطح المكتب. \nإذا تم تثبيت عدة ملفات نصية للكتاب المقدس ، تتغير اللغة أو إصدار الكتاب المقدس بشكل عشوائي مع كل تغيير للصورة. \nيقوم BiblePix بإعداد عرض الشرائح مع صورة متغيرة بشكل افتراضي يتم عرض صورة واحدة يوميًا ، يمكن إلغاء تنشيط عرض الشرائح (انظر أعلاه). \nفي نافذة [mc textposlabel] ، يمكنك تحريك $dw إلى الموضع المطلوب على الشاشة. عند إضافة الصور ، يمكن أيضًا تحديد موضع النص بشكل فردي.  يتم تعيين [mc f2Fontsize] تلقائيًا بناءً على ارتفاع الشاشة. ومع ذلك ، لديك خيار تكييف الحجم والسمك (الأحرف الكبيرة = تباين أفضل). \nيمكنك إما إصلاح [mc f2Fontcolor] أو تركت للصدفة. يمكن أن يقوم BiblePix أيضًا بتعديل اللون بناءً على سطوع الخلفية. لا يسري هذا التأثير لا بعد حف¸ الصور الجديدة. \nإذا لم تظهر صورة الخلفية الجديدة تلقائيًا ، فستجد حلاً في الدليل‫.‬ "

# P H O T O S 

mcset ar textposAdjust "هل تريد تغيير موضع النص لهذه الصورة قبل الحفظ؟"
mcset ar f6Tit "تنظيم الصور لـ BiblePix"

mcset ar f6Txt "هنا يمكنك سحب أي عدد تريده من الصور من مجلد الصور الشخصية الخاص بك إلى مجموعة صور BiblePix. يجب أن تكون الصور بتنسيق أفقي ولها منطقة ذات ألوان متساوية لسهولة قراءة آية الكتاب المقدس.  \n يحفظ BiblePix ملفًا نسخة من الصورة في مجلد صور BiblePix وتغيير تنسيق الصورة وحجمها إذا كانت لا تتطابق مع أبعاد الشاشة. في هذه الحالة ، لديك خيار تحديد قسم الصورة المناسب والموقع المستقبلي لنص الكتاب المقدس بنفسك. \n تظل الصورة الأصلية دون تغيير على أي حال‫.‬ "

mcset ar f6numPhotosTxt "عدد الصور‫:‬ "
mcset ar f6Add "للإضافة إلى مكتبة صور BiblePix:"
mcset ar f6Show "عرض مكتبة صور BiblePix"
mcset ar f6Find "البحث عن صور جديدة"
mcset ar f6Del "للحذف من مكتبة صور BiblePix"

# R E S I Z I N G
mcset ar movePicToResize "حرك قسم الصورة حسب الرغبة وأكد بـ [mc ok] للحفظ."
mcset ar resizeF_txt "صورتك لا تتناسب مع حجم الشاشة ويجب تصغيرها. [mc movePicToResize]"

mcset ar resizingPic "يتم ضبط حجم الصورة على الشاشة \u2014 يرجى التحلي بالصبر للحظة ..."

mcset ar movePic "تحريك قسم الصورة \u21CA"
mcset ar picSchonDa "الصورة موجودة بالفعل في ملف صور BiblePix"

# S I G N A T U R E
mcset ar f3Tit "$dw على توقيعات بريدك الإلكتروني"
mcset ar f3Btn "إنشاء توقيع البريد الإلكتروني"
mcset ar f3Sprachen "اللغات المرغوبة لتوقيعي"
mcset ar f3Txt "إذا تم تنشيطه ، فإن BiblePix يضيف $dw إلى توقيعات البريد الإلكتروني مرة واحدة يوميًا لكل ملف نصي للكتاب المقدس مثبت. يتم فرز ملفات التوقيع التي تم إنشاؤها وفقًا لاختصارات اللغة (على سبيل المثال ، signature-ar_NewAra.txt) في المجلد التالي: \n\t $sigdir \nيمكنك تحرير هذه الملفات من برنامج البريد الإلكتروني الخاص بك أو في محرر نصوص وإضافة تحيات شخصية وعناوين وما إلى ذلك في الأعلى. ال?ص  الموجود على السطر الفاصل ==== يظل غير متأثر عند التبديل من $dw. \n ربما إذا كنت لا تريد أن يقرأ مستلمو البريد الخاص بك $dw بجميع اللغات التي قمت بتثبيتها ، فحدد اللغة (اللغات) التي تريدها في الزاوية اليمنى العليا. "
#\n\n لديك لتعليم برنامج البريد الخاص بك استخدام الملفات الموضحة أعلاه (عادةً ضمن الإعدادات - التوقيع). تقوم برامج معينة مثل Seamonkey Mail أو Evolution أو Trojitá بإدارة التوقيعات داخليًا. يمكن أن يأخذ BiblePix مؤقتًا Trojitá و Evolution في الاعتبار‫‬"

# T E R M I N A L
mcset ar f4Tit  "$dw في ترمينالز ت Linux الخاصة بك"
mcset ar f4Btn "انشاء $dw للعرض في الترمينال"
#mcset ar f4Txt "إذا تم تنشيطه ، يقوم BiblePix بإنشاء $dw للعرض في وحدات التحكم الخاصة بك. إذا كان هناك العديد من ملفات نصوص الكتاب المقدس ، يتغير النص في كل مرة يتم فيها فتح ترمينالز طرفية. \n\n يمكن تغيير العرض والألوان في \n\n\t $confdir/term.conf \n\n يتم تغييرها. \n\n بالنسبة للعرض بالنص العبري أو العربي ، فقط ترمينالز الط±فية مثل QTerminal أو mlterm أو gnome-terminal أو xfce4-terminal أو Konsole (KDE) ، والتي تعرض النص ثنائي الاتجاه بشكل صحيح. \n\n للتأكد من عرض $dw تلقائيًا في الجهاز ، يقوم إعداد BiblePix بإجراء إدخال في ~ / .bashrc. "

# S E T U P S A V E
mcset ar linChangingDesktop "يحاول موقع BiblePix الآن تغيير إعدادات سطح المكتب. إذا لم تشاهد صورة خلفية جديدة بعد ذلك ، فستجد حلاً في الدليل‫.‬"
mcset ar winIgnorePopup "الرجاء إغلاق النافذة المنبثقة دون إجراء أي تغييرات حتى يتمكن BiblePix من إكمال التسجيل‫!‬"
mcset ar winChangingDesktop "يحاول تطبيق BiblePix الآن تغيير خلفية سطح المكتب لديك"
mcset ar winChangeDesktopProb "واجهتنا مشكلة في تغيير خلفية سطح المكتب. \nانقر بزر الماوس الأيمن فوق حقل فارغ على سطح المكتب و  تخصيص ضمن  الخلفية ، اضبط صورة الخلفية على\n $TwdBMP أو \n $TwdPNG \n  ولا لعرض الشرائح $imgdir . "

mcset ar linChangeDesktopProb "واجهتنا مشكلة في تغيير إعدادات سطح المكتب. الرجاء النقر بزر الماوس الأيمن فوق سطح المكتب والعثور على مربع الحوار 'صورة الخلفية' . أدخل $imgdir كمسار للصورة."

mcset ar linNoDesktopFound "لم يتم العثور على سطح مكتب Linux! راجع الدليل لايجاد حل لإعداد صورة خلفية BiblePix يدويًا."

mcset ar linReloadingDesktop "نحاول الآن قراءة مساحة العمل الخاصة بك مرة أخرى. إذا فشل ذلك ، فسيتعين عليك تسجيل الخروج لفترة وجيزة ثم تسجيل الدخول مرة أخرى حتى يتم تفعيل إعدادات BiblePix."

if {$os=="Linux"} {
  mcset ar changeDesktopOk "تم إعداد BiblePix على جهاز الكمبيوتر الخاص بك وسيبدأ الآن. يمكنك بدء برنامج الإعداد $bp في أي وقت بتحديد رمز $bp في قائمة البرنامج."
} else {
  mcset ar changeDesktopOk "تم إعداد BiblePix على جهاز الكمبيوتر الخاص بك وسيبدأ الآن. يمكنك بدء برنامج الإعداد $bp في أي وقت عن طريق النقر بزر الماوس الأيمن على سطح المكتب وتحديد رمز $bp."
}

mcset ar winRegister "يجب الآن تسجيل BiblePix على نظامك.  الرجاء تأكيد أي نوافذ إعلام بـ 'نعم'‫!‬"
mcset ar winRegisterProb "لم يتم تثبيت BiblePix بشكل صحيح على جهاز الكمبيوتر الخاص بك. ابدأ الإعدا¯ مرة أخرى أو أضف $bp إلى تشغيل البرامج تلقائيًا ؛"

# P H O T O S
mcset ar reposSaved "تم حفظ الصورة بالمعلومات‫.‬"
mcset ar reposNotSaved "لم يتم حفظ الصورة‫.‬"
mcset ar noPhotosFound "لم يتم العثور على صور في ملف صور BiblePix. الرجاء نسخ بعض الصور في الملف"
mcset ar rotatePic "تدوير الصورة"
mcset ar preview90 "\u21BB معاينة 90 درجة استدارة"
mcset ar preview180 "\u21BB معاينة 180 درجة استدارة"
mcset ar computePreview "\u21B6 \u21B7 معاينة أفضل تدوير"
mcset ar rotateWait "يرجى التحلي بالصبر لبعض الوقت حتى يتم تدوير الصورة الأصلية ‫...‬"
mcset ar rotateInfo "انتبه: عن طريق حفظ وإعادة تحميل صورة يمكن استدارتها في عدة خطوات‫!‬"
mcset ar deletedPicMsg "تم حذف الصورة من ألبوم صور BiblePix:"
mcset ar copiedPicMsg "تم نسخ صورة جديدة إلى ألبوم صور BiblePix:"
