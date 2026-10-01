import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Responsive scaler. Figma frame 390 px wide hai, isliye har number
/// (Figma wala) yahan se guzar kar asli screen ke hisab se scale hota hai.
///
/// main.dart mein MaterialApp ke `builder` mein ek dafa `Sz.init(context)`
/// call karna zaroori hai
class Sz {
  static const double figmaWidth = 390;
  static const double maxContentWidth = 520; // ScreenShell ki max width

  static double _scale = 1;

  static void init(BuildContext context) {
    final w = math.min(MediaQuery.sizeOf(context).width, maxContentWidth);
    _scale = (w / figmaWidth).clamp(0.85, 1.3);
  }

  /// Padding, gaps, radius, icon, height, width ke liye
  static double w(double v) => v * _scale;

  /// Font sizes ke liye
  static double sp(double v) => v * _scale;
}

/// Gaps / padding. Naam number ke hisab se hai (Figma value).
class AppSpace {
  static double get s2 => Sz.w(2);
  static double get s4 => Sz.w(4);
  static double get s6 => Sz.w(6);
  static double get s8 => Sz.w(8);
  static double get s10 => Sz.w(10);
  static double get s12 => Sz.w(12);
  static double get s14 => Sz.w(14);
  static double get s16 => Sz.w(16);
  static double get s18 => Sz.w(18);
  static double get s20 => Sz.w(20);
  static double get s24 => Sz.w(24);
  static double get s36 => Sz.w(36);

  // Screen ke padding
  static double get screenSide => Sz.w(18);
  static double get screenTop => Sz.w(28);
  static double get screenBottom => Sz.w(24);
}

class AppRadius {
  static double get sm => Sz.w(10);
  static double get md => Sz.w(14); // chips, text fields (dialog)
  static double get card => Sz.w(16); // cards, icon buttons
  static double get button => Sz.w(18);
  static double get dialog => Sz.w(20);
  static double get sheet => Sz.w(24);
  static double get pill => Sz.w(999);
}

/// Component sizes
class AppSize {
  static const double maxWidth = Sz.maxContentWidth;

  static double get button => Sz.w(52);
  static double get buttonSm => Sz.w(50);
  static double get iconBtn => Sz.w(42);
  static double get chip => Sz.w(34);
  static double get inputIcon => Sz.w(38);

  static double get iconXs => Sz.w(15);
  static double get iconSm => Sz.w(19);
  static double get icon => Sz.w(20);
  static double get iconLg => Sz.w(23);
  static double get iconXl => Sz.w(32);

  static double get avatar => Sz.w(62);
  static double get mascot => Sz.w(120);
  static double get choiceCard => Sz.w(106);
}

/// Text styles (color nahi hai, `.c(Fg.ink)` se lagao)
/// Weights yahan ek jagah hain: Figma se match na ho to sirf yahan badlo.
class AppText {
  static TextStyle get display => TextStyle(
      fontSize: Sz.sp(42), fontWeight: FontWeight.w800, letterSpacing: 0.5);

  static TextStyle get titleLg =>
      TextStyle(fontSize: Sz.sp(26), fontWeight: FontWeight.w800);

  /// Screen header title (Figma: 22 / 30)
  static TextStyle get title => TextStyle(
      fontSize: Sz.sp(22), height: 30 / 22, fontWeight: FontWeight.w800);

  static TextStyle get heading =>
      TextStyle(fontSize: Sz.sp(18), fontWeight: FontWeight.w700);

  static TextStyle get subheading => TextStyle(
      fontSize: Sz.sp(15), height: 1.35, fontWeight: FontWeight.w700);

  static TextStyle get label => TextStyle(
      fontSize: Sz.sp(14), height: 1.35, fontWeight: FontWeight.w700);

  static TextStyle get body => TextStyle(
      fontSize: Sz.sp(13), height: 1.4, fontWeight: FontWeight.w400);

  static TextStyle get bodySm => TextStyle(
      fontSize: Sz.sp(12), height: 16 / 12, fontWeight: FontWeight.w400);

  static TextStyle get caption => TextStyle(
      fontSize: Sz.sp(11), height: 1.35, fontWeight: FontWeight.w400);

  static TextStyle get captionBold => TextStyle(
      fontSize: Sz.sp(11), height: 15 / 11, fontWeight: FontWeight.w700);

  static TextStyle get chip => TextStyle(
      fontSize: Sz.sp(12), height: 16 / 12, fontWeight: FontWeight.w700);

  static TextStyle get button =>
      TextStyle(fontSize: Sz.sp(16), fontWeight: FontWeight.w700);

  static TextStyle get buttonSm =>
      TextStyle(fontSize: Sz.sp(15), fontWeight: FontWeight.w700);
}

extension TextStyleColor on TextStyle {
  TextStyle c(Color color) => copyWith(color: color);
}
