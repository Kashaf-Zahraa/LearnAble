import 'package:flutter/material.dart';

import '../Models/learner_profile.dart';
import '../Models/subject.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/layout_helpers.dart';
import '../Widgets/screen_shell.dart';

class SubjectLibraryTab extends StatelessWidget {
  const SubjectLibraryTab({super.key});

  void _soon(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final profile = LearnerProfile.current;
    final mine = SubjectCatalog.selected;

    // Bachay ke chune hue subjects sab se upar
    final ordered = [
      ...SubjectCatalog.all.where((s) => mine.contains(s.id)),
      ...SubjectCatalog.all.where((s) => !mine.contains(s.id)),
    ];
    final rec = ordered.first;

    return TabScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Explore subjects',
                    style: AppText.title.c(Fg.ink)),
              ),
              const ToolsChip(),
            ],
          ),
          SizedBox(height: AppSpace.s4),
          Text(
            '${profile.grade} picks, with choices for every format.',
            style: AppText.body.c(Fg.muted),
          ),
          SizedBox(height: AppSpace.s14),

          // ---------------- RECOMMENDED ----------------
          Container(
            padding: EdgeInsets.all(AppSpace.s12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF1C9), Color(0xFFFFE7EA)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.sheet),
              border: Border.all(
                color: const Color(0xFFB47A15).withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB47A15).withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: Sz.w(42),
                  height: Sz.w(42),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Icon(Icons.auto_awesome_rounded,
                      size: AppSize.iconLg,
                      color: const Color(0xFFB47A15)),
                ),
                SizedBox(width: AppSpace.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recommended next',
                          style: AppText.label.c(Fg.ink)),
                      SizedBox(height: AppSpace.s2),
                      Text(rec.featuredLesson,
                          style: AppText.caption.c(Fg.muted)),
                    ],
                  ),
                ),
                SizedBox(width: AppSpace.s8),
                Material(
                  color: Colors.white,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () =>
                        _soon(context, 'Lesson screen jald aa rahi hai'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpace.s16,
                        vertical: AppSpace.s10,
                      ),
                      child: Text('Start', style: AppText.label.c(Fg.blue)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpace.s14),

          // ---------------- SUBJECT LIST ----------------
          for (final s in ordered) ...[
            _SubjectRow(
              subject: s,
              isPick: mine.contains(s.id),
              onTap: () => _soon(
                context,
                s.premium
                    ? 'Premium subjects need a grown-up to unlock.'
                    : '${s.name} journeys jald aa rahe hain',
              ),
            ),
            SizedBox(height: AppSpace.s10),
          ],
        ],
      ),
    );
  }
}

// =============================================================
// SUBJECT ROW
// =============================================================

class _SubjectRow extends StatelessWidget {
  final Subject subject;
  final bool isPick;
  final VoidCallback onTap;

  const _SubjectRow({
    required this.subject,
    required this.isPick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: EdgeInsets.all(AppSpace.s12),
          decoration: Fg.cardDeco(),
          child: Row(
            children: [
              Container(
                width: Sz.w(46),
                height: Sz.w(46),
                decoration: BoxDecoration(
                  color: subject.bg,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(subject.icon,
                    size: AppSize.iconLg, color: subject.accent),
              ),
              SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(subject.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.subheading.c(Fg.ink)),
                        ),
                        if (isPick) ...[
                          SizedBox(width: AppSpace.s6),
                          Icon(Icons.favorite_rounded,
                              size: AppSize.iconXs,
                              color: const Color(0xFFD45B70)),
                        ],
                      ],
                    ),
                    SizedBox(height: AppSpace.s2),
                    Text(subject.meta, style: AppText.caption.c(Fg.muted)),
                  ],
                ),
              ),
              SizedBox(width: AppSpace.s8),
              _Badge(premium: subject.premium),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool premium;
  const _Badge({required this.premium});

  @override
  Widget build(BuildContext context) {
    final bg = premium ? const Color(0xFFFFF1C9) : const Color(0xFFDDF5E7);
    final fg = premium ? const Color(0xFFB47A15) : const Color(0xFF37845A);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s10,
        vertical: AppSpace.s6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (premium) ...[
            Icon(Icons.workspace_premium_rounded,
                size: AppSize.iconXs, color: fg),
            SizedBox(width: AppSpace.s4),
          ],
          Text(premium ? 'Premium' : 'Free',
              style: AppText.captionBold.c(fg)),
        ],
      ),
    );
  }
}
