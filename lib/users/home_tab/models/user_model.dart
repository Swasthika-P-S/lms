class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? photoUrl;
  final String language;
  final bool isDarkMode;
  final int coursesCompleted;
  final int totalHours;
  final double progressPercentage;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'student',
    this.photoUrl,
    this.language = 'en',
    this.isDarkMode = true,
    this.coursesCompleted = 0,
    this.totalHours = 0,
    this.progressPercentage = 0.0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'student',
      photoUrl: map['photoUrl'],
      language: map['language'] ?? 'en',
      isDarkMode: map['isDarkMode'] ?? true,
      coursesCompleted: map['coursesCompleted'] ?? 0,
      totalHours: map['totalHours'] ?? 0,
      progressPercentage: (map['progressPercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'language': language,
      'isDarkMode': isDarkMode,
      'coursesCompleted': coursesCompleted,
      'totalHours': totalHours,
      'progressPercentage': progressPercentage,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? language,
    bool? isDarkMode,
    int? coursesCompleted,
    int? totalHours,
    double? progressPercentage,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      totalHours: totalHours ?? this.totalHours,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }

  String getInitials() {
    if (name.isEmpty) return 'U';
    final names = name.split(' ');
    if (names.length == 1) return names[0][0].toUpperCase();
    return (names[0][0] + names[1][0]).toUpperCase();
  }
}
