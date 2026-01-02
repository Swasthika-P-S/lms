import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/category_icon.dart';
import '../../widgets/pro_tip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.user != null) {
      userProvider.loadUserData(authProvider.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
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
          child: Consumer2<AuthProvider, UserProvider>(
            builder: (context, authProvider, userProvider, _) {
              final user = userProvider.userModel;

              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Text(
                                user.name.split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryPurple,
                            child: Text(
                              user.getInitials(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Keep Learning Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Keep Learning!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Complete your daily goals and earn achievements',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Goal Achieved',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const ProTipCard(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.book,
                                  label: 'Browse Courses',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B35),
                                      Color(0xFFFF8E53),
                                    ],
                                  ),
                                  badge: '7 Days',
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.bar_chart,
                                  label: 'New Course Available!',
                                  subtitle: 'Advanced Flutter\nTechniques',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7C3AED),
                                      Color(0xFF9F67FF),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  icon: Icons.menu_book,
                                  value: user.coursesCompleted.toString(),
                                  label: 'Courses',
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.access_time,
                                  value: user.totalHours.toString(),
                                  label: 'Hours',
                                  color: AppTheme.accentPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.trending_up,
                                  value: '${user.progressPercentage.toInt()}%',
                                  label: 'Progress',
                                  color: AppTheme.accentCyan,
                                  showProgress: true,
                                  progress: user.progressPercentage / 100,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Categories
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 20),
                                SizedBox(width: 4),
                                Text('New Course'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Category Icons
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CategoryIcon(
                            icon: Icons.code,
                            color: AppTheme.primaryPurple,
                            onTap: () {},
                          ),
                          CategoryIcon(
                            icon: Icons.palette,
                            color: AppTheme.accentPink,
                            onTap: () {},
                          ),
                          CategoryIcon(
                            icon: Icons.business,
                            color: AppTheme.accentCyan,
                            onTap: () {},
                          ),
                          CategoryIcon(
                            icon: Icons.camera,
                            color: AppTheme.accentOrange,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}