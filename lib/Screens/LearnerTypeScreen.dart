import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'CreateLearnerProfileScreen.dart';
import 'AccessibilityProfileScreen.dart';

const String kIndependentLearnerImage =
    'assets/pngs/independent_learner.png';

const String kSupportedLearnerImage =
    'assets/pngs/supported_learner.png';

class LearnerTypeScreen extends StatelessWidget {
  const LearnerTypeScreen({super.key});

  // =============================================================
  // NAVIGATION
  // =============================================================

  void _continue(
      BuildContext context,
      String learnerType,
      ) {
    // Supported learner goes to accessibility selection
    if (learnerType == 'supported') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AccessibilityProfileScreen(),
        ),
      );
    } else {
      // Independent learner goes directly to profile creation
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CreateLearnerProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [
          // =========================================================
          // BACKGROUND DECORATION
          // =========================================================

          Positioned(
            left: -35,
            top: Sz.w(350),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(100),
                height: Sz.w(100),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDDF5E7)
                      .withValues(alpha: 0.45),
                ),
              ),
            ),
          ),

          // =========================================================
          // MAIN CONTENT
          // =========================================================

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =====================================================
              // BACK BUTTON
              // =====================================================

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: Sz.w(42),
                  height: Sz.w(42),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEFF),
                    borderRadius:
                    BorderRadius.circular(AppRadius.card),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFF5269D8),
                      size: AppSize.icon,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),

              SizedBox(height: AppSpace.s16),

              // =====================================================
              // HEADING
              // =====================================================

              Text(
                'How do you like\nto learn?',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),

              SizedBox(height: AppSpace.s6),

              Text(
                'Everyone learns differently. Choose what feels right for you.',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),

              SizedBox(height: AppSpace.s20),

              // =====================================================
              // INDEPENDENT LEARNER
              // =====================================================

              _LearnerChoiceCard(
                imagePath: kIndependentLearnerImage,
                title: 'I learn independently',
                description:
                'I’m comfortable learning without extra support.',
                backgroundColor: const Color(0xFFE5EFFF),
                accentColor: const Color(0xFF5269D8),
                onTap: () {
                  _continue(
                    context,
                    'independent',
                  );
                },
              ),

              SizedBox(height: AppSpace.s14),

              // =====================================================
              // SUPPORTED LEARNER
              // =====================================================

              _LearnerChoiceCard(
                imagePath: kSupportedLearnerImage,
                title: 'I need extra learning support',
                description:
                'I may need a little extra help with learning, focus, communication, or accessibility.',
                backgroundColor: const Color(0xFFF2E9FF),
                accentColor: const Color(0xFF8A5BD6),
                onTap: () {
                  _continue(
                    context,
                    'supported',
                  );
                },
              ),

              SizedBox(height: AppSpace.s16),

              // =====================================================
              // BOTTOM MESSAGE
              // =====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    size: AppSize.iconXs,
                    color: const Color(0xFFD45B70),
                  ),

                  SizedBox(width: AppSpace.s4),

                  Flexible(
                    child: Text(
                      'There is no wrong choice. You can change this later.',
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
}

// =============================================================
// LEARNER CHOICE CARD
// =============================================================

class _LearnerChoiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _LearnerChoiceCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(AppRadius.sheet),
        child: Container(
          padding: EdgeInsets.all(AppSpace.s14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
            BorderRadius.circular(AppRadius.sheet),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                accentColor.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // =====================================================
              // IMAGE
              // =====================================================

              Container(
                width: Sz.w(105),
                height: Sz.w(105),
                padding: EdgeInsets.all(AppSpace.s6),
                decoration: BoxDecoration(
                  color:
                  Colors.white.withValues(alpha: 0.75),
                  borderRadius:
                  BorderRadius.circular(AppRadius.card),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, error, __) {
                    debugPrint(
                      'LEARNER IMAGE ERROR: $error',
                    );

                    return Icon(
                      Icons.school_rounded,
                      size: AppSize.iconXl,
                      color: accentColor,
                    );
                  },
                ),
              ),

              SizedBox(width: AppSpace.s14),

              // =====================================================
              // TEXT
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                      AppText.subheading.c(Fg.ink),
                    ),

                    SizedBox(height: AppSpace.s6),

                    Text(
                      description,
                      style:
                      AppText.bodySm.c(Fg.muted),
                    ),

                    SizedBox(height: AppSpace.s10),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Choose',
                          style:
                          AppText.label.c(accentColor),
                        ),

                        SizedBox(width: AppSpace.s4),

                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppSize.iconXs,
                          color: accentColor,
                        ),
                      ],
                    ),
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