import 'dart:async';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// Tracker detecting user input friction and typing pauses.
class FrictionTracker {
  Timer? _timer;
  final Duration timeout;

  FrictionTracker({this.timeout = AppConstants.frictionTimeout});

  /// Starts or restarts the inactivity timer.
  void startTracking() {
    _timer?.cancel();
    _timer = Timer(timeout, _onFrictionDetected);
  }

  /// Resets the inactivity timer when user typing resumes.
  void resetTracking() {
    startTracking();
  }

  /// Triggered when typing pauses for longer than the [timeout] duration.
  void _onFrictionDetected() {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('Friction Event Detected');
    debugPrint('Timestamp: $timestamp');
  }

  /// Cancels any active timer resources to prevent memory leaks.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
