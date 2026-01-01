import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_service.dart';
import '../services/download_service.dart';
import '../widgets/lesson_item.dart';
import '../utils/colors.dart';
import 'content_viewer_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseService _courseService = CourseService();
  final DownloadService _downloadService = DownloadService();
  List<Lesson> lessons = [];
  bool isLoading = true;
  late Course currentCourse;

  @override
  void initState() {
    super.initState();
    currentCourse = widget.course;
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() {
      isLoading = true;
    });

    // For demo purposes, using sample data
    lessons = _courseService.getSampleLessons(widget.course.id);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _enrollInCourse() async {
    await _courseService.enrollInCourse('user123', widget.course.id);
    setState(() {
      currentCourse = currentCourse.copyWith(isEnrolled: true);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully enrolled in course!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _handleDownload(Lesson lesson) async {
    if (lesson.isDownloaded) {
      await _downloadService.removeDownload(lesson);
    } else {
      await _downloadService.downloadLesson(lesson);
    }
    _loadLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildCourseHeader(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildLessonList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildEnrollButton(),
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    currentCourse.thumbnail,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentCourse.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By ${currentCourse.instructor}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoChip(
                Icons.play_circle_outline,
                '${currentCourse.totalLessons} Lessons',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.access_time, currentCourse.duration),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.signal_cellular_alt, 'Intermediate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList() {
    return Container(
      decoration: const BoxDecoration(color: AppColors.background),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return LessonItem(
            lesson: lessons[index],
            index: index,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentViewerScreen(
                    lesson: lessons[index],
                    course: currentCourse,
                  ),
                ),
              ).then((_) => _loadLessons());
            },
            onDownload: () => _handleDownload(lessons[index]),
          );
        },
      ),
    );
  }

  Widget _buildEnrollButton() {
    if (currentCourse.isEnrolled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final firstIncompleteLesson = lessons.firstWhere(
              (l) => !l.isCompleted,
              orElse: () => lessons.first,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentViewerScreen(
                  lesson: firstIncompleteLesson,
                  course: currentCourse,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Continue Learning',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _enrollInCourse,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Enroll Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
