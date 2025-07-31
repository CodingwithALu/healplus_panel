import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_details_controller.dart';
import 'package:healplus_panel/features/shop/screens/customers/customer_details/tables/customer_data_table_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerOrderTablets extends StatelessWidget {
  const CustomerOrderTablets({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CustomerDetailController.instance;
    final local = AppLocalizations.of(context)!;
    return Obx(() {
      Visibility(
        visible: false,
        child: Text(controller.filteredCustomerOrders.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );
      return TPaginateDataTable(
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        minWith: 550,
        tableHeight: 640,
        dataRowHeight: kMinInteractiveDimension,
        columns: [
          DataColumn2(
            label: Text(local.orderId),
            onSort: (columnIndex, ascending) =>
                controller.sortById(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.orderDate)),
          DataColumn2(label: Text(local.orderItems)),
          DataColumn2(
            label: Text(local.orderStatus),
            fixedWidth: TDeviceUtils.isMobileScreen(context) ? 100 : null,
          ),
          DataColumn2(label: Text(local.orderTotal), numeric: true),
        ],
        source: CustomerDataTableSource(),
      );
    });
  }
}
