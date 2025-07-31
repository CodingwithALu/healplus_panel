import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/brands/edit_brands/responsive_screen/edit_brands_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EditBrandsScreen extends StatelessWidget {
  const EditBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final brand = Get.arguments;
    return TSizeTemplate(desktop: EditBrandsDesktop(brands: brand));
  }
}
