class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;
  final DateTime? lastAccessedAt;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
    this.lastAccessedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'enrolledAt': enrolledAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    };
  }

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      enrolledAt: DateTime.parse(json['enrolledAt']),
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
    );
  }
}
