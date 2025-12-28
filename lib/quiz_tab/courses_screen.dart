import 'package:flutter/material.dart';
import 'package:lms/app_colors.dart'; 
import 'course.dart';

class CoursesScreen extends StatelessWidget {
  final String semesterId;
  final String semesterName;

  const CoursesScreen({
    super.key,
    required this.semesterId,
    required this.semesterName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Course> allCourses = [
      Course(id: 'c1', name: 'Data Structures', semesterId: 's1'),
      Course(id: 'c2', name: 'Operating Systems', semesterId: 's1'),
      Course(id: 'c3', name: 'DBMS', semesterId: 's2'),
      Course(id: 'c4', name: 'Computer Networks', semesterId: 's2'),
      Course(id: 'c5', name: 'Software Engineering', semesterId: 's3'),
    ];

    final courses =
        allCourses.where((c) => c.semesterId == semesterId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          semesterName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.cardWhite,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                courses[index].name,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.iconGreen,
              ),
              onTap: () {
                // navigate later
              },
            ),
          );
        },
      ),
    );
  }
}
