import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/screen_shell.dart';

class CreateLearnerProfileScreen extends StatefulWidget {
  const CreateLearnerProfileScreen({super.key});

  @override
  State<CreateLearnerProfileScreen> createState() =>
      _CreateLearnerProfileScreenState();
}

class _CreateLearnerProfileScreenState
    extends State<CreateLearnerProfileScreen> {
  static const _avatarColors = [
    Color(0xFFE8EBFF),
    Color(0xFFDCFCE7),
    Color(0xFFFFF1D6),
    Color(0xFFFFE4EC),
    Color(0xFFDFF5FF),
    Color(0xFFF1E4FF),
    Color(0xFFFFE9DA),
    Color(0xFFE3F8F3),
  ];

  static const _grades = [
    'Kindergarten',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
  ];

  int _avatar = 0;
  String _nickname = 'Maya';
  int _age = 9;
  String _grade = 'Grade 4';

  Future<void> _editNickname() async {
    final c = TextEditingController(text: _nickname);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dialog)),
        title: Text('Nickname', style: AppText.heading.c(Fg.ink)),
        content: TextField(
          controller: c,
          autofocus: true,
          maxLength: 16,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter a nickname',
            filled: true,
            fillColor: Fg.chipBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: Fg.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: Fg.btn, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppText.label.c(Fg.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: Text('Save', style: AppText.label.c(Fg.btn)),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _nickname = result);
    }
  }

  Future<T?> _pick<T>({
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T) labelOf,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              AppSpace.s20, AppSpace.s20, AppSpace.s20, AppSpace.s16),
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
                      onTap: () => Navigator.pop(ctx, o),
                      child: Container(
                        constraints: BoxConstraints(minHeight: Sz.w(48)),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpace.s16, vertical: AppSpace.s12),
                        decoration: BoxDecoration(
                          color: o == selected ? Fg.tint : Fg.chipBg,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                              color: o == selected ? Fg.btn : Fg.border,
                              width: o == selected ? 2 : 1),
                        ),
                        child: Text(labelOf(o),
                            style: AppText.body
                                .copyWith(fontWeight: FontWeight.w700)
                                .c(Fg.ink)),
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

  Future<void> _pickAge() async {
    final v = await _pick<int>(
      title: 'Choose age',
      options: List.generate(10, (i) => i + 5),
      selected: _age,
      labelOf: (a) => '$a years',
    );
    if (v != null) setState(() => _age = v);
  }

  Future<void> _pickGrade() async {
    final v = await _pick<String>(
      title: 'Choose grade',
      options: _grades,
      selected: _grade,
      labelOf: (g) => g,
    );
    if (v != null) setState(() => _grade = v);
  }

  void _build() {
    // TODO: yahan profile Firestore mein save karein / Home par jayein
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_nickname ($_age years, $_grade) ka profile ready hai'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            title: 'Create a learner\nprofile',
            subtitle: 'Choose details that make LearnAble feel like yours.',
          ),
          SizedBox(height: AppSpace.s12),
          _avatarCard(),
          SizedBox(height: AppSpace.s12),
          _nicknameCard(),
          SizedBox(height: AppSpace.s12),
          Row(
            children: [
              Expanded(
                child: _choiceCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Age',
                  value: '$_age years',
                  onTap: _pickAge,
                ),
              ),
              SizedBox(width: AppSpace.s10),
              Expanded(
                child: _choiceCard(
                  icon: Icons.school_outlined,
                  label: 'Grade',
                  value: _grade,
                  onTap: _pickGrade,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpace.s12),
          SizedBox(
            height: AppSize.buttonSm,
            child: ElevatedButton(
              onPressed: _build,
              style: ElevatedButton.styleFrom(
                backgroundColor: Fg.btn,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: AppSpace.s18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.card)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, size: AppSize.iconSm),
                  SizedBox(width: AppSpace.s8),
                  Flexible(
                    child: Text(
                      "Build $_nickname's learning space",
                      overflow: TextOverflow.ellipsis,
                      style: AppText.buttonSm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarCard() {
    return Container(
      padding: EdgeInsets.all(AppSpace.s14),
      decoration: Fg.cardDeco(),
      child: Row(
        children: [
          LumiFace(size: AppSize.avatar, color: _avatarColors[_avatar]),
          SizedBox(width: AppSpace.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose an avatar',
                    style: AppText.subheading.c(Fg.ink)),
                SizedBox(height: AppSpace.s4),
                Text('8 friendly explorers',
                    style: AppText.caption.c(Fg.muted)),
                SizedBox(height: AppSpace.s4),
                _changeChip(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeChip() {
    return Material(
      color: Fg.chipBg,
      shape: const StadiumBorder(side: BorderSide(color: Fg.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () =>
            setState(() => _avatar = (_avatar + 1) % _avatarColors.length),
        child: SizedBox(
          height: AppSize.chip,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.s12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sentiment_satisfied_alt_outlined,
                    size: AppSize.iconXs, color: Fg.blue),
                SizedBox(width: AppSpace.s6),
                Text('Change', style: AppText.chip.c(Fg.blue)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nicknameCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.card),
      onTap: _editNickname,
      child: Container(
        padding: EdgeInsets.all(AppSpace.s12),
        decoration: Fg.cardDeco(),
        child: Row(
          children: [
            Container(
              width: AppSize.inputIcon,
              height: AppSize.inputIcon,
              decoration: BoxDecoration(
                color: Fg.tint,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(Icons.edit_outlined,
                  size: AppSize.iconSm, color: Fg.blue),
            ),
            SizedBox(width: AppSpace.s10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nickname', style: AppText.label.c(Fg.ink)),
                  SizedBox(height: AppSpace.s2),
                  Text(_nickname,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.c(Fg.muted)),
                ],
              ),
            ),
            SizedBox(width: AppSpace.s10),
            Align(
              alignment: Alignment.topCenter,
              child: Text('Edit', style: AppText.captionBold.c(Fg.blue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Fg.tint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: Fg.btn, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          height: AppSize.choiceCard,
          padding: EdgeInsets.all(AppSpace.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: AppSize.iconLg, color: Fg.blue),
                  Icon(Icons.check_circle_outline,
                      size: AppSize.icon, color: Fg.blue),
                ],
              ),
              SizedBox(height: AppSpace.s6),
              Text(label, style: AppText.label.c(Fg.ink)),
              SizedBox(height: AppSpace.s6),
              Text(value,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.c(Fg.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
