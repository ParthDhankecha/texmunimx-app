import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors
          .mainColor, // Used for primary elements (e.g., button colors, selected state, DatePicker header)
      onPrimary: Colors
          .white, // Used for text/icons on the primary color background (e.g., text inside buttons)
      secondary: AppColors
          .mainColor, // Optional: For secondary accents, often set to primary for simplicity
    ),

    // 2. Optional: Set primary color directly (for backward compatibility, but ColorScheme is preferred)
    primaryColor: AppColors.mainColor,

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.mainColor),
    ),

    primaryTextTheme: GoogleFonts.poppinsTextTheme(),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainColor,
    ),

    useMaterial3: true,

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      textStyle: TextStyle(color: Colors.black),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    textTheme: GoogleFonts.poppinsTextTheme(),

    scaffoldBackgroundColor: AppColors.appBg,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBg,
      surfaceTintColor: Colors.transparent,

      elevation: 1.0, // Fixed elevation
      scrolledUnderElevation: 0.0, // Prevents elevation/color change on scroll
      shadowColor: Colors.black12,
    ),
    cardColor: Colors.white,

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        surfaceTintColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.mainColor; // Color when switch is ON
        }
        return Colors.grey; // Color when switch is OFF
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.mainColor.withAlpha(128); // Track color when ON
        }
        return Colors.white; // Track color when OFF
      }),
      trackOutlineWidth: WidgetStatePropertyAll(0),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    log('them mode channged : $_themeMode');
    Get.changeTheme(_themeMode == ThemeMode.light ? lightTheme : darkTheme);
    refresh();
  }
}
