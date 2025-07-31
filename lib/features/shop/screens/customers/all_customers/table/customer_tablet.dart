import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:healplus_panel/features/shop/screens/customers/all_customers/table/customer_data_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CustomerTablet extends StatelessWidget {
  const CustomerTablet({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    final controller = CustomerController.instance;
    final local = AppLocalizations.of(context)!;
    return Obx(() {
      Text(controller.filteredItems.length.toString());
      Text(controller.selectedRows.length.toString());
      return TPaginateDataTable(
        minWith: 700,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            label: Text(local.customers),
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.email)),
          DataColumn2(label: Text(local.phoneNo)),
          DataColumn2(label: Text(local.registered)),
          DataColumn2(label: Text(local.action), fixedWidth: 100),
        ],
        source: CustomerDataSource(),
      );
    });
  }
}
