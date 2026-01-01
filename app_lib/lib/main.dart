import 'package:flutter/material.dart';
import 'screens/course_listing_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const LearnHubApp());
}

class LearnHubApp extends StatelessWidget {
  const LearnHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHub',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        cardColor: AppColors.card,
      ),
      home: const CourseListingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
