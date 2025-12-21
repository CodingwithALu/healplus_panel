import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/widgets/tablet_action_button.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CategoryRows extends DataTableSource {
  final controller = IngredientController.instance;
  final categoryController = Get.put(CategoryController());
  final local = AppLocalizations.of(Get.context!)!;
  @override
  DataRow? getRow(int index) {
    final ingredient = controller.filteredItems[index];
    final parentCategory = categoryController.allItems.firstWhereOrNull(
      (item) => item.idc == ingredient.idc,
    );
    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.sm,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
                imageType: ImageType.network,
                imageUrl: ingredient.url,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  ingredient.title,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(parentCategory != null ? parentCategory.name : '')),
        DataCell(
          ingredient.isFeatured
              ? const Icon(Iconsax.heart5, color: TColors.primary)
              : const Icon(Iconsax.heart),
        ),
        DataCell(Text(ingredient.quantity.toString())),
        DataCell(
          Text(
            ingredient.createAt == null
                ? ''
                : ingredient.formattedOrderDate(local.localeName),
          ),
        ),
        DataCell(
          TTabletActionButtons(
            onEditPressed: () =>
                Get.toNamed(TRoutes.editCategory, arguments: ingredient),
            onDeletePressed: () => controller.confirmAndDeleteItem(ingredient),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => 0;
}
