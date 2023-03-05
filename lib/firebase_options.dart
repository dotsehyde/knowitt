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
    apiKey: 'AIzaSyCPEFV48dikvrwOJGoOtB9JdMbHqGmpIKQ',
    appId: '1:712761504148:web:586434efd35833959ddf81',
    messagingSenderId: '712761504148',
    projectId: 'knowittapp',
    authDomain: 'knowittapp.firebaseapp.com',
    storageBucket: 'knowittapp.appspot.com',
    measurementId: 'G-D4CY56112Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKNY3I9txdr-J_DySqUXyp3N89eTHTxGM',
    appId: '1:712761504148:android:63524cba115d6ea19ddf81',
    messagingSenderId: '712761504148',
    projectId: 'knowittapp',
    storageBucket: 'knowittapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB80wHywEUBtw9ZTZIFOenZsf7E5fAAtB8',
    appId: '1:712761504148:ios:a76a8cf2d11fa9f09ddf81',
    messagingSenderId: '712761504148',
    projectId: 'knowittapp',
    storageBucket: 'knowittapp.appspot.com',
    iosClientId: '712761504148-pba75ml077tm6s18tj4sga9up3hh1fok.apps.googleusercontent.com',
    iosBundleId: 'com.dotsehyde.knowitt',
  );
}