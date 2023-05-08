import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';


mixin Styles {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.PRIMARY_500,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "Roboto",
          fontSize: 18,
          height: 1.0,
          fontWeight: FontWeight.w500,
          color: AppColors.grey6,
        ),
        bodyMedium: TextStyle(
          fontFamily: "Roboto",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey1,
        ),
        bodySmall: TextStyle(
          fontFamily: "Roboto",
          fontSize: 12,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey1,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme(
      background: AppColors.LM_BACKGROUND_BASIC,
      brightness: Brightness.light,
      error: AppColors.RED,
      onBackground: AppColors.LM_BACKGROUND_BASIC,
      onError: AppColors.RED,
      onPrimary: AppColors.BLUE,
      onSecondary: AppColors.PRIMARY_700,
      onSurface: AppColors.PRIMARY_500,
      primary: AppColors.BLUE,
      secondary: AppColors.PRIMARY_700,
      surface: AppColors.PRIMARY_500,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.BLUE,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        ),
        bodyMedium: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        ),
        bodySmall: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
