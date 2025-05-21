# GodotFirebaseAndroid

Firebase plugin for Android export in Godot Engine.

## Features

- [x] Firebase Authentication (Email/Password, Google Sign-In)
- [x] Cloud Firestore
- [x] Realtime Database
- [x] Cloud Storage
- [ ] Cloud Messaging (coming soon)

---

## Quick Start

**Step 1: Install the Plugin**

- Download the latest release from the [Releases](https://github.com/your-repo/releases) page.

- Unzip and copy the plugin to your project’s `addons` folder:

  ```
  your_project/addons/GodotFirebaseAndroid/
  ```

- In Godot, go to **Project > Project Settings > Plugins**, and enable **GodotFirebaseAndroid**.

---

**Step 2: Add Firebase to Your Project**

- Open [Firebase Console](https://console.firebase.google.com)
- Create a Firebase project and register your Android app.
- Enable the required services (e.g., Authentication, Firestore).
- Download the `google-services.json` file.
- Place it in:

  ```
  android/build/google-services.json
  ```

---

**Step 3: Enable Gradle Build for Android Export**

- In Godot:
  **Project > Export > Android > gradle/use_gradle_build**: ✅

---

## Build Notes

This plugin automatically modifies `build.gradle` and `settings.gradle` at export time to include the necessary Firebase dependencies.

Make sure:

- Gradle build is enabled before exporting.
- `google-services.json` exists in `android/build/` before export.
