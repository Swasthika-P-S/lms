class Course {
  final String id;
  final String title;
  final String instructor;
  final String thumbnail;
  final double progress;
  final int totalLessons;
  final int completedLessons;
  final String category;
  final bool isEnrolled;
  final String duration;
  final String description;
  final List<String> tags;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    this.progress = 0.0,
    required this.totalLessons,
    this.completedLessons = 0,
    required this.category,
    this.isEnrolled = false,
    required this.duration,
    this.description = '',
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'thumbnail': thumbnail,
      'progress': progress,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'category': category,
      'isEnrolled': isEnrolled ? 1 : 0,
      'duration': duration,
      'description': description,
      'tags': tags.join(','),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      instructor: json['instructor'],
      thumbnail: json['thumbnail'],
      progress: json['progress'] ?? 0.0,
      totalLessons: json['totalLessons'],
      completedLessons: json['completedLessons'] ?? 0,
      category: json['category'],
      isEnrolled: json['isEnrolled'] == 1,
      duration: json['duration'],
      description: json['description'] ?? '',
      tags: json['tags'] != null ? (json['tags'] as String).split(',') : [],
    );
  }

  Course copyWith({
    String? id,
    String? title,
    String? instructor,
    String? thumbnail,
    double? progress,
    int? totalLessons,
    int? completedLessons,
    String? category,
    bool? isEnrolled,
    String? duration,
    String? description,
    List<String>? tags,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      thumbnail: thumbnail ?? this.thumbnail,
      progress: progress ?? this.progress,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      category: category ?? this.category,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
