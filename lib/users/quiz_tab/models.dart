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

  double get progress => completedQuestions / totalQuestions;
}
