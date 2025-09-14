import 'package:flutter/material.dart';
import 'screens/input_screen.dart';
import 'core/constants.dart';

void main() {
  runApp(const PoolCalculatorApp());
}

class PoolCalculatorApp extends StatelessWidget {
  const PoolCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);
    return MaterialApp(
      title: 'Offline Pool Calculator',
      theme: base.copyWith(
        // 1) ColorScheme: drives primary/secondary, backgrounds, onPrimary, etc.
        colorScheme: ColorScheme.light(
          primary:       AppColors.primary,
          onPrimary:     AppColors.textColor,
          secondary:     AppColors.secondary,
          surface:    AppColors.backgroundColor,
          onSurface:  AppColors.textColor,
        ),

        // 2) Scaffold & canvas use your dark bg
        scaffoldBackgroundColor: AppColors.backgroundColor,
        canvasColor:            AppColors.backgroundColor,

        // 3) TextTheme: default all body/display text to your light text
        textTheme: base.textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor:    AppColors.textColor,
          displayColor: AppColors.textColor,
        ).copyWith(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium:  TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        // 4) Input fields default decoration (you can still override per-field)
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: AppColors.textColor.withValues(alpha : 0.7)),
          hintStyle:  TextStyle(color: AppColors.textColor.withValues(alpha : 0.4)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.textColor.withValues(alpha: 0.4),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // 5) Elevated buttons match your primary & text
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:   AppColors.primary,
            foregroundColor: AppColors.textColor,
          ),
        ),

        // 6) AppBar picks up your background & text colors
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          titleTextStyle:  TextStyle(color: AppColors.textColor, fontSize: 20),
          iconTheme:       IconThemeData(color: AppColors.textColor),
        ),

        // 7) Card defaults (for your result cards)
        cardTheme: CardThemeData(
          color: AppColors.backgroundColor.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),

        // 8) Pill shaped buttons theme
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(shape: const StadiumBorder()),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
        ),

      ),
      home: const InputScreen(),
    );
  }
}
