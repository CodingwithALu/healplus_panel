import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/personalization/screen/profiles/reponsive_screen/profile_desktop.dart';
import 'package:healplus_panel/features/personalization/screen/profiles/reponsive_screen/profile_mobile.dart';
import 'package:flutter/material.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TSizeTemplate(
      desktop: ProfileDesktopScreen(),
      mobile: ProfileMobilesScreen(),
    );
  }
}
