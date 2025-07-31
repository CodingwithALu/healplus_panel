import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_details_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDataTableSource extends DataTableSource {
  final controller = CustomerDetailController.instance;
  @override
  DataRow? getRow(int index) {
    final local = AppLocalizations.of(Get.context!)!;
    final order = controller.filteredCustomerOrders[index];
    final totleamount = order.items.fold<double>(
      0,
      (previousValue, element) => previousValue + element.price,
    );
    return DataRow2(
      selected: false,
      onTap: () => Get.toNamed(
        TRoutes.detailsOrders,
        arguments: order,
        parameters: {'orderId': order.docId},
      ),
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate(local.localeName))),
        DataCell(Text('${order.items.length}')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getOrderStatusColor(
              order.status,
            ).withAlpha(100),
            child: Text(
              THelperFunctions.getStatusText(
                order.status.name.capitalize.toString(),
              ),
              style: TextStyle(
                color: THelperFunctions.getOrderStatusColor(order.status),
              ),
            ),
          ),
        ),
        DataCell(Text('\$$totleamount')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrders.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((item) => item).length;
}
