import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/tables/data_table.dart';
import 'package:healplus_panel/common/widgets/data_table/tables_header.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesDesktopScreen extends StatelessWidget {
  const CategoriesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(IngredientController());
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadcrumbWithHeading(
                heading: local.categories,
                breadcrumbItems: [BreadcrumbItem(local.categories)],
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              // Table Body
              // Show Loader
              TRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TTableHeader(
                      buttonText: local.createNewCategory,
                      onPressed: () => Get.toNamed(TRoutes.createCategory),
                      seatrchController: controller.searchTextController,
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    // Table
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const TLoaderAnimation();
                      }
                      return TCategoryTablets();
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
