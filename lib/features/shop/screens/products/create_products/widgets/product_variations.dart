import 'package:get/get.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_images_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/features/shop/models/product_variation_model.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/widgets/image_loader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(ProductVariationController());
    final creteProductCotroller = CreateProductController.instance;
    final localizations = AppLocalizations.of(context)!;
    return Obx(
      () => creteProductCotroller.productType.value == ProductType.variable
          ? TRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Variations Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.productVariations,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () => controller.removeVariations(context),
                        child: Text(localizations.removeVariations),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Variations
                  if (controller.productVariations.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final variations = controller.productVariations[index];
                        return _buildVariationTitle(
                          context,
                          index,
                          variations,
                          controller,
                          localizations,
                        );
                      },
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: TSizes.spaceBtwItems),
                      itemCount: controller.productVariations.length,
                    )
                  else
                    // No Variations message
                    _buildNoVariationsMessage(localizations),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildVariationTitle(
    BuildContext context,
    int index,
    ProductVariationModel variations,
    ProductVariationController controller,
    AppLocalizations localizations,
  ) {
    return ExpansionTile(
      backgroundColor: TColors.lightGrey,
      collapsedBackgroundColor: TColors.lightGrey,
      childrenPadding: const EdgeInsets.all(TSizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      title: Text(
        variations.attributeValue.entries
            .map((item) => '${item.key}: ${item.value}')
            .join(', '),
      ),
      children: [
        // Up load Variation Image
        Obx(
          () => TImageUpLoader(
            right: 0,
            left: null,
            imageType: variations.image.value.isNotEmpty
                ? ImageType.network
                : ImageType.asset,
            image: variations.image.value.isNotEmpty
                ? variations.image.value
                : TImages.defaultImage,
            onIconButtonPressed: () => ProductImagesController.instance
                .selectedVariationsImage(variations),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        // Varistions Stock, and Pricing
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) => variations.stock = int.parse(value),
                controller:
                    controller.getStockController(index, variations) ??
                    TextEditingController(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: localizations.stockLabel,
                  hintText: localizations.stockHint,
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                onChanged: (value) => variations.price = double.parse(value),
                controller:
                    controller.getPriceController(index, variations) ??
                    TextEditingController(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                decoration: InputDecoration(
                  labelText: localizations.priceLabel,
                  hintText: localizations.priceHint,
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                onChanged: (value) =>
                    variations.salePrice = double.parse(value),
                controller:
                    controller.getSalePriceController(index, variations) ??
                    TextEditingController(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                decoration: InputDecoration(
                  labelText: localizations.discountedPrice,
                  hintText: localizations.priceHint,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        // Variation Descriptio
        TextFormField(
          controller:
              controller.getDescriptionController(index, variations) ??
              TextEditingController(),
          onChanged: (value) => variations.description = value,
          decoration: InputDecoration(
            labelText: localizations.description,
            hintText: localizations.addDescriptionVariationHint,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationsMessage(AppLocalizations localizations) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(
              width: 200,
              height: 200,
              imageType: ImageType.asset,
              imageUrl: TImages.defaultVariationImageIcon,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(localizations.noVariationsMessage),
      ],
    );
  }
}
