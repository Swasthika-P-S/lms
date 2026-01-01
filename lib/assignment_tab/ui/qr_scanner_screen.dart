import 'package:flutter/material.dart';
import '../logic/qr_service.dart';
import '../core/app_colors.dart';

class QRScannerScreen extends StatefulWidget {
  final String expectedCourseId;
  final String userId;
  const QRScannerScreen({super.key, required this.expectedCourseId, required this.userId});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final _codeController = TextEditingController();
  final QRService _qrService = QRService();
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Join via QR Code'), backgroundColor: AppColors.card),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the QR join code provided by your instructor.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppConstants.spacing),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Join Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppConstants.spacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isJoining ? null : _join,
                  icon: const Icon(Icons.qr_code_2, color: AppColors.textPrimary),
                  label: Text(_isJoining ? 'Joining...' : 'Join Course',
                      style: const TextStyle(color: AppColors.textPrimary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _join() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a join code')));
      return;
    }
    setState(() => _isJoining = true);

    await Future.delayed(const Duration(milliseconds: 400)); // simulate processing

    final success = _qrService.joinCourseWithQR(code, widget.expectedCourseId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Successfully joined course!' : 'Invalid or expired QR code'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.card,
      ),
    );

    if (success) {
      Navigator.pop(context); // return to previous screen after join
    }

    setState(() => _isJoining = false);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
