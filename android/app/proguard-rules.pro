# Keep Flutter embedding

# Keep Gson/Moshi/JSON model annotations if used
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Flutter Secure Storage & AndroidX Security Crypto (Preserve Keystore on release)
-keep class androidx.security.crypto.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn androidx.security.crypto.**
-dontwarn com.it_nomads.fluttersecurestorage.**
