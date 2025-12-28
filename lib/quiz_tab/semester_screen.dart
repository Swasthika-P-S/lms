import 'package:flutter/material.dart';
import 'courses_screen.dart';
import 'semester.dart';

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy semesters
    final List<Semester> semesters = [
      Semester(id: 's1', name: 'Semester 1'),
      Semester(id: 's2', name: 'Semester 2'),
      Semester(id: 's3', name: 'Semester 3'),
      Semester(id: 's4', name: 'Semester 4'),
      Semester(id: 's5', name: 'Semester 5'),
      Semester(id: 's6', name: 'Semester 6'),
      Semester(id: 's7', name: 'Semester 7'),
      Semester(id: 's8', name: 'Semester 8'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Semester'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: semesters.length,
        itemBuilder: (context, index) {
          final semester = semesters[index];

          return Card(
            child: ListTile(
              title: Text(
                semester.name,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursesScreen(
                      semesterId: semester.id,
                      semesterName: semester.name,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
