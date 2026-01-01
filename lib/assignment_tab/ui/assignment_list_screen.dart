import 'package:flutter/material.dart';
import '../data/assignment.dart';
import '../logic/assignment_service.dart';
import 'create_assignment_screen.dart';
import 'assignment_detail_screen.dart';
import '../core/app_colors.dart';

class AssignmentListScreen extends StatelessWidget {
  final String courseId;
  final AssignmentService _service = AssignmentService();

  AssignmentListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Assignments'), backgroundColor: AppColors.card),
      body: StreamBuilder<List<Assignment>>(
        stream: _service.getAssignmentsByCourse(courseId),
        builder: (context, snapshot) {
          final assignments = snapshot.data ?? [];
          if (assignments.isEmpty) {
            return Center(
              child: Text('No assignments yet', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            itemCount: assignments.length,
            padding: const EdgeInsets.all(AppConstants.spacing),
            itemBuilder: (context, i) => _buildAssignmentCard(context, assignments[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateAssignmentScreen(courseId: courseId)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, Assignment assignment) {
    final isOverdue = assignment.isOverdue;
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing),
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        title: Text(assignment.title, style: const TextStyle(color: AppColors.textPrimary)),
        subtitle: Text(assignment.description,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.textSecondary)),
        trailing: Icon(isOverdue ? Icons.warning : Icons.calendar_today,
            color: isOverdue ? AppColors.accent : AppColors.primary),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AssignmentDetailScreen(assignment: assignment)),
        ),
      ),
    );
  }
}
