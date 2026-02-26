import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firebase_auth_provider.dart';
import '../home_tab/utils/theme.dart';

/// Quick Test Login Screen for debugging authentication
class TestLoginScreen extends StatefulWidget {
  const TestLoginScreen({Key? key}) : super(key: key);

  @override
  State<TestLoginScreen> createState() => _TestLoginScreenState();
}

class _TestLoginScreenState extends State<TestLoginScreen> {
  final _emailController = TextEditingController(text: 'CB.EN.U4CSE21001@cb.students.amrita.edu');
  final _passwordController = TextEditingController(text: 'student123');
  final _nameController = TextEditingController(text: 'Amrita Student');
  
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _testRegisterAndLogin() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating test account...';
    });

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    
    try {
      // Try to register
      final registered = await firebaseAuthProvider.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      
      if (registered) {
        setState(() {
          _statusMessage = '✅ Registration successful! You are now logged in.';
        });
        
        // Wait a moment for user to see message
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          // Navigation should happen automatically via FirebaseAuthProvider
          setState(() {
            _statusMessage = '✅ Logged in successfully!';
          });
        }
      } else {
        // Registration failed, try login instead
        setState(() {
          _statusMessage = 'Account exists, trying to login...';
        });
        
        final loggedIn = await firebaseAuthProvider.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        
        if (loggedIn) {
          setState(() {
            _statusMessage = '✅ Login successful!';
          });
        } else {
          setState(() {
            _statusMessage = '❌ Login failed: ${firebaseAuthProvider.errorMessage}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Starting Google Sign-In...';
    });

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    
    final success = await firebaseAuthProvider.signInWithGoogle();
    
    setState(() {
      _isLoading = false;
      if (success) {
        _statusMessage = '✅ Google Sign-In successful!';
      } else {
        _statusMessage = '❌ Google Sign-In failed: ${firebaseAuthProvider.errorMessage}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Authentication'),
        backgroundColor: AppTheme.primaryTerracotta,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Quick Test Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This will create/login with a test account',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 24),
              
              // Test registration/login button
              ElevatedButton(
                onPressed: _isLoading ? null : _testRegisterAndLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTerracotta,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Register / Login with Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Email/Password Authentication Only',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Info message about Google Sign-In
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Google Sign-In is disabled. Use email/password above.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              /* Google Sign-In disabled in Firebase - commenting out
              // Google Sign-In button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testGoogleSignIn,
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              */
              
              const SizedBox(height: 24),
              
              // Status message
              if (_statusMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _statusMessage.contains('✅')
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _statusMessage.contains('✅')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusMessage.contains('✅')
                          ? Colors.green
                          : Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Back button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Main Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
