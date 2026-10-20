import 'package:flutter/material.dart';

import 'app_sizes.dart';

/// Tab pages ka scroll + padding (ScreenShell jaisa, bina Scaffold ke)
class TabScroll extends StatelessWidget {
  final Widget child;
  const TabScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpace.screenSide,
          AppSpace.screenTop,
          AppSpace.screenSide,
          AppSpace.s20,
        ),
        child: child,
      ),
    );
  }
}

/// Widgets ko 2 columns mein rakhta hai
Widget twoColumnGrid(List<Widget> items, {double? gap}) {
  final g = gap ?? AppSpace.s10;
  return Column(
    children: [
      for (var i = 0; i < items.length; i += 2)
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < items.length ? g : 0),
          child: Row(
            children: [
              Expanded(child: items[i]),
              SizedBox(width: g),
              Expanded(
                child: i + 1 < items.length ? items[i + 1] : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
    ],
  );
}
