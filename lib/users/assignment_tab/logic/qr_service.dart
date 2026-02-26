class QRService {
  // Deterministic join code generation from courseId
  String generateCourseQR(String courseId) {
    final normalized = courseId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    final suffix = (normalized.hashCode & 0xFFFF).toRadixString(16).toUpperCase();
    return '$normalized-$suffix';
  }

  // Validate provided code against expected courseId
  bool joinCourseWithQR(String joinCode, String expectedCourseId) {
    final expected = generateCourseQR(expectedCourseId);
    return joinCode.trim().toUpperCase() == expected.toUpperCase();
  }
}
