import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/order/oder_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/widgets/tablet_action_button.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/Tcurrency_formatter.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRows extends DataTableSource {
  final controller = OrderController.instance;
  @override
  DataRow? getRow(int index) {
    final orders = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(
        TRoutes.detailsOrders,
        arguments: orders,
        parameters: {'orderId': orders.docId},
      ),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Text(
            orders.docId.toString(),
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(orders.orderDate)),
        DataCell(Text('${orders.quantity} sản phẩm')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md,
              vertical: TSizes.xs,
            ),
            backgroundColor: THelperFunctions.getOrderStatusColor(
              orders.status,
            ).withAlpha(100),
            child: Text(
              THelperFunctions.getStatusText(
                orders.status.name.capitalize.toString(),
              ),
              style: TextStyle(
                color: THelperFunctions.getOrderStatusColor(orders.status),
              ),
            ),
          ),
        ),
        DataCell(Text(TCurrencyFormatter.formatVND(orders.sumMoney.toInt()))),
        DataCell(
          TTabletActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              TRoutes.detailsOrders,
              arguments: orders,
              parameters: {'orderId': orders.docId},
            ),
            onDeletePressed: () => controller.confirmAndDeleteItem(orders),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.selectedRows.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((item) => item).length;
}
