import 'package:flutter/material.dart';
import '../data/assignment.dart';
import 'submit_assignment_screen.dart';
import 'submissions_list_screen.dart';
import '../core/app_colors.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(assignment.title), backgroundColor: AppColors.card),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assignment.description, style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppConstants.spacing),
            Text('Deadline: ${assignment.formattedDeadline}', style: const TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: AppConstants.spacing),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.upload),
              label: const Text('Submit'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SubmitAssignmentScreen(assignment: assignment)),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('View Submissions'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SubmissionsListScreen(assignmentId: assignment.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
