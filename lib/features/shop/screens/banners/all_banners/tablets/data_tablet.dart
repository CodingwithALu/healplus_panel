import 'package:healplus_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:healplus_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:healplus_panel/features/shop/screens/banners/all_banners/tablets/data_source.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BannerTablets extends StatelessWidget {
  const BannerTablets({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // implement build
    final controller = BannerController.instance;
    return Obx(() {
      Text(controller.filteredItems.length.toString());
      Text(controller.selectedRows.length.toString());
      return TPaginateDataTable(
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        minWith: 700,
        tableHeight: 900,
        dataRowHeight: 110,
        source: BannersForm(),
        columns: [
          DataColumn2(label: SelectableText(local.banner)),
          DataColumn2(
            label: Text(local.redirectScreen),
            onSort: (columnIndex, ascending) =>
                controller.sortByParentRout(columnIndex, ascending),
          ),
          DataColumn2(label: Text(local.active)),
          DataColumn2(label: Text(local.action), fixedWidth: 100),
        ],
      );
    });
  }
}
