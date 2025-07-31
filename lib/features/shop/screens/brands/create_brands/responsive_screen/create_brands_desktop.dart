import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/screens/brands/create_brands/widgets/create_brands_form.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CreateBrandsDesktop extends StatelessWidget {
  const CreateBrandsDesktop({super.key});
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
              // Breadrumbs
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.brandCreateHeading,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.brandsStoragePath,
                    route: TRoutes.brands,
                  ),
                  BreadcrumbItem(local.brandCreateHeading),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              // Forms
              CreateBrandsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
