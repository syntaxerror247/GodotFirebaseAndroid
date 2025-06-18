# GodotFirebaseAndroid

**GodotFirebaseAndroid** is an Android plugin for the Godot Engine that integrates Firebase services in Godot Android games and apps.
It supports Godot 4.2+

## Features

- [x] Firebase Authentication (Email/Password, Google Sign-In)
- [x] Cloud Firestore
- [x] Realtime Database
- [x] Cloud Storage
- [ ] Cloud Messaging (coming soon)

---

## 🚀 Quick Start

### 1. Install the Plugin

- Download the latest release from the [Releases](https://github.com/syntaxerror247/GodotFirebaseAndroid/releases) page.

- Unzip and copy the plugin to your project’s `addons` folder:

	```
	your_project/addons/GodotFirebaseAndroid/
	```

- In Godot, go to: **Project > Project Settings > Plugins**, and enable **GodotFirebaseAndroid**.

---

### 2. Add Firebase to Your Project

- Visit [Firebase Console](https://console.firebase.google.com)
- Create a Firebase project and register your Android app.
- Enable required services (e.g., Authentication, Firestore).
- Download the `google-services.json` file and place it in:

	```
	android/build/google-services.json
	```

---

### 3. Enable Gradle Build for Android Export

In Godot, go to: **Project > Export > Android > gradle/use\_gradle\_build** and enable it ✅

---

## 📚 Documentation

Full documentation is available at: https://syntaxerror247.github.io/GodotFirebaseAndroid
