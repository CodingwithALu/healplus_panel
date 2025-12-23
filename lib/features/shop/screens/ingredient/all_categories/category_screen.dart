import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/responsive_screens/categories_desktop.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TSizeTemplate(desktop: CategoriesDesktopScreen());
  }
}
