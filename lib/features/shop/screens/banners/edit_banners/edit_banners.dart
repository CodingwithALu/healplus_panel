import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/banners/edit_banners/reponsive_screen/edit_banners_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EditBannersScreen extends StatelessWidget {
  const EditBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final banner = Get.arguments;
    return TSizeTemplate(desktop: EditBannersDesktopScreen(banner: banner));
  }
}
