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
        totalLessons: 25,
        completedLessons: 7,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '12h 20m',
        description: 'Core data structures and algorithmic problem solving',
        tags: ['DSA', 'Algorithms'],
      ),
      Course(
        id: '2',
        title: 'C Programming',
        instructor: 'Prof. Arjun Mehta',
        thumbnail: '⚡',
        progress: 0.0,
        totalLessons: 20,
        completedLessons: 0,
        category: 'Programming',
        isEnrolled: false,
        duration: '10h 00m',
        description: 'Master the fundamentals of C programming',
        tags: ['C', 'Programming'],
      ),
      Course(
        id: '3',
        title: 'Object Oriented Programming',
        instructor: 'Dr. Pooja Nair',
        thumbnail: '🎯',
        progress: 0.0,
        totalLessons: 15,
        completedLessons: 0,
        category: 'Programming',
        isEnrolled: false,
        duration: '8h 30m',
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
          title: 'C Programming for Beginners',
          type: 'video',
          duration: '20:10',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=KJgsSFOSQv0', // mycodeschool (WORKING)
          notes: 'C is a general-purpose programming language that provides low-level access to memory.',
          order: 1,
        ),
        Lesson(
          id: 'c_2',
          courseId: '2',
          title: 'Variables and Constants',
          type: 'video',
          duration: '10:15',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=h4VBpylsjJc', // Programiz - C Variables (Embeddable)
          notes: 'Variables are used to store data that can be changed.',
          order: 2,
        ),
        Lesson(
          id: 'c_3',
          courseId: '2',
          title: 'Control Flow: Loops & Logic',
          type: 'video',
          duration: '15:45',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=KnvbUiSxvbM', // Programiz - C Loops (Embeddable)
          notes: 'Control flow statements like if-else and loops (for, while) allow you to control execution.',
          order: 3,
        ),
      ];
    } else if (courseId == '3') {
      // OOP Lessons
      return [
        Lesson(
          id: 'oop_1',
          courseId: '3',
          title: 'The Four Pillars of OOP',
          type: 'video',
          duration: '12:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=g5JpCqQG3eE', // Best Animation (WORKING)
          notes: 'The four main principles of Object-Oriented Programming are Encapsulation, Abstraction, Inheritance, and Polymorphism.',
          order: 1,
        ),
        Lesson(
          id: 'oop_2',
          courseId: '3',
          title: 'Inheritance and Polymorphism',
          type: 'video',
          duration: '14:30',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=uXAtInwVveA', // WORKING
          notes: 'Inheritance allows a class to inherit properties from another.',
          order: 2,
        ),
        Lesson(
          id: 'oop_3',
          courseId: '3',
          title: 'Encapsulation in Action',
          type: 'video',
          duration: '11:15',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=T3C_JcM_8s', // WORKING
          notes: 'Encapsulation is the bundling of data with methods.',
          order: 3,
        ),
      ];
    }
    return [];
  }
}
