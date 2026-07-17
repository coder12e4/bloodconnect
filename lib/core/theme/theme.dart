import 'package:flutter/material.dart';

/// Central place for every color used across the app (light mode).
/// Pulled from the red/white palette already used on the Login page.
class AppColors {
  AppColors._();

  static const Color primary = Colors.red;
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color textOnPrimary = Colors.white;
  static const Color textPrimary = Colors.red;
  static const Color border = Colors.grey;
  static const Color error = Colors.red;
}

/// Same palette, remapped for dark mode. Primary red is brightened slightly
/// so it doesn't look muddy against near-black surfaces, and surfaces/borders
/// shift to dark greys instead of white/light grey.
class AppColorsDark {
  AppColorsDark._();

  static const Color primary = Color(0xFFEF5350);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textOnPrimary = Colors.white;
  static const Color textPrimary = Color(0xFFEF5350);
  static const Color border = Color(0xFF5C5C5C);
  static const Color error = Color(0xFFEF5350);
}

/// Reusable text styles so every screen doesn't redeclare fontSize/weight by hand.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headerBrand = TextStyle(
    fontSize: 24,
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 6,
    color: AppColors.textPrimary,
  );
}

/// Same text styles, recolored for dark mode.
class AppTextStylesDark {
  AppTextStylesDark._();

  static const TextStyle headerBrand = TextStyle(
    fontSize: 24,
    color: AppColorsDark.textOnPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    color: AppColorsDark.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    color: AppColorsDark.textOnPrimary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColorsDark.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 6,
    color: AppColorsDark.textPrimary,
  );
}

/// Shared border shapes for form fields, so every TextFormField
/// doesn't need to redeclare enabled/focused/error borders individually.
class AppBorders {
  AppBorders._();

  static OutlineInputBorder _bordered(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder get enabled => _bordered(AppColors.border, 1.5);
  static OutlineInputBorder get focused => _bordered(AppColors.primary, 2);
  static OutlineInputBorder get error => _bordered(AppColors.error, 2);
  static OutlineInputBorder get focusedError => _bordered(AppColors.error, 2);
}

/// Same border shapes, recolored for dark mode.
class AppBordersDark {
  AppBordersDark._();

  static OutlineInputBorder _bordered(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder get enabled => _bordered(AppColorsDark.border, 1.5);
  static OutlineInputBorder get focused => _bordered(AppColorsDark.primary, 2);
  static OutlineInputBorder get error => _bordered(AppColorsDark.error, 2);
  static OutlineInputBorder get focusedError => _bordered(AppColorsDark.error, 2);
}

/// App-wide ThemeData. Wire this into MaterialApp(theme: AppTheme.light).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: AppBorders.enabled,
        focusedBorder: AppBorders.focused,
        errorBorder: AppBorders.error,
        focusedErrorBorder: AppBorders.focusedError,
        border: AppBorders.enabled,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 55),
          elevation: 5,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: AppTextStyles.screenTitle,
        labelLarge: AppTextStyles.button,
        bodyMedium: AppTextStyles.link,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsDark.primary,
        brightness: Brightness.dark,
        primary: AppColorsDark.primary,
        surface: AppColorsDark.surface,
        error: AppColorsDark.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.surface,
        foregroundColor: AppColorsDark.textOnPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: AppBordersDark.enabled,
        focusedBorder: AppBordersDark.focused,
        errorBorder: AppBordersDark.error,
        focusedErrorBorder: AppBordersDark.focusedError,
        border: AppBordersDark.enabled,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.textOnPrimary,
          minimumSize: const Size(double.infinity, 55),
          elevation: 5,
          textStyle: AppTextStylesDark.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: AppTextStylesDark.screenTitle,
        labelLarge: AppTextStylesDark.button,
        bodyMedium: AppTextStylesDark.link,
      ),
    );
  }
}