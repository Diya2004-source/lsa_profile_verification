// Screen for LSA Profile Verification UI with fail-closed validation logic.
import 'package:flutter/material.dart';
import '../security/security_validator.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_header.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _predecessorIdController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _predecessorIdController.dispose();
    super.dispose();
  }

  /// Handles profile verification submission using fail-closed validation.
  void _handleVerification() {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final predecessorId = _predecessorIdController.text;

    final errorMessage = SecurityValidator.validateSubmission(
      name: name,
      email: email,
      phone: phone,
      predecessorId: predecessorId,
    );

    ScaffoldMessenger.of(context).clearSnackBars();

    if (errorMessage != null) {
      // Show red SnackBar if validation fails and stop execution immediately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show green SnackBar when validation succeeds
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Validation Passed'),
        backgroundColor: Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Section: Profile Header
              const ProfileHeader(),
              const SizedBox(height: 32),

              // Main Card containing text fields and verify button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F0F172A),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Name Field
                    CustomTextField(
                      label: 'Name',
                      hintText: 'Enter full name',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    CustomTextField(
                      label: 'Email',
                      hintText: 'enter@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Field
                    CustomTextField(
                      label: 'Phone Number',
                      hintText: '+1 (555) 000-0000',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Predecessor ID Field
                    CustomTextField(
                      label: 'Predecessor ID',
                      hintText: 'Enter predecessor ID',
                      controller: _predecessorIdController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 28),

                    // Button Section: Verify Profile Button
                    PrimaryButton(
                      text: 'Verify Profile',
                      onPressed: _handleVerification,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Section: Security Features Info Card
              _buildSecurityInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// Information card displaying security features.
  Widget _buildSecurityInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
    );
  }

  /// Individual checkmark row for security features.
  Widget _buildSecurityFeatureItem(String title) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}