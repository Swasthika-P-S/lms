import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_service.dart';
import '../services/download_service.dart';
import '../widgets/lesson_item.dart';
import '../utils/colors.dart';
import 'content_viewer_screen.dart';
import 'package:learnhub/providers/chatbot_provider.dart';
import 'package:learnhub/home_tab/screens/chatbot/chatbot_screen.dart';

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

  /// Map course title/tags to chatbot mode
  String _getChatbotMode(Course course) {
    final title = course.title.toLowerCase();
    final tags = course.tags.map((t) => t.toLowerCase()).toList();
    
    if (title.contains('data structure') || title.contains('algorithm') ||
        tags.contains('dsa') || tags.contains('algorithms')) {
      return 'DSA';
    } else if (title.contains('c programming') || title.contains('c language') ||
        tags.contains('c') || tags.contains('c programming')) {
      return 'C';
    } else if (title.contains('object oriented') || title.contains('oops') || title.contains('oop') ||
        tags.contains('oops') || tags.contains('oop') || tags.contains('object oriented')) {
      return 'OOPs';
    }
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chatbotMode = _getChatbotMode(widget.course);
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCard(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCourseHeader(context, isDarkMode),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : _buildLessonList(context),
          ),
        ],
      ),
      // Course-specific chatbot FAB
      floatingActionButton: chatbotMode != 'General' ? Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, const Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Switch chatbot to this course's mode
              context.read<ChatbotProvider>().switchCourse(chatbotMode);
              
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (ctx, scrollController) => Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF0F0A2A) : const Color(0xFFF0F2FF),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: const ChatbotScreen(),
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ) : null,
      bottomNavigationBar: _buildEnrollButton(context, isDarkMode),
    );
  }

  Widget _buildCourseHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.getCard(context),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By ${currentCourse.instructor}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                context,
                Icons.play_circle_outline,
                '${currentCourse.totalLessons} Lessons',
              ),
              _buildInfoChip(
                context,
                Icons.access_time,
                currentCourse.duration,
              ),
              _buildInfoChip(
                context,
                Icons.signal_cellular_alt,
                'Intermediate',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? AppColors.background 
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(BuildContext context) {
    return Container(
      color: AppColors.getBackground(context),
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

  Widget _buildEnrollButton(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCard(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: currentCourse.isEnrolled
              ? () {
                  if (lessons.isEmpty) return;
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
                }
              : _enrollInCourse,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            currentCourse.isEnrolled ? 'Continue Learning' : 'Enroll Now',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}