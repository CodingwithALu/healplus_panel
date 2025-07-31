import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/loaders/animation_loader.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TPaginateDataTable extends StatelessWidget {
  const TPaginateDataTable({
    super.key,
    this.sortAscending = true,
    this.sortColumnIndex,
    this.rowPerPage = 10,
    required this.source,
    required this.columns,
    this.onPagaChanged,
    this.dataRowHeight = TSizes.xl * 2,
    this.tableHeight = 760,
    this.minWith = 1000,
  });

  /// Whether to sort the DataTable in ascending ỏ descending order
  final bool sortAscending;

  /// Index of the column to sort by
  final int? sortColumnIndex;

  /// Number of rows to display per page
  final int rowPerPage;

  /// Data source for thr DataTable
  final DataTableSource source;

  /// List of column for the DataTable
  final List<DataColumn> columns;

  /// Callback function to handle page changes
  final Function(int)? onPagaChanged;

  /// Height of each data row in the DataTable
  final double dataRowHeight;

  /// height of the entire DataTable
  final double tableHeight;

  /// minimum width of the encire DataTable
  final double? minWith;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Theme(
        // user to set the backend color
        data: Theme.of(context).copyWith(
          cardTheme: const CardThemeData(color: Colors.white, elevation: 0),
        ),
        child: PaginatedDataTable2(
          columnSpacing: 12,
          minWidth: minWith,
          dividerThickness: 0,
          horizontalMargin: 12,
          dataRowHeight: dataRowHeight,
          rowsPerPage: rowPerPage,
          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => TColors.primaryBackground,
          ),
          headingRowDecoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TSizes.borderRadiusMd),
              topRight: Radius.circular(TSizes.borderRadiusMd),
            ),
          ),
          showCheckboxColumn: true,
          // Pagination
          showFirstLastButtons: true,
          onPageChanged: onPagaChanged,
          renderEmptyRowsInTheEnd: false,
          onRowsPerPageChanged: (noOfRows) {},
          // Sorting
          sortAscending: sortAscending,
          sortArrowAlwaysVisible: true,
          sortArrowIcon: Icons.line_axis,
          sortColumnIndex: sortColumnIndex,
          sortArrowBuilder: (bool ascendding, bool sorted) {
            if (sorted) {
              return Icon(
                ascendding ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                size: TSizes.iconSm,
              );
            } else {
              return const Icon(Iconsax.arrow_3, size: TSizes.iconSm);
            }
          },
          columns: columns,
          source: source,
          // empty
          empty: TAnimationLoaderWidget(
            text: 'Nothing Found',
            animation: TImages.packageAnimation,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
