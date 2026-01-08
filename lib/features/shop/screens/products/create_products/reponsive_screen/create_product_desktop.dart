import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_images_controller.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_additional_images.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_attributes.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_bottom_navigation_button.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_brands.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_categories.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_expiry.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_manufacturer.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_origin.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_stock_pricing.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_thumbnail_image.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_title_and_description.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_trademark.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_variations.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/widgets/product_visibility_widgets.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductDesktopScreen extends StatelessWidget {
  const CreateProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    Get.put(CreateProductController());
    final productImagesController = Get.put(ProductImagesController());
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breandcrumbs
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.productCreateHeading,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.productsStoragePath,
                    route: TRoutes.products,
                  ),
                  BreadcrumbItem(local.productCreateHeading),
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
                        const ProductTitleAndDescription(),
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
                              // const ProductTypeWidget(),
                              // const SizedBox(
                              //   height: TSizes.spaceBtwInputFields,
                              // ),
                              //Stock
                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              // Attributes
                              const ProductIngredient(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Varistions
                        const ProductVariations(),
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
                        const ProductBrandsScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product Categories
                        const ProductCategoriesScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Product Visibility
                        const ProductTrademarkScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const ProductOriginScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const ProductManufacturerScreen(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const ProductExpiryScreen(),
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
