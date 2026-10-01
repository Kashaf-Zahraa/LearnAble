import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/app_widgets.dart';
import 'HomeScreen.dart';
import 'WelcomeScreen.dart';

const String kSplashImage = 'assets/pngs/splash_lumi.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5000),
  )..repeat();

  late final AnimationController _twinkle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  late final List<_Sparkle> _sparkles = _makeSparkles();

  static List<_Sparkle> _makeSparkles() {
    final r = math.Random(7);
    return List.generate(
      32,
          (_) => _Sparkle(
        x: r.nextDouble(),
        y: r.nextDouble() * 0.75,
        radius: 1.2 + r.nextDouble() * 2.4,
        phase: r.nextDouble(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  @override
  void dispose() {
    _intro.dispose();
    _float.dispose();
    _wave.dispose();
    _twinkle.dispose();
    _dots.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) =>
        user != null ? const HomeScreen() : const WelcomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _reveal(double start, double end, Widget child,
      {double dy = 0.25}) {
    final anim = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, dy), end: Offset.zero)
            .animate(anim),
        child: child,
      ),
    );
  }

  Widget _lumi() {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          AnimatedBuilder(
            animation: _float,
            builder: (_, __) {
              final t = Curves.easeInOut.transform(_float.value);
              return Transform.scale(
                scale: 1.0 + 0.08 * t,
                child: Container(
                  width: 290,
                  height: 290,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.30 + 0.10 * t),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Lumi (floating)
          AnimatedBuilder(
            animation: _float,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, -12 * Curves.easeInOut.transform(_float.value)),
              child: child,
            ),
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  kSplashImage,
                  width: 210,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, __) {
                    debugPrint('SPLASH IMAGE ERROR: $error');
                    return const LumiMascot(size: 210);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingDots() {
    return AnimatedBuilder(
      animation: _dots,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final v = (math.sin(2 * math.pi * (_dots.value - i * 0.15)) + 1) / 2;
            return Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.35 + 0.65 * v),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Sky -> sea gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B4BC4),
                  AppColors.primary,
                  Color(0xFF5C7FE0),
                  Color(0xFF35B8C9),
                ],
                stops: [0.0, 0.40, 0.75, 1.0],
              ),
            ),
          ),

          // Twinkling sparkles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _twinkle,
              builder: (_, __) => CustomPaint(
                painter: _SparklePainter(_sparkles, _twinkle.value),
              ),
            ),
          ),

          // Waves
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 190,
            child: AnimatedBuilder(
              animation: _wave,
              builder: (_, __) => CustomPaint(
                painter: _WavePainter(_wave.value),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1).animate(
                      CurvedAnimation(
                        parent: _intro,
                        curve: const Interval(0.0, 0.6,
                            curve: Curves.easeOutBack),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: const Interval(0.0, 0.4),
                      ),
                      child: _lumi(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _reveal(
                    0.35,
                    0.75,
                    const Text(
                      'LearnAble',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 4)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _reveal(
                    0.5,
                    0.9,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Your personal, accessible learning space',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _reveal(0.7, 1.0, _loadingDots(), dy: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sparkle {
  final double x, y, radius, phase;
  const _Sparkle({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double t;
  _SparklePainter(this.sparkles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final v = (math.sin(2 * math.pi * (t + s.phase)) + 1) / 2;
      final center = Offset(s.x * size.width, s.y * size.height);
      final glow = Paint()
        ..color = Colors.white.withValues(alpha: 0.10 + 0.25 * v)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      final core = Paint()
        ..color = Colors.white.withValues(alpha: 0.25 + 0.65 * v);
      canvas.drawCircle(center, s.radius * 2.2, glow);
      canvas.drawCircle(center, s.radius * (0.7 + 0.3 * v), core);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) => old.t != t;
}

class _WavePainter extends CustomPainter {
  final double t;
  _WavePainter(this.t);

  void _wave(Canvas canvas, Size size,
      {required double baseY,
        required double amp,
        required double phase,
        required double alpha}) {
    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, baseY);
    for (double x = 0; x <= size.width; x += 4) {
      final y = baseY +
          amp * math.sin((x / size.width) * 2 * math.pi * 1.5 + phase);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(
        path, Paint()..color = Colors.white.withValues(alpha: alpha));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = t * 2 * math.pi;
    _wave(canvas, size,
        baseY: size.height * 0.40, amp: 12, phase: p, alpha: 0.10);
    _wave(canvas, size,
        baseY: size.height * 0.60, amp: 14, phase: -p * 1.3 + 1.5, alpha: 0.16);
    _wave(canvas, size,
        baseY: size.height * 0.80, amp: 10, phase: p + 3, alpha: 0.22);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.t != t;
}
