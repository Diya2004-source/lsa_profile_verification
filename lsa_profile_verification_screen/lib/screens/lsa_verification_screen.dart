import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/lsa_profile_model.dart';
import '../security/metadata_generator.dart';
import '../security/security_validator.dart';
import '../services/api_service.dart';
import '../trackers/friction_tracker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_header.dart';

/// Screen for LSA Profile Verification UI with a human-designed, production-ready SaaS aesthetic.
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

  String? _currentTraceId;
  String? _currentLogicHash;
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
      _currentTraceId = traceId;
      _currentLogicHash = logicHash;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const ProfileHeader(),
          const SizedBox(height: 20),

          // Structured Layout: 2 Columns on Desktop, 1 Column on Mobile
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Container (60% width)
                Expanded(
                  flex: 3,
                  child: _buildFormCard(),
                ),
                const SizedBox(width: 20),

                // Side Details (40% width)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildSecurityInfoCard(),
                      const SizedBox(height: 16),
                      _buildAuditMetadataCard(),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildFormCard(),
                const SizedBox(height: 16),
                _buildSecurityInfoCard(),
                const SizedBox(height: 16),
                _buildAuditMetadataCard(),
              ],
            ),
        ],
      ),
    );
  }

  /// Verification Form Card container.
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verification Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter the entity details below for lineage validation.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),

          // Name Field
          CustomTextField(
            label: 'Name',
            hintText: 'Enter full name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            label: 'Email',
            hintText: 'enter@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 16),

          // Phone Number Field
          CustomTextField(
            label: 'Phone Number',
            hintText: '+1 (555) 000-0000',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 16),

          // Predecessor ID Field
          CustomTextField(
            label: 'Predecessor ID',
            hintText: 'Enter predecessor ID',
            controller: _predecessorIdController,
            keyboardType: TextInputType.text,
            onChanged: (_) => _frictionTracker.resetTracking(),
          ),
          const SizedBox(height: 24),

          // Button Section: Verify Profile Button
          PrimaryButton(
            text: _isSubmitting ? 'Verifying...' : 'Verify Profile',
            onPressed: _isSubmitting ? null : _handleVerification,
          ),
        ],
      ),
    );
  }

  /// Clean Security Features Info Card.
  Widget _buildSecurityInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.security_rounded,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                'Security Features',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSecurityFeatureItem('Lineage Validation', 'Verifies record hierarchy.'),
          const SizedBox(height: 8),
          _buildSecurityFeatureItem('Fail-Closed Security', 'Immediate rejection on error.'),
          const SizedBox(height: 8),
          _buildSecurityFeatureItem('Metadata Tracking', 'Cryptographic trace generation.'),
        ],
      ),
    );
  }

  /// Individual checkmark row for security features.
  Widget _buildSecurityFeatureItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Audit Metadata Trail card showing current trace_id and logic_hash.
  Widget _buildAuditMetadataCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.fingerprint_rounded,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                'Security Audit Trail',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_currentTraceId == null)
            const Text(
              'No verification metadata generated yet. Submit valid data to inspect trace details.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            )
          else ...[
            _buildMetadataField('TRACE ID', _currentTraceId!),
            const SizedBox(height: 8),
            _buildMetadataField('LOGIC HASH (SHA-256)', _currentLogicHash!),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}