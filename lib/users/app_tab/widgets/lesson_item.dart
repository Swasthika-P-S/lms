import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../utils/colors.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const LessonItem({
    Key? key,
    required this.lesson,
    required this.index,
    required this.onTap,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getCard(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: lesson.isCompleted
                    ? AppColors.primary
                    : (isDarkMode 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: lesson.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: AppColors.getTextSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lesson.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                      if (lesson.isDownloaded) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.download_done,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                lesson.isDownloaded ? Icons.download_done : Icons.download,
                color: lesson.isDownloaded
                    ? AppColors.primary
                    : AppColors.getTextSecondary(context),
              ),
              onPressed: onDownload,
            ),
          ],
        ),
      ),
    );
  }
}