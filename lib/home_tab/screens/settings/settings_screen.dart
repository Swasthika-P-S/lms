import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../auth/login_screen.dart';
import 'package:learnhub/providers/locale_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  void _handleLogout() {
    final loc = context.read<LocaleProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.t('logout')),
        content: Text(loc.t('logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.t('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final authProvider = context.read<AuthProvider>();
              final userProvider = context.read<UserProvider>();
              authProvider.logout();
              userProvider.clearUser();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: Text(
              loc.t('logout'),
              style: const TextStyle(color: Colors.red),
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
    final loc = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('settings')),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== APP PREFERENCES =====
          Text(
            loc.t('app_preferences'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // ðŸŒ Language Toggle
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.t('language')),
            subtitle: Text(
              loc.isHindi ? loc.t('language_hindi') : loc.t('language_english'),
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                value: loc.locale,
                underline: const SizedBox(),
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('\u0939\u093f\u0902\u0926\u0940')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    loc.switchLocale(value);
                  }
                },
              ),
            ),
          ),

          // ðŸŒ™ Dark Mode Toggle
          SwitchListTile(
            title: Text(loc.t('dark_mode')),
            subtitle: Text(
              isDarkMode ? loc.t('switch_to_light') : loc.t('switch_to_dark'),
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

          // ðŸ”” Notifications Toggle
          SwitchListTile(
            title: Text(loc.t('notifications')),
            subtitle: Text(
              notificationsEnabled ? loc.t('enabled') : loc.t('disabled'),
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
            loc.t('account'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.person),
            title: Text(loc.t('edit_profile')),
            subtitle: Text(loc.t('update_personal_info')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('edit_profile')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(loc.t('change_password')),
            subtitle: Text(loc.t('update_password')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('change_password')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== LEARNING =====
          Text(
            loc.t('learning'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.school),
            title: Text(loc.t('study_goals')),
            subtitle: Text(loc.t('set_daily_targets')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('study_goals')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.trending_up),
            title: Text(loc.t('progress_tracking')),
            subtitle: Text(loc.t('view_analytics')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('progress_tracking')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== ABOUT =====
          Text(
            loc.t('about'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.info),
            title: Text(loc.t('learnhub_lms')),
            subtitle: const Text('Version 1.0.0 â€¢ Build 2026.01'),
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(loc.t('privacy_policy')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('privacy_policy')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: Text(loc.t('terms_of_service')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${loc.t('terms_of_service')} ${loc.t('feature_coming_soon')}'),
                ),
              );
            },
          ),

          const Divider(),
          const SizedBox(height: 8),

          // ðŸšª Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: Text(loc.t('logout')),
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
