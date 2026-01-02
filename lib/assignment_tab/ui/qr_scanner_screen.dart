import 'package:flutter/material.dart';
import '../logic/qr_service.dart';
import '../core/app_colors.dart';

class QRScannerScreen extends StatefulWidget {
  final String expectedCourseId;
  final String userId;
  const QRScannerScreen({
    super.key,
    required this.expectedCourseId,
    required this.userId,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final _codeController = TextEditingController();
  final QRService _qrService = QRService();
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Join via QR Code'),
        backgroundColor: AppColors.getCard(context),
        foregroundColor: AppColors.getTextPrimary(context),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(AppConstants.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join Course',
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter the join code from your instructor',
                          style: TextStyle(
                            color: AppColors.getTextSecondary(context),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Main Input Card
            Container(
              padding: const EdgeInsets.all(AppConstants.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.getCard(context),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Row(
                    children: [
                      Icon(
                        Icons.vpn_key,
                        size: 18,
                        color: AppColors.getTextSecondary(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Join Code',
                        style: TextStyle(
                          color: AppColors.getTextSecondary(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Text Field
                  TextField(
                    controller: _codeController,
                    enabled: !_isJoining,
                    style: TextStyle(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter code here',
                      hintStyle: TextStyle(
                        color: AppColors.getTextSecondary(context),
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.warning,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Join Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isJoining
                            ? AppColors.warning.withOpacity(0.6)
                            : AppColors.warning,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadius,
                          ),
                        ),
                        elevation: _isJoining ? 0 : 2,
                      ),
                      onPressed: _isJoining ? null : _join,
                      icon: _isJoining
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.login, size: 20),
                      label: Text(
                        _isJoining ? 'Joining...' : 'Join Course',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions Card
            Container(
              padding: const EdgeInsets.all(AppConstants.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How to Join',
                        style: TextStyle(
                          color: AppColors.getTextPrimary(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionItem(
                    context,
                    '1',
                    'Get the join code from your instructor',
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionItem(
                    context,
                    '2',
                    'Enter the code in the field above',
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionItem(
                    context,
                    '3',
                    'Tap "Join Course" to complete enrollment',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.getTextSecondary(context),
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _join() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Please enter a join code'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }
    
    setState(() => _isJoining = true);

    await Future.delayed(const Duration(milliseconds: 400));

    final success = _qrService.joinCourseWithQR(code, widget.expectedCourseId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                success
                    ? 'Successfully joined course!'
                    : 'Invalid or expired QR code',
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? AppColors.success : AppColors.accent,
        duration: const Duration(seconds: 3),
      ),
    );

    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _isJoining = false);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}