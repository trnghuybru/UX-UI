import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define Nocturnal Guardian Colors
  static const Color darkSurface = Color(0xFF0A0E14);
  static const Color darkSurfaceContainerLow = Color(0xFF0F141A);
  static const Color darkSurfaceBright = Color(0xFF262C36);
  static const Color darkSurfaceContainerHighest = Color(0xFF20262F);
  
  static const Color darkPrimary = Color(0xFF89ACFF);
  static const Color darkPrimaryDim = Color(0xFF0F6DF3);
  static const Color darkSecondary = Color(0xFFFF7350);
  static const Color darkTertiary = Color(0xFFFFE483);
  static const Color darkError = Color(0xFFFF6E84);
  
  static const Color darkOnSurface = Color(0xFFF1F3FC);
  static const Color darkOnSurfaceVariant = Color(0xFFA8ABB3);
  static const Color darkOutlineVariant = Color(0xFF44484F);

  // Light Theme Colors (Derived from existing app)
  static const Color lightSurface = Color(0xFFF7F9FB); // Used in Login
  static const Color lightSurfaceContainerLow = Colors.white; // Used for Cards
  static const Color lightSurfaceBright = Color(0xFFF2F4F6); // 5 Day Forecast Background
  static const Color lightPrimary = Color(0xFF0058BE);
  static const Color lightPrimaryDim = Color(0xFF2170E4);
  static const Color lightError = Color(0xFFDC2C4F); // Alert Card Background
  static const Color lightOnSurface = Color(0xFF191C1E);
  static const Color lightOnSurfaceVariant = Color(0xFF424754);
  static const Color lightOutlineVariant = Color(0xFFC2C6D6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightSurface,
      colorScheme: const ColorScheme.light(
        surface: lightSurface,
        primary: lightPrimary,
        error: lightError,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
        outlineVariant: lightOutlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(color: lightOnSurface),
        displayMedium: GoogleFonts.manrope(color: lightOnSurface),
        displaySmall: GoogleFonts.manrope(color: lightOnSurface),
        headlineLarge: GoogleFonts.manrope(color: lightOnSurface),
        headlineMedium: GoogleFonts.manrope(color: lightOnSurface),
        headlineSmall: GoogleFonts.manrope(color: lightOnSurface),
        titleLarge: GoogleFonts.inter(color: lightOnSurface),
        titleMedium: GoogleFonts.inter(color: lightOnSurface),
        titleSmall: GoogleFonts.inter(color: lightOnSurface),
        bodyLarge: GoogleFonts.inter(color: lightOnSurface),
        bodyMedium: GoogleFonts.inter(color: lightOnSurface),
        bodySmall: GoogleFonts.inter(color: lightOnSurface),
        labelLarge: GoogleFonts.inter(color: lightOnSurfaceVariant),
        labelMedium: GoogleFonts.inter(color: lightOnSurfaceVariant),
        labelSmall: GoogleFonts.inter(color: lightOnSurfaceVariant),
      ),
      cardColor: lightSurfaceContainerLow,
      dividerTheme: DividerThemeData(
        color: lightOutlineVariant.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkTertiary,
        error: darkError,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        outlineVariant: darkOutlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(color: darkOnSurface),
        displayMedium: GoogleFonts.manrope(color: darkOnSurface),
        displaySmall: GoogleFonts.manrope(color: darkOnSurface),
        headlineLarge: GoogleFonts.manrope(color: darkOnSurface),
        headlineMedium: GoogleFonts.manrope(color: darkOnSurface),
        headlineSmall: GoogleFonts.manrope(color: darkOnSurface),
        titleLarge: GoogleFonts.inter(color: darkOnSurface),
        titleMedium: GoogleFonts.inter(color: darkOnSurface),
        titleSmall: GoogleFonts.inter(color: darkOnSurface),
        bodyLarge: GoogleFonts.inter(color: darkOnSurface),
        bodyMedium: GoogleFonts.inter(color: darkOnSurface),
        bodySmall: GoogleFonts.inter(color: darkOnSurface),
        labelLarge: GoogleFonts.inter(color: darkOnSurfaceVariant),
        labelMedium: GoogleFonts.inter(color: darkOnSurfaceVariant),
        labelSmall: GoogleFonts.inter(color: darkOnSurfaceVariant),
      ),
      cardColor: darkSurfaceContainerLow,
      dividerTheme: DividerThemeData(
        color: darkOutlineVariant.withValues(alpha: 0.15),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
