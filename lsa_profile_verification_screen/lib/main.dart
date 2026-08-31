import 'package:flutter/material.dart';
import 'screens/lsa_verification_screen.dart';

void main() {
  runApp(const LsaProfileVerificationApp());
}

class LsaProfileVerificationApp extends StatelessWidget {
  const LsaProfileVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);

    return MaterialApp(
      title: 'LSA Profile Verification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          brightness: Brightness.light,
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const LsaVerificationScreen(),
    );
  }
}
