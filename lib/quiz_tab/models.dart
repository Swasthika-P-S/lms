import 'package:flutter/material.dart';

class Course {
  final String id;
  final String name;
  final String fullName;
  final IconData icon;
  final List<Color> gradientColors;
  final List<Topic> topics;

  Course({
    required this.id,
    required this.name,
    required this.fullName,
    required this.icon,
    required this.gradientColors,
    required this.topics,
  });

  factory Course.fromMap(Map<String, dynamic> map, {List<Topic> topics = const []}) {
    final String colorHex = map['color'] ?? '#6C63FF';
    final Color primaryColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    
    // Create a gradient by darkening/lightening the primary color
    final Color secondaryColor = Color.fromARGB(
      255,
      (primaryColor.red * 0.7).toInt(),
      (primaryColor.green * 0.7).toInt(),
      (primaryColor.blue * 0.7).toInt(),
    );

    return Course(
      id: map['courseId'] ?? map['_id'] ?? '',
      name: map['title'] ?? '',
      fullName: map['description'] ?? '',
      icon: _getIconData(map['icon']),
      gradientColors: [primaryColor, secondaryColor],
      topics: topics,
    );
  }

  static IconData _getIconData(String? iconStr) {
    switch (iconStr) {
      case '📚': return Icons.menu_book_rounded;
      case '🌳': return Icons.account_tree_rounded;
      case '🎯': return Icons.track_changes_rounded;
      case '⚡': return Icons.bolt_rounded;
      case '☕': return Icons.coffee_rounded;
      case '🗄️': return Icons.storage_rounded;
      case '🌐': return Icons.public_rounded;
      default: return Icons.quiz_rounded;
    }
  }
}

class Topic {
  final String id;
  final String name;
  final int totalQuestions;
  final int completedQuestions;
  final bool quizTaken;
  final int? score;
  final String difficulty;

  Topic({
    required this.id,
    required this.name,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.quizTaken,
    this.score,
    required this.difficulty,
  });

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] ?? map['_id'] ?? '',
      name: map['name'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 10, // Default for now
      completedQuestions: map['completedQuestions'] ?? 0,
      quizTaken: map['quizTaken'] ?? false,
      score: map['score'],
      difficulty: map['difficulty'] ?? 'Medium',
    );
  }

  double get progress => totalQuestions == 0 ? 0 : completedQuestions / totalQuestions;
}
