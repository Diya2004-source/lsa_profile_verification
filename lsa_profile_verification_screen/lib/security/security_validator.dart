import '../constants/app_constants.dart';

/// Security validator enforcing fail-closed input validation rules.
class SecurityValidator {
  /// Validates the submission parameters for LSA Profile Verification.
  ///
  /// Returns an error message [String] if validation fails, or `null` if all checks pass.
  static String? validateSubmission({
    required String name,
    required String email,
    required String phone,
    required String predecessorId,
  }) {
    // Rule 1: Name cannot be empty
    if (name.trim().isEmpty) {
      return AppConstants.nameRequired;
    }

    // Rule 2: Email cannot be empty
    if (email.trim().isEmpty) {
      return AppConstants.emailRequired;
    }

    // Rule 3: Email must contain '@'
    if (!email.contains('@')) {
      return AppConstants.emailInvalid;
    }

    // Rule 4: Phone cannot be empty
    if (phone.trim().isEmpty) {
      return AppConstants.phoneRequired;
    }

    // Rule 5: Phone must contain at least 10 digits
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return AppConstants.phoneInvalid;
    }

    // Rule 6: Predecessor ID cannot be empty
    if (predecessorId.trim().isEmpty) {
      return AppConstants.predecessorIdRequired;
    }

    // All validation checks passed (Fail-Closed principle)
    return null;
  }
}