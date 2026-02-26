import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home_tab/utils/theme.dart';

/// Direct Firebase Test - No providers, just pure Firebase
class DirectFirebaseTestScreen extends StatefulWidget {
  const DirectFirebaseTestScreen({Key? key}) : super(key: key);

  @override
  State<DirectFirebaseTestScreen> createState() => _DirectFirebaseTestScreenState();
}

class _DirectFirebaseTestScreenState extends State<DirectFirebaseTestScreen> {
  final _emailController = TextEditingController(text: 'test@cb.students.amrita.edu');
  final _passwordController = TextEditingController(text: 'test123456');
  
  bool _isLoading = false;
  String _result = '';
  Color _resultColor = Colors.black;

  Future<void> _testFirebaseDirectly() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing Firebase...';
      _resultColor = AppTheme.accentGold;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      print('🔥 TESTING: Attempting Firebase authentication...');
      print('📧 Email: $email');
      
      // Try to create account first
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        setState(() {
          _result = '✅ SUCCESS! Account created!\nEmail: ${userCredential?.user?.email}\nUID: ${userCredential?.user?.uid}';
          _resultColor = Colors.green;
        });
        
        print('✅ Account created successfully!');
        
        // Create Firestore document
        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': email,
            'role': email.endsWith('@cb.students.amrita.edu') ? 'student' : 'admin',
            'displayName': 'Test User',
            'createdAt': FieldValue.serverTimestamp(),
          });
          
          setState(() {
            _result += '\n\n✅ Firestore document created!';
          });
        }
        
      } catch (e) {
        // If account exists, try to login
        if (e.toString().contains('email-already-in-use')) {
          print('Account exists, trying login...');
          
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          
          setState(() {
            _result = '✅ SUCCESS! Logged in!\nEmail: ${userCredential?.user?.email}\nUID: ${userCredential?.user?.uid}';
            _resultColor = Colors.green;
          });
          
          print('✅ Login successful!');
        } else {
          rethrow;
        }
      }
      
      // Check Firestore
      if (userCredential?.user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential!.user!.uid)
            .get();
        
        if (doc.exists) {
          final role = doc.data()?['role'] ?? 'unknown';
          setState(() {
            _result += '\n\n📊 Firestore Data:\nRole: $role';
          });
        }
      }
      
    } catch (e) {
      print('❌ ERROR: $e');
      String errorMessage = e.toString();
      String suggestion = '';
      
      if (errorMessage.contains('operation-not-allowed')) {
        suggestion = '''
🔴 CRITICAL FIX REQUIRED:
1. Go to Firebase Console (firebase.google.com)
2. Click "Authentication" > "Sign-in method"
3. Click "Email/Password"
4. Flip the switch to "Enable" -> Save
5. Try this button again!
''';
      } else if (errorMessage.contains('network-request-failed')) {
        suggestion = '🔴 NETWORK ERROR: Check your internet connection.';
      } else if (errorMessage.contains('invalid-api-key')) {
        suggestion = '🔴 API KEY ERROR: The API key in firebase_service.dart is invalid.';
      }

      setState(() {
        _result = '❌ ERROR: $errorMessage\n\n$suggestion';
        _resultColor = Colors.red;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Firebase Test'),
        backgroundColor: AppTheme.primaryTerracotta,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DIRECT FIREBASE TEST',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTerracotta,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'This bypasses all providers and tests Firebase directly',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryTerracotta, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password (min 6 chars)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryTerracotta, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testFirebaseDirectly,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTerracotta,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: AppTheme.primaryTerracotta.withOpacity(0.5),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'TEST FIREBASE NOW',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _resultColor.withOpacity(0.1),
                    border: Border.all(color: _resultColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _result,
                      style: TextStyle(
                        color: _resultColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
