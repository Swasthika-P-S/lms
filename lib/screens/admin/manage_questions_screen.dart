import 'package:flutter/material.dart';
import '../../services/mongo_service.dart';
import '../../models/question_model.dart';
import '../../models/course_model.dart';

/// ─────────────────────────────────────────────────────────────────
///  QUIZ MANAGEMENT SCREEN
///  3-level hierarchy:
///    Course (DSA / OOPs / C++) → Topic → Questions (1 correct + 4 options)
/// ─────────────────────────────────────────────────────────────────
class ManageQuestionsScreen extends StatefulWidget {
  const ManageQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  late Future<List<CourseModel>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = MongoService.getCourses();
  }

  void _refresh() {
    setState(() {
      _coursesFuture = MongoService.getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0A0A1A) : const Color(0xFFF5F5FF);

    return FutureBuilder<List<CourseModel>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: bg,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: bg,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            ),
          );
        }

        final courses = snapshot.data ?? [];
        if (courses.isEmpty) {
          return Scaffold(
            backgroundColor: bg,
            appBar: AppBar(title: const Text('Quiz Management')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.quiz_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No courses found in MongoDB'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _refresh, child: const Text('Refresh')),
                ],
              ),
            ),
          );
        }

        // Map to internal _Course helper
        final mappedCourses = courses.map((c) {
          final colorHex = c.color;
          final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
          return _Course(c.id, c.title, _getIconData(c.icon), color);
        }).toList();

        return DefaultTabController(
          length: mappedCourses.length,
          child: Scaffold(
            backgroundColor: bg,
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF0F0F2A) : Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text('Quiz Management',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
              bottom: TabBar(
                isScrollable: mappedCourses.length > 3,
                indicatorColor: const Color(0xFFFF6B6B),
                indicatorWeight: 3,
                labelColor: const Color(0xFFFF6B6B),
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: mappedCourses
                    .map((c) => Tab(icon: Icon(c.icon, size: 18), text: c.label))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: mappedCourses
                  .map((c) => _CourseTopicsView(course: c, isDark: isDark))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  static IconData _getIconData(String? iconStr) {
    switch (iconStr) {
      case '📚': return Icons.menu_book_rounded;
      case '🌳': return Icons.account_tree_rounded;
      case '🎯': return Icons.track_changes_rounded;
      case '⚡': return Icons.bolt_rounded;
      case '☕': return Icons.coffee_rounded;
      case '🗄️': return Icons.storage_rounded;
      case '🌐': return Icons.public_rounded;
      default: return Icons.quiz_rounded;
    }
  }
}

// ──────────────────────────────────────────────────────────────────
// COURSE TOPICS VIEW — shows topics for one course + add topic button
// ──────────────────────────────────────────────────────────────────
class _CourseTopicsView extends StatefulWidget {
  final _Course course;
  final bool isDark;
  const _CourseTopicsView({required this.course, required this.isDark});

  @override
  State<_CourseTopicsView> createState() => _CourseTopicsViewState();
}

class _CourseTopicsViewState extends State<_CourseTopicsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addTopic() async {
    final nameCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.topic_rounded, color: widget.course.color),
            const SizedBox(width: 8),
            Text('Add Topic to ${widget.course.label}'),
          ],
        ),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Topic Name',
            hintText: 'e.g. Arrays, Sorting, Polymorphism…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.course.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && nameCtrl.text.trim().isNotEmpty) {
      final name = nameCtrl.text.trim();
      try {
        await MongoService.addTopic(widget.course.id, name);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Topic "$name" created in MongoDB!'),
              backgroundColor: widget.course.color,
            ),
          );
          setState(() {}); // refresh list
        }
      } catch (e) {
        if (mounted) {
          _showNetworkError(e.toString());
        }
      }
    }
  }

  void _showNetworkError(String err) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text('Operation Failed'),
          ],
        ),
        content: Text('Backend error: $err', style: const TextStyle(fontSize: 13)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.course.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTopic(String topicId, String topicName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Topic'),
        content: Text('Delete "$topicName" from MongoDB and all its questions?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await MongoService.deleteTopic(topicId);
        if (mounted) setState(() {});
      } catch (e) {
        if (mounted) _showNetworkError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cardBg = widget.isDark ? const Color(0xFF1A1A2E) : Colors.white;

    return Column(
      children: [
        // ── Always-visible "Add Topic" bar ──────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: widget.isDark ? const Color(0xFF0F0F2A) : Colors.white,
          child: ElevatedButton.icon(
            onPressed: _addTopic,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              '+ Add New Topic to ${widget.course.label}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.course.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        // ── Topic list ───────────────────────────────────────────────
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: FutureBuilder<List<Topic>>(
              future: MongoService.getTopics(widget.course.id),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: widget.course.color));
                }
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('❌ MongoDB Error: ${snap.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }
                final topics = snap.data ?? [];

                if (topics.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded,
                            size: 72,
                            color: widget.course.color.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'No topics yet in MongoDB.\nTap "+ Add New Topic" above.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: topics.length,
                  itemBuilder: (context, i) {
                    final topic = topics[i];
                    final topicId = topic.id;
                    final topicName = topic.name;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(widget.isDark ? 0.2 : 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.course.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.topic_rounded,
                              color: widget.course.color),
                        ),
                        title: Text(topicName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: widget.isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                            )),
                        subtitle: FutureBuilder<List<QuestionModel>>(
                          future: MongoService.getQuestions(topicId),
                          builder: (ctx, qSnap) {
                            final count = qSnap.data?.length ?? 0;
                            return Text(
                                '$count question${count == 1 ? '' : 's'}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500]));
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Add question button
                            IconButton(
                              icon: Icon(Icons.add_circle_rounded,
                                  color: widget.course.color),
                              tooltip: 'Add Question',
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _AddQuestionScreen(
                                      courseId: widget.course.id,
                                      topicId: topicId,
                                      topicName: topicName,
                                      accentColor: widget.course.color,
                                      isDark: widget.isDark,
                                    ),
                                  ),
                                );
                                setState(() {}); // Refresh topic list (for question count)
                              },
                            ),
                            // View questions button
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 16),
                              color: Colors.grey,
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _TopicQuestionsScreen(
                                      courseId: widget.course.id,
                                      topicId: topicId,
                                      topicName: topicName,
                                      accentColor: widget.course.color,
                                      isDark: widget.isDark,
                                    ),
                                  ),
                                );
                                setState(() {}); // Refresh topic list
                              },
                            ),
                            // Delete topic
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.red, size: 20),
                              tooltip: 'Delete Topic',
                              onPressed: () => _deleteTopic(topicId, topicName),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// TOPIC QUESTIONS SCREEN — lists all questions in a topic
