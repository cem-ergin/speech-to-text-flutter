// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGWuRjM9TRkfOkNOmXu4C1ms0ucUCpVgw',
    appId: '1:958476996789:web:52cf270bd6ea3c5737eefc',
    messagingSenderId: '958476996789',
    projectId: 'gurhan-speech-to-text',
    authDomain: 'gurhan-speech-to-text.firebaseapp.com',
    storageBucket: 'gurhan-speech-to-text.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzDZevYqtMYMUvWSjQZqdM6WEa_1saOn4',
    appId: '1:958476996789:android:107742448990258f37eefc',
    messagingSenderId: '958476996789',
    projectId: 'gurhan-speech-to-text',
    storageBucket: 'gurhan-speech-to-text.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMBSVFLII_etebK5oLc90cmH1BbSh8bVU',
    appId: '1:958476996789:ios:50e5a2ed5b29bf7f37eefc',
    messagingSenderId: '958476996789',
    projectId: 'gurhan-speech-to-text',
    storageBucket: 'gurhan-speech-to-text.appspot.com',
    iosClientId: '958476996789-r0mj0eveehb0ugipgp544ohndqd2qlag.apps.googleusercontent.com',
    iosBundleId: 'com.example.speechToTextFlutter',
  );
}