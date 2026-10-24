# تطبيق بصمة كلاود للآيفون (iOS App & IPA Builder)

يحتوي هذا المجلد على المشروع الكامل لتطبيق **بصمة كلاود** للحضور والانصراف ولوحة التحكم بلغة **SwiftUI + SwiftData**، بالإضافة إلى ملف البناء السحابي التلقائي لاستخراج ملف **`BasmahAttendance.ipa`** حتى لو لم يكن لديك جهاز Mac.

---

## الطريقة الأولى: استخراج ملف `.ipa` مجاناً عبر GitHub Actions (بدون جهاز Mac)

بما أن أنظمة Apple تشترط وجود بيئة macOS ومترجم Xcode لتحويل كود Swift إلى ملف تنفيذي بصيغة `.ipa`، فقد أعددنا لك ملف بناء تلقائي داخل `.github/workflows/build-ipa.yml`:

1. قم بإنشاء مستودع (Repository) جديد على حسابك في **GitHub**.
2. ارفع محتويات هذا المجلد بالكامل إلى المستودع.
3. ادخل إلى تبويب **Actions** في GitHub، وستجد عملية البناء **Build iOS IPA** تعمل تلقائياً على خادم macOS.
4. بعد انتهاء البناء (يستغرق حوالي دقيقتين)، اضغط على العملية وحمّل ملف **`BasmahAttendance.ipa`** الجاهز.
5. يمكنك تثبيت ملف `.ipa` على الآيفون باستخدام:
   - **Sideloadly** أو **AltStore** (بحساب Apple ID مجاني).
   - **TrollStore** أو شهادة مطور (Developer Certificate).

---

## الطريقة الثانية: التشغيل المباشر عبر برنامج Xcode (إذا كان لديك جهاز Mac)

1. افتح Terminal داخل هذا المجلد وشغّل الأمر `xcodegen generate` (أو أنشئ مشروع iOS App جديد في Xcode باسم `BasmahAttendance`).
2. اسحب ملفات المجلد `BasmahAttendance/` (`BasmahAttendanceApp.swift`, `Models.swift`, `Views.swift`) إلى داخل المشروع.
3. وصّل جهازك الآيفون واختر **Product > Run** لتثبيته مباشرة، أو **Product > Archive** لتصدير ملف `.ipa`.
