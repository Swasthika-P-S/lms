import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../models/question_model.dart';
import '../../home_tab/utils/theme.dart';
import '../../app_tab/utils/colors.dart';

class ManageQuestionsScreen extends StatefulWidget {
  const ManageQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedTopic;
  List<String> _topics = [];
  List<QuestionModel> _questions = [];
  bool _isLoading = false;
  bool _isTopicsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() => _isTopicsLoading = true);
    final topics = await _firestoreService.getAllQuizTopics();
    setState(() {
      _topics = topics;
      _isTopicsLoading = false;
      if (_topics.isNotEmpty && _selectedTopic == null) {
        _selectedTopic = _topics[0];
        _loadQuestions();
      }
    });
  }

  Future<void> _loadQuestions() async {
    if (_selectedTopic == null) return;
    setState(() => _isLoading = true);
    final questions = await _firestoreService.getQuestions(_selectedTopic!);
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  Future<void> _deleteQuestion(String questionId) async {
    try {
      await _firestoreService.deleteQuestion(_selectedTopic!, questionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question deleted successfully')),
      );
      _loadQuestions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showAddTopicDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Quiz Topic'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Topic ID (e.g., "recursion")',
            hintText: 'Use lowercase and hyphens',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final topicId = controller.text.trim().toLowerCase();
                await FirebaseFirestore.instance.collection('quizzes').doc(topicId).set({
                  'lastUpdated': FieldValue.serverTimestamp(),
                  'name': topicId[0].toUpperCase() + topicId.substring(1),
                });
                Navigator.pop(context);
                _loadTopics();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddQuestionDialog() {
    final formKey = GlobalKey<FormState>();
    final questionController = TextEditingController();
    final optionAController = TextEditingController();
    final optionBController = TextEditingController();
    final optionCController = TextEditingController();
    final optionDController = TextEditingController();
    final explanationController = TextEditingController();
    final codeSnippetController = TextEditingController();
    int correctOptionIndex = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Question to $_selectedTopic'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question Text'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: codeSnippetController,
                    decoration: const InputDecoration(labelText: 'Code Snippet (Optional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: optionAController,
                    decoration: const InputDecoration(labelText: 'Option A'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: optionBController,
                    decoration: const InputDecoration(labelText: 'Option B'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: optionCController,
                    decoration: const InputDecoration(labelText: 'Option C'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: optionDController,
                    decoration: const InputDecoration(labelText: 'Option D'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: correctOptionIndex,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Option A')),
                      DropdownMenuItem(value: 1, child: Text('Option B')),
                      DropdownMenuItem(value: 2, child: Text('Option C')),
                      DropdownMenuItem(value: 3, child: Text('Option D')),
                    ],
                    onChanged: (v) => setDialogState(() => correctOptionIndex = v!),
                    decoration: const InputDecoration(labelText: 'Correct Answer'),
                  ),
                  TextFormField(
                    controller: explanationController,
                    decoration: const InputDecoration(labelText: 'Explanation'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newQuestion = QuestionModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    topicId: _selectedTopic!,
                    questionText: questionController.text,
                    options: [
                      optionAController.text,
                      optionBController.text,
                      optionCController.text,
                      optionDController.text,
                    ],
                    correctOptionIndex: correctOptionIndex,
                    explanation: explanationController.text,
                    codeSnippet: codeSnippetController.text.isEmpty ? null : codeSnippetController.text,
                  );

                  try {
                    // Update the DataSeeder to support direct adding or just use Firestore directly
                    final questionsCol = FirebaseFirestore.instance
                        .collection('quizzes')
                        .doc(_selectedTopic)
                        .collection('questions');
                    
                    await questionsCol.doc(newQuestion.id).set(newQuestion.toMap());
                    
                    Navigator.pop(context);
                    _loadQuestions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Question added!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Quiz Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTopics,
          ),
        ],
      ),
      body: Column(
        children: [
          // Topic Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Topic: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: _isTopicsLoading
                      ? const LinearProgressIndicator()
                      : DropdownButton<String>(
                          value: _selectedTopic,
                          isExpanded: true,
                          items: _topics
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedTopic = v;
                              _loadQuestions();
                            });
                          },
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                  onPressed: _showAddTopicDialog,
                  tooltip: 'Add New Topic',
                ),
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _questions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('No questions found for $_selectedTopic'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final q = _questions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(q.questionText, maxLines: 2, overflow: TextOverflow.ellipsis),
                              subtitle: Text('Options: ${q.options.length} | CorrectIdx: ${q.correctOptionIndex}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _deleteQuestion(q.id),
                              ),
                              onTap: () {
                                // TODO: Implement edit
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedTopic == null ? null : _showAddQuestionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
