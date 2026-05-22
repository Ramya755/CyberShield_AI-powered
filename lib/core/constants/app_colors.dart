import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B1020);
  static const Color backgroundDark = background;

  static const Color surface = Color(0xFF121A2F);
  static const Color surfaceDark = surface;
  static const Color surfaceDarker = Color(0xFF0A0F1F);

  static const Color card = Color(0xFF18223D);
  static const Color cardDark = card;
  static const Color cardBlue = Color(0xFF102A43);

  static const Color primaryBlue = Color(0xFF4FC3F7);
  static const Color primaryPurple = Color(0xFF9B5DE5);
  static const Color primaryPink = Color(0xFFF15BB5);
  static const Color primaryNeonGreen = Color(0xFF00E676);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB8C1D1);
  static const Color errorRed = Color(0xFFFF5A5F);

  static const Color border = Color(0xFF2A3555);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}