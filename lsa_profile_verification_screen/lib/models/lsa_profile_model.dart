/// Model representing the user profile payload for LSA verification.
class LsaProfile {
  final String name;
  final String email;
  final String phone;
  final String predecessorId;

  const LsaProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.predecessorId,
  });

  /// Converts the model instance into a JSON-serializable Map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'predecessor_id': predecessorId,
    };
  }
}
