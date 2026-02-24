import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learnhub/models/question_model.dart';
import 'package:learnhub/services/firestore_service.dart';
import 'package:learnhub/providers/firebase_auth_provider.dart';
import 'package:learnhub/quiz_tab/models.dart';
import 'package:learnhub/home_tab/utils/theme.dart';
import 'package:learnhub/services/data_seeder.dart';

class QuizScreen extends StatefulWidget {
  final Topic topic;
  final Course course;

  const QuizScreen({
    Key? key,
    required this.topic,
    required this.course,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final PageController _pageController = PageController();
  
  List<QuestionModel> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  bool _isFinished = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final questions = await _firestoreService.getQuestions(widget.topic.id);
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().contains('timeout') 
              ? 'Loading timed out. Please check your connection.' 
              : 'Error loading questions: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _handleOptionSelect(int optionIndex) {
    if (_isFinished) return;
    
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });

    // Auto-advance after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentIndex < _questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    int scoreCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctOptionIndex) {
        scoreCount++;
      }
    }
    
    final percentage = ((scoreCount / _questions.length) * 100).toInt();
    
    setState(() {
      _score = percentage;
      _isFinished = true;
    });

    // Submit result to Firebase
    final authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      _firestoreService.submitQuizResult(
        authProvider.user!.uid,
        widget.topic.id,
        percentage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: widget.course.gradientColors[0]),
                const SizedBox(height: 20),
                Text(
                  'Connecting to database...\nTopic: ${widget.topic.id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                // Fail-safe button to go back if it hangs
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
                const SizedBox(height: 12),
                // Option to force seed if user thinks it's missing
                TextButton.icon(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await DataSeeder.seedDsaQuizzes();
                      await _loadQuestions();
                    } catch (e) {
                      setState(() => _errorMessage = 'Seeding failed: $e');
                    }
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Force Seed Data', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.topic.name)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadQuestions,
                  child: const Text('Retry Loading Quizzes'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.topic.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No questions available for "${widget.topic.id}"',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  await DataSeeder.seedDsaQuizzes();
                  await _loadQuestions();
                },
                child: const Text('Seed & Refresh Data'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isFinished) {
      return _buildResultScreen(isDark);
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(_questions[index], isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.course.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topic.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentIndex + 1) / _questions.length,
      backgroundColor: Colors.white.withOpacity(0.1),
      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
      minHeight: 6,
    );
  }

  Widget _buildQuestionCard(QuestionModel question, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.questionText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (question.codeSnippet != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                question.codeSnippet!,
                style: const TextStyle(
                  color: Color(0xFFD4D4D4),
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
          ...List.generate(
            question.options.length,
            (index) => _buildOptionTile(
              index,
              question.options[index],
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int index, String text, bool isDark) {
    final isSelected = _selectedAnswers[_currentIndex] == index;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleOptionSelect(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? widget.course.gradientColors[0].withOpacity(0.1)
                : (isDark ? AppTheme.darkCard : Colors.white),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected 
                  ? widget.course.gradientColors[0]
                  : (isDark ? Colors.white10 : Colors.grey.shade300),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? widget.course.gradientColors[0]
                      : (isDark ? Colors.white24 : Colors.grey.shade100),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _score >= 70 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _score >= 70 ? Icons.emoji_events : Icons.refresh,
                  size: 50,
                  color: _score >= 70 ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You scored',
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                '$_score%',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: widget.course.gradientColors[0],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.course.gradientColors[0],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Back to Topics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
