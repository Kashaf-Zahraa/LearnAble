import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

class GrownUpCheckpointScreen extends StatelessWidget {
  const GrownUpCheckpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            title: 'Grown-up\ncheckpoint',
            subtitle:
            'A parent, guardian, or teacher can set up your safe learning space.',
          ),
          SizedBox(height: AppSpace.s12),
          Container(
            padding: EdgeInsets.all(AppSpace.s16),
            decoration: Fg.cardDeco(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LumiFace(size: AppSize.avatar),
                SizedBox(height: AppSpace.s12),
                Text('Pass the device to your grown-up',
                    style: AppText.heading.c(Fg.ink)),
                SizedBox(height: AppSpace.s6),
                Text(
                  "We'll create an account, then your learner can choose a profile.",
                  style: AppText.body.c(Fg.muted),
                ),
                SizedBox(height: AppSpace.s16),
                PrimaryButton(
                  label: 'Sign up with email',
                  icon: Icons.mail_outline,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                ),
                SizedBox(height: AppSpace.s10),
                SecondaryButton(
                  label: 'I already have an account',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpace.s14),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.s12, vertical: AppSpace.s8),
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined,
                      size: AppSize.iconXs, color: AppColors.green),
                  SizedBox(width: AppSpace.s6),
                  Text('Child-safe · no ads · private by design',
                      style: AppText.chip.c(AppColors.green)),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpace.s14),
          Text(
            'By continuing, you agree to the Terms and confirm grown-up consent. '
                'Children never need to enter an email.',
            style: AppText.caption.c(Fg.muted),
          ),
        ],
      ),
    );
  }
}
