import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/data_table/tables_header.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/screens/brands/all_brands/tablets/data_tablets.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsDesktopScreen extends StatelessWidget {
  const BrandsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(CategoryController());
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbWithHeading(
                heading: local.brands,
                breadcrumbItems: [BreadcrumbItem(local.brands)],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Tablet Body
              TRoundedContainer(
                child: Column(
                  children: [
                    // Tablet Header
                    TTableHeader(
                      buttonText: local.createNewBrands,
                      onPressed: () => Get.toNamed(TRoutes.createBrand),
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const TLoaderAnimation();
                      } else {
                        return const BrandTable();
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
