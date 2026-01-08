import 'package:get/get.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_inut_name_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CreateProductController.instance;
    final unitNameController = Get.put(ProductUnitNameController());
    final local = AppLocalizations.of(context)!;
    return Obx(
      () => controller.productType.value == ProductType.single
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock
                FractionallySizedBox(
                  widthFactor: 0.45,
                  child: TextFormField(
                    controller: controller.stock,
                    decoration: InputDecoration(
                      labelText: local.stockLabel,
                      hintText: local.stockHint,
                    ),
                    validator: (value) =>
                        TValidator.validateEmptyText(local.stockLabel, value),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                // Pricing
                Form(
                  key: unitNameController.attributesFormKeys,
                  child: Row(
                    children: [
                      // Price
                      Expanded(
                        child: TextFormField(
                          controller: unitNameController.inagredientNames,
                          decoration: InputDecoration(
                            labelText: "Đơn vị",
                            hintText: "Đơn vị tính. Ví dụ: Hộp, Viên",
                          ),
                          validator: (value) => TValidator.validateEmptyText(
                            local.priceLabel,
                            value,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          // inputFormatters: <TextInputFormatter>[
                          //   FilteringTextInputFormatter.allow(
                          //     RegExp(r'^\d+\.?\d{0,2}$'),
                          //   ),
                          // ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      // Sale Price
                      Expanded(
                        child: TextFormField(
                          controller: unitNameController.body,
                          decoration: InputDecoration(
                            labelText: "Giá",
                            hintText: 'Nhập giá',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton.icon(
                          onPressed: () => unitNameController.addNewUnitName(),
                          label: Text(local.add),
                          icon: const Icon(Iconsax.add),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: TColors.black,
                            backgroundColor: TColors.secondary,
                            side: const BorderSide(color: TColors.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // list
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  "Danh sách ",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                // Display added attribute in a rouded container
                TRoundedContainer(
                  backgroundColor: TColors.primaryBackground,
                  child: Column(
                    children: [
                      buildAttributesList(context, unitNameController, local),
                    ],
                  ),
                ),
                // const SizedBox(height: TSizes.spaceBtwSections),
                // Generate Variations Button
                // Obx(
                //   () =>
                //       controller.productType.value == ProductType.single &&
                //           variationController.productVariations.isEmpty
                //       ? Center(
                //           child: SizedBox(
                //             width: 200,
                //             child: ElevatedButton.icon(
                //               onPressed: () => variationController
                //                   .generateVariationsConfirmation(context),
                //               label: Text(local.generateVariations),
                //               icon: const Icon(Iconsax.activity),
                //             ),
                //           ),
                //         )
                //       : const SizedBox.shrink(),
                // ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget buildAttributesList(
    BuildContext context,
    ProductUnitNameController controller,
    AppLocalizations local,
  ) {
    return Obx(
      () => controller.productUnitName.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                  child: ListTile(
                    title: Text(controller.productUnitName[index].name),
                    subtitle: Text(controller.productUnitName[index].price.toString()),
                    trailing: IconButton(
                      onPressed: () =>
                          controller.removeUnitName(index, context),
                      icon: const Icon(Iconsax.trash, color: TColors.error),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwItems),
              itemCount: controller.productUnitName.length,
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
                Text(local.noVariationsMessage),
              ],
            ),
    );
  }
}
