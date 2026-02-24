import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for learning management system
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String role;
  final UserStats stats;
  final UserPreferences preferences;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  
  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.role = 'student',
    required this.stats,
    required this.preferences,
    this.createdAt,
    this.lastLogin,
  });
  
  /// Check if user is admin
  bool get isAdmin => role == 'admin';
  
  /// Helper for UI
  String get name => displayName;
  String get uid => id;

  /// Get initials from name
  String getInitials() {
    if (displayName.isEmpty) return 'U';
    List<String> names = displayName.trim().split(' ');
    if (names.length > 1) {
      return (names[0][0] + names[names.length - 1][0]).toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  // Proxy getters for stats
  int get coursesCompleted => stats.coursesCompleted;
  int get totalHours => stats.totalHours;
  double get progressPercentage => stats.progressPercentage;
  
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'Student',
      photoURL: data['photoURL'],
      role: data['role'] ?? 'student',
      stats: UserStats.fromMap(data['stats'] ?? {}),
      preferences: UserPreferences.fromMap(data['preferences'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'stats': stats.toMap(),
      'preferences': preferences.toMap(),
      'lastLogin': FieldValue.serverTimestamp(),
    };
  }
}

/// User statistics for progress tracking
class UserStats {
  final int totalProblems;
  final int solvedProblems;
  final int totalScore;
  final int streak;
  final int coursesCompleted;
  final int totalHours;
  final double progressPercentage;
  
  UserStats({
    this.totalProblems = 0,
    this.solvedProblems = 0,
    this.totalScore = 0,
    this.streak = 0,
    this.coursesCompleted = 0,
    this.totalHours = 0,
    this.progressPercentage = 0.0,
  });
  
  factory UserStats.fromMap(Map<String, dynamic> data) {
    return UserStats(
      totalProblems: data['totalProblems'] ?? 0,
      solvedProblems: data['solvedProblems'] ?? 0,
      totalScore: data['totalScore'] ?? 0,
      streak: data['streak'] ?? 0,
      coursesCompleted: data['coursesCompleted'] ?? 0,
      totalHours: data['totalHours'] ?? 0,
      progressPercentage: (data['progressPercentage'] ?? 0.0).toDouble(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'totalProblems': totalProblems,
      'solvedProblems': solvedProblems,
      'totalScore': totalScore,
      'streak': streak,
      'coursesCompleted': coursesCompleted,
      'totalHours': totalHours,
      'progressPercentage': progressPercentage,
    };
  }
  
  double get completionRate {
    if (totalProblems == 0) return 0.0;
    return (solvedProblems / totalProblems) * 100;
  }
}

/// User preferences
class UserPreferences {
  final String theme;
  final bool notifications;
  
  UserPreferences({
    this.theme = 'system',
    this.notifications = true,
  });
  
  factory UserPreferences.fromMap(Map<String, dynamic> data) {
    return UserPreferences(
      theme: data['theme'] ?? 'system',
      notifications: data['notifications'] ?? true,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'theme': theme,
      'notifications': notifications,
    };
  }
}
