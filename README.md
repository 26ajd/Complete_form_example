# وصف المشروع

هذا المشروع هو مثال لتطبيق Flutter يحتوي على نموذج (Form) متكامل مع حفظ البيانات محليًا باستخدام حزمة `hive`.

**الهدف:** تعليم كيفية إنشاء نموذج مدخلات، التحقق من البيانات، حفظها محليًا وعرضها في شاشة عرض.

---

**التقنيات المستخدمة:**
- Flutter (Dart)
- Hive (حفظ محلي وخوارزمية تخزين خفيفة)
- hive_flutter + hive_generator (للـ TypeAdapter وتوليد الشيفرة)
- build_runner (لتشغيل مولد الكود)

---


**كيفية تشغيل المشروع محليًا (Windows):**
1. افتح PowerShell في مجلد المشروع (حيث يوجد `pubspec.yaml`).
2. شغل الأوامر التالية بالترتيب:

```powershell
flutter clean
flutter pub get
# توليد الملفات الناقصة
flutter create .
# إعادة توليد محولات Hive 
dart run build_runner build --delete-conflicting-outputs
# شغّل التطبيق على منصة Windows
flutter run -d windows -v
```

