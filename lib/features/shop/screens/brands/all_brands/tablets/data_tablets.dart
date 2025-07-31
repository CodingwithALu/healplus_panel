import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/screens/brands/all_brands/tablets/data_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(BrandController());
    final local = AppLocalizations.of(context)!;
    return Obx(() {
      Text(controller.filteredItems.length.toString());
      Text(controller.selectedRows.length.toString());
      final lgTable = controller.filteredItems.any(
        (element) =>
            element.brandCategories != null &&
            element.brandCategories!.length > 2,
      );
      return TPaginateDataTable(
        minWith: 700,
        tableHeight: lgTable ? 96 * 11.5 : 760,
        dataRowHeight: lgTable ? 96 : 64,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        source: BrandsRows(),
        columns: [
          DataColumn2(
            label: Text(local.brand),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.categories)),
          DataColumn2(
            label: Text(local.featured),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 100,
          ),
          DataColumn2(
            label: Text(local.orderDate),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
          ),
          DataColumn2(
            label: Text(local.action),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 100,
          ),
        ],
      );
    });
  }
}
