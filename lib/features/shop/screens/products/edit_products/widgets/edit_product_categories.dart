import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/edit_product_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class EditProductCategories extends StatelessWidget {
  const EditProductCategories({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = EditProductController.instance;
    final categoryController = IngredientController.instance;
    final localizations = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text(
            localizations.categories,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // MultiSelectDialogField for selecting categories
          FutureBuilder(
            future: controller.loadSelectedCategories(product.id),
            builder: (context, snapshot) {
              final widget = TCloudHelperFunctions.checkMultiRecordState(
                snapshot: snapshot,
              );
              if (widget != null) return widget;
              return MultiSelectDialogField(
                buttonText: Text(localizations.selectCategories),
                title: Text(localizations.categories),
                initialValue: List<CategoryModel>.from(
                  controller.selectedCategories,
                ),
                items: categoryController.allItems
                    .map((item) => MultiSelectItem(item, item.title))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (value) {
                  controller.selectedCategories.assignAll(value.cast<IngredientModel>());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
