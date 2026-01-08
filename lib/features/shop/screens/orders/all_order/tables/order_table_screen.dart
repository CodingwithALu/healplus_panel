import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/order/oder_controller.dart';
import 'package:healplus_panel/features/shop/screens/orders/all_order/tables/order_data_table_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class OrderTableScreen extends StatelessWidget {
  const OrderTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = OrderController.instance;
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
        minWith: 700,
        columns: [
          DataColumn2(label: Text(local.orderId)),
          DataColumn2(
            label: Text(local.orderDate),
            onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.orderItems)),
          DataColumn2(
            label: Text(local.orderStatus),
            fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null,
          ),
          DataColumn2(
            label: Text(local.orderTotal),
            onSort: (columnIndex, ascending) =>
                controller.sortById(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.action), fixedWidth: 100),
        ],
        source: OrderRows(),
      );
    });
  }
}
