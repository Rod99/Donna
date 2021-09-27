import 'package:donna/constants/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {

  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, dimens) {
          if (dimens.maxWidth < kTabletBreakpoint){
            return mobileBody;
          } else if (dimens.maxWidth >= kTabletBreakpoint && dimens.maxWidth < kDesktopBreakpoint) {
            return tabletBody;
          } else {
            return desktopBody;
          }
        }
    );
  }
}
