import 'package:cloud_firestore/cloud_firestore.dart';

/// Progress model for tracking user progress in topics
class ProgressModel {
  final String id;
  final String topicId;
  final List<String> solvedProblems;
  final int totalSolved;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  
  ProgressModel({
    required this.id,
    required this.topicId,
    required this.solvedProblems,
    required this.totalSolved,
    this.createdAt,
    this.lastUpdated,
  });
  
  factory ProgressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProgressModel(
      id: id,
      topicId: data['topicId'] ?? '',
      solvedProblems: List<String>.from(data['solvedProblems'] ?? []),
      totalSolved: data['totalSolved'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'solvedProblems': solvedProblems,
      'totalSolved': totalSolved,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }
  
  bool isProblemSolved(String problemId) {
    return solvedProblems.contains(problemId);
  }
}
