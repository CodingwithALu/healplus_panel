import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/screens/category/all_categories/widgets/tablet_action_button.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class BrandsRows extends DataTableSource {
  final controller = CategoryController.instance;
  @override
  DataRow? getRow(int index) {
    final brand = controller.filteredItems[index];
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
                imageUrl: brand.image,
                imageType: ImageType.network,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  brand.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: TSizes.xs,
                direction: TDeviceUtils.isMobileScreen(Get.context!)
                    ? Axis.vertical
                    : Axis.horizontal,
                children: brand.ingredients != null
                    ? brand.ingredients!
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    TDeviceUtils.isMobileScreen(Get.context!)
                                    ? 0
                                    : TSizes.xs,
                              ),
                              child: Chip(
                                label: Text(e.title),
                                padding: EdgeInsets.all(TSizes.xs),
                              ),
                            ),
                          )
                          .toList()
                    : [const SizedBox()],
              ),
            ),
          ),
        ),
        DataCell(
          brand.isFeatured
              ? Icon(Iconsax.heart5, color: TColors.primary)
              : const Icon(Iconsax.heart),
        ),
        DataCell(Text(brand.createAt != null ? brand.formattedDate : '')),
        DataCell(
          TTabletActionButtons(
            onEditPressed: () =>
                Get.toNamed(TRoutes.editbrand, arguments: brand),
            onDeletePressed: () => controller.confirmAndDeleteItem(brand),
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
