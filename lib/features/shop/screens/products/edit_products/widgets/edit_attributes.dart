import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/products/edit_product_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_attribute_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditProductAttributes extends StatelessWidget {
  const EditProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = EditProductController.instance;
    final attributeController = Get.put(ProductAttributeController());
    final variationController = Get.put(ProductVariationController());
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return controller.productType.value == ProductType.single
              ? Column(
                  children: [
                    const Divider(color: TColors.primaryBackground),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                )
              : const SizedBox.shrink();
        }),
        Text(
          localizations.addProductAttributes,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // Form to add new attribute
        Form(
          key: attributeController.attributesFormKeys,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildAttrbuteName(
                        attributeController,
                        localizations,
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      flex: 2,
                      child: _buildAttributes(
                        attributeController,
                        localizations,
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(
                      attributeController,
                      localizations,
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildAttrbuteName(attributeController, localizations),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAttributes(attributeController, localizations),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(
                      attributeController,
                      localizations,
                    ),
                  ],
                ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        // List of added attribute
        Text(
          localizations.allAttribute,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // Display added attribute in a rouded container
        TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          child: Column(
            children: [
              buildAttributesList(context, attributeController, localizations),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        // Generate Variations Button
        Obx(
          () =>
              controller.productType.value == ProductType.single &&
                  variationController.productVariations.isEmpty
              ? Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () => variationController
                          .generateVariationsConfirmation(context),
                      label: Text(localizations.generateVariations),
                      icon: const Icon(Iconsax.activity),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build button to add a new attribute
  SizedBox _buildAddAttributeButton(
    ProductAttributeController controller,
    AppLocalizations localizations,
  ) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () => controller.addNewAttributes(),
        label: Text(localizations.add),
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: TColors.black,
          backgroundColor: TColors.secondary,
          side: const BorderSide(color: TColors.secondary),
        ),
      ),
    );
  }
  // Build text form field for attribute name

  TextFormField _buildAttrbuteName(
    ProductAttributeController controller,
    AppLocalizations localizations,
  ) {
    return TextFormField(
      controller: controller.attributeNames,
      validator: (value) =>
          TValidator.validateEmptyText(localizations.attributeName, value),
      decoration: InputDecoration(
        labelText: localizations.attributeName,
        hintText: localizations.attributeNameHint,
      ),
    );
  }
  // Build text form field for attribute values

  SizedBox _buildAttributes(
    ProductAttributeController controller,
    AppLocalizations localizations,
  ) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller.attributes,
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) =>
            TValidator.validateEmptyText(localizations.attributeField, value),
        decoration: InputDecoration(
          labelText: localizations.attribute,
          hintText: localizations.attributeHint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget buildAttributesList(
    BuildContext context,
    ProductAttributeController controller,
    AppLocalizations localizations,
  ) {
    return Obx(
      () => controller.productAttributes.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                  child: ListTile(
                    title: Text(controller.productAttributes[index].name ?? ''),
                    subtitle: Text(
                      controller.productAttributes[index].value!
                          .map((item) => item.trim())
                          .toString(),
                    ),
                    trailing: IconButton(
                      onPressed: () =>
                          controller.removeAttributes(index, context),
                      icon: const Icon(Iconsax.trash, color: TColors.error),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwItems),
              itemCount: controller.productAttributes.length,
            )
          : Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TRoundedImage(
                      width: 150,
                      height: 80,
                      imageType: ImageType.asset,
                      imageUrl: TImages.defaultAttributeColorsImageIcon,
                    ),
                  ],
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(localizations.noAttributesAdded),
              ],
            ),
    );
  }
}