// ──────────────────────────────────────────────────────────────────
class _TopicQuestionsScreen extends StatefulWidget {
  final String courseId, topicId, topicName;
  final Color accentColor;
  final bool isDark;

  const _TopicQuestionsScreen({
    required this.courseId,
    required this.topicId,
    required this.topicName,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_TopicQuestionsScreen> createState() => _TopicQuestionsScreenState();
}

class _TopicQuestionsScreenState extends State<_TopicQuestionsScreen> {
  Future<void> _deleteQuestion(String qId) async {
    try {
      await MongoService.deleteQuestion(qId);
      if (mounted) {
        setState(() {}); // refresh list
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Question deleted.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark ? const Color(0xFF1A1A2E) : Colors.white;

    return Scaffold(
      backgroundColor:
          widget.isDark ? const Color(0xFF0A0A1A) : const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: widget.isDark ? const Color(0xFF0F0F2A) : Colors.white,
        elevation: 0,
        title: Text(widget.topicName,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E))),
      ),
      body: FutureBuilder<List<QuestionModel>>(
        future: MongoService.getQuestions(widget.topicId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: widget.accentColor));
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}', style: const TextStyle(color: Colors.red)));
          }
          final questions = snap.data ?? [];
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined,
                      size: 72, color: widget.accentColor.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text('No questions yet in MongoDB',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (ctx, i) {
              final q = questions[i];
              final options = q.options;
              final correctIdx = q.correctOptionIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Q${i + 1}. ${q.questionText}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: widget.isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.red, size: 20),
                          onPressed: () => _deleteQuestion(q.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (j) {
                      final isCorrect = j == correctIdx;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? widget.accentColor.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCorrect
                                ? widget.accentColor
                                : (widget.isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + j)}. ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isCorrect ? widget.accentColor : Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                options[j],
                                style: TextStyle(
                                  color: isCorrect
                                      ? widget.accentColor
                                      : (widget.isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                  fontWeight: isCorrect
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isCorrect)
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.green, size: 18),
                          ],
                        ),
                      );
                    }),
                    if (q.explanation != null && q.explanation!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.amber.withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                q.explanation!,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: widget.accentColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Question',
            style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _AddQuestionScreen(
                courseId: widget.courseId,
                topicId: widget.topicId,
                topicName: widget.topicName,
                accentColor: widget.accentColor,
                isDark: widget.isDark,
              ),
            ),
          );
          setState(() {}); // refresh list
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// ADD QUESTION SCREEN — question + 4 options + correct answer picker
// ──────────────────────────────────────────────────────────────────
class _AddQuestionScreen extends StatefulWidget {
  final String courseId, topicId, topicName;
  final Color accentColor;
  final bool isDark;

