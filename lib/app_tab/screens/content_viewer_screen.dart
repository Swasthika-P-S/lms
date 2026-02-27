import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_service.dart';
import '../services/download_service.dart';
import '../utils/colors.dart';
import '../../widgets/video_player_widget.dart';

class ContentViewerScreen extends StatefulWidget {
  final Lesson lesson;
  final Course course;

  const ContentViewerScreen({
    Key? key,
    required this.lesson,
    required this.course,
  }) : super(key: key);

  @override
  State<ContentViewerScreen> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  final CourseService _courseService = CourseService();
  final DownloadService _downloadService = DownloadService();
  bool showNotes = false;
  late Lesson currentLesson;

  @override
  void initState() {
    super.initState();
    currentLesson = widget.lesson;
  }

  Future<void> _markAsComplete() async {
    await _courseService.markLessonComplete(widget.lesson.id, widget.course.id);

    setState(() {
      currentLesson = currentLesson.copyWith(isCompleted: true);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson marked as complete!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _handleDownload() async {
    if (currentLesson.isDownloaded) {
      await _downloadService.removeDownload(currentLesson);
      setState(() {
        currentLesson = currentLesson.copyWith(isDownloaded: false);
      });
    } else {
      await _downloadService.downloadLesson(currentLesson);
      setState(() {
        currentLesson = currentLesson.copyWith(isDownloaded: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
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
        title: Text(
          currentLesson.title,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showNotes ? Icons.videocam : Icons.notes,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              setState(() {
                showNotes = !showNotes;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: showNotes 
                ? _buildNotesView(context, isDarkMode) 
                : _buildVideoPlayer(),
          ),
          _buildControlBar(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    // If the lesson has a valid video URL, show the player
    if (currentLesson.videoUrl.isNotEmpty && 
        (currentLesson.videoUrl.contains('youtube.com') || 
         currentLesson.videoUrl.contains('youtu.be'))) {
      return Container(
        color: Colors.black,
        child: Center(
          child: VideoPlayerWidget(
          key: ValueKey(currentLesson.id),
          videoUrl: currentLesson.videoUrl,
          autoPlay: true,
        ),
        ),
      );
    }
    
    // Otherwise, show placeholder
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                currentLesson.title,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentLesson.duration,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No video URL available',
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 8),
            Text(
              currentLesson.videoUrl.isEmpty 
                  ? 'Please add a video URL to this lesson'
                  : 'Please provide a valid YouTube URL',
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesView(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.getBackground(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson Notes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentLesson.notes.isEmpty
                  ? 'No notes available for this lesson.'
                  : currentLesson.notes,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Key Takeaways',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint(context, 'Understanding core concepts', isDarkMode),
            _buildBulletPoint(context, 'Practical implementation strategies', isDarkMode),
            _buildBulletPoint(context, 'Best practices and tips', isDarkMode),
            _buildBulletPoint(context, 'Common pitfalls to avoid', isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar(BuildContext context, bool isDarkMode) {
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: currentLesson.isCompleted ? null : _markAsComplete,
                icon: Icon(
                  currentLesson.isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: Text(
                  currentLesson.isCompleted ? 'Completed' : 'Mark as Complete',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentLesson.isCompleted
                      ? AppColors.success
                      : AppColors.primary,
                  disabledBackgroundColor: AppColors.success.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _handleDownload,
                icon: Icon(
                  currentLesson.isDownloaded 
                      ? Icons.download_done 
                      : Icons.download,
                  color: currentLesson.isDownloaded
                      ? AppColors.primary
                      : AppColors.getTextPrimary(context),
                ),
                padding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}