import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/auth_service.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.login(email: _email.text, password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      _showMsg(AuthService.errorMessage(e), error: true);
    } catch (_) {
      _showMsg('Kuch ghalat ho gaya. Dobara try karein.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _showMsg('Pehle email likhein, phir "Forgot password" dabayein.',
          error: true);
      return;
    }
    try {
      await _auth.resetPassword(email);
      _showMsg('Password reset email bhej di gayi hai.');
    } on FirebaseAuthException catch (e) {
      _showMsg(AuthService.errorMessage(e), error: true);
    }
  }

  void _showMsg(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red.shade700 : AppColors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(
              title: 'Welcome back',
              subtitle: 'Apne grown-up account mein login karein.',
            ),
            SizedBox(height: AppSpace.s24),
            AppTextField(
              label: 'Email',
              controller: _email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Email likhein' : null,
            ),
            SizedBox(height: AppSpace.s14),
            AppTextField(
              label: 'Password',
              controller: _password,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'Password likhein' : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                child: Text('Forgot password?',
                    style: AppText.label.c(Fg.blue)),
              ),
            ),
            SizedBox(height: AppSpace.s8),
            PrimaryButton(
                label: 'Log in', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
