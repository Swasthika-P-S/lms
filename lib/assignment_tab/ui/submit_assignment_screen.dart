import 'package:flutter/material.dart';
import '../data/assignment.dart';
import '../data/submission.dart';
import '../logic/assignment_service.dart';
import '../core/app_colors.dart';

class SubmitAssignmentScreen extends StatefulWidget {
  final Assignment assignment;
  const SubmitAssignmentScreen({super.key, required this.assignment});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isOverdue = widget.assignment.isOverdue;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Submit Assignment'), backgroundColor: AppColors.card),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          children: [
            if (isOverdue)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('This submission will be marked as late.',
                    style: TextStyle(color: AppColors.warning)),
              ),
            Expanded(
              child: TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Your Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: AppConstants.spacing),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide an answer')));
      return;
    }
    setState(() => _isLoading = true);
    final submission = Submission(
      id: '',
      assignmentId: widget.assignment.id,
      studentId: 'currentStudent',
      studentName: 'Current Student',
      content: _contentController.text.trim(),
      submittedAt: DateTime.now(),
      status: widget.assignment.isOverdue ? 'late' : 'submitted',
    );
    await AssignmentService().submitAssignment(submission);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
