import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/auth_service.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'WelcomeScreen.dart';

/// Temporary home screen — yahan baad mein learner profiles wagera aayenge.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Fg.bg,
      appBar: AppBar(
        title: Text('LearnAble', style: AppText.heading.c(Fg.ink)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: Icon(Icons.logout, color: Fg.blue, size: AppSize.iconLg),
            onPressed: () async {
              await AuthService().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpace.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LumiMascot(size: AppSize.mascot),
              SizedBox(height: AppSpace.s24),
              Text('Hello, ${user?.displayName ?? 'Grown-up'}!',
                  style: AppText.title.c(Fg.ink)),
              SizedBox(height: AppSpace.s6),
              Text(user?.email ?? '', style: AppText.body.c(Fg.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
