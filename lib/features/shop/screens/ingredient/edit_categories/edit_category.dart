import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/edit_categories/responsive_screen/edit_category_desktop.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/edit_categories/responsive_screen/edit_category_mobile.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/edit_categories/responsive_screen/edit_category_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final category = Get.arguments;
    return TSizeTemplate(
      desktop: EditCategoryDesktopScreen(ingredient: category),
      tablet: EditCategoryTabletScreen(),
      mobile: EditCategoryMobileScreen(),
    );
  }
}
