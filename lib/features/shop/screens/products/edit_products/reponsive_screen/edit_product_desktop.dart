import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_images_controller.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_additional_images.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_thumbnail_image.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_visibility_widgets.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_attributes.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_bottom_navigation_button.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_product_brands.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_product_categories.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_product_variations.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_stock_pricing.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_title_and_description.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/widgets/edit_type_widget.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:flutter/material.dart';

class EditProductDesktop extends StatelessWidget {
  const EditProductDesktop({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    final productImagesController = ProductImagesController.instance;
    return Scaffold(
      bottomNavigationBar: EditProductBottomNavigationButton(product: product),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breandcrumbs
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.productEditHeading,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.productsStoragePath,
                    route: TRoutes.products,
                  ),
                  BreadcrumbItem(local.productEditHeading),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Create Products
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        const EditProductTitleAndDescription(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Stock and Pricing
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text(
                                local.stockAndPricing,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              // Product Type
                              const EditProductTypeWidget(),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),
                              // Stock
                              const EditProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              // Attributes
                              const EditProductAttributes(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Varistions
                        const EditProductVariations(),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.defaultSpace),
                  // Sidebar
                  Expanded(
                    child: Column(
                      children: [
                        // Product Thubnail
                        const ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product Images
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                local.allProductImages,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              // ProductAdditionalImage
                              ProductAdditionalImages(
                                additionalProductImagesURLs:
                                    productImagesController
                                        .additionalProductImagesUrl,
                                onTapToAddImages: () => productImagesController
                                    .selectedMultipleproductImages(),
                                onTapToRemoveImage: (index) =>
                                    productImagesController.removeImges(index),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product bar
                        const EditProductBrandsScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product Categories
                        EditProductCategories(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product Visibility
                        const ProductVisibilityWidgets(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
