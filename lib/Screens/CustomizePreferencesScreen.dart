import 'package:flutter/material.dart';

import '../Models/learner_preferences.dart';
import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';
import 'PreviewSettingsScreen.dart';

class CustomizePreferencesScreen extends StatefulWidget {
  /// AccessibilityProfileScreen se aata hai (vision, hearing, adhd ...)
  final String? profile;

  const CustomizePreferencesScreen({super.key, this.profile});

  @override
  State<CustomizePreferencesScreen> createState() =>
      _CustomizePreferencesScreenState();
}

class _CustomizePreferencesScreenState
    extends State<CustomizePreferencesScreen> {
  late LearnerPreferences _p =
  LearnerPreferences.forProfile(widget.profile);

  // ============================================================
  // BOTTOM SHEET PICKER
  // ============================================================

  Future<String?> _pick(
      String title,
      List<String> options,
      String selected,
      Color accent,
      ) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.s20,
              AppSpace.s20,
              AppSpace.s20,
              AppSpace.s16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.heading.c(Fg.ink)),
                SizedBox(height: AppSpace.s14),
                Wrap(
                  spacing: AppSpace.s10,
                  runSpacing: AppSpace.s10,
                  children: [
                    for (final o in options)
                      InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        onTap: () => Navigator.of(sheetContext).pop(o),
                        child: Container(
                          constraints:
                          BoxConstraints(minHeight: Sz.w(48)),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpace.s16,
                            vertical: AppSpace.s12,
                          ),
                          decoration: BoxDecoration(
                            color: o == selected
                                ? accent.withValues(alpha: 0.12)
                                : Fg.chipBg,
                            borderRadius:
                            BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: o == selected ? accent : Fg.border,
                              width: o == selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (o == selected) ...[
                                Icon(Icons.check_rounded,
                                    size: AppSize.iconSm, color: accent),
                                SizedBox(width: AppSpace.s6),
                              ],
                              Text(o, style: AppText.label.c(Fg.ink)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _choose(
      String title,
      List<String> options,
      String current,
      Color accent,
      void Function(String) apply,
      ) async {
    final v = await _pick(title, options, current, accent);
    if (!mounted) return;
    if (v != null) setState(() => apply(v));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Stack(
        children: [
          Positioned(
            left: -35,
            top: Sz.w(330),
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
          Positioned(
            right: -30,
            top: Sz.w(120),
            child: IgnorePointer(
              child: Container(
                width: Sz.w(80),
                height: Sz.w(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0E9FF).withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _topBar(context),
              SizedBox(height: AppSpace.s18),
              Text(
                'Make it feel right',
                textAlign: TextAlign.center,
                style: AppText.titleLg.c(Fg.ink),
              ),
              SizedBox(height: AppSpace.s6),
              Text(
                'Your settings work together across lessons.',
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted),
              ),
              SizedBox(height: AppSpace.s16),
              _livePreview(),
              SizedBox(height: AppSpace.s14),
              _seeAndHear(),
              SizedBox(height: AppSpace.s12),
              _paceAndFocus(),
              SizedBox(height: AppSpace.s6),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _p =
                      LearnerPreferences.forProfile(widget.profile)),
                  icon: Icon(Icons.refresh_rounded,
                      size: AppSize.iconSm, color: Fg.blue),
                  label: Text('Reset to suggested',
                      style: AppText.captionBold.c(Fg.blue)),
                ),
              ),
              SizedBox(height: AppSpace.s6),
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
                  label: 'Preview my settings',
                  icon: Icons.visibility_outlined,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PreviewSettingsScreen(preferences: _p),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpace.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline_rounded,
                      size: AppSize.iconXs, color: const Color(0xFF55916D)),
                  SizedBox(width: AppSpace.s4),
                  Flexible(
                    child: Text(
                      'You can change these any time.',
                      textAlign: TextAlign.center,
                      style: AppText.caption.c(const Color(0xFF55916D)),
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

  Widget _topBar(BuildContext context) {
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
  // LIVE PREVIEW STRIP (settings badalte hi foran badalta hai)
  // ============================================================

  Widget _livePreview() {
    final pal = PrefPalette.of(_p.contrast);
    final scale = _p.textScale;

    return AnimatedContainer(
      duration: _p.reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 220),
      padding: EdgeInsets.all(AppSpace.s14),
      decoration: BoxDecoration(
        color: pal.bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: pal.border, width: pal.borderWidth),
        boxShadow: [
          BoxShadow(
            color: pal.accent.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Aa',
            style: TextStyle(
              fontSize: Sz.sp(30 * scale),
              fontWeight: FontWeight.w800,
              color: pal.accent,
            ),
          ),
          SizedBox(width: AppSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Live preview',
                    style: AppText.captionBold.c(pal.muted)),
                SizedBox(height: AppSpace.s2),
                Text(
                  'Learning should feel comfortable.',
                  style: TextStyle(
                    fontSize: Sz.sp(13 * scale),
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: pal.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GROUPS
  // ============================================================

  Widget _seeAndHear() {
    const yellow = Color(0xFFFFF1C9), yellowA = Color(0xFFB47A15);
    const purple = Color(0xFFF2E9FF), purpleA = Color(0xFF8A5BD6);
    const blue = Color(0xFFE5EFFF), blueA = Color(0xFF5269D8);
    const green = Color(0xFFDDF5E7), greenA = Color(0xFF37845A);
    const pink = Color(0xFFFFE7EA), pinkA = Color(0xFFD45B70);

    return _group('SEE & HEAR', blueA, [
      _SettingRow(
        icon: Icons.text_fields_rounded,
        bg: yellow,
        accent: yellowA,
        title: 'Text size',
        value: _p.textSize,
        onTap: () => _choose('Text size', LearnerPreferences.textSizes,
            _p.textSize, yellowA, (v) => _p = _p.copyWith(textSize: v)),
      ),
      _SettingRow(
        icon: Icons.contrast_rounded,
        bg: purple,
        accent: purpleA,
        title: 'Contrast',
        value: _p.contrast,
        onTap: () => _choose('Contrast', LearnerPreferences.contrasts,
            _p.contrast, purpleA, (v) => _p = _p.copyWith(contrast: v)),
      ),
      _SettingRow(
        icon: Icons.record_voice_over_rounded,
        bg: blue,
        accent: blueA,
        title: 'Narration',
        value: _p.narration ? 'On' : 'Off',
        isSwitch: true,
        switchValue: _p.narration,
        onTap: () =>
            setState(() => _p = _p.copyWith(narration: !_p.narration)),
      ),
      _SettingRow(
        icon: Icons.closed_caption_rounded,
        bg: green,
        accent: greenA,
        title: 'Captions',
        value: _p.captions,
        onTap: () => _choose('Captions', LearnerPreferences.captionOptions,
            _p.captions, greenA, (v) => _p = _p.copyWith(captions: v)),
      ),
      _SettingRow(
        icon: Icons.sign_language_rounded,
        bg: pink,
        accent: pinkA,
        title: 'Sign-language inset',
        value: _p.signLanguage,
        onTap: () => _choose(
            'Sign-language inset',
            LearnerPreferences.signOptions,
            _p.signLanguage,
            pinkA,
                (v) => _p = _p.copyWith(signLanguage: v)),
      ),
    ]);
  }

  Widget _paceAndFocus() {
    const teal = Color(0xFFE1F7F4), tealA = Color(0xFF318B83);
    const yellow = Color(0xFFFFF1C9), yellowA = Color(0xFFB47A15);
    const blue = Color(0xFFE5EFFF), blueA = Color(0xFF5269D8);
    const pink = Color(0xFFFFE7EA), pinkA = Color(0xFFD45B70);

    return _group('PACE & FOCUS', tealA, [
      _SettingRow(
        icon: Icons.animation_rounded,
        bg: teal,
        accent: tealA,
        title: 'Reduced motion',
        value: _p.reducedMotion ? 'On' : 'Off',
        isSwitch: true,
        switchValue: _p.reducedMotion,
        onTap: () => setState(
                () => _p = _p.copyWith(reducedMotion: !_p.reducedMotion)),
      ),
      _SettingRow(
        icon: Icons.speed_rounded,
        bg: yellow,
        accent: yellowA,
        title: 'Reading pace',
        value: _p.pace,
        onTap: () => _choose('Reading pace', LearnerPreferences.paces,
            _p.pace, yellowA, (v) => _p = _p.copyWith(pace: v)),
      ),
      _SettingRow(
        icon: Icons.checklist_rounded,
        bg: blue,
        accent: blueA,
        title: 'Simplified text',
        value: _p.simplified,
        onTap: () => _choose(
            'Simplified text',
            LearnerPreferences.simplifiedOptions,
            _p.simplified,
            blueA,
                (v) => _p = _p.copyWith(simplified: v)),
      ),
      _SettingRow(
        icon: Icons.timer_outlined,
        bg: pink,
        accent: pinkA,
        title: 'Focus timer',
        value: _p.focusTimer,
        onTap: () => _choose('Focus timer', LearnerPreferences.timers,
            _p.focusTimer, pinkA, (v) => _p = _p.copyWith(focusTimer: v)),
      ),
    ]);
  }

  Widget _group(String title, Color accent, List<Widget> rows) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpace.s6),
      decoration: Fg.cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                AppSpace.s14, AppSpace.s8, AppSpace.s14, AppSpace.s4),
            child: Row(
              children: [
                Container(
                  width: Sz.w(8),
                  height: Sz.w(8),
                  decoration:
                  BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
                SizedBox(width: AppSpace.s6),
                Text(title, style: AppText.captionBold.c(accent)),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: AppSpace.s12,
                endIndent: AppSpace.s12,
                color: Fg.border,
              ),
            rows[i],
          ],
        ],
      ),
    );
  }
}

// =============================================================
// SETTING ROW
// =============================================================

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color accent;
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isSwitch;
  final bool switchValue;

  const _SettingRow({
    required this.icon,
    required this.bg,
    required this.accent,
    required this.title,
    required this.value,
    required this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpace.s12,
            vertical: AppSpace.s8,
          ),
          child: Row(
            children: [
              Container(
                width: AppSize.inputIcon,
                height: AppSize.inputIcon,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: AppSize.iconSm, color: accent),
              ),
              SizedBox(width: AppSpace.s12),
              Expanded(child: Text(title, style: AppText.label.c(Fg.ink))),
              if (isSwitch) ...[
                Text(value, style: AppText.captionBold.c(accent)),
                SizedBox(width: AppSpace.s6),
                Switch(
                  value: switchValue,
                  onChanged: (_) => onTap(),
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackOutlineColor:
                  const WidgetStatePropertyAll(Colors.transparent),
                  trackColor: WidgetStateProperty.resolveWith(
                        (s) => s.contains(WidgetState.selected)
                        ? accent
                        : Fg.border,
                  ),
                ),
              ] else
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpace.s10,
                    vertical: AppSpace.s6,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(value, style: AppText.captionBold.c(accent)),
                      SizedBox(width: AppSpace.s2),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: AppSize.iconSm, color: accent),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
