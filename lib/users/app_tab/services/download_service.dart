import '../models/lesson.dart';
import 'database_helper.dart';

class DownloadService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Download lesson for offline access
  Future<void> downloadLesson(Lesson lesson) async {
    // Simulate download process
    await Future.delayed(const Duration(seconds: 2));

    final updatedLesson = lesson.copyWith(isDownloaded: true);
    await _dbHelper.updateLesson(updatedLesson);
  }

  // Remove downloaded lesson
  Future<void> removeDownload(Lesson lesson) async {
    final updatedLesson = lesson.copyWith(isDownloaded: false);
    await _dbHelper.updateLesson(updatedLesson);
  }

  // Check if lesson is downloaded
  Future<bool> isLessonDownloaded(String lessonId) async {
    // Implementation would check local storage
    return false;
  }

  // Get total download size
  Future<double> getTotalDownloadSize(List<Lesson> lessons) async {
    // Calculate total size of downloaded content
    return lessons.where((l) => l.isDownloaded).length * 50.0; // MB
  }
}
