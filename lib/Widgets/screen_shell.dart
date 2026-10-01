import 'package:flutter/material.dart';

import 'app_sizes.dart';

/// Figma colors (ek jagah, sab screens ke liye)
class Fg {
  static const bg = Color(0xFFEEF7FF);
  static const ink = Color(0xFF172B4D);
  static const muted = Color(0xFF60708F);
  static const blue = Color(0xFF3145B3);
  static const btn = Color(0xFF4C63D9);
  static const tint = Color(0xFFE8EBFF);
  static const border = Color(0xFFD8E6F3);
  static const chipBg = Color(0xFFF7FBFF);

  static BoxDecoration cardDeco() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(color: border),
    boxShadow: const [
      BoxShadow(
        color: Color(0x1822466A),
        blurRadius: 24,
        offset: Offset(0, 8),
      ),
    ],
  );
}

/// Har screen ka common frame: background, SafeArea, top-aligned,
/// responsive padding, aur wide screens par max width.
class ScreenShell extends StatelessWidget {
  final Widget child;
  const ScreenShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Fg.bg,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSize.maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpace.screenSide,
                AppSpace.screenTop,
                AppSpace.screenSide,
                AppSpace.screenBottom,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma App header: [Back] Title [Tools] + subtitle
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBack) ...[
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.card)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: SizedBox(
                    width: AppSize.iconBtn,
                    height: AppSize.iconBtn,
                    child: Icon(Icons.arrow_back,
                        size: AppSize.icon, color: Fg.blue),
                  ),
                ),
              ),
              SizedBox(width: AppSpace.s10),
            ],
            Expanded(
              child: Text(title, style: AppText.title.c(Fg.ink)),
            ),
            SizedBox(width: AppSpace.s10),
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.card)),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.card),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Accessibility tools jald aa rahe hain')),
                ),
                child: SizedBox(
                  height: AppSize.iconBtn,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpace.s12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.accessibility_new_rounded,
                            size: AppSize.icon, color: Fg.blue),
                        SizedBox(width: AppSpace.s6),
                        Text('Tools', style: AppText.captionBold.c(Fg.blue)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppSpace.s4),
          Text(subtitle!, style: AppText.body.c(Fg.muted)),
        ],
      ],
    );
  }
}

/// Lumi ka chehra (code se bana, image nahi chahiye). Kisi bhi size par.
class LumiFace extends StatelessWidget {
  final double size;
  final Color color;
  const LumiFace({super.key, this.size = 62, this.color = Fg.tint});

  @override
  Widget build(BuildContext context) {
    final k = size / 62;

    Widget eye() => Container(
      width: 15 * k,
      height: 15 * k,
      decoration:
      const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      alignment: const Alignment(0.45, -0.45),
      child: Container(
        width: 5 * k,
        height: 5 * k,
        decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle),
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1822466A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48 * k,
            height: 48 * k,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              eye(),
              SizedBox(width: 3 * k),
              Container(
                width: 9 * k,
                height: 5 * k,
                margin: EdgeInsets.only(top: 4 * k),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(6 * k)),
                ),
              ),
              SizedBox(width: 3 * k),
              eye(),
            ],
          ),
        ],
      ),
    );
  }
}
