import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../models/enrollment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('learnhub.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Courses table
    await db.execute('''
      CREATE TABLE courses (
        id $idType,
        title $textType,
        instructor $textType,
        thumbnail $textType,
        progress $realType,
        totalLessons $intType,
        completedLessons $intType,
        category $textType,
        isEnrolled $intType,
        duration $textType,
        description TEXT,
        tags TEXT
      )
    ''');

    // Lessons table
    await db.execute('''
      CREATE TABLE lessons (
        id $idType,
        courseId $textType,
        title $textType,
        type $textType,
        duration $textType,
        isCompleted $intType,
        isDownloaded $intType,
        videoUrl TEXT,
        notes TEXT,
        "order" $intType,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');

    // Enrollments table
    await db.execute('''
      CREATE TABLE enrollments (
        id $idType,
        userId $textType,
        courseId $textType,
        enrolledAt $textType,
        lastAccessedAt TEXT,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');
  }

  // Course CRUD operations
  Future<Course> createCourse(Course course) async {
    final db = await database;
    await db.insert('courses', course.toJson());
    return course;
  }

  Future<Course?> readCourse(String id) async {
    final db = await database;
    final maps = await db.query('courses', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Course.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Course>> readAllCourses() async {
    final db = await database;
    final result = await db.query('courses', orderBy: 'title ASC');
    return result.map((json) => Course.fromJson(json)).toList();
  }

  Future<int> updateCourse(Course course) async {
    final db = await database;
    return db.update(
      'courses',
      course.toJson(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(String id) async {
    final db = await database;
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  // Lesson CRUD operations
  Future<Lesson> createLesson(Lesson lesson) async {
    final db = await database;
    await db.insert('lessons', lesson.toJson());
    return lesson;
  }

  Future<List<Lesson>> readLessonsByCourse(String courseId) async {
    final db = await database;
    final result = await db.query(
      'lessons',
      where: 'courseId = ?',
      whereArgs: [courseId],
      orderBy: '"order" ASC',
    );
    return result.map((json) => Lesson.fromJson(json)).toList();
  }

  Future<int> updateLesson(Lesson lesson) async {
    final db = await database;
    return db.update(
      'lessons',
      lesson.toJson(),
      where: 'id = ?',
      whereArgs: [lesson.id],
    );
  }

  // Enrollment operations
  Future<Enrollment> createEnrollment(Enrollment enrollment) async {
    final db = await database;
    await db.insert('enrollments', enrollment.toJson());
    return enrollment;
  }

  Future<List<Course>> readEnrolledCourses(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT c.* FROM courses c
      INNER JOIN enrollments e ON c.id = e.courseId
      WHERE e.userId = ?
      ORDER BY e.lastAccessedAt DESC
    ''',
      [userId],
    );
    return result.map((json) => Course.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
