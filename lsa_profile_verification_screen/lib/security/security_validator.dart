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
      return 'Name is required';
    }

    // Rule 2: Email cannot be empty
    if (email.trim().isEmpty) {
      return 'Email is required';
    }

    // Rule 3: Email must contain '@'
    if (!email.contains('@')) {
      return 'Please enter a valid email';
    }

    // Rule 4: Phone cannot be empty
    if (phone.trim().isEmpty) {
      return 'Phone is required';
    }

    // Rule 5: Phone must contain at least 10 digits
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    // Rule 6: Predecessor ID cannot be empty
    if (predecessorId.trim().isEmpty) {
      return 'Predecessor ID is required';
    }

    // All validation checks passed (Fail-Closed principle)
    return null;
  }
}