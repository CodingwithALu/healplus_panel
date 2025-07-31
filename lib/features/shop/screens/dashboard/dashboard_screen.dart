import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/reponsive_screen/dashboard_desktop_screen.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/reponsive_screen/dashboard_mobile_screen.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/reponsive_screen/dashboard_tablet_screen.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TSizeTemplate(
      desktop: DashboardDesktopScreen(),
      tablet: DashboardTabletScreen(),
      mobile: DashboardMobileScreen(),
    );
  }
}
