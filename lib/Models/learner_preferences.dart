import 'package:flutter/material.dart';

/// Learner ki accessibility / comfort settings.
/// Abhi `LearnerPreferences.current` mein save hoti hain.
/// Baad mein `toMap()` se Firestore mein save kar sakte hain.
class LearnerPreferences {
  final String textSize; // Small, Medium, Large, Extra large
  final String contrast; // Soft, Normal, Strong
  final bool narration;
  final String captions; // Always, With sound, Off
  final String signLanguage; // When available, Always, Off
  final bool reducedMotion;
  final String pace; // Relaxed, Normal, Quick
  final String simplified; // Off, Short, Step-by-step
  final String focusTimer; // Off, 10 min, 15 min, 25 min

  const LearnerPreferences({
    this.textSize = 'Medium',
    this.contrast = 'Normal',
    this.narration = false,
    this.captions = 'With sound',
    this.signLanguage = 'Off',
    this.reducedMotion = false,
    this.pace = 'Normal',
    this.simplified = 'Off',
    this.focusTimer = 'Off',
  });

  static const textSizes = ['Small', 'Medium', 'Large', 'Extra large'];
  static const contrasts = ['Soft', 'Normal', 'Strong'];
  static const captionOptions = ['Always', 'With sound', 'Off'];
  static const signOptions = ['When available', 'Always', 'Off'];
  static const paces = ['Relaxed', 'Normal', 'Quick'];
  static const simplifiedOptions = ['Off', 'Short', 'Step-by-step'];
  static const timers = ['Off', '10 min', '15 min', '25 min'];

  /// Abhi ki chuni hui settings (baad mein Firestore se load hongi)
  static LearnerPreferences current = const LearnerPreferences();

  /// Accessibility profile ke hisab se shuruaati settings
  factory LearnerPreferences.forProfile(String? profile) {
    const base = LearnerPreferences();
    switch (profile) {
      case 'vision':
        return base.copyWith(
          textSize: 'Extra large',
          contrast: 'Strong',
          narration: true,
          captions: 'Off',
        );
      case 'hearing':
        return base.copyWith(
          captions: 'Always',
          signLanguage: 'When available',
          narration: false,
        );
      case 'non_verbal':
        return base.copyWith(
          captions: 'Always',
          simplified: 'Step-by-step',
          pace: 'Relaxed',
        );
      case 'color_blind':
        return base.copyWith(contrast: 'Strong');
      case 'autism':
        return base.copyWith(
          reducedMotion: true,
          pace: 'Relaxed',
          simplified: 'Step-by-step',
        );
      case 'adhd':
        return base.copyWith(
          focusTimer: '15 min',
          simplified: 'Step-by-step',
          pace: 'Normal',
        );
      default:
        return base;
    }
  }

  LearnerPreferences copyWith({
    String? textSize,
    String? contrast,
    bool? narration,
    String? captions,
    String? signLanguage,
    bool? reducedMotion,
    String? pace,
    String? simplified,
    String? focusTimer,
  }) {
    return LearnerPreferences(
      textSize: textSize ?? this.textSize,
      contrast: contrast ?? this.contrast,
      narration: narration ?? this.narration,
      captions: captions ?? this.captions,
      signLanguage: signLanguage ?? this.signLanguage,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      pace: pace ?? this.pace,
      simplified: simplified ?? this.simplified,
      focusTimer: focusTimer ?? this.focusTimer,
    );
  }

  double get textScale {
    switch (textSize) {
      case 'Small':
        return 0.9;
      case 'Large':
        return 1.15;
      case 'Extra large':
        return 1.3;
      default:
        return 1.0;
    }
  }

  Duration get wordDelay {
    switch (pace) {
      case 'Relaxed':
        return const Duration(milliseconds: 700);
      case 'Quick':
        return const Duration(milliseconds: 300);
      default:
        return const Duration(milliseconds: 450);
    }
  }

  int? get focusMinutes => int.tryParse(focusTimer.split(' ').first);

  bool get captionsVisible =>
      captions == 'Always' || (captions == 'With sound' && narration);

  Map<String, dynamic> toMap() => {
    'textSize': textSize,
    'contrast': contrast,
    'narration': narration,
    'captions': captions,
    'signLanguage': signLanguage,
    'reducedMotion': reducedMotion,
    'pace': pace,
    'simplified': simplified,
    'focusTimer': focusTimer,
  };
}

/// Contrast setting ke hisab se rang
class PrefPalette {
  final Color bg;
  final Color ink;
  final Color muted;
  final Color border;
  final Color accent;
  final double borderWidth;

  const PrefPalette({
    required this.bg,
    required this.ink,
    required this.muted,
    required this.border,
    required this.accent,
    required this.borderWidth,
  });

  static PrefPalette of(String contrast) {
    switch (contrast) {
      case 'Soft':
        return const PrefPalette(
          bg: Color(0xFFF5F9FF),
          ink: Color(0xFF3E4C6B),
          muted: Color(0xFF7C8AA5),
          border: Color(0xFFD8E6F3),
          accent: Color(0xFF6B7FD9),
          borderWidth: 1,
        );
      case 'Strong':
        return const PrefPalette(
          bg: Colors.white,
          ink: Color(0xFF050B18),
          muted: Color(0xFF2B3A55),
          border: Color(0xFF1F2F8F),
          accent: Color(0xFF1F2F8F),
          borderWidth: 2.5,
        );
      default:
        return const PrefPalette(
          bg: Colors.white,
          ink: Color(0xFF172B4D),
          muted: Color(0xFF60708F),
          border: Color(0xFFD8E6F3),
          accent: Color(0xFF4C63D9),
          borderWidth: 1,
        );
    }
  }
}
