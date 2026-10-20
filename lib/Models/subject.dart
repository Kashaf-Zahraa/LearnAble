import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final IconData icon;
  final Color bg;
  final Color accent;
  final int journeys;
  final int newCount;
  final bool premium;
  final String featuredLesson;

  const Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.bg,
    required this.accent,
    required this.journeys,
    required this.newCount,
    required this.featuredLesson,
    this.premium = false,
  });

  String get meta =>
      newCount > 0 ? '$journeys journeys · $newCount new' : '$journeys journeys';
}

class SubjectCatalog {
  static const List<Subject> all = [
    Subject(
      id: 'math',
      name: 'Mathematics',
      icon: Icons.calculate_rounded,
      bg: Color(0xFFE5EFFF),
      accent: Color(0xFF5269D8),
      journeys: 12,
      newCount: 4,
      featuredLesson: 'Fractions of a whole · 8 min',
    ),
    Subject(
      id: 'science',
      name: 'Science',
      icon: Icons.science_rounded,
      bg: Color(0xFFE1F7F4),
      accent: Color(0xFF318B83),
      journeys: 9,
      newCount: 2,
      featuredLesson: 'Why do clouds float? · 6 min',
    ),
    Subject(
      id: 'english',
      name: 'English',
      icon: Icons.menu_book_rounded,
      bg: Color(0xFFFFF1C9),
      accent: Color(0xFFB47A15),
      journeys: 11,
      newCount: 0,
      featuredLesson: 'Story sounds and words · 7 min',
    ),
    Subject(
      id: 'social',
      name: 'Social Studies',
      icon: Icons.public_rounded,
      bg: Color(0xFFDDF5E7),
      accent: Color(0xFF37845A),
      journeys: 8,
      newCount: 0,
      featuredLesson: 'Maps of our world · 8 min',
    ),
    Subject(
      id: 'computing',
      name: 'Computing',
      icon: Icons.code_rounded,
      bg: Color(0xFFF2E9FF),
      accent: Color(0xFF8A5BD6),
      journeys: 6,
      newCount: 0,
      premium: true,
      featuredLesson: 'Fun with patterns · 9 min',
    ),
    Subject(
      id: 'arts',
      name: 'Creative Arts',
      icon: Icons.palette_rounded,
      bg: Color(0xFFFFE7EA),
      accent: Color(0xFFD45B70),
      journeys: 7,
      newCount: 0,
      premium: true,
      featuredLesson: 'Colors that mix · 6 min',
    ),
  ];

  /// Bachay ke chune hue subject ids. Baad mein `learner_subjects` table se.
  static Set<String> selected = {};

  static List<Subject> get mine =>
      all.where((s) => selected.contains(s.id)).toList();
}
