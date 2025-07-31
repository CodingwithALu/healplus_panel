import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/shimmer/shimmer.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductBrandsScreen extends StatelessWidget {
  const ProductBrandsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(CreateProductController());
    final brandsController = Get.put(BrandController());
    final local = AppLocalizations.of(context)!;
    if (brandsController.allItems.isEmpty) {
      brandsController.fetchItems();
    }
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand label
          Text(local.brand, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          // TypeAheadFiela for brand selection
          Obx(
            () => brandsController.isLoading.value
                ? const TShimmerEffect(width: double.infinity, height: 50)
                : TypeAheadField(
                    builder: (context, ctr, focusNode) {
                      return TextFormField(
                        focusNode: focusNode,
                        controller: controller.brandTextField = ctr,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: local.selectBrand,
                          suffixIcon: const Icon(Iconsax.box),
                        ),
                      );
                    },
                    suggestionsCallback: (pattern) {
                      // Return filtered brand suggestion base on the search pattern
                      return brandsController.allItems
                          .where((item) => item.name.contains(pattern))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(title: Text(suggestion.name));
                    },
                    onSelected: (suggestion) {
                      controller.selectedBrand.value = suggestion;
                      controller.brandTextField.text = suggestion.name;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
