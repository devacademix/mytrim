import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  // Core brand colors — same hue as before, now fully opaque for a solid,
  // consistent look instead of the previous translucent (90% alpha) primary.
  static const appColor = Color(0xFF3401FF);
  static const appColorDark = Color(0xFF2600C4);
  static const secondaryAppColor = Color(0xFF234AD6);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF000000);
  static const greyColor = Colors.grey;
  static const backgroundColor = Color(0xFFF5F6FA);
  static const orangeColor = Color(0xFFF59E0B);
  static const greenColor = Color(0xFF2E9E5B);
  static const redColor = Color(0xFFE5484D);
  static const transparent = Color.fromARGB(0, 0, 0, 0);

  // Neutral text/surface scale for a more refined, professional look.
  static const textPrimary = Color(0xFF1A1A1F);
  static const textSecondary = Color(0xFF6B7280);
  static const borderColor = Color(0xFFE3E5EA);
  static const surfaceColor = Color(0xFFFFFFFF);

  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);

  // Shared card/list design tokens for the UI polish pass.
  static const cardRadius = 18.0;
  static const chipRadius = 999.0;
  static const surfaceTint = Color(0xFFF7F6FB);

  static List<BoxShadow> get cardShadow => [BoxShadow(color: ThemeProvider.blackColor.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 6), spreadRadius: -4)];

  static BoxDecoration cardDecoration({Color color = surfaceColor, double radius = cardRadius}) =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius), boxShadow: cardShadow, border: Border.all(color: borderColor, width: 1));
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  displayLarge: typeTheme.bodyLarge?.copyWith(fontFamily: 'bold', fontSize: 32, height: 1.25, letterSpacing: -0.3, color: ThemeProvider.textPrimary),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontFamily: 'bold', fontSize: 28, height: 1.28, letterSpacing: -0.2, color: ThemeProvider.textPrimary),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontFamily: 'bold', fontSize: 24, height: 1.3, color: ThemeProvider.textPrimary),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontFamily: 'semibold', fontSize: 21, height: 1.3, color: ThemeProvider.textPrimary),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontFamily: 'semibold', fontSize: 18, height: 1.35, color: ThemeProvider.textPrimary),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontFamily: 'semibold', fontSize: 16, height: 1.4, color: ThemeProvider.textPrimary),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontFamily: 'medium', fontSize: 24, height: 1.3, color: ThemeProvider.textPrimary),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontFamily: 'medium', fontSize: 21, height: 1.35, color: ThemeProvider.textPrimary),
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontFamily: 'regular', fontSize: 16, height: 1.5, color: ThemeProvider.textPrimary),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontFamily: 'regular', fontSize: 14, height: 1.5, color: ThemeProvider.textSecondary),
  labelLarge: typeTheme.bodyLarge?.copyWith(fontFamily: 'medium', fontSize: 14, height: 1.4, letterSpacing: 0.1, color: ThemeProvider.textPrimary),
);

ThemeData light = ThemeData(
    fontFamily: 'regular',
    primaryColor: ThemeProvider.appColor,
    secondaryHeaderColor: ThemeProvider.secondaryAppColor,
    scaffoldBackgroundColor: ThemeProvider.whiteColor,
    disabledColor: const Color(0xFFBABFC4),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9AA0A9),
    cardColor: ThemeProvider.appColor,
    dividerColor: ThemeProvider.borderColor,
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(surface: ThemeProvider.whiteColor).copyWith(error: const Color(0xFFE5484D)));

ThemeData dark = ThemeData(
    fontFamily: 'regular',
    primaryColor: ThemeProvider.blackColor,
    secondaryHeaderColor: const Color(0xFF009f67),
    disabledColor: const Color(0xffa2a7ad),
    brightness: Brightness.dark,
    hintColor: const Color(0xFFbebebe),
    cardColor: Colors.black,
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.blackColor)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.dark(primary: ThemeProvider.blackColor, secondary: Color(0xFFffbd5c)).copyWith(surface: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)));
