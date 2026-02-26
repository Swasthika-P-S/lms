import 'package:flutter/material.dart';
import '../../../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const email = 'student@example.com';
    final name = email.split('@').first;
    final initials = name.length >= 2
        ? name[0].toUpperCase() + name[1].toUpperCase()
        : name[0].toUpperCase();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    const Color(0xFF1F1640),
                    AppTheme.darkBackground,
                  ]
                : [
                    Colors.grey.shade50,
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                /// 🔹 Avatar (Hero style)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                      tag: 'profile-avatar',
                      child: CircleAvatar(
                        radius: 62,
                        backgroundColor: AppTheme.primaryPurple,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),

                const SizedBox(height: 10),

                /// Role badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryPurple),
                  ),
                  child: const Text(
                    'STUDENT',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 About section
                ExpansionTile(
                  title: const Text('About Me'),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: const [
                    Text(
                      'Computer Science student passionate about Flutter, UI design, and building modern mobile applications.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// 🔥 Streak
                Text(
                  '🔥 Learning Streak: 5 Days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),

                const SizedBox(height: 25),

                /// Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem('3', 'Courses', Icons.book),
                    _divider(),
                    _statItem('12', 'Hours', Icons.access_time),
                    _divider(),
                    _statItem('65%', 'Progress', Icons.trending_up),
                  ],
                ),

                const SizedBox(height: 20),

                /// Animated progress
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(
                      AppTheme.primaryPurple,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// Skills
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _skillChip('Flutter'),
                    _skillChip('Dart'),
                    _skillChip('UI/UX'),
                    _skillChip('Firebase'),
                  ],
                ),

                const SizedBox(height: 30),

                /// Edit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit Profile coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// helpers
  Widget _statItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryPurple),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 45,
      width: 1,
      color: Colors.grey.shade600,
    );
  }

  Widget _skillChip(String text) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(text),
        side: BorderSide(color: AppTheme.primaryPurple),
      ),
    );
  }
}
