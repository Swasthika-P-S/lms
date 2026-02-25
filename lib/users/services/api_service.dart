import 'package:dio/dio.dart';
import 'dart:convert';

/// API service for integrating external learning platforms
class APIService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  /// Get curated resources from various platforms
  /// Note: This uses public RSS feeds and curated content
  Future<List<Resource>> getResources(String topic) async {
    try {
      // In a real implementation, this would aggregate from multiple sources
      // For now, we'll return curated links
      return _getCuratedResources(topic);
    } catch (e) {
      print('❌ Error fetching resources: $e');
      return [];
    }
  }
  
  /// Get curated resources (predefined quality content)
  List<Resource> _getCuratedResources(String topic) {
    final topicLower = topic.toLowerCase();
    
    if (topicLower.contains('dsa') || topicLower.contains('algorithm')) {
      return [
        Resource(
          title: 'Data Structures Tutorial - GeeksforGeeks',
          url: 'https://www.geeksforgeeks.org/data-structures/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Comprehensive guide to all data structures',
        ),
        Resource(
          title: 'Arrays Practice Problems',
          url: 'https://www.hackerrank.com/domains/data-structures/arrays',
          platform: 'HackerRank',
          type: 'practice',
          description: 'Arrays problems on HackerRank',
        ),
        Resource(
          title: 'LeetCode Study Plan - DSA',
          url: 'https://leetcode.com/study-plan/data-structure/',
          platform: 'LeetCode',
          type: 'practice',
          description: 'Structured DSA learning path',
        ),
      ];
    } else if (topicLower.contains('dbms') || topicLower.contains('sql')) {
      return [
        Resource(
          title: 'SQL Tutorial - W3Schools',
          url: 'https://www.w3schools.com/sql/',
          platform: 'W3Schools',
          type: 'tutorial',
          description: 'Interactive SQL tutorial with examples',
        ),
        Resource(
          title: 'DBMS Concepts - GeeksforGeeks',
          url: 'https://www.geeksforgeeks.org/dbms/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Database management system concepts',
        ),
        Resource(
          title: 'SQL Practice - HackerRank',
          url: 'https://www.hackerrank.com/domains/sql',
          platform: 'HackerRank',
          type: 'practice',
          description: 'SQL query practice problems',
        ),
      ];
    } else if (topicLower.contains('oop') || topicLower.contains('object')) {
      return [
        Resource(
          title: 'OOP Concepts - GeeksforGeeks',
          url: 'https://www.geeksforgeeks.org/object-oriented-programming-oops-concept-in-java/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Core OOP concepts explained',
        ),
        Resource(
          title: 'Design Patterns',
          url: 'https://www.geeksforgeeks.org/software-design-patterns/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Common design patterns in OOP',
        ),
      ];
    } else if (topicLower.contains('c++')) {
      return [
        Resource(
          title: 'C++ Tutorial - W3Schools',
          url: 'https://www.w3schools.com/cpp/',
          platform: 'W3Schools',
          type: 'tutorial',
          description: 'C++ programming tutorial',
        ),
        Resource(
          title: 'C++ STL - GeeksforGeeks',
          url: 'https://www.geeksforgeeks.org/cpp-stl-tutorial/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Standard Template Library guide',
        ),
        Resource(
          title: 'C++ Practice - HackerRank',
          url: 'https://www.hackerrank.com/domains/cpp',
          platform: 'HackerRank',
          type: 'practice',
          description: 'C++ coding challenges',
        ),
      ];
    } else if (topicLower.contains('java')) {
      return [
        Resource(
          title: 'Java Tutorial - W3Schools',
          url: 'https://www.w3schools.com/java/',
          platform: 'W3Schools',
          type: 'tutorial',
          description: 'Java programming tutorial',
        ),
        Resource(
          title: 'Java Collections - GeeksforGeeks',
          url: 'https://www.geeksforgeeks.org/java-collections/',
          platform: 'GeeksforGeeks',
          type: 'article',
          description: 'Java Collections Framework',
        ),
        Resource(
          title: 'Java Practice - HackerRank',
          url: 'https://www.hackerrank.com/domains/java',
          platform: 'HackerRank',
          type: 'practice',
          description: 'Java coding challenges',
        ),
      ];
    }
    
    // Default resources
    return [
      Resource(
        title: 'Algorithms Tutorial - GeeksforGeeks',
        url: 'https://www.geeksforgeeks.org/fundamentals-of-algorithms/',
        platform: 'GeeksforGeeks',
        type: 'article',
        description: 'Fundamental algorithms explained',
      ),
    ];
  }
  
  /// Search for problems on external platforms
  Future<List<ExternalProblem>> searchProblems(String query, String difficulty) async {
    // This would integrate with platform APIs if available
    // For now, returning curated problem links
    return _getCuratedProblems(query, difficulty);
  }
  
  /// Get curated problems
  List<ExternalProblem> _getCuratedProblems(String query, String difficulty) {
    // Map difficulty to filter
    String leetcodeDiff = difficulty == 'easy' ? 'Easy' : 
                         difficulty == 'hard' ? 'Hard' : 'Medium';
    
    return [
      ExternalProblem(
        title: 'Two Sum',
        url: 'https://leetcode.com/problems/two-sum/',
        platform: 'LeetCode',
        difficulty: 'easy',
      ),
      ExternalProblem(
        title: 'Add Two Numbers',
        url: 'https://leetcode.com/problems/add-two-numbers/',
        platform: 'LeetCode',
        difficulty: 'medium',
      ),
      ExternalProblem(
        title: 'Reverse Integer',
        url: 'https://www.hackerrank.com/challenges/reverse-integer/',
        platform: 'HackerRank',
        difficulty: 'easy',
      ),
    ];
  }
}

/// Resource model for external learning resources
class Resource {
  final String title;
  final String url;
  final String platform;
  final String type; // 'article', 'tutorial', 'practice', 'video'
  final String description;
  
  Resource({
    required this.title,
    required this.url,
    required this.platform,
    required this.type,
    required this.description,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'platform': platform,
      'type': type,
      'description': description,
    };
  }
  
  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      platform: map['platform'] ?? '',
      type: map['type'] ?? 'article',
      description: map['description'] ?? '',
    );
  }
}

/// External problem model
class ExternalProblem {
  final String title;
  final String url;
  final String platform;
  final String difficulty;
  
  ExternalProblem({
    required this.title,
    required this.url,
    required this.platform,
    required this.difficulty,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'platform': platform,
      'difficulty': difficulty,
    };
  }
}
