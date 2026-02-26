import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  void loadUserData(String userId) {
    // Dummy user data (frontend-only)
    _userModel = UserModel(
      uid: userId,
      email: userId.contains('@') ? userId : 'student@example.com',
      name: userId.contains('@') ? userId.split('@').first : 'Student',
      role: 'student',
      coursesCompleted: 3,
      totalHours: 12,
      progressPercentage: 65,
    );
    notifyListeners();
  }

  void clearUser() {
    _userModel = null;
    notifyListeners();
  }
}
