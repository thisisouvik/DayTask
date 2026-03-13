import 'package:daytask/core/theme/app_colours.dart';
import 'package:flutter/material.dart';

class AppTheme {
  
  // darktheme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary:          AppColors.primary,
      secondary:        AppColors.primaryDark,
      surface:          AppColors.darkSurface,
      error:            AppColors.error,
      onPrimary:        AppColors.darkBackground,   // text on yellow btn
      onSecondary:      AppColors.darkTextPrimary,
      onSurface:        AppColors.darkTextPrimary,
      onError:          AppColors.darkTextPrimary,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor:  AppColors.darkBackground,
      elevation:        0,
      titleTextStyle: TextStyle(
        color:      AppColors.darkTextPrimary,
        fontSize:   20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),

    // Cards
    cardTheme: CardThemeData(
      color:     AppColors.darkSurface,
      elevation:    0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Bottom Nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      AppColors.darkNavBar,
      selectedItemColor:    AppColors.primary,
      unselectedItemColor:  AppColors.darkTextSecondary,
      type:                 BottomNavigationBarType.fixed,
      elevation:            0,
    ),

    // Input / Search
    inputDecorationTheme: InputDecorationTheme(
      filled:            true,
      fillColor:         AppColors.darkSurface,
      hintStyle:  const TextStyle(color: AppColors.darkTextHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   BorderSide.none,
      ),
    ),

    // Elevated Button (Primary CTA - yellow)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize:   15,
        ),
      ),
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge:  TextStyle(color: AppColors.darkTextPrimary,   fontWeight: FontWeight.w800, fontSize: 28),
      titleLarge:    TextStyle(color: AppColors.darkTextPrimary,   fontWeight: FontWeight.w700, fontSize: 20),
      titleMedium:   TextStyle(color: AppColors.darkTextPrimary,   fontWeight: FontWeight.w600, fontSize: 16),
      bodyLarge:     TextStyle(color: AppColors.darkTextPrimary,   fontSize: 15),
      bodyMedium:    TextStyle(color: AppColors.darkTextSecondary, fontSize: 13),
      labelSmall:    TextStyle(color: AppColors.darkTextHint,      fontSize: 11),
    ),

    dividerColor:   AppColors.divider,
    iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
  );


  // light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary:          AppColors.primary,
      secondary:        AppColors.primaryDark,
      surface:          AppColors.lightSurface,
      error:            AppColors.error,
      onPrimary:        AppColors.darkBackground,
      onSecondary:      AppColors.lightTextPrimary,
      onSurface:        AppColors.lightTextPrimary,
      onError:          AppColors.lightSurface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor:  AppColors.lightBackground,
      elevation:        0,
      titleTextStyle: TextStyle(
        color:      AppColors.lightTextPrimary,
        fontSize:   20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
    ),

    cardTheme: CardThemeData(
      color:     AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      AppColors.lightNavBar,
      selectedItemColor:    AppColors.primary,
      unselectedItemColor:  AppColors.lightTextSecondary,
      type:                 BottomNavigationBarType.fixed,
      elevation:            4,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:    true,
      fillColor: AppColors.lightCard,
      hintStyle: const TextStyle(color: AppColors.lightTextHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize:   15,
        ),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge:  TextStyle(color: AppColors.lightTextPrimary,   fontWeight: FontWeight.w800, fontSize: 28),
      titleLarge:    TextStyle(color: AppColors.lightTextPrimary,   fontWeight: FontWeight.w700, fontSize: 20),
      titleMedium:   TextStyle(color: AppColors.lightTextPrimary,   fontWeight: FontWeight.w600, fontSize: 16),
      bodyLarge:     TextStyle(color: AppColors.lightTextPrimary,   fontSize: 15),
      bodyMedium:    TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
      labelSmall:    TextStyle(color: AppColors.lightTextHint,      fontSize: 11),
    ),

    dividerColor:   AppColors.lightCard,
    iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
  );
}