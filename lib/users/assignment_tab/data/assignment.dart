import 'package:intl/intl.dart';

class Assignment {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime deadline;
  final int maxScore;
  final DateTime createdAt;
  final String createdBy;

  Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.maxScore,
    required this.createdAt,
    required this.createdBy,
  });

  bool get isOverdue => DateTime.now().isAfter(deadline);
  Duration get timeRemaining => deadline.difference(DateTime.now());
  String get formattedDeadline =>
      DateFormat('MMM dd, yyyy HH:mm').format(deadline);
}
