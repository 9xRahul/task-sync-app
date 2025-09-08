import java.util.Properties
import java.io.FileInputStream
import java.io.File

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
    try {
        // Load properties (use forward slashes in key.properties to avoid \u problems)
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
        println("Loaded keystore from: ${keystorePropertiesFile.path}")
    } catch (e: Exception) {
        println("Failed to load key.properties: ${e.message}")
        println("Common cause: backslashes in Windows paths like C:\\Users\\... are interpreted as escape sequences.")
        println("Try using forward slashes (D:/key/tasksync.jks) or escaping backslashes (D:\\\\key\\\\tasksync.jks).")
        throw e
    }
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
        applicationId = "com.rahul.tasksync"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    // Create release signing config and validate keystore exists
    signingConfigs {
        create("release") {
            val storePathRaw = (keystoreProperties["storeFile"] as String?)?.trim()
            if (storePathRaw != null && storePathRaw.isNotEmpty()) {
                // normalize Windows backslashes if user used them
                val normalizedPath = storePathRaw.replace("\\\\", "/").replace("\\", "/")
                val candidate = file(normalizedPath)
                if (!candidate.exists()) {
                    // Helpful message and guidance
                    println("ERROR: Keystore file does not exist at path from key.properties: $storePathRaw")
                    println("Tried normalized path: ${candidate.path}")
                    println("Recommendations:")
                    println("  - Use forward slashes in key.properties: storeFile=D:/key/tasksync.jks")
                    println("  - Or put the keystore inside your project (android/app/tasksync.jks) and set storeFile=android/app/tasksync.jks")
                    throw GradleException("Keystore not found at: $storePathRaw. Build cannot continue until keystore is available.")
                } else {
                    storeFile = candidate
                    println("Using keystore at: ${candidate.path}")
                }
            } else {
                println("ERROR: 'storeFile' is not set in key.properties")
                throw GradleException("'storeFile' not defined in key.properties. Build cannot continue for release signing.")
            }

            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            // Turn on code shrinking (R8)
            isMinifyEnabled = true

            // Shrink resources
            isShrinkResources = true

    

            // Attach signing config (must exist otherwise we have already thrown a helpful error)
            signingConfig = signingConfigs.getByName("release")
        }

        getByName("debug") {
            isMinifyEnabled = false
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

    // Multidex
    implementation("androidx.multidex:multidex:2.0.1")

    // Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))

    // Firebase SDKs
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
