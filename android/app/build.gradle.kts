import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")


}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("Loaded keystore from: ${keystorePropertiesFile.path}")
} else {
    println("key.properties not found at: ${keystorePropertiesFile.path}")
}

android {
    namespace = "com.rahul.tasksync"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rahul.tasksync"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
         multiDexEnabled = true

    }

       signingConfigs {
        create("release") {
            val storePath = keystoreProperties["storeFile"] as String?
            if (storePath != null) {
                storeFile = file(storePath)   // file() takes a String path
            }
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }


     
    buildTypes {
        getByName("release") {
            // ✅ Turn on code shrinking (R8)
            isMinifyEnabled = true

            // ✅ Now you can shrink resources
            // AGP 8+: use isShrinkResources
            isShrinkResources = true
            // If your AGP is older and this line errors, use:
            // setShrinkResources(true)

            // Optional but recommended ProGuard config
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Keep your signing config if you set it:
            // signingConfig = signingConfigs.getByName("release")
        }

        getByName("debug") {
            isMinifyEnabled = false
            // Make sure you do NOT set shrink resources in debug
            // isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
     implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // ✅ Multidex
    implementation("androidx.multidex:multidex:2.0.1")

    // ✅ Firebase BOM (keeps versions aligned)
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))

    // ✅ Firebase SDKs (pick what you need)
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

}

