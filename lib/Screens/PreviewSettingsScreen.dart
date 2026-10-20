import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../Models/learner_preferences.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'CreateLearnerProfileScreen.dart';

const String kPreviewChildImage = 'assets/pngs/create_profile_child.png';

class PreviewSettingsScreen extends StatefulWidget {
  final LearnerPreferences preferences;

  const PreviewSettingsScreen({super.key, required this.preferences});

  @override
  State<PreviewSettingsScreen> createState() =>
      _PreviewSettingsScreenState();
}

class _PreviewSettingsScreenState extends State<PreviewSettingsScreen> {
  LearnerPreferences get p => widget.preferences;

  Timer? _timer;
  bool _playing = false;
  int _word = -1;

  // ============================================================
  // LESSON TEXT (Simplified text setting ke hisab se)
  // ============================================================

  String get _text {
    switch (p.simplified) {
      case 'Step-by-step':
        return 'Step 1 of 3 · Warm air rises. As it cools, tiny drops of water gather together.';
      case 'Short':
        return 'Warm air rises. Tiny water drops gather into clouds.';
      default:
        return 'Clouds float because warm air rises. As the air cools, tiny drops of water gather together and form a cloud. The drops are so light that moving air keeps them high up in the sky.';
    }
  }

  List<String> get _words => _text.split(' ');

  // ============================================================
  // LISTEN / READ ALONG (timer based, baad mein MMS-TTS se jorenge)
  // ============================================================

