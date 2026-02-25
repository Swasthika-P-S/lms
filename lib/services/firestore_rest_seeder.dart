import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Seeds quiz data via the Firestore REST API (plain HTTPS).
/// This bypasses the Flutter Web SDK's broken WebSocket transport,
/// which causes all .set()/.add() calls to timeout on web.
class FirestoreRestSeeder {
  static const _projectId = 'placement-lms-a8ca5';
  static const _baseUrl =
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  // ── Firestore field value helpers ─────────────────────────────────
  static Map<String, dynamic> _str(String v) => {'stringValue': v};
  static Map<String, dynamic> _int(int v) => {'integerValue': '$v'};
  static Map<String, dynamic> _arr(List<String> items) => {
        'arrayValue': {
          'values': items.map((e) => _str(e)).toList(),
        }
      };

  /// Get current user's Firebase ID token for REST auth
  static Future<String> _idToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not signed in');
    return await user.getIdToken() ?? '';
  }

  /// PATCH a document at the given path with the given fields
  static Future<void> _patchDoc(
    String path,
    Map<String, dynamic> fields,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/$path');
    final body = jsonEncode({'fields': fields});

    final resp = await http
        .patch(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 15));

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Firestore REST error ${resp.statusCode}: ${resp.body}');
    }
  }

  /// Seed all quiz courses via REST API
  static Future<void> seedQuizCourses() async {
    print('🌱 [REST] Seeding quiz_courses via Firestore REST API...');
    final token = await _idToken();
    print('✅ Got ID token, starting seed...');

    final data = _buildData();

    for (final courseEntry in data.entries) {
      final courseId = courseEntry.key;
      final courseData = courseEntry.value;
      final topics = courseData['topics'] as Map<String, dynamic>;

      // Write course document
      await _patchDoc(
        'quiz_courses/$courseId',
        {'name': _str(courseData['courseName'] as String)},
        token,
      );
      print('✅ Created course: $courseId');

      for (final topicEntry in topics.entries) {
        final topicId = topicEntry.key;
        final topicData = topicEntry.value as Map<String, dynamic>;
        final questions = topicData['questions'] as List<Map<String, dynamic>>;

        // Write topic document
        await _patchDoc(
          'quiz_courses/$courseId/topics/$topicId',
          {
            'name': _str(topicData['name'] as String),
            'courseId': _str(courseId),
          },
          token,
        );
        print('  ✅ Created topic: $courseId/$topicId');

        // Write each question
        for (int i = 0; i < questions.length; i++) {
          final q = questions[i];
          await _patchDoc(
            'quiz_courses/$courseId/topics/$topicId/questions/q${i + 1}',
            {
              'questionText': _str(q['q'] as String),
              'options': _arr(List<String>.from(q['opts'] as List)),
              'correctOptionIndex': _int(q['ans'] as int),
              'explanation': _str(q['exp'] as String),
              'topicId': _str(topicId),
              'courseId': _str(courseId),
              'order': _int(i + 1),
            },
            token,
          );
        }
        print('    ✅ Added ${questions.length} questions to $topicId');
      }
    }
    print('🎉 [REST] Quiz courses seeded successfully!');
  }

  static Map<String, dynamic> _buildData() => {
        'dsa': {
          'courseName': 'DSA',
          'topics': {
            'arrays': {
              'name': 'Arrays',
              'questions': [
                {'q': 'What is the time complexity of accessing an array element by index?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 0, 'exp': 'Array access by index is O(1) — memory address is computed directly.'},
                {'q': 'Which describes a Dynamic Array?', 'opts': ['Fixed size at compile time', 'Can grow/shrink at runtime', 'Stores integers only', 'Non-contiguous memory'], 'ans': 1, 'exp': 'Dynamic arrays (e.g. vector in C++) resize themselves as needed.'},
                {'q': 'In a 2D array arr[3][4], how many total elements?', 'opts': ['7', '12', '3', '4'], 'ans': 1, 'exp': '3 rows × 4 columns = 12 elements.'},
                {'q': 'Out-of-bounds access in C++ causes?', 'opts': ['Exception thrown', 'Array resizes', 'Undefined behaviour', 'Returns null'], 'ans': 2, 'exp': 'C++ does not do bounds checking by default.'},
                {'q': 'Space complexity of an array of size n?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 1, 'exp': 'An array of n elements occupies O(n) space.'},
              ],
            },
            'linked-lists': {
              'name': 'Linked Lists',
              'questions': [
                {'q': 'Time to insert at the beginning of a Singly Linked List?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 0, 'exp': 'Only pointer changes needed — constant time.'},
                {'q': 'Each node in a Singly Linked List contains?', 'opts': ['Data + prev pointer', 'Data + next pointer', 'Only data', 'Data + two pointers'], 'ans': 1, 'exp': 'A singly linked list node holds data and a reference to the next node.'},
                {'q': 'Which linked list allows bidirectional traversal?', 'opts': ['Singly', 'Doubly', 'Circular', 'Both Doubly and Circular'], 'ans': 3, 'exp': 'Doubly and circular doubly linked lists support bidirectional traversal.'},
              ],
            },
            'stacks': {
              'name': 'Stacks',
              'questions': [
                {'q': 'Which principle does a Stack follow?', 'opts': ['FIFO', 'LIFO', 'LILO', 'FILO'], 'ans': 1, 'exp': 'Stack follows Last In First Out (LIFO).'},
                {'q': 'Which operation adds an element to a stack?', 'opts': ['enqueue', 'push', 'insert', 'add'], 'ans': 1, 'exp': 'push() adds an element to the top of the stack.'},
                {'q': 'Common application of stacks?', 'opts': ['CPU Scheduling', 'Undo functionality', 'BFS traversal', 'Sorting'], 'ans': 1, 'exp': 'Undo/redo in editors uses a stack.'},
              ],
            },
          },
        },
        'oops': {
          'courseName': 'OOPs',
          'topics': {
            'classes': {
              'name': 'Classes & Objects',
              'questions': [
                {'q': 'What is encapsulation in OOP?', 'opts': ['Inheriting methods', 'Hiding data within a class', 'Overriding functions', 'Multiple inheritance'], 'ans': 1, 'exp': 'Encapsulation bundles data and methods and restricts direct access.'},
                {'q': 'Keyword used to create an object in Java?', 'opts': ['create', 'object', 'new', 'class'], 'ans': 2, 'exp': 'The new keyword allocates memory and creates a new object.'},
                {'q': 'What is a constructor?', 'opts': ['Destroys objects', 'Special method called at object creation', 'A return type', 'A static method'], 'ans': 1, 'exp': 'A constructor initializes the object when it is created.'},
              ],
            },
            'inheritance': {
              'name': 'Inheritance',
              'questions': [
                {'q': 'What is inheritance in OOP?', 'opts': ['Hiding data', 'A class acquiring properties of another', 'Method overloading', 'Polymorphism'], 'ans': 1, 'exp': 'Inheritance allows a child class to inherit fields and methods from a parent.'},
                {'q': 'Which inheritance type is NOT supported directly in Java via classes?', 'opts': ['Single', 'Multi-level', 'Multiple', 'Hierarchical'], 'ans': 2, 'exp': 'Java does not support multiple inheritance through classes — only through interfaces.'},
              ],
            },
          },
        },
        'cpp': {
          'courseName': 'C++',
          'topics': {
            'pointers': {
              'name': 'Pointers',
              'questions': [
                {'q': 'What does a pointer store?', 'opts': ['A value', 'A memory address', 'A string', 'A function'], 'ans': 1, 'exp': 'A pointer holds the memory address of another variable.'},
                {'q': 'What is a null pointer?', 'opts': ['Pointer to zero', 'Pointer that points to nothing', 'Invalid pointer', 'Pointer to a function'], 'ans': 1, 'exp': 'A null pointer does not point to any valid memory location.'},
                {'q': 'Operator to get the address of a variable?', 'opts': ['*', '&', '->', '::'], 'ans': 1, 'exp': 'The & (address-of) operator returns the memory address of a variable.'},
              ],
            },
            'templates': {
              'name': 'Templates',
              'questions': [
                {'q': 'Purpose of templates in C++?', 'opts': ['Memory management', 'Write generic type-independent code', 'Operator overloading', 'Exception handling'], 'ans': 1, 'exp': 'Templates enable generic programming — one function/class works with any type.'},
                {'q': 'Keyword used to define a template in C++?', 'opts': ['generic', 'template', 'type', 'class'], 'ans': 1, 'exp': 'The template keyword declares a template in C++.'},
              ],
            },
          },
        },
      };
}
