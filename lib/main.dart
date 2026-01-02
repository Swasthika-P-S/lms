import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_tab/screens/course_listing_screen.dart';
import 'app_tab/utils/colors.dart';
import 'quiz_tab/courses_screen.dart';
import 'assignment_tab/ui/dashboard_screen.dart';
import 'home_tab/screens/providers/theme_provider.dart';
import 'home_tab/screens/providers/auth_provider.dart';
import 'home_tab/screens/providers/user_provider.dart';
import 'home_tab/screens/auth/login_screen.dart';
import 'home_tab/screens/home/home_screen.dart';
import 'home_tab/screens/auth/profile/profile_screen.dart';
import 'home_tab/screens/settings/settings_screen.dart';
import 'home_tab/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LearnHubApp());
}

class LearnHubApp extends StatelessWidget {
  const LearnHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'LearnHub LMS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isLoading) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
                return authProvider.user != null
                    ? const MainScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get user info from UserProvider (not AuthProvider)
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userModel?.name ?? 'User';
    
    final screens = [
      HomeScreen(), // Home tab - main dashboard
      CourseListingScreen(), // App tab - course listing
      CoursesScreen(), // Quiz tab - courses only
      DashboardScreen( // Assignment tab - dashboard
        userName: userName,
        courseId: 'course_flutter_basics',
      ),
      ProfileScreen(), // Home tab - profile
      SettingsScreen(), // Home tab - settings
    ];
    
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.card : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Home', 0, isDarkMode),
                _buildNavItem(Icons.school_rounded, 'Courses', 1, isDarkMode),
                _buildNavItem(Icons.book_rounded, 'Quizzes', 2, isDarkMode),
                _buildNavItem(Icons.assignment_rounded, 'Tasks', 3, isDarkMode),
                _buildNavItem(Icons.person_rounded, 'Profile', 4, isDarkMode),
                _buildNavItem(Icons.settings_rounded, 'Settings', 5, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isDarkMode) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColors.primary 
                  : (isDarkMode ? Colors.grey : Colors.grey[600]),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? AppColors.primary 
                    : (isDarkMode ? Colors.grey : Colors.grey[600]),
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}