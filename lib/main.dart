import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'Screens/SplashScreen.dart';
import 'Widgets/app_widgets.dart';
import 'Widgets/app_sizes.dart'; // 👈 add karo

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LearnAbleApp());
}

class LearnAbleApp extends StatelessWidget {
  const LearnAbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnAble',
      debugShowCheckedModeBanner: false,
      // 👇 yeh builder add karo
      builder: (context, child) {
        Sz.init(context);
        return child!;
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const SplashScreen(),
    );
  }
}
