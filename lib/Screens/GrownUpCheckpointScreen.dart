import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

const String kGrownUpImage = 'assets/pngs/grownup.png';

class GrownUpCheckpointScreen extends StatelessWidget {
  const GrownUpCheckpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [
          // Decorative pastel circle - left
          Positioned(
            left: -35,
            top: Sz.w(310),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(95),
                height: Sz.w(95),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDDF5E7)
                      .withValues(alpha: 0.45),
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================================
              // HEADER
              // =================================================

              const AppHeader(
                title: 'Grown-up\ncheckpoint',
                subtitle:
                'A parent, guardian, or teacher can set up your safe learning space.',
              ),

              SizedBox(height: AppSpace.s16),

              // =================================================
              // MAIN COLORFUL CARD
              // =================================================

              Container(
                padding: EdgeInsets.all(AppSpace.s16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFEAF1FF),
                      Color(0xFFF2EDFF),
                      Color(0xFFE7F8F1),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(AppRadius.sheet),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5367C7)
                          .withValues(alpha: 0.13),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =============================================
                    // BIGGER GROWN-UP ILLUSTRATION
                    // =============================================

                    Center(
                      child: Container(
                        width: Sz.w(200),
                        height: Sz.w(165),
                        padding: EdgeInsets.all(AppSpace.s6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.80),
                          borderRadius:
                          BorderRadius.circular(AppRadius.sheet),
                        ),
                        child: Image.asset(
                          kGrownUpImage,
                          fit: BoxFit.contain,
                          errorBuilder: (_, error, __) {
                            debugPrint(
                              'GROWN-UP IMAGE ERROR: $error',
                            );

                            return Center(
                              child: LumiFace(
                                size: AppSize.avatar,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpace.s16),

                    // =============================================
                    // TITLE
                    // =============================================

                    Text(
                      'Pass the device to your grown-up',
                      textAlign: TextAlign.center,
                      style: AppText.heading.c(Fg.ink),
                    ),

                    SizedBox(height: AppSpace.s6),

                    Text(
                      'A parent or teacher can create an account to manage learners and follow their learning progress.',
                      textAlign: TextAlign.center,
                      style: AppText.body.c(Fg.muted),
                    ),

                    SizedBox(height: AppSpace.s14),

                    // =============================================
                    // SMALL INFO CHIPS
                    // =============================================

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpace.s6,
                      runSpacing: AppSpace.s6,
                      children: [
                        _InfoChip(
                          icon: Icons.lock_outline_rounded,
                          text: 'Private',
                          background: const Color(0xFFE4ECFF),
                          foreground: const Color(0xFF5367C7),
                        ),
                        _InfoChip(
                          icon: Icons.child_care_rounded,
                          text: 'Child-safe',
                          background: const Color(0xFFDDF5E7),
                          foreground: const Color(0xFF37845A),
                        ),
                        _InfoChip(
                          icon: Icons.favorite_outline_rounded,
                          text: 'Made with care',
                          background: const Color(0xFFFFE7EA),
                          foreground: const Color(0xFFD45B70),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpace.s18),

                    // =============================================
                    // SIGN UP BUTTON
                    // =============================================

                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(AppRadius.button),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F67D8)
                                .withValues(alpha: 0.20),
                            blurRadius: 14,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        label: 'Sign up with email',
                        icon: Icons.mail_outline_rounded,
                        onPressed: () =>
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                const SignUpScreen(),
                              ),
                            ),
                      ),
                    ),

                    SizedBox(height: AppSpace.s10),

                    // =============================================
                    // LOGIN BUTTON
                    // =============================================

                    Container(
                      padding: EdgeInsets.all(AppSpace.s4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EDFF),
                        borderRadius:
                        BorderRadius.circular(AppRadius.button),
                      ),
                      child: SecondaryButton(
                        label: 'I already have an account',
                        icon: Icons.login_rounded,
                        onPressed: () =>
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                const LoginScreen(),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s14),

              // =================================================
              // CHILD SAFETY CARD
              // =================================================

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.s12,
                  vertical: AppSpace.s10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF5E7),
                  borderRadius:
                  BorderRadius.circular(AppRadius.card),
                  border: Border.all(
                    color: const Color(0xFF37845A)
                        .withValues(alpha: 0.12),
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
                      child: Icon(
                        Icons.shield_outlined,
                        size: AppSize.icon,
                        color: const Color(0xFF37845A),
                      ),
                    ),

                    SizedBox(width: AppSpace.s10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A safe place to learn',
                            style: AppText.label.c(
                              const Color(0xFF37845A),
                            ),
                          ),
                          SizedBox(height: AppSpace.s2),
                          Text(
                            'Child-safe · no ads · private by design',
                            style: AppText.caption.c(
                              const Color(0xFF55916D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpace.s14),

              // =================================================
              // PRIVACY / CONSENT
              // =================================================

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.s6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: AppSize.iconXs,
                      color: Fg.muted,
                    ),

                    SizedBox(width: AppSpace.s6),

                    Expanded(
                      child: Text(
                        'By continuing, you agree to the Terms and confirm '
                            'grown-up consent. Children never need to enter an email.',
                        style: AppText.caption.c(Fg.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// SMALL INFO CHIP
// =============================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s10,
        vertical: AppSpace.s8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
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
            text,
            style: AppText.captionBold.c(foreground),
          ),
        ],
      ),
    );
  }
}