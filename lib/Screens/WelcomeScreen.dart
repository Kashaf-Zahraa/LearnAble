import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'CreateLearnerProfileScreen.dart';
import 'GrownUpCheckpointScreen.dart';

const String kWelcomeImage = 'assets/pngs/welcome_scene.png';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _reveal(double start, double end, Widget child) {
    final anim = CurvedAnimation(
      parent: _c,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _reveal(
            0.0,
            0.45,
            const AppHeader(
              title: 'Welcome aboard!',
              subtitle: 'Lumi will help you find the right place.',
              showBack: false,
            ),
          ),
          SizedBox(height: AppSpace.s12),
          _reveal(
            0.15,
            0.65,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sheet),
                boxShadow: [
                  BoxShadow(
                    color: Fg.btn.withValues(alpha: 0.16),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sheet),
                child: AspectRatio(
                  aspectRatio: 354 / 210,
                  child: Image.asset(
                    kWelcomeImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, __) {
                      debugPrint('WELCOME IMAGE ERROR: $error');
                      return Container(
                        color: const Color(0xFFB8E1FF),
                        child: Center(child: LumiMascot(size: Sz.w(110))),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpace.s12),
          _reveal(
            0.4,
            0.85,
            PrimaryButton(
              label: "I'm a learner",
              icon: Icons.rocket_launch_outlined,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateLearnerProfileScreen(),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpace.s12),
          _reveal(
            0.5,
            0.95,
            SecondaryButton(
              label: "I'm a grown-up",
              icon: Icons.people_outline,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const GrownUpCheckpointScreen(),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpace.s12),
          _reveal(
            0.6,
            1.0,
            Center(
              child: Text(
                'You can change this later · Privacy',
                style: AppText.bodySm.c(Fg.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
