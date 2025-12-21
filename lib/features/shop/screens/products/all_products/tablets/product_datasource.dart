import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/widgets/tablet_action_button.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ProductDatasource extends DataTableSource {
  final controller = ProductController.instace;
  @override
  DataRow? getRow(int index) {
    final product = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(TRoutes.editProduct, arguments: product),
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.xs,
                imageType: ImageType.network,
                imageUrl: product.thumbnail,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.title,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(controller.getProductStockTotal(product))),
        DataCell(Text(controller.getProductSoldQuantity(product))),
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 35,
                height: 35,
                padding: TSizes.xs,
                imageType: product.brand != null
                    ? ImageType.network
                    : ImageType.asset,
                imageUrl: product.brand != null
                    ? product.brand!.image
                    : TImages.nikeLogo,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.brand != null ? product.brand!.name : '',
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text('\$${controller.getProductPrice(product)}')),
        DataCell(
          Text(
            product.formattedOrderDate(
              AppLocalizations.of(Get.context!)!.localeName,
            ),
          ),
        ),
        DataCell(
          TTabletActionButtons(
            onEditPressed: () =>
                Get.toNamed(TRoutes.editProduct, arguments: product),
            onDeletePressed: () => controller.confirmAndDeleteItem(product),
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
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
