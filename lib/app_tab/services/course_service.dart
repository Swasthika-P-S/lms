import '../models/course.dart';
import '../models/lesson.dart';
import 'database_helper.dart';

class CourseService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Get all courses
  Future<List<Course>> getAllCourses() async {
    return await _dbHelper.readAllCourses();
  }

  // Get course by ID
  Future<Course?> getCourseById(String id) async {
    return await _dbHelper.readCourse(id);
  }

  // Get enrolled courses
  Future<List<Course>> getEnrolledCourses(String userId) async {
    return await _dbHelper.readEnrolledCourses(userId);
  }

  // Enroll in course
  Future<void> enrollInCourse(String userId, String courseId) async {
    final course = await _dbHelper.readCourse(courseId);
    if (course != null) {
      final updatedCourse = course.copyWith(isEnrolled: true);
      await _dbHelper.updateCourse(updatedCourse);
    }
  }

  // Get lessons for course
  Future<List<Lesson>> getLessonsForCourse(String courseId) async {
    return await _dbHelper.readLessonsByCourse(courseId);
  }

  // Mark lesson as complete
  Future<void> markLessonComplete(String lessonId, String courseId) async {
    final lessons = await _dbHelper.readLessonsByCourse(courseId);
    final lesson = lessons.firstWhere((l) => l.id == lessonId);

    final updatedLesson = lesson.copyWith(isCompleted: true);
    await _dbHelper.updateLesson(updatedLesson);

    // Update course progress
    final completedLessons = lessons.where((l) => l.isCompleted).length + 1;
    final course = await _dbHelper.readCourse(courseId);

    if (course != null) {
      final progress = completedLessons / course.totalLessons;
      final updatedCourse = course.copyWith(
        progress: progress,
        completedLessons: completedLessons,
      );
      await _dbHelper.updateCourse(updatedCourse);
    }
  }

  // Get sample data (for testing)
  List<Course> getSampleCourses() {
    return [
      Course(
        id: '1',
        title: 'Data Structures & Algorithms',
        instructor: 'Dr. Rahul Verma',
        thumbnail: '📊',
        progress: 0.30,
        totalLessons: 3,
        completedLessons: 1,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '5h 21m',
        description: 'Core data structures and algorithmic problem solving',
        tags: ['DSA', 'Algorithms'],
      ),
      Course(
        id: '2',
        title: 'C Programming',
        instructor: 'Prof. Arjun Mehta',
        thumbnail: '⚡',
        progress: 0.0,
        totalLessons: 3,
        completedLessons: 0,
        category: 'Programming',
        isEnrolled: false,
        duration: '1h 45m',
        description: 'Master the fundamentals of C programming',
        tags: ['C', 'Programming'],
      ),
      Course(
        id: '3',
        title: 'Object Oriented Programming',
        instructor: 'Dr. Pooja Nair',
        thumbnail: '🎯',
        progress: 0.0,
        totalLessons: 3,
        completedLessons: 0,
        category: 'Programming',
        isEnrolled: false,
        duration: '1h 15m',
        description: 'Learn OOP principles and design patterns',
        tags: ['OOP', 'Software Design'],
      ),

    ];
  }

  List<Lesson> getSampleLessons(String courseId) {
    if (courseId == '1') {
      // DSA Lessons
      return [
        Lesson(
          id: 'dsa_1',
          courseId: '1',
          title: 'Introduction to Algorithms',
          type: 'video',
          duration: '1:57:44',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=0&end=7064', // freeCodeCamp (WORKING)
          notes: 'Algorithms and how they are measured and evaluated.',
          order: 1,
        ),
        Lesson(
          id: 'dsa_2',
          courseId: '1',
          title: 'Introduction to Data Structures',
          type: 'video',
          duration: '2:13:18',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=7064&end=15062', // freeCodeCamp (WORKING)
          notes: 'Understanding arrays, linked lists, and other foundational data structures.',
          order: 2,
        ),
        Lesson(
          id: 'dsa_3',
          courseId: '1',
          title: 'Algorithms: Sorting and Searching',
          type: 'video',
          duration: '1:10:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=15062', // freeCodeCamp (WORKING)
          notes: 'A deep dive into sorting and searching algorithms like Merge Sort.',
          order: 3,
        ),
      ];
    } else if (courseId == '2') {
      // C Programming Lessons
      return [
        Lesson(
          id: 'c_1',
          courseId: '2',
          title: 'Introduction & Setup',
          type: 'video',
          duration: '35:00',
          isCompleted: true,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=KJgsSFOSQv0&start=0&end=2100', // 0:00 to 35:00
          notes: 'Setting up the C compiler and printing "Hello World".',
          order: 1,
        ),
        Lesson(
          id: 'c_2',
          courseId: '2',
          title: 'Variables, Data Types, and printf',
          type: 'video',
          duration: '25:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=KJgsSFOSQv0&start=2100&end=3600', // 35:00 to 1:00:00
          notes: 'Understanding data types and printing memory formats.',
          order: 2,
        ),
        Lesson(
          id: 'c_3',
          courseId: '2',
          title: 'Pointers & Memory Addresses',
          type: 'video',
          duration: '45:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=KJgsSFOSQv0&start=10680&end=13380', // Approximate pointer section
          notes: 'Deep dive into memory management with pointers.',
          order: 3,
        ),
      ];
    } else if (courseId == '3') {
      // OOP Lessons
      return [
        Lesson(
          id: 'oops_1',
          courseId: '3',
          title: 'Classes and Objects',
          type: 'video',
          duration: '18:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=wN0x9eZLix4&start=0&end=1080',
          notes: 'Defining and instantiating your first class.',
          order: 1,
        ),
        Lesson(
          id: 'oops_2',
          courseId: '3',
          title: 'Constructors, Setters, Getters',
          type: 'video',
          duration: '22:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=wN0x9eZLix4&start=1080&end=2400',
          notes: 'Managing access modifiers and initialization state.',
          order: 2,
        ),
        Lesson(
          id: 'oops_3',
          courseId: '3',
          title: 'Encapsulation & Inheritance',
          type: 'video',
          duration: '35:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=wN0x9eZLix4&start=2400&end=4500', 
          notes: 'Extending classes and protecting data.',
          order: 3,
        ),
      ];
    }
    return [];
  }
}
