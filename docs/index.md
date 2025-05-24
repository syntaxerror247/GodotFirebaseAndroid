# GodotFirebaseAndroid

**GodotFirebaseAndroid** is an Android plugin for the Godot Engine that integrates Firebase services in Godot Android games and apps.

## Features

- ✅ Firebase Authentication (Email/Password, Google Sign-In)
- ✅ Cloud Firestore
- ✅ Realtime Database
- ✅ Cloud Storage
- 🔜 Cloud Messaging (Coming Soon)

## Getting Started

1. **Download & Install Plugin**
   - Download the latest release from [Releases](https://github.com/syntaxerror247/GodotFirebaseAndroid/releases)
   - Extract and copy the `GodotFirebaseAndroid` folder to your project's `addons/` directory: `your_project/addons GodotFirebaseAndroid/`
   - Enable the plugin via **Project > Project Settings > Plugins**.

2. **Set Up Firebase**
   - Go to the [Firebase Console](https://console.firebase.google.com/)
   - Create a Firebase project and register your Android app.
   - Enable the necessary Firebase features (Auth, Firestore, etc.)
   - Download `google-services.json` and place it in: `android/build/`

3. **Enable Gradle Build**
   - Open **Project > Export**
   - Enable `gradle_build/use_gradle_build` in Android preset.

## Documentation

- [Authentication](authentication.md)
- [Cloud Firestore](firestore.md)
- [Realtime Database](realtime_database.md)
- [Cloud Storage](storage.md)
- [Cloud Messaging](messaging.md)

## License

MIT License

Copyright (c) 2025 Anish Mishra (syntaxerror247)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
