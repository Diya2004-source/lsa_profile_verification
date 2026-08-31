/// Application-wide constants including API endpoints, timeouts, and user feedback messages.
class AppConstants {
  // API Endpoint
  static const String apiUrl = 'https://reqres.in/api/users';

  // Timeouts
  static const Duration frictionTimeout = Duration(seconds: 5);

  // Success Messages
  static const String validationPassed = 'Validation Passed';
  static const String metadataGenerated = 'Metadata Generated Successfully';
  static const String profileSubmitted = 'Profile Submitted Successfully';

  // Error Messages
  static const String nameRequired = 'Name is required';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String phoneRequired = 'Phone is required';
  static const String phoneInvalid = 'Please enter a valid phone number';
  static const String predecessorIdRequired = 'Predecessor ID is required';
  static const String apiError = 'Failed to submit profile. Please try again.';
}
