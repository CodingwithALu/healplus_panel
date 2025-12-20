import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/screens/category/all_categories/tables/table_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class TCategoryTablets extends StatelessWidget {
  const TCategoryTablets({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // implement build
    final controller = IngredientController.instance;
    return Obx(() {
      Text(controller.filteredItems.length.toString());
      Text(controller.selectedRows.length.toString());
      return TPaginateDataTable(
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        minWith: 700,
        source: CategoryRows(),
        columns: [
          DataColumn2(
            label: Text(local.categoryColumn),
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.featuredColumn)),
          DataColumn2(label: Text("Số lượng")),
          DataColumn2(label: Text(local.dateColumn)),
          DataColumn2(label: Text(local.action), fixedWidth: 100),
        ],
      );
    });
  }
}