  void _toggle() {
    if (_playing) {
      _stop();
      return;
    }

    setState(() {
      _playing = true;
      _word = 0;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(p.wordDelay, (t) {
      if (!mounted || !_playing) {
        t.cancel();
        return;
      }
      if (_word >= _words.length - 1) {
        t.cancel();
        _stop();
        return;
      }
      setState(() => _word++);
    });
  }

  void _stop() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _playing = false;
      _word = -1;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _confirm() {
    _timer?.cancel();
    _playing = false;
    LearnerPreferences.current = p;
    debugPrint('Preferences: ${p.toMap()}');

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateLearnerProfileScreen()),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final pal = PrefPalette.of(p.contrast);

    return ScreenShell(
      child: Stack(
        children: [
          Positioned(
            left: -35,
            top: Sz.w(380),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(95),
                height: Sz.w(95),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDDF5E7).withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _topBar(),
              SizedBox(height: AppSpace.s18),
              Text(
                'How does this feel?',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),
              SizedBox(height: AppSpace.s6),
              Text(
                'Try the preview before you confirm.',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),
              SizedBox(height: AppSpace.s16),
              _hero(),
              SizedBox(height: AppSpace.s14),
              _lessonCard(pal),
              SizedBox(height: AppSpace.s14),
              _summaryChips(),
              SizedBox(height: AppSpace.s18),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5269D8).withValues(alpha: 0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  label: 'This works for me',
                  icon: Icons.auto_awesome_rounded,
                  onPressed: _confirm,
                ),
              ),
              SizedBox(height: AppSpace.s10),
              Container(
                padding: EdgeInsets.all(AppSpace.s4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EDFF),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: SecondaryButton(
                  label: 'Adjust settings',
                  icon: Icons.tune_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(height: AppSpace.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline_rounded,
                      size: AppSize.iconXs, color: const Color(0xFFD45B70)),
                  SizedBox(width: AppSpace.s4),
                  Flexible(
                    child: Text(
                      'No pressure. You can change this later.',
                      textAlign: TextAlign.center,
                      style: AppText.caption.c(Fg.muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: Sz.w(42),
          height: Sz.w(42),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEFF),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back_rounded,
                color: const Color(0xFF5269D8), size: AppSize.icon),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: AppSpace.s10),
        Container(
          width: Sz.w(36),
          height: Sz.w(36),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1C9),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Icon(Icons.auto_awesome_rounded,
              color: const Color(0xFFB47A15), size: AppSize.icon),
        ),
        SizedBox(width: AppSpace.s8),
        Text('LearnAble',
            style: AppText.subheading.c(const Color(0xFF4053B5))),
      ],
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _hero() {
    return Container(
      height: Sz.w(125),
      padding: EdgeInsets.symmetric(horizontal: AppSpace.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8EBFF), Color(0xFFF1E4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Let’s try it! 🎈',
                    style: AppText.subheading.c(Fg.ink)),
                SizedBox(height: AppSpace.s6),
                Text(
                  'Tap Listen to see how your lessons will look and sound.',
                  style: AppText.caption.c(Fg.muted),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpace.s8),
          SizedBox(
            width: Sz.w(105),
            height: Sz.w(120),
            child: Image.asset(
              kPreviewChildImage,
              fit: BoxFit.contain,
              errorBuilder: (_, error, __) => Icon(
                Icons.auto_awesome_rounded,
                size: Sz.w(50),
                color: Fg.btn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LESSON CARD (settings ke hisab se poora badalta hai)
  // ============================================================

  Widget _lessonCard(PrefPalette pal) {
    final scale = p.textScale;
    final baseStyle = TextStyle(
      fontSize: Sz.sp(15 * scale),
      height: 1.5,
      fontWeight: FontWeight.w600,
      color: pal.ink,
    );
    final words = _words;
    final meta =
        '${p.pace} pace${p.captionsVisible ? ' · captions' : ''}';

    return Container(
      padding: EdgeInsets.all(AppSpace.s16),
      decoration: BoxDecoration(
        color: pal.bg,
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        border: Border.all(color: pal.border, width: pal.borderWidth),
        boxShadow: [
          BoxShadow(
            color: pal.accent.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s8,
            children: [
              _pill(Icons.text_fields_rounded, '${p.textSize} text', true,
                  pal),
              _pill(
                p.narration
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                p.narration ? 'Narration on' : 'Narration off',
                false,
                pal,
              ),
            ],
          ),
          SizedBox(height: AppSpace.s14),
          Text(
            'Why do clouds float?',
            style: TextStyle(
              fontSize: Sz.sp(20 * scale),
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: pal.ink,
            ),
          ),
          SizedBox(height: AppSpace.s10),
          Text.rich(
            TextSpan(
              children: [
                for (var i = 0; i < words.length; i++)
                  TextSpan(
                    text: i < words.length - 1 ? '${words[i]} ' : words[i],
                    style: TextStyle(
                      backgroundColor:
                      i == _word ? const Color(0xFFFFE08A) : null,
                    ),
                  ),
              ],
            ),
            style: baseStyle,
          ),
          SizedBox(height: AppSpace.s14),
          Row(
            children: [
              _listenButton(pal),
              SizedBox(width: AppSpace.s10),
              Expanded(
                child: Text(meta, style: AppText.caption.c(pal.muted)),
              ),
            ],
          ),
          if (p.captionsVisible) ...[
            SizedBox(height: AppSpace.s12),
            _captionBar(scale),
          ],
          if (p.signLanguage != 'Off') ...[
            SizedBox(height: AppSpace.s10),
            _infoRow(
              Icons.sign_language_rounded,
              'Sign-language inset · ${p.signLanguage}',
              const Color(0xFFF2E9FF),
              const Color(0xFF8A5BD6),
            ),
          ],
          if (p.focusMinutes != null) ...[
            SizedBox(height: AppSpace.s10),
            _infoRow(
              Icons.timer_outlined,
              'Break reminder after ${p.focusMinutes} min',
              const Color(0xFFFFE7EA),
              const Color(0xFFD45B70),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label, bool selected, PrefPalette pal) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s10,
        vertical: AppSpace.s6,
      ),
      decoration: BoxDecoration(
        color: selected ? pal.accent.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: selected ? pal.accent : pal.border,
          width: selected ? 2 : pal.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.iconXs, color: pal.accent),
          SizedBox(width: AppSpace.s4),
          Text(label, style: AppText.captionBold.c(pal.accent)),
        ],
      ),
    );
  }

  Widget _listenButton(PrefPalette pal) {
    final fg = _playing ? Colors.white : pal.accent;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: _toggle,
        child: Container(
          height: Sz.w(48),
          padding: EdgeInsets.symmetric(horizontal: AppSpace.s14),
          decoration: BoxDecoration(
            color: _playing ? pal.accent : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: pal.accent,
              width: pal.borderWidth > 1 ? 2 : 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: AppSize.iconLg,
                color: fg,
              ),
              SizedBox(width: AppSpace.s6),
              Text(
                _playing ? 'Pause' : (p.narration ? 'Listen' : 'Read along'),
                style: AppText.label.c(fg),
              ),
              if (_playing) ...[
                SizedBox(width: AppSpace.s8),
                _waveBars(fg),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Bina AnimationController ke: bars har word ke saath badalte hain.
  Widget _waveBars(Color color) {
    final active = !p.reducedMotion;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: Sz.w(3),
            height: Sz.w(8) +
                Sz.w(10) * (active && ((_word + i) % 2 == 0) ? 1.0 : 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }

  Widget _captionBar(double scale) {
    final words = _words;
    final caption = _word < 0
        ? ''
        : words.sublist(math.max(0, _word - 3), _word + 1).join(' ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s12,
        vertical: AppSpace.s10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF172B4D),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.closed_caption_rounded,
              size: AppSize.iconLg, color: const Color(0xFFFFE08A)),
          SizedBox(width: AppSpace.s10),
          Expanded(
            child: Text(
              caption.isEmpty ? 'Captions appear here while it reads' : caption,
              style: TextStyle(
                fontSize: Sz.sp(13 * scale),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color bg, Color fg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s12,
        vertical: AppSpace.s8,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSize.iconSm, color: fg),
          SizedBox(width: AppSpace.s8),
          Expanded(child: Text(text, style: AppText.captionBold.c(fg))),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY CHIPS (jo chuna uska khulasa)
  // ============================================================

  Widget _summaryChips() {
    final chips = <_Tag>[
      if (p.textScale >= 1.15 ||
          p.contrast == 'Strong' ||
          p.simplified != 'Off')
        const _Tag(Icons.check_rounded, 'Easy to read', Color(0xFFDDF5E7),
            Color(0xFF37845A)),
      if (p.narration)
        const _Tag(Icons.volume_up_rounded, 'Sounds good', Color(0xFFE5EFFF),
            Color(0xFF5269D8)),
      if (p.captionsVisible)
        const _Tag(Icons.closed_caption_rounded, 'Captions on',
            Color(0xFFFFF1C9), Color(0xFFB47A15)),
      if (p.reducedMotion)
        const _Tag(Icons.animation_rounded, 'Motion reduced',
            Color(0xFFE1F7F4), Color(0xFF318B83)),
      if (p.focusMinutes != null)
        const _Tag(Icons.timer_outlined, 'Focus breaks', Color(0xFFFFE7EA),
            Color(0xFFD45B70)),
    ];

    if (chips.isEmpty) {
      chips.add(const _Tag(Icons.auto_awesome_rounded, 'Standard look',
          Color(0xFFF2E9FF), Color(0xFF8A5BD6)));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpace.s6,
      runSpacing: AppSpace.s6,
      children: [
        for (final t in chips)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpace.s10,
              vertical: AppSpace.s8,
            ),
            decoration: BoxDecoration(
              color: t.bg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: t.fg.withValues(alpha: 0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(t.icon, size: AppSize.iconXs, color: t.fg),
                SizedBox(width: AppSpace.s4),
                Text(t.label, style: AppText.captionBold.c(t.fg)),
              ],
            ),
          ),
      ],
    );
  }
}

class _Tag {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  const _Tag(this.icon, this.label, this.bg, this.fg);
}
