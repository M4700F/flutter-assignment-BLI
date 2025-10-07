import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(fontSize, Brightness.light),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  static ThemeData darkTheme(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(fontSize, Brightness.dark),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  static TextTheme _buildTextTheme(double baseFontSize, Brightness brightness) {
    final baseTheme = brightness == Brightness.light 
        ? ThemeData.light().textTheme 
        : ThemeData.dark().textTheme;
    
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(fontSize: baseFontSize + 8),
      displayMedium: baseTheme.displayMedium?.copyWith(fontSize: baseFontSize + 6),
      displaySmall: baseTheme.displaySmall?.copyWith(fontSize: baseFontSize + 4),
      headlineLarge: baseTheme.headlineLarge?.copyWith(fontSize: baseFontSize + 4),
      headlineMedium: baseTheme.headlineMedium?.copyWith(fontSize: baseFontSize + 2),
      headlineSmall: baseTheme.headlineSmall?.copyWith(fontSize: baseFontSize + 2),
      titleLarge: baseTheme.titleLarge?.copyWith(fontSize: baseFontSize + 2),
      titleMedium: baseTheme.titleMedium?.copyWith(fontSize: baseFontSize),
      titleSmall: baseTheme.titleSmall?.copyWith(fontSize: baseFontSize - 2),
      bodyLarge: baseTheme.bodyLarge?.copyWith(fontSize: baseFontSize),
      bodyMedium: baseTheme.bodyMedium?.copyWith(fontSize: baseFontSize - 2),
      bodySmall: baseTheme.bodySmall?.copyWith(fontSize: baseFontSize - 4),
      labelLarge: baseTheme.labelLarge?.copyWith(fontSize: baseFontSize - 2),
      labelMedium: baseTheme.labelMedium?.copyWith(fontSize: baseFontSize - 4),
      labelSmall: baseTheme.labelSmall?.copyWith(fontSize: baseFontSize - 6),
    );
  }
}