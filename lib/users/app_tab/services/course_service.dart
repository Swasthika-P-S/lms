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
        totalLessons: 3,
        completedLessons: 1,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '5h 21m',
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
        id: '10', // Changed to match "C Programming" mapping
        title: 'C Programming for Beginners',
        instructor: 'Dr. Rahul Verma',
        thumbnail: '💻',
        progress: 0.10,
        totalLessons: 3,
        completedLessons: 1,
        category: 'Computer Science',
        isEnrolled: false,
        duration: '1h 45m',
        description: 'Learn C programming from scratch. Variables, loops, pointers.',
        tags: ['C', 'Programming'],
      ),
      Course(
        id: '11', // Changed to match "OOPS" mapping
        title: 'Object Oriented Programming in C++',
        instructor: 'Prof. Ananya Iyer',
        thumbnail: '📦',
        progress: 0.00,
        totalLessons: 3,
        completedLessons: 0,
        category: 'Computer Science',
        isEnrolled: true,
        duration: '1h 15m',
        description: 'Master Object Oriented Programming principles.',
        tags: ['OOPS', 'C++'],
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
    if (courseId == '3' || courseId == 'dsa') { // DSA
      return [
        Lesson(
          id: 'dsa_1',
          courseId: courseId,
          title: 'Introduction to Algorithms',
          type: 'video',
          duration: '1:57:44',
          isCompleted: true,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=0&end=7064',
          notes: 'Algorithms and how they are measured and evaluated.',
          order: 1,
        ),
        Lesson(
          id: 'dsa_2',
          courseId: courseId,
          title: 'Introduction to Data Structures',
          type: 'video',
          duration: '2:13:18',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=7064&end=15062',
          notes: 'Understanding arrays, linked lists, and other foundational data structures.',
          order: 2,
        ),
        Lesson(
          id: 'dsa_3',
          courseId: courseId,
          title: 'Algorithms: Sorting and Searching',
          type: 'video',
          duration: '1:10:00',
          isCompleted: false,
          isDownloaded: false,
          videoUrl: 'https://www.youtube.com/watch?v=8hly31xKli0&start=15062',
          notes: 'A deep dive into sorting and searching algorithms like Merge Sort.',
          order: 3,
        ),
      ];
    } else if (courseId == '10' || courseId == 'cpp' || courseId == 'c') { // C / C++ Programming
      return [
        Lesson(
          id: 'c_1',
          courseId: courseId,
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
          courseId: courseId,
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
          courseId: courseId,
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
    } else if (courseId == '11' || courseId == 'oops' || courseId == 'oop') { // OOPS
      return [
        Lesson(
          id: 'oops_1',
          courseId: courseId,
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
          courseId: courseId,
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
          courseId: courseId,
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
