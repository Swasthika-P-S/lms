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
        title: 'Advanced Flutter Techniques',
        instructor: 'John Doe',
        thumbnail: '🎨',
        progress: 0.75,
        totalLessons: 24,
        completedLessons: 18,
        category: 'Development',
        isEnrolled: true,
        duration: '12h 30m',
        description: 'Master advanced Flutter concepts and techniques',
        tags: ['Flutter', 'Mobile', 'Advanced'],
      ),
      Course(
        id: '2',
        title: 'UI/UX Design Masterclass',
        instructor: 'Jane Smith',
        thumbnail: '🎭',
        progress: 0.45,
        totalLessons: 18,
        completedLessons: 8,
        category: 'Design',
        isEnrolled: true,
        duration: '8h 45m',
        description: 'Learn professional UI/UX design principles',
        tags: ['Design', 'UI/UX'],
      ),
      Course(
        id: '3',
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
        id: '4',
        title: 'Operating Systems Fundamentals',
        instructor: 'Prof. Ananya Iyer',
        thumbnail: '🖥️',
        progress: 0.15,
        totalLessons: 20,
        completedLessons: 3,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '10h 10m',
        description: 'Processes, threads, memory management and scheduling',
        tags: ['OS', 'Systems'],
      ),
      Course(
        id: '5',
        title: 'Database Management Systems',
        instructor: 'Dr. Karthik Rao',
        thumbnail: '🗄️',
        progress: 0.55,
        totalLessons: 22,
        completedLessons: 12,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '11h 30m',
        description: 'Relational databases, SQL and normalization concepts',
        tags: ['DBMS', 'SQL'],
      ),
      Course(
        id: '6',
        title: 'Computer Networks',
        instructor: 'Prof. Sneha Kulkarni',
        thumbnail: '🌐',
        progress: 0.20,
        totalLessons: 18,
        completedLessons: 4,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '9h 15m',
        description: 'Networking concepts, TCP/IP, routing and protocols',
        tags: ['Networks', 'TCP/IP'],
      ),
      Course(
        id: '7',
        title: 'Software Engineering',
        instructor: 'Dr. Manoj Kumar',
        thumbnail: '🛠️',
        progress: 0.40,
        totalLessons: 16,
        completedLessons: 6,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '8h 00m',
        description: 'Software development life cycle and process models',
        tags: ['SE', 'SDLC'],
      ),
      Course(
        id: '8',
        title: 'Artificial Intelligence Basics',
        instructor: 'Dr. Pooja Nair',
        thumbnail: '🤖',
        progress: 0.10,
        totalLessons: 20,
        completedLessons: 2,
        category: 'AI & ML',
        isEnrolled: false,
        duration: '10h 50m',
        description: 'Foundations of AI, search techniques and reasoning',
        tags: ['AI', 'ML'],
      ),
      Course(
        id: '9',
        title: 'Cyber Security Essentials',
        instructor: 'Prof. Arjun Mehta',
        thumbnail: '🔐',
        progress: 0.00,
        totalLessons: 15,
        completedLessons: 0,
        category: 'Security',
        isEnrolled: false,
        duration: '7h 30m',
        description: 'Security threats, cryptography and network defense',
        tags: ['Security', 'Cryptography'],
      ),
    ];
  }

  List<Lesson> getSampleLessons(String courseId) {
    return [
      Lesson(
        id: '1',
        courseId: courseId,
        title: 'Introduction to Advanced Flutter',
        type: 'video',
        duration: '12:45',
        isCompleted: true,
        isDownloaded: true,
        videoUrl: 'https://example.com/video1',
        notes: 'Introduction notes here...',
        order: 1,
      ),
      Lesson(
        id: '2',
        courseId: courseId,
        title: 'State Management Basics',
        type: 'video',
        duration: '18:30',
        isCompleted: true,
        isDownloaded: false,
        videoUrl: 'https://example.com/video2',
        notes: 'State management notes...',
        order: 2,
      ),
      Lesson(
        id: '3',
        courseId: courseId,
        title: 'Building Custom Widgets',
        type: 'video',
        duration: '25:15',
        isCompleted: false,
        isDownloaded: false,
        videoUrl: 'https://example.com/video3',
        notes: 'Custom widgets notes...',
        order: 3,
      ),
    ];
  }
}
