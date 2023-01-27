# ~/Biblepix/prog/msg/ar.msg
# Arabic texts in msgcat format
# sourced by SetupTools:[setTexts]
# Author: Peter Vollmar, $bp.vollmar.ch
# Updated: 27jan23 pv

# U N T R A N S L A T A B L E S
set dw "الْكَلِمَة" 
mcset ar dw $dw

#\u060d - numbering sign
#\u061e - triple dot
#\u060e - poetic
#\u066d - star
#\u06d4 - Arabic full stop

set bp "\u061eآية بصورة\u061e"
mcset ar bp $bp

# G E N E R A L
mcset ar bpsetup " قم بإعداد $bp"
mcset ar refresh "تحديث"
mcset ar delete "حذف ملف"
mcset ar ok "موافق" 
mcset ar cancel "إلغاء"
mcset ar close "إغلاق"
mcset ar save "حفظ"
mcset ar saveSettings "حفظ الاعدادات"
mcset ar random "عشوائى"
mcset ar uninst " إلغاء التثبيت $bp"
mcset ar welcome "أهلا وسهلا"
mcset ar bibletexts "نصوص الكتاب المقدس"
mcset ar desktop "سطح المكتب"
mcset ar photos "صور"
mcset ar email "توقيع البريد الإلكتروني"
mcset ar terminal "محطة لينكس"
mcset ar manual "دليل الاعداد"
mcset ar packageRequireMissing "يتطلب $bp امتداد تي سي إل '%s' يرجى تثبيته عبر لوحة التحكم الخاصة بك أو كتابة أحد الأوامر التالية في وحدة التحكم (root أو sudo): [mc packageRequire]"

# W E L C O M E 
mcset ar next " التالي \u25bc"
mcset ar welcTit "مرحبًا بك في برنامج إعداد $bp !"
mcset ar welcSubtit1 "ما هو برنامج $bp ؟"
mcset ar welcTxt1 "$bp هو برنامج تي سي إل تم تطويره لمشروع الكتاب المقدس 2.0 ، والذي يهدف إلى نشر $dw في عدد متزايد من اللغات. $dw يتكون من آيتين مختارتين من الكتاب المقدس لكل يوم من أيام السنة. يمكن أن يعرض $bp $dw بعدة طرق على جهاز الكمبيوتر الشخصي الخاص بك."
mcset ar welcSubtit2 "ما هي خياراتك ؟"
mcset ar welcTxt2 "\u066d[mc bibletexts]: اختر المفضل لديك من إصدارات ولغات الكتاب المقدس 
\u066d[mc desktop]: شاهد $dw مع صورك الشخصية على خلفية الشاشة 
\u066d[mc photos]: اختر صور الخلفية الخاصة بك لـ $bp 
\u066d[mc email]: أضف $dw إلى رسائلك الإلكترونية 
\u066d[mc manual]: ادرس دليل $bp الكامل 
\u066d[mc terminal]: انظر إلى $dw في ترمينال لينكس"

# U N I N S T A L L
mcset ar uninstall "هل تريد حقاًإزالة $bp من جهاز الكمبيوتر الخاص بك؟"
mcset ar uninstalling "سيتم الآن إلغاء تثبيت $bp. لحذف إعدادات النظام، يجب الرد على أي نافذة إشعار بـ نعم‬"
mcset ar uninstalled "تمت إزالة $bp بأمان من نظامك. لإعادة تثبيته، قم بزيارتنا على [mc www] وقم بتنزيل مثبت $bp."

