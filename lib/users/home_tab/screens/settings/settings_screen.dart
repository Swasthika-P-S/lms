import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
              
              // Logout from providers
              final authProvider = context.read<AuthProvider>();
              final userProvider = context.read<UserProvider>();
              
              authProvider.logout();
              userProvider.clearUser();
              
              // Navigate to login screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false, // Remove all routes
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== APP PREFERENCES =====
          Text(
            'App Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // 🌙 Dark Mode Toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.themeMode =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),

          // 🔔 Notifications Toggle
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: Text(
              notificationsEnabled ? 'Enabled' : 'Disabled',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),

          const Divider(),

          // ===== ACCOUNT =====
          Text(
            'Account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            subtitle: const Text('Update your personal information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit Profile feature coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            subtitle: const Text('Update your password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to change password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change Password feature coming soon!'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== LEARNING =====
          Text(
            'Learning',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Study Goals'),
            subtitle: const Text('Set daily learning targets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Study Goals feature coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Progress Tracking'),
            subtitle: const Text('View your learning analytics'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress Tracking feature coming soon!'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== ABOUT =====
          Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text('LearnHub LMS'),
            subtitle: Text('Version 1.0.0 • Build 2026.01'),
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy Policy feature coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of Service feature coming soon!'),
                ),
              );
            },
          ),

          const Divider(),
          const SizedBox(height: 8),

          // 🚪 Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 219, 78, 63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}