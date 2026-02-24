import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import '../models/problem_model.dart';

/// Firestore database service for CRUD operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get coursesCollection => _firestore.collection('courses');
  CollectionReference get resourcesCollection => _firestore.collection('resources');
  CollectionReference get leaderboardCollection => _firestore.collection('leaderboard');
  
  /// Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      // Set a timeout for the network request
      final doc = await usersCollection.doc(userId).get(
        const GetOptions(source: Source.serverAndCache),
      ).timeout(const Duration(seconds: 10));
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      
      // Try to get from cache if server fails
      try {
        final doc = await usersCollection.doc(userId).get(
          const GetOptions(source: Source.cache),
        );
        if (doc.exists) {
          print('ℹ️ Restored user data from cache');
          return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }
      } catch (cacheError) {
        print('❌ Cache fallback failed: $cacheError');
      }
      
      return null;
    }
  }
  
  /// Stream user data
  Stream<UserModel?> streamUserData(String userId) {
    return usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }
  
  /// Update user stats
  Future<void> updateUserStats(String userId, Map<String, dynamic> stats) async {
    try {
      await usersCollection.doc(userId).update({
        'stats': stats,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ Error updating user stats: $e');
      rethrow;
    }
  }
  
  /// Get user progress for a topic
  Future<ProgressModel?> getTopicProgress(String userId, String topicId) async {
    try {
      final doc = await usersCollection
          .doc(userId)
          .collection('progress')
          .doc(topicId)
          .get();
          
      if (doc.exists) {
        return ProgressModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('❌ Error getting topic progress: $e');
      return null;
    }
  }
  
  /// Update problem progress
  Future<void> updateProblemProgress(
    String userId,
    String topicId,
    String problemId,
    bool solved,
  ) async {
    try {
      final progressRef = usersCollection
          .doc(userId)
          .collection('progress')
          .doc(topicId);
      
      final progressDoc = await progressRef.get();
      
      if (progressDoc.exists) {
        // Update existing progress
        final data = progressDoc.data()!;
        final solvedProblems = List<String>.from(data['solvedProblems'] ?? []);
        
        if (solved && !solvedProblems.contains(problemId)) {
          solvedProblems.add(problemId);
        } else if (!solved) {
          solvedProblems.remove(problemId);
        }
        
        await progressRef.update({
          'solvedProblems': solvedProblems,
          'totalSolved': solvedProblems.length,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new progress document
        await progressRef.set({
          'topicId': topicId,
          'solvedProblems': solved ? [problemId] : [],
          'totalSolved': solved ? 1 : 0,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      
      // Update overall user stats
      await _updateOverallStats(userId);
      
    } catch (e) {
      print('❌ Error updating problem progress: $e');
      rethrow;
    }
  }
  
  /// Update overall user statistics
  Future<void> _updateOverallStats(String userId) async {
    try {
      // Get all progress documents
      final progressSnapshot = await usersCollection
          .doc(userId)
          .collection('progress')
          .get();
      
      int totalSolved = 0;
      for (var doc in progressSnapshot.docs) {
        totalSolved += (doc.data()['totalSolved'] as int?) ?? 0;
      }
      
      // Update user stats
      await usersCollection.doc(userId).update({
        'stats.solvedProblems': totalSolved,
        'stats.totalScore': totalSolved * 10, // Simple scoring: 10 points per problem
      });
      
    } catch (e) {
      print('❌ Error updating overall stats: $e');
    }
  }
  
  /// Get problems for a topic
  Future<List<ProblemModel>> getTopicProblems(String courseId, String topicId) async {
    try {
      final snapshot = await coursesCollection
          .doc(courseId)
          .collection('topics')
          .doc(topicId)
          .collection('problems')
          .orderBy('order')
          .get();
      
      return snapshot.docs
          .map((doc) => ProblemModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting topic problems: $e');
      return [];
    }
  }
  
  /// Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    try {
      final snapshot = await leaderboardCollection
          .orderBy('score', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'userId': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting leaderboard: $e');
      return [];
    }
  }
  
  /// Save chat message
  Future<void> saveChatMessage(
    String userId,
    String message,
    String response,
  ) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('chats')
          .add({
        'userMessage': message,
        'botResponse': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ Error saving chat message: $e');
    }
  }
  
  /// Get chat history
  Future<List<Map<String, dynamic>>> getChatHistory(String userId, {int limit = 50}) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('❌ Error getting chat history: $e');
      return [];
    }
  }
}