  const _AddQuestionScreen({
    required this.courseId,
    required this.topicId,
    required this.topicName,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<_AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  late final List<TextEditingController> _optCtrl;
  int _correctIdx = 0;
  bool _saving = false;

  static const _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _optCtrl = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    _qCtrl.dispose();
    _expCtrl.dispose();
    _codeCtrl.dispose();
    for (var c in _optCtrl) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final question = QuestionModel(
        id: '', // Blank for new question (Node backend uses _id)
        questionText: _qCtrl.text.trim(),
        options: _optCtrl.map((c) => c.text.trim()).toList(),
        correctOptionIndex: _correctIdx,
        explanation: _expCtrl.text.trim(),
        codeSnippet: _codeCtrl.text.trim().isEmpty
            ? null
            : _codeCtrl.text.trim(),
        topicId: widget.topicId,
        courseId: widget.courseId,
      );

      await MongoService.saveQuestion(question);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Question saved to MongoDB!'),
            backgroundColor: widget.accentColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showErrorDialog(String err) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Failed'),
        content: Text('Backend error: $err'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: widget.isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade50,
      );

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF0A0A1A) : const Color(0xFFF5F5FF);
    final cardBg = widget.isDark ? const Color(0xFF1A1A2E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: widget.isDark ? const Color(0xFF0F0F2A) : Colors.white,
        elevation: 0,
        title: Text(
          'Add Question — ${widget.topicName}',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _saving
                ? const CircularProgressIndicator(color: Colors.white)
                : TextButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    style: TextButton.styleFrom(
                      backgroundColor: widget.accentColor.withOpacity(0.15),
                      foregroundColor: widget.accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Question text ───────────────────────────────────────
            _section('Question', cardBg, [
              TextFormField(
                controller: _qCtrl,
                decoration:
                    _dec('Question Text', hint: 'Type the question here…'),
                maxLines: 3,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeCtrl,
                decoration: _dec('Code Snippet',
                    hint: 'Optional — paste code here'),
                maxLines: 4,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ]),

            const SizedBox(height: 16),

            // ── Options ─────────────────────────────────────────────
            _section('Answer Options', cardBg, [
              ...List.generate(4, (i) {
                final isCorrect = _correctIdx == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Correct answer selector
                      GestureDetector(
                        onTap: () => setState(() => _correctIdx = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCorrect
                                ? widget.accentColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isCorrect
                                  ? widget.accentColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _optionLabels[i],
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: isCorrect
                                    ? Colors.white
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _optCtrl[i],
                          decoration: _dec(
                            'Option ${_optionLabels[i]}',
                            hint: isCorrect ? '← Correct answer' : '',
                          ).copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isCorrect
                                    ? widget.accentColor
                                    : Colors.grey.shade400,
                                width: isCorrect ? 2 : 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: widget.accentColor, width: 2),
                            ),
                          ),
                          validator: (v) => v!.trim().isEmpty
                              ? 'Add option ${_optionLabels[i]}'
                              : null,
                        ),
                      ),
                      if (isCorrect)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.check_circle_rounded,
                              color: widget.accentColor),
                        ),
                    ],
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_rounded,
                        color: widget.accentColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Tap a circle to mark the correct answer',
                      style: TextStyle(
                          fontSize: 12, color: widget.accentColor),
                    ),
                  ],
                ),
              ),
            ]),

            const SizedBox(height: 16),

            // ── Explanation ─────────────────────────────────────────
            _section('Explanation (Optional)', cardBg, [
              TextFormField(
                controller: _expCtrl,
                decoration: _dec('Why is this the correct answer?'),
                maxLines: 3,
              ),
            ]),

            const SizedBox(height: 24),

            // ── Save button ─────────────────────────────────────────
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save_rounded),
                label: Text(_saving ? 'Saving…' : 'Save Question',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Color bg, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// ── Data class ───────────────────────────────────────────────────
class _Course {
  final String id, label;
  final IconData icon;
  final Color color;
  const _Course(this.id, this.label, this.icon, this.color);
}
