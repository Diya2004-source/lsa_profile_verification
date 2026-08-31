import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/lsa_profile_model.dart';

/// Service handling API integration for profile submission.
class ApiService {
  /// Submits the [profile] payload to the backend server with security headers.
  static Future<ApiResponse> submitProfile({
    required LsaProfile profile,
    required String traceId,
    required String logicHash,
  }) async {
    final url = Uri.parse(AppConstants.apiUrl);
    final headers = {
      'Content-Type': 'application/json',
      'trace_id': traceId,
      'logic_hash': logicHash,
    };
    final body = jsonEncode(profile.toJson());

    debugPrint('--- API Request ---');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('--- API Response ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body) as Map<String, dynamic>?;
        return ApiResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          message: AppConstants.profileSubmitted,
          data: decodedData,
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          message: AppConstants.apiError,
        );
      }
    } catch (e) {
      debugPrint('API Exception: $e');
      return ApiResponse(
        isSuccess: false,
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}

/// Helper class encapsulating the HTTP API response outcome.
class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  const ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    this.message,
    this.data,
  });
}