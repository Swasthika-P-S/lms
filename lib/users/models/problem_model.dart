/// Problem model for coding problems
class ProblemModel {
  final String id;
  final String title;
  final String description;
  final String difficulty; // 'easy', 'medium', 'hard'
  final List<String> tags;
  final String? solutionCode;
  final String? explanation;
  final String? externalLink;
  final int order;
  
  ProblemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tags,
    this.solutionCode,
    this.explanation,
    this.externalLink,
    this.order = 0,
  });
  
  factory ProblemModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProblemModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      difficulty: data['difficulty'] ?? 'medium',
      tags: List<String>.from(data['tags'] ?? []),
      solutionCode: data['solutionCode'],
      explanation: data['explanation'],
      externalLink: data['externalLink'],
      order: data['order'] ?? 0,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'tags': tags,
      'solutionCode': solutionCode,
      'explanation': explanation,
      'externalLink': externalLink,
      'order': order,
    };
  }
  
  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return '#10B981'; // Green
      case 'medium':
        return '#F59E0B'; // Orange
      case 'hard':
        return '#EF4444'; // Red
      default:
        return '#6B7280'; // Gray
    }
  }
}
