import 'package:flutter/material.dart';

import '../Models/learner_profile.dart';
import '../Models/subject.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/layout_helpers.dart';
import '../Widgets/screen_shell.dart';

class ChildHomeTab extends StatelessWidget {
  final VoidCallback onOpenLibrary;

  const ChildHomeTab({super.key, required this.onOpenLibrary});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _soon(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final profile = LearnerProfile.current;
    final subjects = SubjectCatalog.mine.isEmpty
        ? SubjectCatalog.all.take(4).toList()
        : SubjectCatalog.mine;

    return TabScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------- HEADER ----------------
          Row(
            children: [
              _avatar(profile),
              SizedBox(width: AppSpace.s10),
              Expanded(
                child: Text(
                  '${_greeting()}, ${profile.nickname}!',
                  style: AppText.title.c(Fg.ink),
                ),
              ),
              SizedBox(width: AppSpace.s8),
              const ToolsChip(),
            ],
          ),
          SizedBox(height: AppSpace.s4),
          Text('Your boat is ready for today’s voyage.',
              style: AppText.body.c(Fg.muted)),
          SizedBox(height: AppSpace.s14),

          // ---------------- STATS ----------------
          // Abhi sample numbers. Baad mein learner_progress table se.
          Row(
            children: [
              const Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  bg: Color(0xFFFFF1C9),
                  fg: Color(0xFFB47A15),
                  count: 6,
                  label: 'day streak',
                ),
              ),
              SizedBox(width: AppSpace.s10),
              const Expanded(
                child: _StatCard(
                  icon: Icons.star_rounded,
                  bg: Color(0xFFF2E9FF),
                  fg: Color(0xFF8A5BD6),
                  count: 284,
                  label: 'stars',
                ),
              ),
              SizedBox(width: AppSpace.s10),
              const Expanded(
                child: _StatCard(
                  icon: Icons.track_changes_rounded,
                  bg: Color(0xFFE1F7F4),
                  fg: Color(0xFF318B83),
                  text: '2/3',
                  label: 'daily quest',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpace.s14),

          // ---------------- CONTINUE CARD ----------------
          Container(
            padding: EdgeInsets.all(AppSpace.s14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE8EBFF), Color(0xFFF1E4FF)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.sheet),
              border: Border.all(color: Fg.btn, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Fg.btn.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    LumiFace(size: Sz.w(54), color: Colors.white),
                    SizedBox(width: AppSpace.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Continue fractions',
                              style: AppText.heading.c(Fg.ink)),
                          SizedBox(height: AppSpace.s2),
                          Text('Math Island · 8 min',
                              style: AppText.caption.c(Fg.muted)),
                          SizedBox(height: AppSpace.s8),
                          const _Segments(filled: 6, total: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpace.s14),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5269D8).withValues(alpha: 0.20),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    label: 'Sail to lesson',
                    icon: Icons.navigation_outlined,
                    onPressed: () =>
                        _soon(context, 'Lesson screen jald aa rahi hai'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpace.s18),

          // ---------------- SUBJECT ISLANDS ----------------
          Row(
            children: [
              Expanded(
                child: Text('Your subject islands',
                    style: AppText.heading.c(Fg.ink)),
              ),
              TextButton(
                onPressed: onOpenLibrary,
                child: Text('See all', style: AppText.label.c(Fg.blue)),
              ),
            ],
          ),
          SizedBox(height: AppSpace.s6),
          twoColumnGrid([
            for (final s in subjects)
              _IslandCard(subject: s, onTap: onOpenLibrary),
          ]),
          SizedBox(height: AppSpace.s16),

          // ---------------- LUMI TIP ----------------
          Container(
            padding: EdgeInsets.all(AppSpace.s12),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF5E7),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: const Color(0xFF37845A).withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Sz.w(38),
                  height: Sz.w(38),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lightbulb_outline_rounded,
                      size: AppSize.icon, color: const Color(0xFF37845A)),
                ),
                SizedBox(width: AppSpace.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lumi’s tip',
                          style: AppText.label.c(const Color(0xFF37845A))),
                      SizedBox(height: AppSpace.s2),
                      Text(
                        'Stretch for two minutes after each journey. Your brain loves it!',
                        style: AppText.caption.c(const Color(0xFF55916D)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(LearnerProfile profile) {
    return Container(
      width: Sz.w(52),
      height: Sz.w(52),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Fg.btn, width: 2),
        boxShadow: [
          BoxShadow(
            color: Fg.btn.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          profile.avatarPath,
          fit: BoxFit.cover,
          errorBuilder: (_, error, __) => Icon(
            Icons.person_rounded,
            size: AppSize.iconLg,
            color: Fg.muted,
          ),
        ),
      ),
    );
  }
}

// =============================================================
// STAT CARD
// =============================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final int? count;
  final String? text;
  final String label;

  const _StatCard({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.label,
    this.count,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontSize: Sz.sp(22),
      height: 1.1,
      fontWeight: FontWeight.w800,
      color: Fg.ink,
    );

    return Container(
      height: Sz.w(98),
      padding: EdgeInsets.all(AppSpace.s12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: fg.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: AppSize.iconLg, color: fg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (count != null)
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: count!),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (_, v, __) => Text('$v', style: valueStyle),
                )
              else
                Text(text ?? '', style: valueStyle),
              SizedBox(height: AppSpace.s2),
              Text(label, style: AppText.caption.c(Fg.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// PROGRESS SEGMENTS
// =============================================================

class _Segments extends StatelessWidget {
  final int filled;
  final int total;

  const _Segments({required this.filled, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            height: Sz.w(8),
            margin: EdgeInsets.symmetric(horizontal: Sz.w(1.5)),
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFF1FB5A5)
                  : const Color(0xFFD5E3F0),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        );
      }),
    );
  }
}

// =============================================================
// ISLAND CARD
// =============================================================

class _IslandCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const _IslandCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          height: Sz.w(76),
          padding: EdgeInsets.all(AppSpace.s10),
          decoration: BoxDecoration(
            color: subject.bg,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: subject.accent.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: Sz.w(40),
                height: Sz.w(40),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(subject.icon,
                    size: AppSize.iconSm, color: subject.accent),
              ),
              SizedBox(width: AppSpace.s8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label.c(Fg.ink)),
                    Text('${subject.journeys} journeys',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.c(Fg.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
