import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF123C69);
  static const Color lightBlue = Color(0xFF1BA2CA);
  static const Color mediumBlue = Color(0xFF177AA4);
  static const Color darkBlue = Color(0xFF144D79);
  static const Color accentBlue = Color(0xFF17234D);

  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFF17234D);
  static const Color textSecondary = Color(0xFF87888A);
  static const Color textLight = Color(0xFFBDBDBD);

  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF6F6F6);
  static const Color borderColor = Color(0xFFE5E7E9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBlue, mediumBlue, darkBlue, primaryBlue],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAFAFA), Colors.white],
  );

  // Typography
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: lightBlue,
        surface: backgroundPrimary,
        onSurface: textPrimary,
      ),
      textTheme: const TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: buttonText,
        labelMedium: caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: CardTheme(
        elevation: elevationS,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusL)),
        color: backgroundPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusS)),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusS)),
          textStyle: buttonText.copyWith(color: primaryBlue),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundPrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: lightBlue,
        secondary: primaryBlue,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white70,
      ),
      textTheme: TextTheme(
        headlineLarge: headingLarge.copyWith(color: Colors.white),
        headlineMedium: headingMedium.copyWith(color: Colors.white),
        headlineSmall: headingSmall.copyWith(color: Colors.white),
        bodyLarge: bodyLarge.copyWith(color: Colors.white70),
        bodyMedium: bodyMedium.copyWith(color: Colors.white70),
        bodySmall: bodySmall.copyWith(color: Colors.white60),
        labelLarge: buttonText,
        labelMedium: caption.copyWith(color: Colors.white60),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  // Helper methods for consistent styling
  static BoxShadow get cardShadow =>
      BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: elevationL, offset: const Offset(0, 2));

  static BoxShadow get buttonShadow =>
      BoxShadow(color: primaryBlue.withValues(alpha: 0.3), blurRadius: elevationM, offset: const Offset(0, 2));

  static BoxDecoration get cardDecoration =>
      BoxDecoration(color: backgroundPrimary, borderRadius: BorderRadius.circular(radiusL), boxShadow: [cardShadow]);

  static BoxDecoration get gradientCardDecoration =>
      BoxDecoration(gradient: cardGradient, borderRadius: BorderRadius.circular(radiusL), boxShadow: [cardShadow]);
}
