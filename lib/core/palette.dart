import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class Palette {
//   static const colorcolorPrimary = Color(0xFFE6FADD);
//   static const hijauButton = Color(0xFF28738B);
//   static Color accentColor = Color(0xFFFF7601);
//   static const Color accentLightColor = Color(0xFFF3A26D);
// }

class fonts {
  static const fontcolorPrimary = GoogleFonts.inter;
}

class Palette {
  static const Color colorPrimary = Color(0xFFE6FADD);
  static const Color hijauButton = Color(0xFF28738B);
  static const Color accent = Color(0xFFFF7601);
  static const Color accentLight = Color(0xFFF3A26D);
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Colors.grey;
}

// Mengadopsi class fonts Anda, diganti nama menjadi AppFonts
class AppFonts {
  static final TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Palette.hijauButton,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14.0,
    color: Palette.hijauButton,
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Palette.white,
  );
}

// Class utama untuk tema aplikasi
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: Palette.colorPrimary,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.hijauButton,
        primary: Palette.hijauButton,
        secondary: Palette.accent,
        background: Palette.colorPrimary,
      ),
      useMaterial3: true,
      textTheme: TextTheme(
        displaySmall: AppFonts.displaySmall,
        bodyMedium: AppFonts.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.white.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.hijauButton,
          foregroundColor: Palette.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: AppFonts.button,
        ),
      ),
    );
  }
}
