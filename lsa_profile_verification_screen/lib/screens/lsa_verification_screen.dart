import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/lsa_profile_model.dart';
import '../security/metadata_generator.dart';
import '../security/security_validator.dart';
import '../services/api_service.dart';
import '../trackers/friction_tracker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// Screen for Profile Verification UI vertically and horizontally centered.
class LsaVerificationScreen extends StatefulWidget {
  const LsaVerificationScreen({super.key});

  @override
  State<LsaVerificationScreen> createState() => _LsaVerificationScreenState();
}

class _LsaVerificationScreenState extends State<LsaVerificationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _predecessorIdController;

  late final FrictionTracker _frictionTracker;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _predecessorIdController = TextEditingController();

    _frictionTracker = FrictionTracker();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _predecessorIdController.dispose();

    _frictionTracker.dispose();
    super.dispose();
  }

  /// Handles profile verification submission flow using fail-closed validation.
  Future<void> _handleVerification() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final predecessorId = _predecessorIdController.text;

    // 1. Validation (Fail Closed)
    final errorMessage = SecurityValidator.validateSubmission(
      name: name,
      email: email,
      phone: phone,
      predecessorId: predecessorId,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();

    if (errorMessage != null) {
      debugPrint('[Validation] Failed: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; // Fail Closed: Stop execution immediately
    }

    debugPrint('[Validation] Passed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppConstants.validationPassed),
        backgroundColor: Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 2. Generate Security Metadata
    final traceId = MetadataGenerator.generateTraceId();
    final logicHash = MetadataGenerator.generateLogicHash(
      name: name,
      email: email,
      phone: phone,
      predecessorId: predecessorId,
    );

    setState(() {
      _isSubmitting = true;
    });

    debugPrint('[Metadata] Generated trace_id: $traceId');
    debugPrint('[Metadata] Generated logic_hash: $logicHash');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppConstants.metadataGenerated),
        backgroundColor: Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 3. Create LsaProfile Model
    final profile = LsaProfile(
      name: name,
      email: email,
      phone: phone,
      predecessorId: predecessorId,
    );

    // 4. Submit Profile to API
    final response = await ApiService.submitProfile(
      profile: profile,
      traceId: traceId,
      logicHash: logicHash,
    );

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    // 5. Display Result
    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.profileSubmitted),
          backgroundColor: Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? AppConstants.apiError),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Center-aligned Screen Heading Text
            const Text(
              'Profile Verification Screen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 20),

            // Main Form Card (Vertically and Horizontally Centered)
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  /// Verification Form Card container with clear contrast and rounded corners.
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name Field
          CustomTextField(
            label: 'Name',
            hintText: 'Enter full name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 14),

          // Email Field
          CustomTextField(
            label: 'Email',
            hintText: 'enter@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 14),

          // Phone Number Field
          CustomTextField(
            label: 'Phone Number',
            hintText: '+91 9876543210',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 14),

          // Predecessor ID Field
          CustomTextField(
            label: 'Predecessor ID',
            hintText: 'Enter predecessor ID',
            controller: _predecessorIdController,
            keyboardType: TextInputType.text,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 22),

          // Button Section: Premium Verify Profile Button
          PrimaryButton(
            text: _isSubmitting ? 'Verifying...' : 'Verify Profile',
            onPressed: _isSubmitting ? null : _handleVerification,
          ),
        ],
      ),
    );
  }
}