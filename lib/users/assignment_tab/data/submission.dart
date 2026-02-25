class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String? content;
  final DateTime submittedAt;
  final int? score;
  final String? feedback;
  final String status;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    this.content,
    required this.submittedAt,
    this.score,
    this.feedback,
    required this.status,
  });

  Submission copyWith({
    int? score,
    String? feedback,
    String? status,
  }) {
    return Submission(
      id: id,
      assignmentId: assignmentId,
      studentId: studentId,
      studentName: studentName,
      content: content,
      submittedAt: submittedAt,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      status: status ?? this.status,
    );
  }
}
