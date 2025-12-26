import 'package:flutter/material.dart';
import 'courses_screen.dart';

// Simple Semester model (if you already have one, keep yours)
class Semester {
  final String id;
  final String name;

  Semester({required this.id, required this.name});
}

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy semesters
    final List<Semester> semesters = [
      Semester(id: 's1', name: 'Semester 1'),
      Semester(id: 's2', name: 'Semester 2'),
      Semester(id: 's3', name: 'Semester 3'),
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
