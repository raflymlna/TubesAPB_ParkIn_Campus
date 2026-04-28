import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF800000);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: primaryColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    ),

    scaffoldBackgroundColor: Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    // 🔴 FIX TEXT SELECTION (cursor dll)
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: Color(0xFFB22222),
      selectionHandleColor: primaryColor,
    ),

    // 🔴 FIX INPUT FIELD (biar gak ungu)
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.grey),

      floatingLabelStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),

      prefixIconColor: Colors.grey,

      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(16),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),

      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
