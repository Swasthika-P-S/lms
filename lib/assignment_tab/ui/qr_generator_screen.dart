import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../logic/qr_service.dart';
import '../core/app_colors.dart';

class QRGeneratorScreen extends StatelessWidget {
  final String courseId;
  final QRService _qrService = QRService();

  QRGeneratorScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final joinCode = _qrService.generateCourseQR(courseId);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Course QR Code'), backgroundColor: AppColors.card),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(data: joinCode, version: QrVersions.auto, size: 240, backgroundColor: Colors.white),
            const SizedBox(height: AppConstants.spacing),
            Text('Join Code: $joinCode', style: const TextStyle(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
