import 'package:flutter/material.dart';

class VoiceCommandHandler {
  static void handleCommand(String command, BuildContext context, Function(int) navigateToTab) {
    final lowerCommand = command.toLowerCase();

    // 1. Navigation Commands
    if (lowerCommand.contains('home') || lowerCommand.contains('\u0939\u094b\u092e')) {
      navigateToTab(0);
    } else if (lowerCommand.contains('courses') || lowerCommand.contains('\u0915\u094b\u0930\u094d\u0938')) {
      navigateToTab(1);
    } else if (lowerCommand.contains('quizzes') || lowerCommand.contains('\u0915\u094d\u0935\u093f\u091c')) {
      navigateToTab(2);
    } else if (lowerCommand.contains('tasks') || lowerCommand.contains('\u091f\u093e\u0938\u094d\u0915')) {
      navigateToTab(3);
    } else if (lowerCommand.contains('profile') || lowerCommand.contains('\u092a\u094d\u0930\u094b\u092b\u093e\u0907\u0932')) {
      navigateToTab(4);
    } else if (lowerCommand.contains('settings') || lowerCommand.contains('\u0938\u0947\u091f\u093f\u0902\u0917\u094d\u0938')) {
      navigateToTab(5);
    }
  }
}
