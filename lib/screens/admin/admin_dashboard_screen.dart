import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/firebase_auth_provider.dart';
import '../../home_tab/utils/theme.dart';
import '../../services/mongo_service.dart';
import 'manage_questions_screen.dart';

/// Admin Dashboard — live stats from Firestore
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _db = FirebaseFirestore.instance;
  bool _seeding = false;

  Future<void> _seedDatabase() async {
    setState(() => _seeding = true);
    try {
      await MongoService.seedDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ MongoDB database seeded! DSA, OOPs & C++ topics added.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        setState(() {}); // refresh stats
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Seed failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  // Courses are fixed (DSA, OOPs, C++) — always 3
  static const _courseIds = ['dsa', 'oops', 'cpp'];
  static const _courseNames = ['DSA', 'OOPs', 'C++'];

  /// Count total questions across all courses and topics from MongoDB
  Future<Map<String, int>> _fetchStats() async {
    int totalTopics = 0;
    int totalQuestions = 0;

    try {
      final courses = await MongoService.getCourses();
      
      for (final course in courses) {
        final topics = await MongoService.getTopics(course.id);
        totalTopics += topics.length;

        for (final topic in topics) {
          final questions = await MongoService.getQuestions(topic.id);
          totalQuestions += questions.length;
        }
      }

      return {
        'courses': courses.length,
        'topics': totalTopics,
        'questions': totalQuestions,
      };
    } catch (e) {
      print('❌ Error fetching MongoDB stats: $e');
      return {
        'courses': 0,
        'topics': 0,
        'questions': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.read<FirebaseAuthProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppTheme.darkBackground, const Color(0xFF1F1640), AppTheme.darkBackground]
                : [Colors.grey.shade50, Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppTheme.primaryPurple,
                              AppTheme.accentPink,
                            ]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.admin_panel_settings,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Admin Dashboard',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87)),
                            Text('Manage your learning platform',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Live Stats ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: FutureBuilder<Map<String, int>>(
                    future: _fetchStats(),
                    builder: (context, snap) {
                      final stats = snap.data;
                      final loading = snap.connectionState == ConnectionState.waiting;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.library_books_rounded,
                                    title: 'Courses',
                                    value: loading ? '…' : '${stats!['courses']}',
                                    color: AppTheme.primaryPurple,
                                    isDark: isDark,
                                    subtitle: _courseNames.join(', '),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.topic_rounded,
                                    title: 'Topics Added',
                                    value: loading ? '…' : '${stats!['topics']}',
                                    color: AppTheme.accentCyan,
                                    isDark: isDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _StatCard(
                              icon: Icons.quiz_rounded,
                              title: 'Total Questions in Database',
                              value: loading ? 'Loading…' : '${stats!['questions']} Questions',
                              color: AppTheme.accentPink,
                              isDark: isDark,
                              wide: true,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Quick Actions ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick Actions',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87)),
                        const SizedBox(height: 16),

                        // Manage Quiz Questions
                        _ActionCard(
                          icon: Icons.quiz_rounded,
                          title: 'Manage Quiz Questions',
                          subtitle: 'Add, edit or delete quiz questions for DSA, OOPs, C++',
                          color: AppTheme.accentPink,
                          isDark: isDark,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ManageQuestionsScreen()),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Seed Database Button ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _seeding ? null : _seedDatabase,
                            icon: _seeding
                                ? const SizedBox(
                                    width: 18, height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.cloud_upload_rounded),
                            label: Text(_seeding
                                ? 'Seeding… please wait'
                                : '🌱 Seed Quiz Database (DSA + OOPs + C++)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Course breakdown
                        _CourseBreakdownCard(isDark: isDark),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final Color color;
  final bool isDark;
  final String? subtitle;
  final bool wide;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.isDark,
    this.subtitle,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: wide
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87)),
                    Text(title,
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(value,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 2),
                Text(title,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: TextStyle(fontSize: 11, color: color),
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
    );
  }
}

// ── Action Card ──────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ── Course Breakdown Card (live question counts per course) ───────
class _CourseBreakdownCard extends StatelessWidget {
  final bool isDark;
  const _CourseBreakdownCard({required this.isDark});

  static const _courses = [
    ('dsa', 'DSA', Color(0xFF6C63FF)),
    ('oops', 'OOPs', Color(0xFF4ECDC4)),
    ('cpp', 'C++', Color(0xFFFF6B6B)),
  ];

  Future<int> _countQuestions(String courseId) async {
    int total = 0;
    final topics = await FirebaseFirestore.instance
        .collection('quiz_courses')
        .doc(courseId)
        .collection('topics')
        .get();
    for (final t in topics.docs) {
      final qs = await FirebaseFirestore.instance
          .collection('quiz_courses')
          .doc(courseId)
          .collection('topics')
          .doc(t.id)
          .collection('questions')
          .get();
      total += qs.docs.length;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Questions by Course',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 14),
          ..._courses.map((c) {
            final (id, name, color) = c;
            return FutureBuilder<int>(
              future: _countQuestions(id),
              builder: (ctx, snap) {
                final count = snap.data ?? 0;
                final loading = snap.connectionState == ConnectionState.waiting;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87)),
                      ),
                      loading
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: color))
                          : Text('$count question${count == 1 ? '' : 's'}',
                              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
