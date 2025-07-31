import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/screens/category/create_categories/widgets/create_category_from.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CreateCategorieDesktopScreen extends StatelessWidget {
  const CreateCategorieDesktopScreen({super.key});

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
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.categoryBreadcrumbCreate,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.categoriesStoragePath,
                    route: TRoutes.categories,
                  ),
                  BreadcrumbItem(local.categoryBreadcrumbCreate),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              // From
              CreateCategoryFrom(),
            ],
          ),
        ),
      ),
    );
  }
}
