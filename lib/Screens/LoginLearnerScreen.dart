
import 'package:flutter/material.dart';

import '../Models/learner_profile.dart';
import '../Models/subject.dart';
import '../Services/api_service.dart';
import '../Services/learner_storage.dart';
import 'MainShell.dart';

class LoginLearnerScreen extends StatefulWidget {
  const LoginLearnerScreen({super.key});

  @override
  State<LoginLearnerScreen> createState() =>
      _LoginLearnerScreenState();
}

class _LoginLearnerScreenState extends State<LoginLearnerScreen> {
  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _showPassword = false;
  bool _isLoggingIn = false;

  static const Color _primaryColor = Color(0xFF5269D8);
  static const Color _backgroundColor = Color(0xFFF8F9FF);

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // SHOW ERROR MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // LOGIN USING NAME + PASSWORD
  // ============================================================

  Future<void> _login() async {
    if (_isLoggingIn) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      _showMessage('Please enter your learner name.');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password.');
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      // Authenticate using learner name and password.
      // FastAPI returns the matching learner ID.
      final authenticatedId = await ApiService.loginLearner(
        name: name,
        password: password,
      );

      // Retrieve saved learner details from PostgreSQL.
      final data = await ApiService.getLearnerProfile(
        authenticatedId,
      );

      // Reconstruct the learner profile.
      final profile = LearnerProfile(
        learnerId: data['learner_id'] as String,
        nickname: data['name'] as String,
        age: data['age'] as int,
        grade: data['grade'] as String,
        avatarPath: (data['avatar'] as String?) ??
            'assets/pngs/avatars/avatar_1.png',
      );

      // PostgreSQL returns subject names.
      final List<String> subjectNames = List<String>.from(
        data['selected_subjects'] ?? [],
      );

      // Convert subject names to SubjectCatalog IDs.
      final Set<String> selectedSubjectIds = SubjectCatalog.all
          .where(
            (subject) => subjectNames.contains(subject.name),
      )
          .map((subject) => subject.id)
          .toSet();

      // Save active learner ID locally.
      await LearnerStorage.saveLearnerId(authenticatedId);

      if (!mounted) return;

      // Restore current learner profile.
      LearnerProfile.current = profile;

      // Restore selected subjects.
      SubjectCatalog.selected = selectedSubjectIds;

      // Clear the password from the input field.
      _passwordController.clear();

      // Open learner dashboard.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
            (route) => false,
      );
    } catch (error) {
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: _primaryColor,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFDDE2F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _primaryColor,
          width: 2,
        ),
      ),
    );
  }

  // ============================================================
  // LOGIN SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        foregroundColor: const Color(0xFF24304B),
        title: const Text('Learner Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ====================================================
              // LOGIN ICON
              // ====================================================

              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_person_rounded,
                    size: 76,
                    color: _primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ====================================================
              // HEADING
              // ====================================================

              const Text(
                'Welcome back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF24304B),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your learner name and password '
                    'to continue your learning adventure.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF727C91),
                ),
              ),

              const SizedBox(height: 32),

              // ====================================================
              // LEARNER NAME INPUT
              // ====================================================

              TextField(
                controller: _nameController,
                enabled: !_isLoggingIn,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                decoration: _inputDecoration(
                  label: 'Learner Name',
                  hint: 'Enter your learner name',
                  icon: Icons.person_outline_rounded,
                ).copyWith(
                  counterText: '',
                ),
              ),

              const SizedBox(height: 16),

              // ====================================================
              // PASSWORD INPUT
              // ====================================================

              TextField(
                controller: _passwordController,
                enabled: !_isLoggingIn,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: !_showPassword,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (_) => _login(),
                decoration: _inputDecoration(
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.password_rounded,
                  suffixIcon: IconButton(
                    tooltip: _showPassword
                        ? 'Hide password'
                        : 'Show password',
                    onPressed: _isLoggingIn
                        ? null
                        : () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ====================================================
              // INFORMATION MESSAGE
              // ====================================================

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: _primaryColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Use the learner name and password '
                            'you created when setting up your profile.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5269D8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ====================================================
              // LOGIN BUTTON
              // ====================================================

              ElevatedButton(
                onPressed: _isLoggingIn ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  _primaryColor.withValues(alpha: 0.5),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoggingIn
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded),
                    SizedBox(width: 10),
                    Text(
                      'Login to My Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ====================================================
              // FOOTER
              // ====================================================

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFF727C91),
                  ),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Your learning profile is saved '
                          'and can be restored using your '
                          'learner name and password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF727C91),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
