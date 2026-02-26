import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedDsaQuizzes() async {
    print('🌱 Seeding DSA Quizzes...');
    
    final Map<String, List<QuestionModel>> quizData = {
      'arrays': [
        QuestionModel(
          id: 'arr_1',
          topicId: 'arrays',
          questionText: 'What is the time complexity to access an element in an array by its index?',
          options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
          correctOptionIndex: 0,
          explanation: 'Array access by index is a constant time operation because the memory address can be calculated directly.',
        ),
        QuestionModel(
          id: 'arr_2',
          topicId: 'arrays',
          questionText: 'Which of the following describes a "Dynamic Array"?',
          options: [
            'An array with a fixed size determined at compile time',
            'An array that can grow or shrink in size during execution',
            'An array that only stores integers',
            'An array that is stored in non-contiguous memory'
          ],
          correctOptionIndex: 1,
          explanation: 'Dynamic arrays (like ArrayList in Java or vector in C++) can resize themselves as needed.',
        ),
        QuestionModel(
          id: 'arr_3',
          topicId: 'arrays',
          questionText: 'What is the output of the following code snippet?',
          codeSnippet: 'int[] arr = {1, 2, 3, 4, 5};\nSystem.out.println(arr[2]);',
          options: ['1', '2', '3', '4'],
          correctOptionIndex: 2,
          explanation: 'Arrays are 0-indexed, so index 2 refers to the third element, which is 3.',
        ),
        QuestionModel(
          id: 'arr_4',
          topicId: 'arrays',
          questionText: 'In a 2D array defined as arr[3][4], how many total elements are there?',
          options: ['7', '12', '3', '4'],
          correctOptionIndex: 1,
          explanation: 'A 2D array with 3 rows and 4 columns has 3 * 4 = 12 elements.',
        ),
        QuestionModel(
          id: 'arr_5',
          topicId: 'arrays',
          questionText: 'What happens if you try to access an index outside the bounds of an array in C++?',
          options: [
            'Throws an ArrayIndexOutOfBoundsException',
            'Automatically resizes the array',
            'Undefined behavior (may crash or return garbage value)',
            'Returns null'
          ],
          correctOptionIndex: 2,
          explanation: 'C++ does not perform bounds checking on arrays by default, leading to undefined behavior.',
        ),
        QuestionModel(
          id: 'arr_6',
          topicId: 'arrays',
          questionText: 'Which operation is O(n) in a sorted array?',
          options: ['Access by index', 'Binary Search', 'Insertion (at a random position)', 'Finding the minimum element'],
          correctOptionIndex: 2,
          explanation: 'Inserting an element into a sorted array requires shifting subsequent elements, making it O(n).',
        ),
        QuestionModel(
          id: 'arr_7',
          topicId: 'arrays',
          questionText: 'What is the space complexity of an array of size n?',
          options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
          correctOptionIndex: 1,
          explanation: 'An array of size n occupies space proportional to n.',
        ),
        QuestionModel(
          id: 'arr_8',
          topicId: 'arrays',
          questionText: 'Predict the output of this Python snippet:',
          codeSnippet: 'arr = [10, 20, 30, 40]\nprint(arr[-1])',
          options: ['Error', '10', '40', '0'],
          correctOptionIndex: 2,
          explanation: 'In Python, negative indexing starts from the end. arr[-1] is the last element.',
        ),
        QuestionModel(
          id: 'arr_9',
          topicId: 'arrays',
          questionText: 'Which of these is NOT a characteristic of a standard array?',
          options: [
            'Contiguous memory allocation',
            'Homogeneous elements (same type)',
            'Fast insertion at the beginning',
            'Fixed size (static arrays)'
          ],
          correctOptionIndex: 2,
          explanation: 'Insertion at the beginning is O(n) because all other elements must be shifted.',
        ),
        QuestionModel(
          id: 'arr_10',
          topicId: 'arrays',
          questionText: 'What is a "Sparse Array"?',
          options: [
            'An array with many elements',
            'An array where most elements are zero or null',
            'An array that stores strings only',
            'An array used for sorting'
          ],
          correctOptionIndex: 1,
          explanation: 'A sparse array is one in which most of the positions are empty or contain 0.',
        ),
      ],
      'linked-lists': [
        QuestionModel(
          id: 'll_1',
          topicId: 'linked-lists',
          questionText: 'What is the time complexity to insert a node at the beginning of a Singly Linked List?',
          options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
          correctOptionIndex: 0,
          explanation: 'Inserting at the head only requires changing a few pointers, which is a constant time operation.',
        ),
        QuestionModel(
          id: 'll_2',
          topicId: 'linked-lists',
          questionText: 'What does each node in a Singly Linked List consist of?',
          options: [
            'Data and pointer to previous node',
            'Data and pointer to next node',
            'Only data',
            'Data and two pointers'
          ],
          correctOptionIndex: 1,
          explanation: 'A singly linked list node contains the data and a reference (pointer) to the next node in the sequence.',
        ),
        QuestionModel(
          id: 'll_3',
          topicId: 'linked-lists',
          questionText: 'Which coding snippet correctly defines a Node class for a Singly Linked List in Java?',
          codeSnippet: 'class Node {\n  int data;\n  Node next;\n  Node(int d) { data = d; next = null; }\n}',
          options: ['Yes, it is correct', 'No, missing constructor', 'No, next should be an int', 'No, missing previous pointer'],
          correctOptionIndex: 0,
          explanation: 'This is the standard representation of a singly linked list node.',
        ),
        QuestionModel(
          id: 'll_4',
          topicId: 'linked-lists',
          questionText: 'In a Doubly Linked List, what does each node contain?',
          options: [
            'Data and next pointer',
            'Data and previous pointer',
            'Data, next pointer, and previous pointer',
            'Just data'
          ],
          correctOptionIndex: 2,
          explanation: 'Doubly linked lists allow traversal in both directions by storing pointers to both next and previous nodes.',
        ),
        QuestionModel(
          id: 'll_5',
          topicId: 'linked-lists',
          questionText: 'What is the disadvantage of a Linked List compared to an Array?',
          options: [
            'Dynamic size',
            'No memory waste',
            'Random access is not possible',
            'Ease of insertion'
          ],
          correctOptionIndex: 2,
          explanation: 'To reach the n-th element in a linked list, you must traverse all preceding nodes, making access O(n).',
        ),
        QuestionModel(
          id: 'll_6',
          topicId: 'linked-lists',
          questionText: 'What is the time complexity to find the middle element of a linked list in one pass?',
          options: ['O(1)', 'O(n/2)', 'O(n)', 'O(log n)'],
          correctOptionIndex: 2,
          explanation: 'Finding the middle requires traversing the list (e.g., using slow and fast pointers), which is O(n).',
        ),
        QuestionModel(
          id: 'll_7',
          topicId: 'linked-lists',
          questionText: 'How do you check for a cycle (loop) in a linked list?',
          options: [
            'Binary Search',
            "Floyd's Cycle-Finding Algorithm (Tortoise and Hare)",
            'Recursion only',
            'Sorting the list'
          ],
          correctOptionIndex: 1,
          explanation: "Floyd's algorithm uses two pointers at different speeds to detect if they ever meet, indicating a cycle.",
        ),
        QuestionModel(
          id: 'll_8',
          topicId: 'linked-lists',
          questionText: 'What defines a Circular Linked List?',
          options: [
            'The last node points back to the first node',
            'Every node points to itself',
            'The list has no tail',
            'Both A and C'
          ],
          correctOptionIndex: 3,
          explanation: 'In a circular linked list, the tail node connects back to the head, creating a circle.',
        ),
        QuestionModel(
          id: 'll_9',
          topicId: 'linked-lists',
          questionText: 'What is the time complexity to delete a node given its pointer (not the head) in a Singly Linked List?',
          options: ['O(1) if we copy data from next node', 'O(n)', 'Impossible', 'O(log n)'],
          correctOptionIndex: 0,
          explanation: 'By copying the data of the next node to the current node and deleting the next node, we can simulate deletion in O(1).',
        ),
        QuestionModel(
          id: 'll_10',
          topicId: 'linked-lists',
          questionText: 'Which operation is more efficient in a Linked List than an Array (Dynamic)?',
          options: [
            'Accessing the middle element',
            'Deleting the first element',
            'Sorting',
            'Binary Search'
          ],
          correctOptionIndex: 1,
          explanation: 'Deleting the first element in a linked list is O(1), while in an array it is O(n) due to shifting.',
        ),
      ],
      'stacks-queues': [
        QuestionModel(
          id: 'sq_1',
          topicId: 'stacks-queues',
          questionText: 'Which principle does a Stack follow?',
          options: ['FIFO (First In First Out)', 'LIFO (Last In First Out)', 'Level Order', 'Random'],
          correctOptionIndex: 1,
          explanation: 'A stack is a Last-In-First-Out data structure.',
        ),
        QuestionModel(
          id: 'sq_2',
          topicId: 'stacks-queues',
          questionText: 'Which principle does a Queue follow?',
          options: ['FIFO (First In First Out)', 'LIFO (Last In First Out)', 'Priority Order', 'None'],
          correctOptionIndex: 0,
          explanation: 'A queue is a First-In-First-Out data structure.',
        ),
        QuestionModel(
          id: 'sq_3',
          topicId: 'stacks-queues',
          questionText: 'What is the result of the following Stack operations?',
          codeSnippet: 'Stack s = new Stack();\ns.push(10);\ns.push(20);\ns.pop();\nprint(s.peek());',
          options: ['10', '20', 'Error', 'Null'],
          correctOptionIndex: 0,
          explanation: '10 is pushed, then 20. 20 is popped, so 10 is at the top.',
        ),
        QuestionModel(
          id: 'sq_4',
          topicId: 'stacks-queues',
          questionText: 'Which data structure is used for Breadth-First Search (BFS)?',
          options: ['Stack', 'Queue', 'Tree', 'Array'],
          correctOptionIndex: 1,
          explanation: 'BFS uses a queue to explore neighbors level by level.',
        ),
        QuestionModel(
          id: 'sq_5',
          topicId: 'stacks-queues',
          questionText: 'Which data structure is used for Depth-First Search (DFS)?',
          options: ['Queue', 'Stack', 'Heap', 'Hash Table'],
          correctOptionIndex: 1,
          explanation: 'DFS uses a stack (or recursion) to explore the deepest nodes first.',
        ),
        QuestionModel(
          id: 'sq_6',
          topicId: 'stacks-queues',
          questionText: 'What is a "Deque"?',
          options: [
            'A stack with priority',
            'A double-ended queue (insertion/deletion at both ends)',
            'A queue with fixed size',
            'A circular stack'
          ],
          correctOptionIndex: 1,
          explanation: 'A Deque (Double-ended Queue) allows adding and removing elements from both the front and the back.',
        ),
        QuestionModel(
          id: 'sq_7',
          topicId: 'stacks-queues',
          questionText: 'What is "Stack Overflow"?',
          options: [
            'When the stack is empty',
            'When you try to push into a full stack',
            'When you pop from an empty stack',
            'A memory leak'
          ],
          correctOptionIndex: 1,
          explanation: 'Stack overflow occurs when you attempt to add more elements to a stack than its capacity allows.',
        ),
        QuestionModel(
          id: 'sq_8',
          topicId: 'stacks-queues',
          questionText: 'What is "Underflow" in a Queue?',
          options: [
            'Adding element to full queue',
            'Removing element from empty queue',
            'Queue size becomes zero',
            'Infinite loop'
          ],
          correctOptionIndex: 1,
          explanation: 'Underflow occurs when you try to dequeue (remove) an element from an empty queue.',
        ),
        QuestionModel(
          id: 'sq_9',
          topicId: 'stacks-queues',
          questionText: 'Which of these is a real-world application of a Circular Queue?',
          options: ['Browser history', 'CPU Scheduling', 'Undo operation', 'Recursion'],
          correctOptionIndex: 1,
          explanation: 'Circular queues are often used in OS scheduling and resource sharing among multiple processes.',
        ),
        QuestionModel(
          id: 'sq_10',
          topicId: 'stacks-queues',
          questionText: 'How many stacks are minimum required to implement a queue?',
          options: ['1', '2', '3', 'None'],
          correctOptionIndex: 1,
          explanation: 'Two stacks can be used to simulate FIFO behavior by reversing the order during dequeue.',
        ),
      ],
      'osi-model': [
        QuestionModel(
          id: 'cn_1',
          topicId: 'osi-model',
          questionText: 'Which layer of the OSI model is responsible for routing?',
          options: ['Physical', 'Data Link', 'Network', 'Transport'],
          correctOptionIndex: 2,
          explanation: 'The Network layer handles logical addressing and routing of packets.',
        ),
        QuestionModel(
          id: 'cn_2',
          topicId: 'osi-model',
          questionText: 'Which layer provides end-to-end communication with reliability and flow control?',
          options: ['Session', 'Transport', 'Network', 'Presentation'],
          correctOptionIndex: 1,
          explanation: 'The Transport layer (like TCP) manages error-free delivery of data.',
        ),
      ],
      'process-mgmt': [
        QuestionModel(
          id: 'os_1',
          topicId: 'process-mgmt',
          questionText: 'What is a "Process Control Block" (PCB)?',
          options: [
            'A hardware component for CPU speed',
            'A data structure containing process information (PID, state, etc.)',
            'A type of operating system',
            'A block of memory that cannot be accessed'
          ],
          correctOptionIndex: 1,
          explanation: 'The PCB is the task control block in OS that stores everything about a process.',
        ),
        QuestionModel(
          id: 'os_2',
          topicId: 'process-mgmt',
          questionText: 'Which scheduling algorithm is non-preemptive but can lead to starvation?',
          options: ['Round Robin', 'Shortest Job First (non-preemptive)', 'Priority Scheduling', 'Multilevel Queue'],
          correctOptionIndex: 1,
          explanation: 'SJF can lead to starvation of long processes if short processes keep arriving.',
        ),
      ],
    };

    try {
      for (var entry in quizData.entries) {
          final topicId = entry.key;
          final questions = entry.value;
          
          final topicRef = _firestore.collection('quizzes').doc(topicId);
          await topicRef.set({'lastUpdated': FieldValue.serverTimestamp()})
              .timeout(const Duration(seconds: 10));
          
          final questionsCol = topicRef.collection('questions');
          
          for (var q in questions) {
              await questionsCol.doc(q.id).set(q.toMap())
                  .timeout(const Duration(seconds: 5));
          }
          print('✅ Seeded $topicId with ${questions.length} questions.');
      }
    } catch (e) {
      print('❌ Error seeding quiz data: $e');
      rethrow;
    }
  }

  /// Seeds quiz data into the quiz_courses/{courseId}/topics/{topicId}/questions
  /// structure used by the admin Manage Questions screen.
  static Future<void> seedQuizCourses() async {
    print('🌱 Seeding quiz_courses structure...');

    // Structure: courseId → topicName → list of questions
    final data = {
      'dsa': {
        'courseName': 'DSA',
        'topics': {
          'arrays': {
            'name': 'Arrays',
            'questions': [
              {'q': 'What is the time complexity of accessing an array element by index?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 0, 'exp': 'Array access by index is O(1) — the memory address is computed directly.'},
              {'q': 'Which of the following describes a Dynamic Array?', 'opts': ['Fixed size at compile time', 'Can grow/shrink at runtime', 'Stores integers only', 'Non-contiguous memory'], 'ans': 1, 'exp': 'Dynamic arrays (e.g. vector in C++) resize themselves as needed.'},
              {'q': 'In a 2D array arr[3][4], how many total elements are there?', 'opts': ['7', '12', '3', '4'], 'ans': 1, 'exp': '3 rows × 4 columns = 12 elements.'},
              {'q': 'What happens when you access an out-of-bounds index in C++?', 'opts': ['Exception thrown', 'Array resizes', 'Undefined behaviour', 'Returns null'], 'ans': 2, 'exp': 'C++ does not do bounds checking by default.'},
              {'q': 'What is the space complexity of an array of size n?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 1, 'exp': 'An array of n elements occupies O(n) space.'},
            ],
          },
          'linked-lists': {
            'name': 'Linked Lists',
            'questions': [
              {'q': 'Time complexity to insert at the beginning of a Singly Linked List?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'], 'ans': 0, 'exp': 'Only pointer changes are needed — constant time.'},
              {'q': 'What does each node in a Singly Linked List contain?', 'opts': ['Data + prev pointer', 'Data + next pointer', 'Only data', 'Data + two pointers'], 'ans': 1, 'exp': 'A singly linked list node holds data and a reference to the next node.'},
              {'q': 'Which linked list allows traversal in both directions?', 'opts': ['Singly', 'Doubly', 'Circular', 'Both B and C'], 'ans': 3, 'exp': 'Doubly and circular doubly linked lists support bidirectional traversal.'},
            ],
          },
          'stacks': {
            'name': 'Stacks',
            'questions': [
              {'q': 'Which principle does a Stack follow?', 'opts': ['FIFO', 'LIFO', 'LILO', 'FILO'], 'ans': 1, 'exp': 'Stack follows Last In First Out (LIFO).'},
              {'q': 'Which operation adds an element to a stack?', 'opts': ['enqueue', 'push', 'insert', 'add'], 'ans': 1, 'exp': 'push() adds an element to the top of the stack.'},
              {'q': 'What is a common application of stacks?', 'opts': ['CPU Scheduling', 'Undo functionality', 'BFS traversal', 'Sorting'], 'ans': 1, 'exp': 'Undo/redo in editors uses a stack.'},
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
              {'q': 'Which keyword is used to create an object in Java?', 'opts': ['create', 'object', 'new', 'class'], 'ans': 2, 'exp': 'The new keyword allocates memory and creates a new object.'},
              {'q': 'What is a constructor?', 'opts': ['A method that destroys objects', 'A special method called at object creation', 'A return type', 'A static method'], 'ans': 1, 'exp': 'A constructor initializes the object when it is created.'},
            ],
          },
          'inheritance': {
            'name': 'Inheritance',
            'questions': [
              {'q': 'What is inheritance in OOP?', 'opts': ['Hiding data', 'A class acquiring properties of another', 'Method overloading', 'Polymorphism'], 'ans': 1, 'exp': 'Inheritance allows a child class to inherit fields and methods from a parent class.'},
              {'q': 'Which type of inheritance is NOT supported directly in Java?', 'opts': ['Single', 'Multi-level', 'Multiple (via classes)', 'Hierarchical'], 'ans': 2, 'exp': 'Java does not support multiple inheritance through classes — only through interfaces.'},
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
              {'q': 'What is a null pointer?', 'opts': ['A pointer to zero', 'A pointer that points to nothing', 'An invalid pointer', 'A pointer to a function'], 'ans': 1, 'exp': 'A null pointer does not point to any valid memory location.'},
              {'q': 'Which operator is used to get the address of a variable?', 'opts': ['*', '&', '->', '::'], 'ans': 1, 'exp': 'The & (address-of) operator returns the memory address of a variable.'},
            ],
          },
          'templates': {
            'name': 'Templates',
            'questions': [
              {'q': 'What is the purpose of templates in C++?', 'opts': ['Memory management', 'Write generic type-independent code', 'Operator overloading', 'Exception handling'], 'ans': 1, 'exp': 'Templates enable generic programming — one function/class works with any data type.'},
              {'q': 'Which keyword is used to define a template?', 'opts': ['generic', 'template', 'type', 'class'], 'ans': 1, 'exp': 'The template keyword declares a template in C++.'},
            ],
          },
        },
      },
    };

    try {
      for (final courseEntry in data.entries) {
        final courseId = courseEntry.key;
        final courseData = courseEntry.value;
        final topics = courseData['topics'] as Map<String, dynamic>;

        // Create/update the course document
        await _firestore.collection('quiz_courses').doc(courseId).set({
          'name': courseData['courseName'],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)).timeout(const Duration(seconds: 10));

        for (final topicEntry in topics.entries) {
          final topicId = topicEntry.key;
          final topicData = topicEntry.value as Map<String, dynamic>;
          final questions = topicData['questions'] as List<dynamic>;

          // Create topic document
          final topicRef = _firestore
              .collection('quiz_courses').doc(courseId)
              .collection('topics').doc(topicId);

          await topicRef.set({
            'name': topicData['name'],
            'courseId': courseId,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true)).timeout(const Duration(seconds: 10));

          // Add questions
          for (int i = 0; i < questions.length; i++) {
            final q = questions[i] as Map<String, dynamic>;
            await topicRef.collection('questions').doc('q${i + 1}').set({
              'questionText': q['q'],
              'options': q['opts'],
              'correctOptionIndex': q['ans'],
              'explanation': q['exp'],
              'topicId': topicId,
              'courseId': courseId,
              'order': i + 1,
            }).timeout(const Duration(seconds: 10));
          }

          print('✅ Seeded $courseId/$topicId with ${questions.length} questions');
        }
      }
      print('🎉 Quiz courses seeded successfully!');
    } catch (e) {
      print('❌ Error seeding quiz_courses: $e');
      rethrow;
    }
  }
}

