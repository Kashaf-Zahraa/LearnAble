import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'CreateLearnerProfileScreen.dart';

class AccessibilityProfileScreen extends StatefulWidget {
  const AccessibilityProfileScreen({super.key});

  @override
  State<AccessibilityProfileScreen> createState() =>
      _AccessibilityProfileScreenState();
}

class _AccessibilityProfileScreenState
    extends State<AccessibilityProfileScreen> {

  // =============================================================
  // SELECTED ACCESSIBILITY PROFILE
  // Only one profile can be selected at a time.
  // =============================================================

  String? _selectedProfile;

  void _toggleProfile(String profile) {
    setState(() {
      // If the same option is tapped again, deselect it.
      // Otherwise, select the new option and automatically
      // deselect the previous one.
      if (_selectedProfile == profile) {
        _selectedProfile = null;
      } else {
        _selectedProfile = profile;
      }
    });
  }

  void _continue() {
    if (_selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose an accessibility profile.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateLearnerProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // =============================================
              // TOP BAR
              // =============================================

              Row(
                children: [
                  Container(
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

                  SizedBox(width: AppSpace.s10),

                  Container(
                    width: Sz.w(36),
                    height: Sz.w(36),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1C9),
                      borderRadius:
                      BorderRadius.circular(AppRadius.card),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: const Color(0xFFB47A15),
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

              // =============================================
              // HEADER
              // =============================================

              Text(
                'Choose your\naccessibility profile',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),

              SizedBox(height: AppSpace.s6),

              Text(
                'Choose the support option that best fits your learning needs.',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),

              SizedBox(height: AppSpace.s6),
              SizedBox(height: AppSpace.s18),

              // =============================================
              // ROW 1
              // =============================================

              Row(
                children: [
                  Expanded(
                    child: _AccessibilityCard(
                      title: 'Blind /\nLow Vision',
                      imagePath:
                      'assets/pngs/low_vision.png',
                      backgroundColor:
                      const Color(0xFFFFF1C9),
                      accentColor:
                      const Color(0xFFB47A15),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'vision',

                      onTap: () =>
                          _toggleProfile('vision'),
                    ),
                  ),

                  SizedBox(width: AppSpace.s10),

                  Expanded(
                    child: _AccessibilityCard(
                      title: 'Deaf / Hard\nof Hearing',
                      imagePath:
                      'assets/pngs/hearing_support.png',
                      backgroundColor:
                      const Color(0xFFE5EFFF),
                      accentColor:
                      const Color(0xFF5269D8),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'hearing',

                      onTap: () =>
                          _toggleProfile('hearing'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpace.s10),

              // =============================================
              // ROW 2
              // =============================================

              Row(
                children: [
                  Expanded(
                    child: _AccessibilityCard(
                      title: 'Non-verbal',
                      imagePath:
                      'assets/pngs/non_verbal.png',
                      backgroundColor:
                      const Color(0xFFDDF5E7),
                      accentColor:
                      const Color(0xFF37845A),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'non_verbal',

                      onTap: () =>
                          _toggleProfile('non_verbal'),
                    ),
                  ),

                  SizedBox(width: AppSpace.s10),

                  Expanded(
                    child: _AccessibilityCard(
                      title: 'Color-blind',
                      imagePath:
                      'assets/pngs/color_blind.png',
                      backgroundColor:
                      const Color(0xFFF2E9FF),
                      accentColor:
                      const Color(0xFF8A5BD6),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'color_blind',

                      onTap: () =>
                          _toggleProfile('color_blind'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpace.s10),

              // =============================================
              // ROW 3
              // =============================================

              Row(
                children: [
                  Expanded(
                    child: _AccessibilityCard(
                      title: 'Autism',
                      imagePath:
                      'assets/pngs/autism.png',
                      backgroundColor:
                      const Color(0xFFFFE7EA),
                      accentColor:
                      const Color(0xFFD45B70),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'autism',

                      onTap: () =>
                          _toggleProfile('autism'),
                    ),
                  ),

                  SizedBox(width: AppSpace.s10),

                  Expanded(
                    child: _AccessibilityCard(
                      title: 'ADHD',
                      imagePath:
                      'assets/pngs/adhd.png',
                      backgroundColor:
                      const Color(0xFFE1F7F4),
                      accentColor:
                      const Color(0xFF318B83),

                      // SINGLE SELECTION
                      selected:
                      _selectedProfile == 'adhd',

                      onTap: () =>
                          _toggleProfile('adhd'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpace.s18),

              // =============================================
              // CONTINUE BUTTON
              // =============================================

              Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(AppRadius.button),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5269D8)
                          .withValues(alpha: 0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _continue,
                ),
              ),

              SizedBox(height: AppSpace.s12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_accessibility_rounded,
                    size: AppSize.iconXs,
                    color: Fg.muted,
                  ),

                  SizedBox(width: AppSpace.s4),

                  Flexible(
                    child: Text(
                      'You can change this choice later.',
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
// ACCESSIBILITY OPTION CARD
// =============================================================

class _AccessibilityCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  const _AccessibilityCard({
    required this.title,
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
        BorderRadius.circular(AppRadius.card),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Sz.w(125),
          padding: EdgeInsets.all(AppSpace.s10),

          decoration: BoxDecoration(
            color: backgroundColor,

            borderRadius:
            BorderRadius.circular(AppRadius.card),

            border: Border.all(
              color: selected
                  ? accentColor
                  : accentColor.withValues(alpha: 0.15),
              width: selected ? 2.5 : 1.2,
            ),

            boxShadow: selected
                ? [
              BoxShadow(
                color: accentColor
                    .withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ]
                : [],
          ),

          child: Stack(
            children: [
              Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  Expanded(
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,

                        errorBuilder:
                            (_, error, __) {
                          return Icon(
                            Icons.accessibility_new_rounded,
                            size: Sz.w(40),
                            color: accentColor,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpace.s4),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppText.label.c(Fg.ink),
                  ),
                ],
              ),

              // =============================================
              // SELECTED CHECKMARK
              // =============================================

              if (selected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: Sz.w(25),
                    height: Sz.w(25),

                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: accentColor
                              .withValues(alpha: 0.25),
                          blurRadius: 6,
                        ),
                      ],
                    ),

                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: Sz.w(17),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}