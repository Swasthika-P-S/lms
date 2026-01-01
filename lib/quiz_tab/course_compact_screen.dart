import 'package:flutter/material.dart';

class CompactCourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String topicCount;
  final List<Color> gradientColors;
  final IconData icon;
  final VoidCallback onTap;

  const CompactCourseCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.topicCount,
    required this.gradientColors,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Reduced from ~280px to 140px
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  // Text content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          topicCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            Positioned(
              right: 12,
              top: 12,
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage in your Quiz Center grid:
class QuizCenterCompact extends StatelessWidget {
  const QuizCenterCompact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Test your knowledge across different subjects',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Compact Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3, // Adjusted for compact cards
                  children: [
                    CompactCourseCard(
                      title: 'DSA',
                      subtitle: 'Data Structures & Algorithms',
                      topicCount: '7 Topics',
                      gradientColors: const [Color(0xFFB24BF3), Color(0xFFFF6B9D)],
                      icon: Icons.hub_rounded,
                      onTap: () {},
                    ),
                    CompactCourseCard(
                      title: 'CN',
                      subtitle: 'Computer Networks',
                      topicCount: '5 Topics',
                      gradientColors: const [Color(0xFF00D4FF), Color(0xFF0099CC)],
                      icon: Icons.router_rounded,
                      onTap: () {},
                    ),
                    CompactCourseCard(
                      title: 'OS',
                      subtitle: 'Operating Systems',
                      topicCount: '6 Topics',
                      gradientColors: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      icon: Icons.computer_rounded,
                      onTap: () {},
                    ),
                    CompactCourseCard(
                      title: 'DBMS',
                      subtitle: 'Database Management',
                      topicCount: '8 Topics',
                      gradientColors: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      icon: Icons.storage_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}