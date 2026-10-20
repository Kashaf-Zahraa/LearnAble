import 'package:flutter/material.dart';

import '../Models/learner_profile.dart';
import '../Models/subject.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/layout_helpers.dart';
import '../Widgets/screen_shell.dart';
import 'MainShell.dart';

class ChooseSubjectsScreen extends StatefulWidget {
  const ChooseSubjectsScreen({super.key});

  @override
  State<ChooseSubjectsScreen> createState() => _ChooseSubjectsScreenState();
}

class _ChooseSubjectsScreenState extends State<ChooseSubjectsScreen> {
  final Set<String> _picked = {...SubjectCatalog.selected};

  void _toggle(String id) {
    setState(() {
      if (!_picked.remove(id)) _picked.add(id);
    });
  }

  void _finish({bool skip = false}) {
    if (!skip && _picked.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick at least one subject, or tap Skip.')),
      );
      return;
    }

    SubjectCatalog.selected = skip ? {} : {..._picked};
    debugPrint('Subjects: ${SubjectCatalog.selected}');

    // Pichli saari screens hata kar seedha Home par
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = LearnerProfile.current.nickname;

    return ScreenShell(
      child: Stack(
        children: [
          Positioned(
            left: -35,
            top: Sz.w(380),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(95),
                height: Sz.w(95),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDDF5E7).withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: Sz.w(130),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(80),
                height: Sz.w(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0E9FF).withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _topBar(),
              SizedBox(height: AppSpace.s18),
              Text(
                'What do you love\nlearning?',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),
              SizedBox(height: AppSpace.s6),
              Text(
                'Pick as many as you like, $name.',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),
              SizedBox(height: AppSpace.s12),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpace.s12,
                    vertical: AppSpace.s6,
                  ),
                  decoration: BoxDecoration(
                    color: _picked.isEmpty
                        ? Fg.chipBg
                        : const Color(0xFFDDF5E7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: _picked.isEmpty
                          ? Fg.border
                          : const Color(0xFF37845A).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _picked.isEmpty
                            ? Icons.touch_app_outlined
                            : Icons.check_circle_rounded,
                        size: AppSize.iconXs,
                        color: _picked.isEmpty
                            ? Fg.muted
                            : const Color(0xFF37845A),
                      ),
                      SizedBox(width: AppSpace.s4),
                      Text(
                        _picked.isEmpty
                            ? 'Tap to choose'
                            : '${_picked.length} picked',
                        style: AppText.captionBold.c(
                          _picked.isEmpty
                              ? Fg.muted
                              : const Color(0xFF37845A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpace.s16),
              twoColumnGrid([
                for (final s in SubjectCatalog.all)
                  _SubjectPickCard(
                    subject: s,
                    selected: _picked.contains(s.id),
                    onTap: () => _toggle(s.id),
                  ),
              ]),
              SizedBox(height: AppSpace.s18),
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
                  label: 'Start my adventure',
                  icon: Icons.rocket_launch_outlined,
                  onPressed: () => _finish(),
                ),
              ),
              SizedBox(height: AppSpace.s6),
              Center(
                child: TextButton(
                  onPressed: () => _finish(skip: true),
                  child: Text('Skip for now',
                      style: AppText.label.c(Fg.blue)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline_rounded,
                      size: AppSize.iconXs, color: const Color(0xFFD45B70)),
                  SizedBox(width: AppSpace.s4),
                  Flexible(
                    child: Text(
                      'You can change your subjects any time.',
                      textAlign: TextAlign.center,
                      style: AppText.caption.c(Fg.muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: Sz.w(42),
          height: Sz.w(42),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEFF),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back_rounded,
                color: const Color(0xFF5269D8), size: AppSize.icon),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: AppSpace.s10),
        Container(
          width: Sz.w(36),
          height: Sz.w(36),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1C9),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Icon(Icons.auto_awesome_rounded,
              color: const Color(0xFFB47A15), size: AppSize.icon),
        ),
        SizedBox(width: AppSpace.s8),
        Text('LearnAble',
            style: AppText.subheading.c(const Color(0xFF4053B5))),
      ],
    );
  }
}

// =============================================================
// SUBJECT PICK CARD
// =============================================================

class _SubjectPickCard extends StatelessWidget {
  final Subject subject;
  final bool selected;
  final VoidCallback onTap;

  const _SubjectPickCard({
    required this.subject,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final a = subject.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Sz.w(118),
          padding: EdgeInsets.all(AppSpace.s12),
          decoration: BoxDecoration(
            color: subject.bg,
            borderRadius: BorderRadius.circular(AppRadius.sheet),
            border: Border.all(
              color: selected ? a : a.withValues(alpha: 0.15),
              width: selected ? 2.5 : 1.2,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: a.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ]
                : [],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Sz.w(44),
                    height: Sz.w(44),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Icon(subject.icon, size: AppSize.iconLg, color: a),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.c(Fg.ink)),
                      Text(subject.meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption.c(Fg.muted)),
                    ],
                  ),
                ],
              ),
              if (selected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: Sz.w(25),
                    height: Sz.w(25),
                    decoration: BoxDecoration(
                      color: a,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: a.withValues(alpha: 0.25),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(Icons.check_rounded,
                        color: Colors.white, size: Sz.w(17)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
