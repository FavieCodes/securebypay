import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central place for all colors, spacing and text styles so the whole
/// app stays visually consistent. This is the Dart equivalent of a
/// CSS "design tokens" file.
class AppColors {
  static const Color primaryPurple = Color(0xFF6C6FC4);
  static const Color primaryPurpleDark = Color(0xFF5A5DB8);
  static const Color background = Color(0xFFFAFAFA);
  static const Color panelBackground = Color(0xFFF7F7F5);
  static const Color inputBorder = Color(0xFFE2E2E2);
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  // Figma token: --Text-Secondary
  static const Color textSecondary = Color(0xFF525252);
  static const Color link = Color(0xFF6C6FC4);
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C);
  static const Color warningBg = Color(0xFFFCEED9);
  static const Color warningText = Color(0xFFB9770E);
  static const Color infoBg = Color(0xFFD6F5EA);
  static const Color infoText = Color(0xFF14996B);

  // Icon-badge tokens for the dashboard "Overview" stat cards
  // (Total Shipment / Total Exports / Total Import). These give each
  // card's leading icon its own tinted circle instead of sitting on
  // a plain white/transparent background.
  static const Color shipmentIconBg = Color(0xFFFCEED9);
  static const Color shipmentIconFg = Color(0xFFB9770E);
  static const Color exportIconBg = Color(0xFFDEF7E8);
  static const Color exportIconFg = Color(0xFF1E9E5A);
  static const Color importIconBg = Color(0xFFDCEEFB);
  static const Color importIconFg = Color(0xFF1E88C7);

  // The active/selected sidebar nav item's background. Deliberately its
  // own token rather than reusing primaryPurple — design called out this
  // specific spot as a distinct, slightly more muted shade.
  static const Color activeNavBg = Color(0xFF5A65AB);
}

class AppTextStyles {
  // "Sign in to your account" / "Create an account"
  // font-family: DM Sans; font-weight: 700; font-size: 32px;
  // line-height: 100%; letter-spacing: 0%;
  static TextStyle get heading => GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.0,
        letterSpacing: 0,
      );

  // "Log in to Myafrimall to enjoy seamless shipping..." paragraph
  // font-family: DM Sans; font-weight: 400; font-size: 14px;
  // line-height: 22px (=> height factor 22/14); letter-spacing: 0%;
  // color: var(--Text-Secondary, #525252)
  static TextStyle get subheading => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 22 / 14,
        letterSpacing: 0,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  // The "Sign Up" / "Login" inline link span
  // font-family: DM Sans; font-weight: 700; font-size: 14px;
  // line-height: 22px; letter-spacing: 0%; underline (solid).
  static TextStyle get link => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.link,
        height: 22 / 14,
        letterSpacing: 0,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
      );
}

/// Simple responsive breakpoints, the Flutter equivalent of CSS media queries.
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobile && w < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: GoogleFonts.dmSans(color: AppColors.textSecondary, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
  );
}