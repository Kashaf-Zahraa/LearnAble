import 'package:flutter/material.dart';

import '../Models/learner_profile.dart';
import 'ChooseSubjectsScreen.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/app_widgets.dart';
import '../Widgets/screen_shell.dart';

const String kCreateProfileChildImage =
    'assets/pngs/create_profile_child.png';

class CreateLearnerProfileScreen extends StatefulWidget {
  const CreateLearnerProfileScreen({super.key});

  @override
  State<CreateLearnerProfileScreen> createState() =>
      _CreateLearnerProfileScreenState();
}

class _CreateLearnerProfileScreenState
    extends State<CreateLearnerProfileScreen> {
  // ============================================================
  // AVATARS
  // ============================================================

  static const List<String> _avatars = [
    'assets/pngs/avatars/avatar_1.png',
    'assets/pngs/avatars/avatar_2.png',
    'assets/pngs/avatars/avatar_3.png',
    'assets/pngs/avatars/avatar_4.png',
    'assets/pngs/avatars/avatar_5.png',
  ];

  // ============================================================
  // GRADES
  // ============================================================

  static const List<String> _grades = [
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

  // ============================================================
  // PROFILE DATA
  // ============================================================

  int _selectedAvatar = 0;

  String _nickname = 'Maya';
  int _age = 9;
  String _grade = 'Grade 4';

  // ============================================================
  // EDIT NICKNAME
  // ============================================================

  Future<void> _editNickname() async {
    final controller = TextEditingController(
      text: _nickname,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.dialog,
            ),
          ),

          // ------------------------------------------------------
          // TITLE
          // ------------------------------------------------------

          title: Text(
            'What should we call you?',
            style: AppText.heading.c(Fg.ink),
          ),

          // ------------------------------------------------------
          // TEXT FIELD
          // ------------------------------------------------------

          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 16,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Enter a nickname',
              filled: true,
              fillColor: Fg.chipBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.md,
                ),
                borderSide: const BorderSide(
                  color: Fg.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.md,
                ),
                borderSide: const BorderSide(
                  color: Fg.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.md,
                ),
                borderSide: const BorderSide(
                  color: Fg.btn,
                  width: 2,
                ),
              ),
            ),

            onSubmitted: (value) {
              final nickname = value.trim();

              if (nickname.isNotEmpty) {
                Navigator.of(dialogContext).pop(nickname);
              }
            },
          ),

          // ------------------------------------------------------
          // BUTTONS
          // ------------------------------------------------------

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: AppText.label.c(Fg.muted),
              ),
            ),
            TextButton(
              onPressed: () {
                final nickname =
                controller.text.trim();

                if (nickname.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  nickname,
                );
              },
              child: Text(
                'Save',
                style: AppText.label.c(Fg.btn),
              ),
            ),
          ],
        );
      },
    );

    // IMPORTANT:
    // Do NOT call controller.dispose() here.

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      setState(() {
        _nickname = result;
      });
    }
  }

  // ============================================================
  // GENERIC BOTTOM SHEET PICKER
  // ============================================================

  Future<T?> _pick<T>({
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T) labelOf,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppRadius.sheet,
          ),
        ),
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.heading.c(Fg.ink),
                ),

                SizedBox(
                  height: AppSpace.s14,
                ),

                Wrap(
                  spacing: AppSpace.s10,
                  runSpacing: AppSpace.s10,
                  children: [
                    for (final option in options)
                      InkWell(
                        borderRadius:
                        BorderRadius.circular(
                          AppRadius.md,
                        ),
                        onTap: () {
                          Navigator.of(
                            sheetContext,
                          ).pop(option);
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: Sz.w(48),
                          ),
                          padding:
                          EdgeInsets.symmetric(
                            horizontal:
                            AppSpace.s16,
                            vertical:
                            AppSpace.s12,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            option == selected
                                ? Fg.tint
                                : Fg.chipBg,
                            borderRadius:
                            BorderRadius.circular(
                              AppRadius.md,
                            ),
                            border: Border.all(
                              color:
                              option == selected
                                  ? Fg.btn
                                  : Fg.border,
                              width:
                              option == selected
                                  ? 2
                                  : 1,
                            ),
                          ),
                          child: Text(
                            labelOf(option),
                            style: AppText.body
                                .copyWith(
                              fontWeight:
                              FontWeight.w700,
                            )
                                .c(Fg.ink),
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

  // ============================================================
  // PICK AGE
  // ============================================================

  Future<void> _pickAge() async {
    final value = await _pick<int>(
      title: 'How old are you?',
      options: List.generate(
        10,
            (index) => index + 5,
      ),
      selected: _age,
      labelOf: (age) => '$age years',
    );

    if (!mounted) return;

    if (value != null) {
      setState(() {
        _age = value;
      });
    }
  }

  // ============================================================
  // PICK GRADE
  // ============================================================

  Future<void> _pickGrade() async {
    final value = await _pick<String>(
      title: 'Choose your grade',
      options: _grades,
      selected: _grade,
      labelOf: (grade) => grade,
    );

    if (!mounted) return;

    if (value != null) {
      setState(() {
        _grade = value;
      });
    }
  }

  // ============================================================
  // BUILD PROFILE
  // ============================================================

  void _buildProfile() {
    LearnerProfile.current = LearnerProfile(
      nickname: _nickname,
      age: _age,
      grade: _grade,
      avatarPath: _avatars[_selectedAvatar],
    );

    debugPrint('Profile: ${LearnerProfile.current.toMap()}');

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChooseSubjectsScreen()),
    );
  }

  // ============================================================
  // MAIN SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          // ------------------------------------------------------
          // HEADER
          // ------------------------------------------------------

          const AppHeader(
            title:
            'Create your\nlearner profile',
            subtitle:
            'Make LearnAble feel like your own learning adventure.',
          ),

          SizedBox(
            height: AppSpace.s12,
          ),

          // ------------------------------------------------------
          // HERO
          // ------------------------------------------------------

          _heroCard(),

          SizedBox(
            height: AppSpace.s12,
          ),

          // ------------------------------------------------------
          // AVATARS
          // ------------------------------------------------------

          _avatarCard(),

          SizedBox(
            height: AppSpace.s12,
          ),

          // ------------------------------------------------------
          // NICKNAME
          // ------------------------------------------------------

          _nicknameCard(),

          SizedBox(
            height: AppSpace.s12,
          ),

          // ------------------------------------------------------
          // AGE + GRADE
          // ------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _choiceCard(
                  icon:
                  Icons.cake_outlined,
                  label: 'Age',
                  value: '$_age years',
                  background:
                  const Color(
                    0xFFFFF1D6,
                  ),
                  iconColor:
                  const Color(
                    0xFFE19A35,
                  ),
                  onTap: _pickAge,
                ),
              ),

              SizedBox(
                width: AppSpace.s10,
              ),

              Expanded(
                child: _choiceCard(
                  icon:
                  Icons.school_outlined,
                  label: 'Grade',
                  value: _grade,
                  background:
                  const Color(
                    0xFFE5EFFF,
                  ),
                  iconColor:
                  const Color(
                    0xFF5269D8,
                  ),
                  onTap: _pickGrade,
                ),
              ),
            ],
          ),

          SizedBox(
            height: AppSpace.s16,
          ),

          // ------------------------------------------------------
          // BUILD BUTTON
          // ------------------------------------------------------

          PrimaryButton(
            label:
            "Build $_nickname's learning space",
            icon:
            Icons.auto_awesome_rounded,
            onPressed: _buildProfile,
          ),

          SizedBox(
            height: AppSpace.s12,
          ),

          // ------------------------------------------------------
          // PRIVACY MESSAGE
          // ------------------------------------------------------

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: AppSize.iconXs,
                color: Fg.muted,
              ),

              SizedBox(
                width: AppSpace.s6,
              ),

              Flexible(
                child: Text(
                  'Your profile helps personalize your learning.',
                  textAlign:
                  TextAlign.center,
                  style:
                  AppText.caption.c(
                    Fg.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================

  Widget _heroCard() {
    return Container(
      height: Sz.w(150),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpace.s16,
      ),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFFE8EBFF),
            Color(0xFFF1E4FF),
          ],
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(
          AppRadius.card,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, learner! 👋',
                  style:
                  AppText.subheading
                      .c(Fg.ink),
                ),

                SizedBox(
                  height: AppSpace.s6,
                ),

                Text(
                  'Let’s make a profile that feels just like you.',
                  style:
                  AppText.caption
                      .c(Fg.muted),
                ),
              ],
            ),
          ),

          SizedBox(
            width: AppSpace.s8,
          ),

          SizedBox(
            width: Sz.w(120),
            height: Sz.w(140),
            child: Image.asset(
              kCreateProfileChildImage,
              fit: BoxFit.contain,
              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Icon(
                  Icons
                      .auto_awesome_rounded,
                  size: Sz.w(60),
                  color: Fg.btn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR CARD
  // ============================================================

  Widget _avatarCard() {
    return Container(
      padding: EdgeInsets.all(
        AppSpace.s14,
      ),
      decoration: Fg.cardDeco(),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your explorer',
            style:
            AppText.subheading
                .c(Fg.ink),
          ),

          SizedBox(
            height: AppSpace.s4,
          ),

          Text(
            'Pick an avatar for your learning journey.',
            style:
            AppText.caption
                .c(Fg.muted),
          ),

          SizedBox(
            height: AppSpace.s14,
          ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children:
            List.generate(
              _avatars.length,
                  (index) {
                return _avatarItem(
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SINGLE AVATAR
  // ============================================================

  Widget _avatarItem(
      int index,
      ) {
    final bool selected =
        _selectedAvatar == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar =
              index;
        });
      },
      child:
      AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOut,
        width: Sz.w(58),
        height: Sz.w(58),
        padding:
        EdgeInsets.all(
          selected ? 3 : 2,
        ),
        decoration:
        BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Fg.btn
                : Fg.border,
            width:
            selected ? 3 : 1,
          ),
          boxShadow:
          selected
              ? [
            BoxShadow(
              color: Fg.btn
                  .withValues(
                alpha:
                0.16,
              ),
              blurRadius:
              10,
              offset:
              const Offset(
                0,
                4,
              ),
            ),
          ]
              : [],
        ),
        child: Stack(
          clipBehavior:
          Clip.none,
          children: [
            // Avatar image
            Positioned.fill(
              child: ClipOval(
                child:
                Image.asset(
                  _avatars[index],
                  fit:
                  BoxFit.cover,
                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color:
                      Fg.chipBg,
                      child: Icon(
                        Icons
                            .person_rounded,
                        color:
                        Fg.muted,
                        size:
                        Sz.w(30),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Checkmark
            if (selected)
              Positioned(
                right: -4,
                bottom: -4,
                child:
                Container(
                  width:
                  Sz.w(20),
                  height:
                  Sz.w(20),
                  decoration:
                  const BoxDecoration(
                    color:
                    Fg.btn,
                    shape:
                    BoxShape.circle,
                  ),
                  child:
                  Icon(
                    Icons
                        .check_rounded,
                    size:
                    Sz.w(14),
                    color:
                    Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NICKNAME CARD
  // ============================================================

  Widget _nicknameCard() {
    return InkWell(
      borderRadius:
      BorderRadius.circular(
        AppRadius.card,
      ),
      onTap: _editNickname,
      child: Container(
        padding:
        EdgeInsets.all(
          AppSpace.s14,
        ),
        decoration:
        Fg.cardDeco(),
        child: Row(
          children: [
            Container(
              width:
              AppSize.inputIcon,
              height:
              AppSize.inputIcon,
              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xFFFFE7EA,
                ),
                borderRadius:
                BorderRadius
                    .circular(
                  AppRadius.sm,
                ),
              ),
              child: Icon(
                Icons
                    .edit_outlined,
                size:
                AppSize.iconSm,
                color:
                const Color(
                  0xFFD45B70,
                ),
              ),
            ),

            SizedBox(
              width:
              AppSpace.s10,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    'Nickname',
                    style:
                    AppText.label
                        .c(
                      Fg.ink,
                    ),
                  ),

                  SizedBox(
                    height:
                    AppSpace.s2,
                  ),

                  Text(
                    _nickname,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    AppText.caption
                        .c(
                      Fg.muted,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width:
              AppSpace.s10,
            ),

            Text(
              'Edit',
              style:
              AppText
                  .captionBold
                  .c(
                Fg.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AGE / GRADE CARD
  // ============================================================

  Widget _choiceCard({
    required IconData icon,
    required String label,
    required String value,
    required Color background,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      borderRadius:
      BorderRadius.circular(
        AppRadius.card,
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          AppRadius.card,
        ),
        onTap: onTap,
        child: Container(
          height:
          AppSize.choiceCard,
          padding:
          EdgeInsets.all(
            AppSpace.s12,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Icon(
                icon,
                size:
                AppSize.iconLg,
                color:
                iconColor,
              ),

              const Spacer(),

              Text(
                label,
                style:
                AppText.label
                    .c(Fg.ink),
              ),

              SizedBox(
                height:
                AppSpace.s4,
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      AppText
                          .caption
                          .c(
                        Fg.muted,
                      ),
                    ),
                  ),

                  Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                    size:
                    AppSize.iconSm,
                    color:
                    iconColor,
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