# I N T E R N A T I O N A L
mcset ar download "تحميل"
mcset ar downloadingHttp "تحميل ملفات برنامج $bp ..."
mcset ar downloadingAsianFont "تحميل ملفات الخطوط الآسيوية ..."
mcset ar downloadComplete "إنتهاء التحميل"
mcset ar updatingHttp "تحديث ملفات برنامج $bp ..."
mcset ar uptodateHTTP "ملفات برنامجك على أخر تحديث‫.‬"
mcset ar noConnHTTP "لا يوجد اتصال بالإنترنت لتحديث البرنامج ، يرجى المحاولة لاحقًا."
mcset ar gettingTwd "احصل على قائمة نص الكتاب المقدس الحديثة من bible2.net ..."
mcset ar noTwdFilesFound "لم يتم تثبيت أي ملفات نصية للكتاب المقدس حاليًا. الرجاء تحديد ملف لغة واحد على الأقل من قسم [mc bibletexts]."
mcset ar connTwd "تم إنشاء الاتصال بـ bible2.net."
mcset ar noConnTwd "لا يوجد اتصال بـ bible2.net. من فضلك حاول في وقت لاحق."
mcset ar f1Tit "قائمة نصوص الكتاب المقدس الحالية للْكَلِمَة"
mcset ar TwdLocalTit "تم تثبيت ملفات نصية للكتاب المقدس لمدة $jahr"
mcset ar TwdRemoteTit "ملفات نصية من الكتاب المقدس للتحميل"
mcset ar language "اللغة"
mcset ar year "العام"
mcset ar bibleversion "طبعة الكتاب المقدس"
mcset ar biblename "اسم الكتاب المقدس"
mcset ar f1Txt "يوفر برنامج $bp $dw بجميع اللغات وإصدارات الكتاب المقدس المثبتة على جهاز الكمبيوتر الخاص بك. إذا حددت ملفات نصية جديدة للكتاب المقدس لتنزيلها (انظر أدناه), سيختار $bp واحدًا عشوائيًا. تم تثبيت عدة ملفات نصية للكتاب المقدس فسيتم تنزيلها بمجرد الضغط على الزر '[mc download]' .نتبه إلى تاريخ العام (الحالي أو العام المقبل)!"

# D E S K T O P
mcset ar f2Tit "$dw على صورة خلفية سطح المكتب"
mcset ar f2Box "إنشاء صورة الخلفية"
mcset ar f2Farbe "لون الخط "
mcset ar f2Slideshow "تفعيل عرض الشرائح"
mcset ar f2Interval "تغيير الصور كل"
mcset ar sec "ثوانى"
mcset ar f2Introline "عرض التاريخ"
mcset ar f2Fontsize "حجم الخط‬ "
mcset ar f2Fontweight "سميك"
mcset ar f2Fontfamily "نوع الخط‬ "
mcset ar f2Fontexpl "ضبط الخط"
mcset ar textposlabel "تحديد مكان النص"
mcset ar f2Txt "إذا تم التفعيل، فإن $bp يعرض $dw على صورة خلفية فى كل يتم التشغيل. سيتم اختيار الصور عشوائيًا من مجموعة صور $bp (انظر قسم الصور) وصورة خلفية جديدة سوف فى 
\u00A0
$imgdir
\u00A0 
حتى يتم عرضها بواسطة مدير سطح المكتب.
\u00A0
إذا تم تثبيت عدة ملفات نصية للكتاب المقدس، تتغير اللغة أو إصدار الكتاب المقدس بشكل عشوائي مع كل تغيير للصورة.
\u00A0
يقوم $bp بإعداد عرض الشرائح مع صورة متغيرة بشكل افتراضي. يتم عرض صورة واحدة يوميًا، يمكن إلغاء تفعيل عرض الشرائح (انظر أعلاه).
\u00A0
في نافذة [mc textposlabel] يمكنك تحريك $dw إلى الموضع المرغوب على الشاشة. عند إضافة الصور، يمكن أيضًا تحديد موضع النص بشكل فردي.
\u00A0
يتم تعيين [mc f2Fontsize] تلقائيًا بناءً على ارتفاع الشاشة. ومع ذلك، لديك خيار تغيير الحجم والسمك (الأحرف الكبيرة = تناسق أفضل).
\u00A0
يمكنك اختيار [mc f2Farbe] أو تركه للصدفة. يمكن أن يقوم $bp أيضًا بتعديل اللون بناءً على سطوع الخلفية. لا يسري هذا التأثير إلا بعد حفظ الصورة الجديدة.
\u00A0
إذا لم تظهر صورة الخلفية الجديدة تلقائيًا، فستجد حلاً في الدليل‫."

# P H O T O S 
mcset ar textposAdjust "هل تريد تغيير موضع النص لهذه الصورة قبل الحفظ ؟"
mcset ar f6Tit "تنظيم الصور لـ $bp"
mcset ar f6Txt "هنا يمكنك اضافة اى عدد من صورك المفضلة من مجلد صورك الشخصية الى مجموعة صور $bp ويمكنك أيضا حذفهم. 
\u00A0
يجب أن تكون الصور بتنسيق افقى ويتوفر بسطح الصورة منطقة الوان سادة حتى تساعد على رؤية النص الكتابى ووضوحه. 
\u00A0
يحفظ $bp ملفًا نسخة من الصورة في مجلد صور $bp وتغيير تنسيق الصورة وحجمها إذا كانت لا تتطابق مع أبعاد الشاشة.
\u00A0
في هذه الحالة، لديك خيار تحديد قسم الصورة المناسب والموقع المستقبلي لنص الكتا"
