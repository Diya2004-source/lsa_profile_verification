import 'package:flutter/material.dart';

/// Premium button widget with gradient fill, elevation shadow, and verified icon.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    this.text = 'Verify Profile',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlueStart = Color(0xFF2563EB);
    const primaryBlueEnd = Color(0xFF1D4ED8);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [primaryBlueStart, primaryBlueEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: onPressed == null ? const Color(0xFF94A3B8) : null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: onPressed != null
            ? const [
                BoxShadow(
                  color: Color(0x332563EB),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
