import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:learnhub/providers/firebase_auth_provider.dart';
import 'package:learnhub/providers/locale_provider.dart';
import 'package:learnhub/home_tab/screens/providers/theme_provider.dart';
import 'package:learnhub/home_tab/utils/theme.dart';
import 'package:learnhub/home_tab/screens/auth/register_screen.dart';

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

    if (!mounted) return;
    setState(() => _isLoading = true);

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final email = _emailController.text.trim();

    final success = await firebaseAuthProvider.signInWithEmailPassword(
      email,
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success && mounted) {
      final errMsg = firebaseAuthProvider.errorMessage ?? '';
      final isNotFound = errMsg.contains('invalid-credential') ||
          errMsg.contains('user-not-found') ||
          errMsg.contains('wrong-password') ||
          errMsg.contains('INVALID_LOGIN_CREDENTIALS');

      if (isNotFound) {
        // Show friendly dialog with Google sign-in suggestion
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.person_off_rounded, color: Colors.orange),
                SizedBox(width: 10),
                Text('Sign-In Failed'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Could not sign in as\n"$email".',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_rounded, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'If you previously signed in with Google, use the "Continue with Google" button instead.',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Or create a new account if you haven\'t registered yet.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Try Again'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: const Text('Sign Up'),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errMsg.isNotEmpty ? errMsg : 'Login failed. Please try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final success = await firebaseAuthProvider.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firebaseAuthProvider.errorMessage ?? 'Google Sign-In failed'),
          backgroundColor: Colors.redAccent,
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
    final loc = context.watch<LocaleProvider>();
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
                    const Color(0xFF1F1640), // Deep purple
                    AppTheme.darkBackground,
                  ]
                : [
                    const Color(0xFFF0F2FF),
                    const Color(0xFFE0E7FF),
                    const Color(0xFFF5F3FF),
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
                    color: AppTheme.primaryPurple.withOpacity(0.1),
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
                    color: AppTheme.accentPink.withOpacity(0.1),
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
                      color: AppTheme.primaryPurple.withOpacity(0.2),
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
                      color: AppTheme.primaryPurple,
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
                                    AppTheme.primaryPurple,
                                    const Color(0xFF4F46E5), // Indigo 600
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryPurple.withOpacity(0.3),
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
                              loc.t('learning_management_system'),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1E1B4B), // Deep Indigo
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Learn, Practice, and Excel',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : const Color(0xFF4B5563),
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
                                        : Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    loc.t('or'),
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[500] : Colors.grey[600],
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
                                        : Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            
                            // Email Field
                            _buildInputField(
                              controller: _emailController,
                              label: loc.t('email_label'),
                              icon: Icons.email_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? loc.t('please_enter_valid_email')
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            
                            // Password Field
                            _buildInputField(
                              controller: _passwordController,
                              label: loc.t('password_label'),
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
                                      : Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              validator: (v) =>
                                  v == null || v.length < 6 ? loc.t('password_min_length') : null,
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
                                  loc.t('dont_have_account'),
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                                    loc.t('sign_up'),
                                    style: TextStyle(
                                      color: AppTheme.primaryPurple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
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
    final loc = context.read<LocaleProvider>();
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
          color: AppTheme.primaryPurple.withOpacity(0.2),
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
          _isLoading ? loc.t('loading') : loc.t('continue_with_google'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF334155) : AppTheme.primaryPurple,
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
    final loc = context.read<LocaleProvider>();
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5), // Indigo 600
            AppTheme.primaryPurple,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
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
            : Text(
                loc.t('login'),
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
              ? AppTheme.primaryPurple.withOpacity(0.3)
              : AppTheme.primaryPurple.withOpacity(0.2),
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
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark ? Colors.white70 : AppTheme.primaryPurple,
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