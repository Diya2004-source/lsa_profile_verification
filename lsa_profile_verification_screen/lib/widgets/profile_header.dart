import 'package:flutter/material.dart';

/// Reusable profile header widget with circular security icon, title, and subtitle.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2563EB);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular shield / security icon container
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0x1A2563EB), // 10% opacity blue
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0x332563EB), // 20% opacity blue border
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.shield_rounded,
              size: 36,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Title
        const Text(
          'LSA Profile Verification',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        const Text(
          'Secure profile verification and validation',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
