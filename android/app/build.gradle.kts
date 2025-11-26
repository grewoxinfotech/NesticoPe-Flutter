plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come after Android/Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.housing_flutter_app" // 🔁 Update with your actual package name
//    adb shell dumpsys package com.example.housing_flutter_app | grep sign
  //  adb shell "cmd appops query-op --mode allow OP_READ_SMS | grep com.example.housing_flutter_app"
   // adb shell dumpsys package com.example.housing_flutter_app | Select-String sign



    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // ✅ FIXED: Set required NDK versiona

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.housing_flutter_app" // 🔁 Change if needed
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // For now, using debug keys for signing release builds
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
