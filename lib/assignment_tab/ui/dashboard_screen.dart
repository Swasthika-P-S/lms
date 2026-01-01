import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../logic/assignment_service.dart';
import '../logic/notification_service.dart';
import '../data/assignment.dart';
import 'assignment_list_screen.dart';
import 'qr_generator_screen.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String courseId;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.courseId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AssignmentService _assignmentService = AssignmentService();
  final NotificationService _notificationService = NotificationService();

  String? _lastNotificationTitle;
  String? _lastNotificationBody;

  @override
  void initState() {
    super.initState();
    _notificationService.register((title, body) {
      setState(() {
        _lastNotificationTitle = title;
        _lastNotificationBody = body;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$title • $body')));
    });

    _seedDemoAssignments(); // 👈 Add demo assignments
  }

  Future<void> _seedDemoAssignments() async {
    final existing = await _assignmentService.getAssignmentsByCourse(widget.courseId).first;
    if (existing.isNotEmpty) return;

    final now = DateTime.now();

    await _assignmentService.createAssignment(Assignment(
      id: '',
      courseId: widget.courseId,
      title: 'Intro to Dart',
      description: 'Read the Dart language tour and summarize key features.',
      deadline: now.add(const Duration(days: 2)),
      maxScore: 100,
      createdAt: now,
      createdBy: 'instructor1',
    ));

    await _assignmentService.createAssignment(Assignment(
      id: '',
      courseId: widget.courseId,
      title: 'Flutter Widgets',
      description: 'Build a small app using layout and stateful widgets.',
      deadline: now.add(const Duration(days: 5)),
      maxScore: 100,
      createdAt: now,
      createdBy: 'instructor1',
    ));

    await _assignmentService.createAssignment(Assignment(
      id: '',
      courseId: widget.courseId,
      title: 'QR Integration',
      description: 'Implement QR code generation and scanning in your LMS module.',
      deadline: now.add(const Duration(days: 7)),
      maxScore: 100,
      createdAt: now,
      createdBy: 'instructor1',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Text('${AppConstants.appName} - ${widget.userName}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacing),
        children: [
          _quickActions(context),
          const SizedBox(height: AppConstants.spacing),
          if (_lastNotificationTitle != null) _notificationCard(),
          const SizedBox(height: AppConstants.spacing),
          _deadlines(context),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionTile(Icons.list, AppColors.accent, 'Assignments', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => AssignmentListScreen(courseId: widget.courseId),
            ));
          }),
        ),
        const SizedBox(width: AppConstants.spacing),
        Expanded(
          child: _actionTile(Icons.qr_code, AppColors.primary, 'Generate QR', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => QRGeneratorScreen(courseId: widget.courseId),
            ));
          }),
        ),
        const SizedBox(width: AppConstants.spacing),
        Expanded(
          child: _actionTile(Icons.qr_code_scanner, AppColors.warning, 'Join via QR', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => QRScannerScreen(
                expectedCourseId: widget.courseId,
                userId: 'currentUser',
              ),
            ));
          }),
        ),
      ],
    );
  }

  Widget _actionTile(IconData icon, Color color, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.success.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${_lastNotificationTitle ?? ''}\n${_lastNotificationBody ?? ''}',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deadlines(BuildContext context) {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getUpcomingDeadlines(widget.courseId),
      builder: (context, snap) {
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Text('No upcoming deadlines',
                style: TextStyle(color: AppColors.textSecondary)),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((a) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppConstants.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: a.isOverdue ? AppColors.accent : AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${a.title} • ${a.formattedDeadline}',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                Text('${a.maxScore} pts',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          )).toList(),
        );
      },
    );
  }
}
