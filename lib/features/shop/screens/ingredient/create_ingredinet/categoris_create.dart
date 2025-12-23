import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/reponsive_screen/create_categorie_desktop.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/reponsive_screen/create_categories_mobile.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/reponsive_screen/create_categories_tablet.dart';
import 'package:flutter/material.dart';

class CategorisCreateScreen extends StatelessWidget {
  const CategorisCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return TSizeTemplate(
      desktop: CreateCategorieDesktopScreen(),
      tablet: CreateCategoriesTablet(),
      mobile: CreateCategoriesMobile(),
    );
  }
}
