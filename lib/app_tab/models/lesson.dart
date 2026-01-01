class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String type;
  final String duration;
  final bool isCompleted;
  final bool isDownloaded;
  final String videoUrl;
  final String notes;
  final int order;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.type = 'video',
    required this.duration,
    this.isCompleted = false,
    this.isDownloaded = false,
    this.videoUrl = '',
    this.notes = '',
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'type': type,
      'duration': duration,
      'isCompleted': isCompleted ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
      'videoUrl': videoUrl,
      'notes': notes,
      'order': order,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      type: json['type'] ?? 'video',
      duration: json['duration'],
      isCompleted: json['isCompleted'] == 1,
      isDownloaded: json['isDownloaded'] == 1,
      videoUrl: json['videoUrl'] ?? '',
      notes: json['notes'] ?? '',
      order: json['order'],
    );
  }

  Lesson copyWith({
    String? id,
    String? courseId,
    String? title,
    String? type,
    String? duration,
    bool? isCompleted,
    bool? isDownloaded,
    String? videoUrl,
    String? notes,
    int? order,
  }) {
    return Lesson(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      videoUrl: videoUrl ?? this.videoUrl,
      notes: notes ?? this.notes,
      order: order ?? this.order,
    );
  }
}
