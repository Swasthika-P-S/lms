import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Firebase service for initializing and accessing Firebase instances
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();
  
  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  
  bool _initialized = false;
  bool get isInitialized => _initialized;
  
  /// Initialize Firebase
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );
      
      // Enable offline persistence (disabled for Web due to known issues with multiple tabs)
      firestore.settings = Settings(
        persistenceEnabled: !kIsWeb,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      _initialized = true;
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }
  
  /// Get Firebase configuration options
  FirebaseOptions _getFirebaseOptions() {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCpn57thkQwD2YSB2yBwPfWLddB3e35ees',
      authDomain: 'placement-lms-a8ca5.firebaseapp.com',
      projectId: 'placement-lms-a8ca5',
      storageBucket: 'placement-lms-a8ca5.firebasestorage.app',
      messagingSenderId: '253082488360',
      appId: '1:253082488360:web:cea6c8931e15e17393af1d',
    );
  }
  
  /// Sign out current user
  Future<void> signOut() async {
    try {
      await auth.signOut();
      print('✅ User signed out');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }
  
  /// Get current user
  User? get currentUser => auth.currentUser;
  
  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;
}
