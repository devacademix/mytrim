import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  static const appColor = Color.fromARGB(229, 52, 1, 255);
  static const secondaryAppColor = Color.fromARGB(255, 35, 74, 214);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF000000);
  static const greyColor = Colors.grey;
  static const backgroundColor = Color(0xFFF3F3F3);
  static const orangeColor = Color(0xFFFF9900);
  static const greenColor = Color(0xFF32CD32);
  static const redColor = Color(0xFFFF0000);
  static const transparent = Color.fromARGB(0, 0, 0, 0);

  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);

  // Shared design tokens for the polished UI pass.
  static const mutedTextColor = Color(0xFF6B7280);
  static const subtleTextColor = Color(0xFF9CA3AF);
  static const dividerColor = Color(0xFFEEEEF2);
  static const surfaceTint = Color(0xFFF7F6FB);
  static const cardRadius = 18.0;
  static const chipRadius = 999.0;

  static List<BoxShadow> get cardShadow => [BoxShadow(color: ThemeProvider.blackColor.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 6), spreadRadius: -4)];

  static BoxDecoration cardDecoration({Color color = whiteColor, double radius = cardRadius}) =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius), boxShadow: cardShadow, border: Border.all(color: dividerColor, width: 1));

  // Maps the shared appointment/order status index -> [Created, Accepted, Rejected,
  // Ongoing, Completed, Cancelled, Refunded, Delayed, Pending Payment] to a semantic color.
  static Color statusColor(int status) {
    switch (status) {
      case 1: // Accepted
      case 3: // Ongoing
        return secondaryAppColor;
      case 4: // Completed
        return const Color(0xFF16A34A);
      case 2: // Rejected
      case 5: // Cancelled
        return const Color(0xFFDC2626);
      case 7: // Delayed
      case 8: // Pending Payment
        return const Color(0xFFD97706);
      case 6: // Refunded
        return const Color(0xFF7C3AED);
      default: // Created
        return mutedTextColor;
    }
  }
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(
  fontFamily: 'regular',
  primaryColor: ThemeProvider.appColor,
  secondaryHeaderColor: ThemeProvider.secondaryAppColor,
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: ThemeProvider.appColor,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)),
  textTheme: txtTheme,
  colorScheme:
      const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)),
);

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
  colorScheme: const ColorScheme.dark(primary: ThemeProvider.blackColor, secondary: Color(0xFFffbd5c)).copyWith(background: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)),
);
