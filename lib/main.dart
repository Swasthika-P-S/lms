import 'package:flutter/material.dart';
import 'app_tab/screens/course_listing_screen.dart';
import 'app_tab/utils/colors.dart';
import 'quiz_tab/home_screen.dart';
import 'quiz_tab/courses_screen.dart';
import 'quiz_tab/profile_screen.dart';
import 'quiz_tab/settings_screen.dart';
import 'assignment_tab/ui/dashboard_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const LearnHubApp());
}

class LearnHubApp extends StatelessWidget {
  const LearnHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHub LMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        cardColor: AppColors.card,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: const Color(0xFFFF6584),
          surface: AppColors.card,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.card,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.card,
          contentTextStyle: const TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(), // Quiz tab home
      CourseListingScreen(), // App tab - course listing
      CoursesScreen(), // Quiz tab - courses
      DashboardScreen( // Assignment tab - dashboard
        userName: 'Hana',
        courseId: 'course_flutter_basics',
      ),
      ProfileScreen(), // Quiz tab - profile
      SettingsScreen(), // Quiz tab - settings
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.school_rounded, 'Courses', 1),
                _buildNavItem(Icons.book_rounded, 'Library', 2),
                _buildNavItem(Icons.assignment_rounded, 'Tasks', 3),
                _buildNavItem(Icons.person_rounded, 'Profile', 4),
                _buildNavItem(Icons.settings_rounded, 'Settings', 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
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
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
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