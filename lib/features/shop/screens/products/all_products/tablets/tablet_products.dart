import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_controller.dart';
import 'package:healplus_panel/features/shop/screens/products/all_products/tablets/product_datasource.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TabletProductsScreen extends StatelessWidget {
  const TabletProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = ProductController.instace;
    final local = AppLocalizations.of(context)!;
    return Obx(() {
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );
      return TPaginateDataTable(
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        minWith: 1000,
        columns: [
          DataColumn2(
            label: Text(local.products),
            fixedWidth: !TDeviceUtils.isDesktopScreen(context) ? 300 : 400,
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text(local.stock),
            onSort: (columnIndex, ascending) =>
                controller.sortByTock(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text(local.sold),
            onSort: (columnIndex, ascending) =>
                controller.sortBySoldItem(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.brands)),
          DataColumn2(
            label: Text(local.price),
            onSort: (columnIndex, ascending) =>
                controller.sortByPrice(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.orderDate)),
          DataColumn2(label: Text(local.action), fixedWidth: 100),
        ],
        source: ProductDatasource(),
      );
    });
  }
}
