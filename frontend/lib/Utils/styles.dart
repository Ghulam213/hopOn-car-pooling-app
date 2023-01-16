import 'package:flutter/material.dart';
import 'package:hop_on/utils/colors.dart';

mixin Styles {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.blue6,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    backgroundColor: AppColors.LM_BACKGROUND_BASIC,
    textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontFamily: "Roboto",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        ),
        bodyText2: TextStyle(
          fontFamily: "Roboto",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.blue6,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    backgroundColor: AppColors.LM_BACKGROUND_BASIC,
    textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        ),
        bodyText2: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.grey6,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
