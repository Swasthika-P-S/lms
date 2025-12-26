import 'package:flutter/material.dart';

// Simple Course model (if you already have one, keep yours)
class Course {
  final String id;
  final String name;
  final String semesterId;

  Course({
    required this.id,
    required this.name,
    required this.semesterId,
  });
}

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
    // Dummy courses
    final List<Course> allCourses = [
      Course(id: 'c1', name: 'Data Structures', semesterId: 's1'),
      Course(id: 'c2', name: 'Operating Systems', semesterId: 's1'),
      Course(id: 'c3', name: 'DBMS', semesterId: 's2'),
      Course(id: 'c4', name: 'Computer Networks', semesterId: 's2'),
      Course(id: 'c5', name: 'Software Engineering', semesterId: 's3'),
    ];

    // Filter courses by selected semester
    final courses = allCourses
        .where((course) => course.semesterId == semesterId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(semesterName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                courses[index].name,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // NEXT STEP: navigate to quiz list
              },
            ),
          );
        },
      ),
    );
  }
}
