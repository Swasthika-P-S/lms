import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/firebase_auth_provider.dart';
import '../providers/theme_provider.dart';
import '../../utils/theme.dart';
import 'register_screen.dart';
import '../../../screens/test_login_screen.dart';
import '../../../screens/direct_firebase_test.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    
    final success = await firebaseAuthProvider.signInWithEmailPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firebaseAuthProvider.errorMessage ?? 'Login failed'),
          backgroundColor: AppTheme.darkTerracotta,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final success = await firebaseAuthProvider.signInWithGoogle();

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firebaseAuthProvider.errorMessage ?? 'Google Sign-In failed'),
          backgroundColor: AppTheme.darkTerracotta,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    const Color(0xFF2A1610),
                    AppTheme.darkBackground,
                  ]
                : [
                    const Color(0xFFFAF7F5),
                    const Color(0xFFF5E6D3),
                    const Color(0xFFFFEFE5),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryTerracotta.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentGold.withOpacity(0.1),
                  ),
                ),
              ),
              
              // Dark Mode Toggle
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark 
                        ? AppTheme.darkCard.withOpacity(0.6)
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryTerracotta.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: AppTheme.primaryTerracotta,
                    ),
                    onPressed: () {
                      themeProvider.themeMode = 
                          isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                  ),
                ),
              ),
              
              // Main Content
              Center(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            // Logo/Icon
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryTerracotta,
                                    AppTheme.darkTerracotta,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryTerracotta.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Title
                            Text(
                              'Learning Management System',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.accentCream : AppTheme.darkTerracotta,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Learn, Practice, and Excel',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : const Color(0xFF8B6F47),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            // Google Sign-In Button
                            _buildGoogleButton(isDark),
                            
                            const SizedBox(height: 32),
                            
                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: isDark 
                                        ? Colors.grey[700] 
                                        : const Color(0xFFD4A574).withOpacity(0.3),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[500] : const Color(0xFF8B6F47),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: isDark 
                                        ? Colors.grey[700] 
                                        : const Color(0xFFD4A574).withOpacity(0.3),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            
                            // Email Field
                            _buildInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            
                            // Password Field
                            _buildInputField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isDark: isDark,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: isDark 
                                      ? Colors.grey[500] 
                                      : const Color(0xFF8B6F47),
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              validator: (v) =>
                                  v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                            ),
                            const SizedBox(height: 32),
                            
                            // Login Button
                            _buildLoginButton(isDark),
                            
                            const SizedBox(height: 24),
                            
                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : const Color(0xFF8B6F47),
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: AppTheme.primaryTerracotta,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Test Login Button (for debugging)
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TestLoginScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.bug_report,
                                size: 18,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              label: Text(
                                'Quick Test Login',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // EMERGENCY: Direct Firebase Test
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DirectFirebaseTestScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.fire_extinguisher, color: Colors.white),
                              label: const Text(
                                '🚨 EMERGENCY: TEST FIREBASE NOW',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTerracotta.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        icon: _isLoading
            ? const SizedBox(width: 24, height: 24)
            : Image.network(
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.login, color: Colors.white, size: 24),
              ),
        label: Text(
          _isLoading ? 'Signing in...' : 'Continue with Google',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppTheme.accentGold : AppTheme.primaryTerracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.darkTerracotta,
            AppTheme.primaryTerracotta,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTerracotta.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleEmailLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Login with Email',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? AppTheme.darkCard.withOpacity(0.5) 
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.accentGold.withOpacity(0.2)
              : AppTheme.primaryTerracotta.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? AppTheme.accentCream : const Color(0xFF2A1F1A),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[500] : const Color(0xFF8B6F47),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark ? AppTheme.accentGold : AppTheme.primaryTerracotta,
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        validator: validator,
      ),
    );
  }
}