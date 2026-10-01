import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/auth_service.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.signUp(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      _showError(AuthService.errorMessage(e));
    } catch (_) {
      _showError('Kuch ghalat ho gaya. Dobara try karein.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700));
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
              title: 'Create grown-up\naccount',
              subtitle: 'Ye account aap ke learner ke liye safe space banayega.',
            ),
            SizedBox(height: AppSpace.s24),
            AppTextField(
              label: 'Full name',
              controller: _name,
              icon: Icons.person_outline,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Naam likhein' : null,
            ),
            SizedBox(height: AppSpace.s14),
            AppTextField(
              label: 'Email',
              controller: _email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email likhein';
                final ok =
                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                return ok ? null : 'Sahi email likhein';
              },
            ),
            SizedBox(height: AppSpace.s14),
            AppTextField(
              label: 'Password',
              controller: _password,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) => (v == null || v.length < 6)
                  ? 'Kam az kam 6 characters'
                  : null,
            ),
            SizedBox(height: AppSpace.s14),
            AppTextField(
              label: 'Confirm password',
              controller: _confirm,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) =>
              v != _password.text ? 'Passwords match nahi karte' : null,
            ),
            SizedBox(height: AppSpace.s24),
            PrimaryButton(
                label: 'Sign up', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
