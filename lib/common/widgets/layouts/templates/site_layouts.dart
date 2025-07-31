import 'package:healplus_panel/common/widgets/responsive/reponsive_design.dart';
import 'package:healplus_panel/common/widgets/responsive/screen/desktop_layout.dart';
import 'package:healplus_panel/common/widgets/responsive/screen/mobile_layout.dart';
import 'package:healplus_panel/common/widgets/responsive/screen/tablet_layout.dart';
import 'package:flutter/material.dart';

class TSizeTemplate extends StatelessWidget {
  const TSizeTemplate({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = true,
  });

  /// Widget for desktop layout
  final Widget? desktop;

  /// Widget for tablrt layout
  final Widget? tablet;

  /// Widget for mobile layout
  final Widget? mobile;

  /// Flag to determine whether to use the layout
  final bool useLayout;
  @override
  Widget build(BuildContext context) {
    // implement build
    return Scaffold(
      body: TResponsiveWidget(
        desktop: useLayout
            ? DesktopLayout(body: desktop)
            : desktop ?? Container(),
        tabblet: useLayout
            ? TabletLayout(body: tablet ?? desktop)
            : tablet ?? desktop ?? Container(),
        mobile: useLayout
            ? MobileLayout(body: mobile ?? desktop)
            : mobile ?? desktop ?? Container(),
      ),
    );
  }
}
