import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/shimmer/shimmer.dart';
import 'package:healplus_panel/features/shop/controllers/element/element_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductBrandsScreen extends StatelessWidget {
  const ProductBrandsScreen({super.key});

  Future<void> _openBrandPickerDialog({
    required BuildContext context,
    required ElementController brandsController,
    required CreateProductController controller,
    required AppLocalizations local,
  }) async {
    final searchController = TextEditingController();
    try {
      await showDialog<void>(
        context: context,
        builder: (context) {
          String query = '';
          return StatefulBuilder(
            builder: (context, setState) {
              final items = brandsController.allItems
                  .where(
                    (e) => e.title.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();

              return AlertDialog(
                title: Text(local.brand),
                content: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: local.selectBrand,
                          prefixIcon: const Icon(Iconsax.search_normal),
                        ),
                        onChanged: (v) => setState(() => query = v),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      SizedBox(
                        height: 360,
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: TSizes.spaceBtwItems),
                          itemBuilder: (_, index) {
                            final item = items[index];
                            final isSelected =
                                controller.selectedBrand.value?.ide == item.ide;

                            return ListTile(
                              title: Text(item.title),
                              trailing: isSelected
                                  ? const Icon(Iconsax.tick_circle)
                                  : null,
                              onTap: () {
                                controller.selectedBrand.value = item;
                                controller.brandTextField.text = item.title;
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      MaterialLocalizations.of(context).cancelButtonLabel,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      searchController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;
    final brandsController = Get.put(ElementController());
    final local = AppLocalizations.of(context)!;

    if (brandsController.allItems.isEmpty) {
      brandsController.fetchItems();
    }

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.brand, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          Obx(
            () => brandsController.isLoading.value
                ? const TShimmerEffect(width: double.infinity, height: 50)
                : TextFormField(
                    controller: controller.brandTextField,
                    readOnly: true,
                    onTap: () => _openBrandPickerDialog(
                      context: context,
                      brandsController: brandsController,
                      controller: controller,
                      local: local,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: local.selectBrand,
                      suffixIcon: const Icon(Iconsax.arrow_down_1),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
