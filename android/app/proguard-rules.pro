# Reglas de protección para Firebase Crashlytics y Analytics en R8 / ProGuard
-keepattributes *Annotation*
-keepattributes Signature
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
