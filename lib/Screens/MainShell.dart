import 'package:flutter/material.dart';

import '../Widgets/app_sizes.dart';
import '../Widgets/screen_shell.dart';
import 'ChildHomeTab.dart';
import 'SubjectLibraryTab.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.menu_book_outlined, Icons.menu_book_rounded, 'Learn'),
    _NavItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Tutor'),
    _NavItem(Icons.emoji_events_outlined, Icons.emoji_events_rounded, 'Rewards'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ChildHomeTab(onOpenLibrary: () => setState(() => _index = 1)),
      const SubjectLibraryTab(),
      _ComingSoon(
        icon: Icons.chat_bubble_rounded,
        title: 'Lumi Tutor',
        message: 'Your friendly AI tutor is on its way.',
        onHome: () => setState(() => _index = 0),
      ),
      _ComingSoon(
        icon: Icons.emoji_events_rounded,
        title: 'Rewards',
        message: 'Stars, badges and surprises are coming soon.',
        onHome: () => setState(() => _index = 0),
      ),
      _ComingSoon(
        icon: Icons.person_rounded,
        title: 'Profile',
        message: 'Your profile and settings will live here.',
        onHome: () => setState(() => _index = 0),
      ),
    ];

    return Scaffold(
      backgroundColor: Fg.bg,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSize.maxWidth),
            child: SizedBox.expand(
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: pages[_index],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        items: _items,
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int index;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.items,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Fg.border)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22466A).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1, // <-- asli fix: bar ki height content tak seemit
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSize.maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpace.s8,
                vertical: AppSpace.s8,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavButton(
                        item: items[i],
                        selected: i == index,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Fg.blue : Fg.muted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: AppSpace.s8),
          decoration: BoxDecoration(
            color: selected ? Fg.tint : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? item.activeIcon : item.icon,
                  size: AppSize.iconLg, color: color),
              SizedBox(height: AppSpace.s2),
              Text(
                item.label,
                style: AppText.captionBold.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onHome;

  const _ComingSoon({
    required this.icon,
    required this.title,
    required this.message,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpace.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LumiFace(size: 90, color: Colors.white),
            SizedBox(height: AppSpace.s16),
            Icon(icon, size: AppSize.iconXl, color: Fg.btn),
            SizedBox(height: AppSpace.s8),
            Text(title, style: AppText.titleLg.c(Fg.ink)),
            SizedBox(height: AppSpace.s6),
            Text(message,
                textAlign: TextAlign.center,
                style: AppText.body.c(Fg.muted)),
            SizedBox(height: AppSpace.s20),
            OutlinedButton.icon(
              onPressed: onHome,
              icon: Icon(Icons.home_rounded, size: AppSize.iconSm),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
