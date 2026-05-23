// Values from android/app/google-services.json (project: europe-79369).
// For iOS/Web/Desktop, add those apps in the Firebase console and run:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
// Then replace this file with the generated one.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Add a Web app in Firebase and run `flutterfire configure`.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Add an iOS app in Firebase, download GoogleService-Info.plist, '
          'then run `flutterfire configure`.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not set for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3E5-qDOc6EsVg-7bEB0fgXglGseMVZ4w',
    appId: '1:436343786630:android:98db2dbfde9e255d5b5507',
    messagingSenderId: '436343786630',
    projectId: 'europe-79369',
    storageBucket: 'europe-79369.firebasestorage.app',
  );
}
