import 'package:healplus_panel/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/Tcurrency_formatter.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

class OrderStatusPiechart extends StatelessWidget {
  const OrderStatusPiechart({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    /* quan ly singleton là cách tổ chức controller/service theo singleton, 
    nhưng sử dụng GetX để truy cập dễ dàng và tự động thay vì tự viết quản lý thủ công.*/
    final controller = DashboardController.instance;
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.status,
                backgroundColor: Colors.amber.withAlpha(100),
                color: Colors.amber,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                local.orderStatusChart,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Graph
          Obx(
            () => controller.orderStatusData.isNotEmpty
                ? SizedBox(
                    height: 400,
                    child: PieChart(
                      // Bieu do du lieu trang thai hinh tron
                      PieChartData(
                        sections: controller.orderStatusData.entries.map((
                          entry,
                        ) {
                          final status = entry.key;
                          final count = entry.value;
                          return PieChartSectionData(
                            title: count.toString(),
                            value: count.toDouble(),
                            radius: 100,
                            color: THelperFunctions.getOrderStatusColor(status),
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(), // chuyển Map.entries thanh mot List
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {},
                          enabled: true,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [TLoaderAnimation()],
                    ),
                  ),
          ),
          // Show status and Color Meta
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => DataTable(
                  columns: [
                    DataColumn(label: Text(local.orderStatus)),
                    DataColumn(label: Text(local.orderItems)),
                    DataColumn(label: Text(local.orderTotal)),
                  ],
                  rows: controller.orderStatusData.entries.map((entry) {
                    final status = entry.key;
                    final count = entry.value;
                    final totalAmount = controller.totalAmounts[status] ?? 0;
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TCircularContainer(
                                width: 20,
                                height: 20,
                                backgroundColor:
                                    THelperFunctions.getOrderStatusColor(
                                      status,
                                    ),
                              ),
                              const SizedBox(width: TSizes.xs),
                              Text(
                                ' ${THelperFunctions.getStatusText(controller.getDisplayStatusName(status).trim())}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(' $count')),
                        DataCell(
                          Text(
                            TCurrencyFormatter.formatVND(totalAmount.toInt()),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
