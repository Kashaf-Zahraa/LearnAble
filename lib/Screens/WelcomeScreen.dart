import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'LearnerTypeScreen.dart';
import 'GrownUpCheckpointScreen.dart';

const String kWelcomeImage = 'assets/pngs/welcome_scene.png';
const String kWelcomeChildImage = 'assets/pngs/welcome_child.png';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _reveal(double start, double end, Widget child) {
    final anim = CurvedAnimation(
      parent: _c,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.07),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  Widget _featureChip({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s10,
        vertical: AppSpace.s8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: foreground.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSize.iconXs,
            color: foreground,
          ),
          SizedBox(width: AppSpace.s4),
          Text(
            label,
            style: AppText.captionBold.c(foreground),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [
          // Green decorative background circle
          Positioned(
            left: -30,
            top: Sz.w(300),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(90),
                height: Sz.w(90),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFCFEEDD)
                      .withValues(alpha: 0.35),
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =====================================================
              // TOP SECTION
              // =====================================================

              _reveal(
                0.0,
                0.40,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // LEARNABLE LOGO - OUTSIDE THE COLORED BOX
                    // =================================================

                    Row(
                      children: [
                        Container(
                          width: Sz.w(38),
                          height: Sz.w(38),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEFF),
                            borderRadius:
                            BorderRadius.circular(AppRadius.card),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: const Color(0xFF5269D8),
                            size: AppSize.icon,
                          ),
                        ),

                        SizedBox(width: AppSpace.s10),

                        Text(
                          'LearnAble',
                          style: AppText.subheading.c(
                            const Color(0xFF4053B5),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpace.s12),

                    // =================================================
                    // WELCOME BOX
                    // =================================================

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: AppSpace.s14,
                        right: AppSpace.s8,
                        top: AppSpace.s10,
                        bottom: AppSpace.s10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E9FF),
                        borderRadius:
                        BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: const Color(0xFFDDEEFF),
                          width: 1,
                        ),
                      ),
                      child: SizedBox(
                        height: Sz.w(110),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            // =========================================
                            // WELCOME TEXT
                            // =========================================

                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to LearnAble!',
                                    style:
                                    AppText.heading.c(Fg.ink),
                                  ),

                                  SizedBox(
                                    height: AppSpace.s6,
                                  ),

                                  Text(
                                    'Let’s personalize your learning experience.',
                                    style:
                                    AppText.body.c(Fg.muted),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: AppSpace.s4),

                            // =========================================
                            // CHILD IMAGE
                            // =========================================

                            Image.asset(
                              kWelcomeChildImage,
                              width: Sz.w(115),
                              height: Sz.w(115),
                              fit: BoxFit.contain,
                              alignment:
                              Alignment.bottomCenter,
                              errorBuilder:
                                  (_, error, __) {
                                debugPrint(
                                  'WELCOME CHILD IMAGE ERROR: $error',
                                );

                                return SizedBox(
                                  width: Sz.w(115),
                                  height: Sz.w(115),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s12),

              // =====================================================
              // MAIN WELCOME SCENE
              // =====================================================

              _reveal(
                0.12,
                0.60,
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(AppRadius.sheet),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFDDEBFF),
                        Color(0xFFE9E2FF),
                        Color(0xFFDDF8EE),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5367C7)
                            .withValues(alpha: 0.15),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(AppRadius.sheet),
                    child: AspectRatio(
                      aspectRatio: 354 / 205,
                      child: Image.asset(
                        kWelcomeImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, __) {
                          debugPrint(
                            'WELCOME IMAGE ERROR: $error',
                          );

                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFDCEBFF),
                                  Color(0xFFE9E4FF),
                                ],
                              ),
                            ),
                            child: Center(
                              child: LumiMascot(
                                size: Sz.w(115),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpace.s14),

              // =====================================================
              // FEATURE CHIPS
              // =====================================================

              _reveal(
                0.30,
                0.72,
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpace.s6,
                  runSpacing: AppSpace.s6,
                  children: [
                    _featureChip(
                      icon: Icons.favorite_outline_rounded,
                      label: 'Made for you',
                      background: const Color(0xFFFFE7EA),
                      foreground: const Color(0xFFD45B70),
                    ),

                    _featureChip(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Fun learning',
                      background: const Color(0xFFFFF1C9),
                      foreground: const Color(0xFFB47A15),
                    ),

                    _featureChip(
                      icon: Icons.accessibility_new_rounded,
                      label: 'Accessible',
                      background: const Color(0xFFDDF5E7),
                      foreground: const Color(0xFF37845A),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s18),

              // =====================================================
              // WHO ARE YOU?
              // =====================================================

              _reveal(
                0.38,
                0.78,
                Column(
                  children: [
                    Text(
                      'Who are you?',
                      textAlign: TextAlign.center,
                      style: AppText.heading.c(Fg.ink),
                    ),

                    SizedBox(height: AppSpace.s4),

                    Text(
                      'Choose how you would like to continue',
                      textAlign: TextAlign.center,
                      style: AppText.bodySm.c(Fg.muted),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s12),

              // =====================================================
              // LEARNER BUTTON
              // =====================================================

              _reveal(
                0.45,
                0.86,
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(AppRadius.button),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F67D8)
                            .withValues(alpha: 0.22),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    label: "I'm a learner",
                    icon: Icons.school_outlined,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                          const LearnerTypeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: AppSpace.s10),

              // =====================================================
              // GROWN-UP BUTTON
              // =====================================================

              _reveal(
                0.55,
                0.94,
                Container(
                  padding: EdgeInsets.all(AppSpace.s4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EDFF),
                    borderRadius:
                    BorderRadius.circular(AppRadius.button),
                  ),
                  child: SecondaryButton(
                    label: "I'm a grown-up",
                    icon: Icons.people_outline_rounded,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                          const GrownUpCheckpointScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: AppSpace.s14),

              // =====================================================
              // SAFETY MESSAGE
              // =====================================================

              _reveal(
                0.65,
                1.0,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: AppSize.iconXs,
                      color: const Color(0xFF55916D),
                    ),

                    SizedBox(width: AppSpace.s4),

                    Flexible(
                      child: Text(
                        'Safe · private · designed for every learner',
                        textAlign: TextAlign.center,
                        style: AppText.caption.c(
                          const Color(0xFF55916D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s6),

              _reveal(
                0.70,
                1.0,
                Center(
                  child: Text(
                    'You can change this later · Privacy',
                    style: AppText.caption.c(Fg.muted),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}