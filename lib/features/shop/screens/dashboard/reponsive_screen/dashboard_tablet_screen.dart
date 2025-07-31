import 'package:healplus_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/widgets/order_status_piechart.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/widgets/recent_order.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/widgets/week_sales.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(DashboardController());
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heding
              Text(
                local.dashboardTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Cards
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashbosrCard(
                        headingIcons: Iconsax.note,
                        headingIconColors: Colors.blue,
                        headingIconBgColor: Colors.blue.withAlpha(50),
                        context: context,
                        comparedText: local.comparedTo,
                        stas: 25,
                        title: local.salesTotal,
                        subtitle:
                            '\$${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashbosrCard(
                        headingIcons: Iconsax.external_drive,
                        headingIconColors: Colors.green,
                        headingIconBgColor: Colors.green.withAlpha(50),
                        context: context,
                        comparedText: local.comparedTo,
                        stas: 15,
                        title: local.averageOrder,
                        subtitle:
                            '\$${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashbosrCard(
                        headingIcons: Iconsax.box,
                        headingIconColors: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withAlpha(50),
                        context: context,
                        comparedText: local.comparedTo,
                        stas: 45,
                        title: local.totalOrders,
                        subtitle:
                            '\$${controller.orderController.allItems.length}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashbosrCard(
                        headingIcons: Iconsax.user,
                        headingIconColors: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withAlpha(50),
                        context: context,
                        comparedText: local.comparedTo,
                        stas: 2,
                        title: local.visitors,
                        subtitle:
                            '\$${controller.customerContrller.allItems.length.toString()}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Graphs
              const TWeeklySalesGraph(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Orders
              const TRecentOrderScreen(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Pie Chart
              const OrderStatusPiechart(),
            ],
          ),
        ),
      ),
    );
  }
}
