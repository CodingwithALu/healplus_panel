import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({
    super.key,
    required this.desktop,
    required this.tabblet,
    required this.mobile,
  });
  // Widget for desktop layout
  final Widget desktop;
  // Widget for Tablet layout
  final Widget tabblet;
  // Widget for Mobile layout
  final Widget mobile;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, contrains) {
        if (contrains.maxWidth >= TSizes.desktopScreenSize) {
          return desktop;
        } else if (contrains.maxWidth < TSizes.desktopScreenSize &&
            contrains.maxWidth >= TSizes.tabletScreenSize) {
          return tabblet;
        } else {
          return mobile;
        }
      },
    );
  }
}
