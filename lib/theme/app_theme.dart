import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        primaryContainer: AppColors.gray100,
        onPrimaryContainer: AppColors.gunmetal800,
        surface: AppColors.white,
        onSurface: AppColors.gunmetal800,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: TextStyles.textTheme,
      appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.gray500,
          disabledForegroundColor: AppColors.gray50,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          minimumSize: const Size(24, 48),
          iconSize: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyles.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          alignment: Alignment.center,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.gunmetal600,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          minimumSize: const Size(24, 48),
          iconSize: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.gunmetal600),
          ),
          textStyle: TextStyles.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          alignment: Alignment.center,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.gray50,
        filled: true,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gunmetal400),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger500),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyles.textTheme.bodyMedium!.copyWith(
          color: AppColors.gunmetal400,
        ),
        labelStyle: TextStyles.textTheme.titleMedium!.copyWith(
          color: AppColors.gunmetal800,
        ),
        errorStyle: TextStyles.textTheme.bodySmall!.copyWith(
          color: AppColors.danger500,
        ),
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.badge,
        textColor: AppColors.white,
        textStyle: TextStyles.textTheme.bodySmall,
      ),

      sliderTheme: SliderThemeData(
        rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
        valueIndicatorColor: AppColors.gunmetal500,
        valueIndicatorTextStyle: TextStyles.textTheme.titleSmall!.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        showValueIndicator: ShowValueIndicator.always,
        inactiveTrackColor: AppColors.gray400,
        activeTrackColor: AppColors.gunmetal500,
        activeTickMarkColor: AppColors.gunmetal500,
        thumbColor: AppColors.gunmetal500,
        overlayColor: AppColors.gunmetal500.withAlpha(32),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.white,
        todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
        todayBackgroundColor: WidgetStateProperty.all(AppColors.alizarin100),

        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          } else if (states.contains(WidgetState.disabled)) {
            return AppColors.gray500;
          }
          return AppColors.black;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          } else if (states.contains(WidgetState.hovered)) {
            return AppColors.alizarin100;
          }
          return Colors.transparent;
        }),
        dayOverlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.alizarin200;
          }
          return null;
        }),
        dayShape: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return CircleBorder();
          }
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        }),
      ),

      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStatePropertyAll(AppColors.primary),
        fillColor: WidgetStatePropertyAll(Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: WidgetStateBorderSide.resolveWith((states) {
          return const BorderSide(color: AppColors.gunmetal500);
        }),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: TextStyles.textTheme.bodyMedium,
          foregroundColor: AppColors.black,
        ),
      ),

      splashColor: AppColors.gunmetal500.withAlpha(32),
      highlightColor: AppColors.gunmetal100,
      hoverColor: AppColors.gray300,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      textTheme: TextStyles.textTheme.apply(
        bodyColor: AppColors.white,
        displayColor: AppColors.white,
      ),
    );
  }
}
