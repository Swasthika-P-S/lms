/// Model for quiz questions
class QuestionModel {
  final String id;
  final String topicId;
  final String courseId;
  final String questionText;
  final String? codeSnippet;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuestionModel({
    required this.id,
    required this.topicId,
    this.courseId = '',
    required this.questionText,
    this.codeSnippet,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuestionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuestionModel(
      id: id,
      topicId: data['topicId'] ?? '',
      courseId: data['courseId'] ?? '',
      questionText: data['questionText'] ?? '',
      codeSnippet: data['codeSnippet'],
      options: List<String>.from(data['options'] ?? []),
      correctOptionIndex: data['correctOptionIndex'] ?? 0,
      explanation: data['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'courseId': courseId,
      'questionText': questionText,
      'codeSnippet': codeSnippet,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }
}
