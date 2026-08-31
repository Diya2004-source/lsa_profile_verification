import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Class responsible for security metadata generation including unique trace IDs
/// and cryptographic payload integrity logic hashes.
///
/// **What is trace_id?**
/// A `trace_id` is a universally unique identifier (UUID v4) generated for each verification payload submission.
/// It enables end-to-end request tracing, log correlation, and auditability across services.
///
/// **What is logic_hash?**
/// A `logic_hash` is a SHA-256 cryptographic digest created by hashing the concatenated input fields.
/// It provides a tamper-proof digital fingerprint of the exact input payload submitted by the user.
///
/// **Why are they generated?**
/// 1. **Auditability & Lineage**: Allows system logs to track the exact execution flow of a verification request.
/// 2. **Data Integrity & Non-repudiation**: Verifies payload consistency across processing stages without relying on raw PII storage.
/// 3. **Fail-Closed Security**: Serves as a verifiable signature before dispatching downstream transactions.
class MetadataGenerator {
  static const _uuid = Uuid();

  /// Generates a unique UUID (v4) string for request tracing.
  static String generateTraceId() {
    return _uuid.v4();
  }

  /// Combines input parameters and computes a SHA-256 cryptographic hash fingerprint.
  static String generateLogicHash({
    required String name,
    required String email,
    required String phone,
    required String predecessorId,
  }) {
    // Combine input parameters into a standardized delimited string representation
    final combinedPayload = '$name|$email|$phone|$predecessorId';

    // Encode string to UTF-8 bytes and compute SHA-256 hash
    final bytes = utf8.encode(combinedPayload);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}
