import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learnhub/app_tab/screens/course_listing_screen.dart';
import 'package:learnhub/app_tab/utils/colors.dart';
import 'package:learnhub/quiz_tab/courses_screen.dart';
import 'package:learnhub/assignment_tab/ui/dashboard_screen.dart';
import 'package:learnhub/home_tab/screens/providers/theme_provider.dart';
import 'package:learnhub/home_tab/screens/providers/auth_provider.dart';
import 'package:learnhub/home_tab/screens/providers/user_provider.dart';
import 'package:learnhub/home_tab/screens/auth/login_screen.dart';
import 'package:learnhub/home_tab/screens/home/home_screen.dart';
import 'package:learnhub/home_tab/screens/auth/profile/profile_screen.dart';
import 'package:learnhub/home_tab/screens/settings/settings_screen.dart';
import 'package:learnhub/home_tab/utils/theme.dart';
import 'package:learnhub/screens/admin/admin_dashboard_screen.dart';

// Firebase imports
import 'services/firebase_service.dart';
import 'providers/firebase_auth_provider.dart';
import 'providers/chatbot_provider.dart';
import 'services/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await FirebaseService.instance.initialize();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    // Continue anyway - app can still work with limited functionality
  }
  
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
        // Firebase providers
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Learning Management System',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: Consumer<FirebaseAuthProvider>(
              builder: (context, firebaseAuthProvider, _) {
                // Show loading screen during initialization
                if (firebaseAuthProvider.isLoading) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
                
                // Show main screen if authenticated, otherwise login screen
                return firebaseAuthProvider.isAuthenticated
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
  void initState() {
    super.initState();
    // One-time seed for DSA questions
    DataSeeder.seedDsaQuizzes().then((_) {
      print('✅ DSA Data Seeded or updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context);
    
    // Get user info from UserProvider (not AuthProvider)
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userModel?.name ?? firebaseAuthProvider.user?.displayName ?? 'User';
    
    // Check if user is admin
    final isAdmin = firebaseAuthProvider.isAdmin;
    
    // Different screens for admin and student
    final List<Widget> adminScreens = [
      const AdminDashboardScreen(), // Admin Dashboard
      HomeScreen(), // Home tab - overview
      SettingsScreen(), // Settings
    ];
    
    final List<Widget> studentScreens = [
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
    
    final screens = isAdmin ? adminScreens : studentScreens;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.card : Colors.white,
        elevation: 0,
        title: Text(
          isAdmin ? 'Admin Panel' : 'LMS',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: AppColors.primary,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
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
              children: isAdmin
                  ? [
                      _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0, isDarkMode),
                      _buildNavItem(Icons.home_rounded, 'Home', 1, isDarkMode),
                      _buildNavItem(Icons.settings_rounded, 'Settings', 2, isDarkMode),
                    ]
                  : [
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