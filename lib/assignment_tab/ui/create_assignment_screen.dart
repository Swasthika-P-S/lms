import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/assignment.dart';
import '../logic/assignment_service.dart';
import '../core/app_colors.dart';

class CreateAssignmentScreen extends StatefulWidget {
  final String courseId;
  const CreateAssignmentScreen({super.key, required this.courseId});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _scoreController = TextEditingController(text: '100');
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Assignment'), backgroundColor: AppColors.card),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacing),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppConstants.spacing),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppConstants.spacing),
            TextFormField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'Max Score', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppConstants.spacing),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(_deadline)),
              trailing: const Icon(Icons.calendar_today, color: AppColors.warning),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: AppConstants.spacing),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _create,
              child: const Text('Create Assignment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline),
      );
      if (time != null) {
        setState(() {
          _deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    final assignment = Assignment(
      id: '',
      courseId: widget.courseId,
      title: _titleController.text,
      description: _descController.text,
      deadline: _deadline,
      maxScore: int.parse(_scoreController.text),
      createdAt: DateTime.now(),
      createdBy: 'currentUser',
    );
    await AssignmentService().createAssignment(assignment);
    Navigator.pop(context);
  }
}
