// Generated from google-services.json and GoogleService-Info.plist for project: kolzumo
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeKx2quiQen5qTLmuWXVvEniQAM_wn-ts',
    appId: '1:973212437141:android:e27a21e82c625653d7699c',
    messagingSenderId: '973212437141',
    projectId: 'kolzumo',
    storageBucket: 'kolzumo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZE9CZ1ouQgKlWtb13Bu-Q7s6XP7257Cc',
    appId: '1:973212437141:ios:9a984420cea88c22d7699c',
    messagingSenderId: '973212437141',
    projectId: 'kolzumo',
    storageBucket: 'kolzumo.firebasestorage.app',
    iosBundleId: 'co.com.kolzumo.app',
  );
}
