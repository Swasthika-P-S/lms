import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/submission.dart';
import '../logic/assignment_service.dart';
import '../core/app_colors.dart';

class SubmissionsListScreen extends StatelessWidget {
  final String assignmentId;
  final AssignmentService _service = AssignmentService();

  SubmissionsListScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Submissions'), backgroundColor: AppColors.card),
      body: StreamBuilder<List<Submission>>(
        stream: _service.getSubmissionsByAssignment(assignmentId),
        builder: (context, snapshot) {
          final submissions = snapshot.data ?? [];
          if (submissions.isEmpty) {
            return Center(child: Text('No submissions yet', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.builder(
            itemCount: submissions.length,
            padding: const EdgeInsets.all(AppConstants.spacing),
            itemBuilder: (context, i) => _buildCard(context, submissions[i]),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, Submission sub) {
    Color chipColor;
    switch (sub.status) {
      case 'late': chipColor = AppColors.warning; break;
      case 'graded': chipColor = AppColors.success; break;
      default: chipColor = AppColors.primary;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing),
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        title: Text(sub.studentName, style: const TextStyle(color: AppColors.textPrimary)),
        subtitle: Text('Submitted: ${DateFormat('MMM dd, HH:mm').format(sub.submittedAt)}',
            style: TextStyle(color: AppColors.textSecondary)),
        trailing: Chip(label: Text(sub.score != null ? '${sub.score} pts' : sub.status), backgroundColor: chipColor),
        onTap: () async {
          final scoreCtrl = TextEditingController(text: sub.score?.toString() ?? '100');
          final feedbackCtrl = TextEditingController(text: sub.feedback ?? '');
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Grade Submission'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: scoreCtrl, decoration: const InputDecoration(labelText: 'Score')),
                  TextField(controller: feedbackCtrl, decoration: const InputDecoration(labelText: 'Feedback')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
              ],
            ),
          );
          if (result == true) {
            final score = int.tryParse(scoreCtrl.text) ?? 100;
            await AssignmentService().gradeSubmission(sub.id, score, feedbackCtrl.text);
          }
        },
      ),
    );
  }
}
