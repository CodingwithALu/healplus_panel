import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/features/shop/screens/category/edit_categories/widgets/edit_category_from.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class EditCategoryDesktopScreen extends StatelessWidget {
  const EditCategoryDesktopScreen({super.key, required this.catedoryModel});
  final IngredientModel catedoryModel;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrombs
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.categoryBreadcrumbEdit,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.categoriesStoragePath,
                    route: TRoutes.categories,
                  ),
                  BreadcrumbItem(local.categoryBreadcrumbEdit),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Form
              EditCategoryFromScreen(category: catedoryModel),
            ],
          ),
        ),
      ),
    );
  }
}
