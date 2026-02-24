import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Authentication service for handling user sign-in/sign-up
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Get current user
  User? get currentUser => _auth.currentUser;
  
  /// Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In...');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('⚠️ Google Sign-In cancelled by user');
        return null;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential).timeout(const Duration(seconds: 20));
      
      // Create/update user document in Firestore
      if (userCredential.user != null) {
        await _createOrUpdateUserDocument(userCredential.user!)
            .timeout(const Duration(seconds: 20), onTimeout: () {
          print('⚠️ Firestore document update timed out');
        });
      }
      
      print('✅ Google Sign-In successful: ${userCredential.user?.email}');
      return userCredential;
      
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      rethrow;
    }
  }
  
  /// Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ Email Sign-In successful: $email');
      return userCredential;
      
    } catch (e) {
      print('❌ Email Sign-In error: $e');
      rethrow;
    }
  }
  
  /// Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
    String email, 
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Create user document
      if (userCredential.user != null) {
        await _createOrUpdateUserDocument(userCredential.user!);
      }
      
      print('✅ Sign-Up successful: $email');
      return userCredential;
      
    } catch (e) {
      print('❌ Sign-Up error: $e');
      rethrow;
    }
  }
  
  /// Create or update user document in Firestore
  Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userRef.get();
      
      // Determine user role based on email domain
      String role = 'admin'; // Default to admin
      
      if (user.email != null) {
        // Students: Amrita college emails (@cb.students.amrita.edu)
        if (user.email!.toLowerCase().endsWith('@cb.students.amrita.edu')) {
          role = 'student';
        }
        // Everyone else gets admin access
      }
      
      final userData = {
        'email': user.email,
        'displayName': user.displayName ?? (role == 'student' ? 'Student' : 'Admin'),
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
      };
      
      if (!docSnapshot.exists) {
        // Create new user document
        await userRef.set({
          ...userData,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'stats': {
            'totalProblems': 0,
            'solvedProblems': 0,
            'totalScore': 0,
            'streak': 0,
          },
          'preferences': {
            'theme': 'system',
            'notifications': true,
          },
        }).timeout(const Duration(seconds: 20));
        print('✅ Created new user document for ${user.uid} with role: $role');
      } else {
        // Update existing user but preserve role if it exists
        final updates = {...userData};
        if (!docSnapshot.data()!.containsKey('role')) {
          updates['role'] = role;
        }
        await userRef.update(updates);
        print('✅ Updated user document for ${user.uid}');
      }
    } catch (e) {
      print('❌ Error creating/updating user document: $e');
      // If Firestore is unavailable, we still want the user to be logged in via Auth
      // They might experience limited functionality, but shouldn't be blocked entirely
      if (e.toString().contains('unavailable')) {
        print('⚠️ Firestore is offline. User document will be created when online.');
      }
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('✅ User signed out');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }
  
  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) return;
      
      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Delete Firebase Auth account
      await user.delete();
      
      print('✅ Account deleted');
    } catch (e) {
      print('❌ Delete account error: $e');
      rethrow;
    }
  }
}
