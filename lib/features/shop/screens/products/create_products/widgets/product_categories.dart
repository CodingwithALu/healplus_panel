import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/shimmer/shimmer.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class ProductCategoriesScreen extends StatelessWidget {
  const ProductCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final categoryController = Get.put(IngredientController());
    final local = AppLocalizations.of(context)!;
    if (categoryController.allItems.isEmpty) {
      categoryController.fetchItems();
    }
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text(
            local.categories,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // MultiSelectDialogField for selecting categories
          Obx(
            () => categoryController.isLoading.value
                ? const TShimmerEffect(width: double.infinity, height: 50)
                : MultiSelectDialogField(
                    buttonText: Text(local.selectCategories),
                    title: Text(local.categories),
                    items: categoryController.allItems
                        .map((item) => MultiSelectItem(item, item.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (value) {
                      CreateProductController.instance.selectedCategories
                          .assignAll(value);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
