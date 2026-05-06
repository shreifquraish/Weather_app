import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  // Android App
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '0xhXhb25dawSIRAHDEBSgzcd_gQvSLIe6Wmezu-ztd4',
    appId: '1:481465177160:android:badb58a582f9a33a5e2f47d',
    messagingSenderId: '481465177160',
    projectId: 'weather-app-4d263',
    storageBucket: 'weather-app-4d263.firebasestorage.app',
  );

  // iOS App
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '0xhXhb25dawSIRAHDEBSgzcd_gQvSLIe6Wmezu-ztd4',
    appId: '1:481465177160:ios:9a7b6c5d4e3f2a1b0c9d',
    messagingSenderId: '481465177160',
    projectId: 'weather-app-4d263',
    storageBucket: 'weather-app-4d263.firebasestorage.app',
    iosBundleId: 'com.example.weatherApp',
  );

  // Web App
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '0xhXhb25dawSIRAHDEBSgzcd_gQvSLIe6Wmezu-ztd4',
    appId: '1:481465177160:web:badb58a582f9a33a5e2f47d',
    messagingSenderId: '481465177160',
    projectId: 'weather-app-4d263',
    authDomain: 'weather-app-4d263.firebaseapp.com',
    storageBucket: 'weather-app-4d263.firebasestorage.app',
  );

  // Windows App
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: '0xhXhb25dawSIRAHDEBSgzcd_gQvSLIe6Wmezu-ztd4',
    appId: '1:481465177160:web:badb58a582f9a33a5e2f47d',
    messagingSenderId: '481465177160',
    projectId: 'weather-app-4d263',
    authDomain: 'weather-app-4d263.firebaseapp.com',
    storageBucket: 'weather-app-4d263.firebasestorage.app',
  );

  // MacOS App
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '0xhXhb25dawSIRAHDEBSgzcd_gQvSLIe6Wmezu-ztd4',
    appId: '1:481465177160:ios:9a7b6c5d4e3f2a1b0c9d',
    messagingSenderId: '481465177160',
    projectId: 'weather-app-4d263',
    storageBucket: 'weather-app-4d263.firebasestorage.app',
    iosBundleId: 'com.example.weatherApp',
  );

  // المنصة الحالية (Android default)
  static const FirebaseOptions currentPlatform = android;
}