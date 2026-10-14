import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'GrownUpCheckpointScreen.dart';

// =============================================================
// IMAGES
// =============================================================

const String kParentGuardianImage =
    'assets/pngs/parent_guardian.png';

const String kTeacherImage =
    'assets/pngs/teacher.png';

class GrownUpTypeScreen extends StatefulWidget {
  const GrownUpTypeScreen({super.key});

  @override
  State<GrownUpTypeScreen> createState() =>
      _GrownUpTypeScreenState();
}

class _GrownUpTypeScreenState
    extends State<GrownUpTypeScreen> {

  String? _selectedType;

  // =============================================================
  // SELECT TYPE
  // =============================================================

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  // =============================================================
  // CONTINUE
  // =============================================================

  void _continue() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose how you support learners.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GrownUpCheckpointScreen(
          grownUpType: _selectedType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [

          // =====================================================
          // DECORATIVE BACKGROUND CIRCLE
          // =====================================================

          Positioned(
            left: -35,
            top: Sz.w(320),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(95),
                height: Sz.w(95),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDDF5E7)
                      .withValues(alpha: 0.40),
                ),
              ),
            ),
          ),

          Positioned(
            right: -30,
            top: Sz.w(150),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(80),
                height: Sz.w(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0E9FF)
                      .withValues(alpha: 0.50),
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [

              // =================================================
              // TOP BAR
              // =================================================

              Row(
                children: [

                  // BACK BUTTON

                  Container(
                    width: Sz.w(42),
                    height: Sz.w(42),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEFF),
                      borderRadius:
                      BorderRadius.circular(
                        AppRadius.card,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color:
                        const Color(0xFF5269D8),
                        size: AppSize.icon,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  SizedBox(width: AppSpace.s10),

                  // LEARNABLE ICON

                  Container(
                    width: Sz.w(36),
                    height: Sz.w(36),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1C9),
                      borderRadius:
                      BorderRadius.circular(
                        AppRadius.card,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color:
                      const Color(0xFFB47A15),
                      size: AppSize.icon,
                    ),
                  ),

                  SizedBox(width: AppSpace.s8),

                  Text(
                    'LearnAble',
                    style: AppText.subheading.c(
                      const Color(0xFF4053B5),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpace.s18),

              // =================================================
              // HEADER
              // =================================================

              Text(
                'Tell us about you',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),

              SizedBox(height: AppSpace.s6),

              Text(
                'How do you support your learner?',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),

              SizedBox(height: AppSpace.s6),

              Text(
                'Choose one option to personalize your experience.',
                textAlign: TextAlign.center,
                style: AppText.bodySm.c(Fg.muted),
              ),

              SizedBox(height: AppSpace.s18),

              // =================================================
              // PARENT / GUARDIAN CARD
              // =================================================

              _GrownUpTypeCard(
                title: 'Parent / Guardian',
                description:
                'Create a safe learning space and follow your child’s progress.',
                imagePath: kParentGuardianImage,
                backgroundColor:
                const Color(0xFFFFE7EA),
                accentColor:
                const Color(0xFFD45B70),
                selected:
                _selectedType == 'parent',
                onTap: () =>
                    _selectType('parent'),
              ),

              SizedBox(height: AppSpace.s12),

              // =================================================
              // TEACHER CARD
              // =================================================

              _GrownUpTypeCard(
                title: 'Teacher',
                description:
                'Support learners and guide their learning journey.',
                imagePath: kTeacherImage,
                backgroundColor:
                const Color(0xFFE5EFFF),
                accentColor:
                const Color(0xFF5269D8),
                selected:
                _selectedType == 'teacher',
                onTap: () =>
                    _selectType('teacher'),
              ),

              SizedBox(height: AppSpace.s18),

              // =================================================
              // CONTINUE BUTTON
              // =================================================

              Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(
                    AppRadius.button,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      const Color(0xFF5269D8)
                          .withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  label: 'Continue',
                  icon:
                  Icons.arrow_forward_rounded,
                  onPressed: _continue,
                ),
              ),

              SizedBox(height: AppSpace.s12),

              // =================================================
              // BOTTOM MESSAGE
              // =================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: AppSize.iconXs,
                    color: const Color(0xFF55916D),
                  ),

                  SizedBox(width: AppSpace.s4),

                  Flexible(
                    child: Text(
                      'Your choice helps us personalize LearnAble for you.',
                      textAlign: TextAlign.center,
                      style: AppText.caption.c(
                        const Color(0xFF55916D),
                      ),
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
}

// =============================================================
// GROWN-UP TYPE CARD
// =============================================================

class _GrownUpTypeCard extends StatelessWidget {

  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  const _GrownUpTypeCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.accentColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(
          AppRadius.sheet,
        ),

        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),

          height: Sz.w(155),

          padding:
          EdgeInsets.all(AppSpace.s14),

          decoration: BoxDecoration(
            color: backgroundColor,

            borderRadius:
            BorderRadius.circular(
              AppRadius.sheet,
            ),

            border: Border.all(
              color: selected
                  ? accentColor
                  : accentColor.withValues(
                alpha: 0.15,
              ),
              width: selected ? 2.5 : 1.2,
            ),

            boxShadow: selected
                ? [
              BoxShadow(
                color:
                accentColor.withValues(
                  alpha: 0.18,
                ),
                blurRadius: 14,
                offset:
                const Offset(0, 6),
              ),
            ]
                : [],
          ),

          child: Row(
            children: [

              // =================================================
              // IMAGE
              // =================================================

              Container(
                width: Sz.w(115),
                height: Sz.w(125),

                padding:
                EdgeInsets.all(AppSpace.s4),

                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.65),

                  borderRadius:
                  BorderRadius.circular(
                    AppRadius.card,
                  ),
                ),

                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,

                  errorBuilder:
                      (_, error, __) {

                    debugPrint(
                      'GROWN-UP TYPE IMAGE ERROR: $error',
                    );

                    return Icon(
                      title == 'Teacher'
                          ? Icons.school_rounded
                          : Icons.family_restroom_rounded,
                      size: Sz.w(50),
                      color: accentColor,
                    );
                  },
                ),
              ),

              SizedBox(width: AppSpace.s14),

              // =================================================
              // TEXT
              // =================================================

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      style:
                      AppText.subheading.c(
                        Fg.ink,
                      ),
                    ),

                    SizedBox(
                      height: AppSpace.s6,
                    ),

                    Text(
                      description,
                      style:
                      AppText.bodySm.c(
                        Fg.muted,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpace.s6),

              // =================================================
              // CHECKMARK
              // =================================================

              AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),

                width: Sz.w(28),
                height: Sz.w(28),

                decoration: BoxDecoration(
                  color: selected
                      ? accentColor
                      : Colors.white.withValues(
                    alpha: 0.75,
                  ),

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: selected
                        ? accentColor
                        : accentColor.withValues(
                      alpha: 0.30,
                    ),
                    width: 2,
                  ),

                  boxShadow: selected
                      ? [
                    BoxShadow(
                      color: accentColor
                          .withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 6,
                    ),
                  ]
                      : [],
                ),

                child: selected
                    ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: Sz.w(18),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}