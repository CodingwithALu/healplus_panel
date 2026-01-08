import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/features/shop/screens/orders/detail_order/widgets/order_customer.dart';
import 'package:healplus_panel/features/shop/screens/orders/detail_order/widgets/order_info.dart';
import 'package:healplus_panel/features/shop/screens/orders/detail_order/widgets/order_items.dart';
import 'package:healplus_panel/features/shop/screens/orders/detail_order/widgets/order_transactions.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class OrderDetailsDesktop extends StatelessWidget {
  const OrderDetailsDesktop({super.key, required this.orderModel});
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breandcrombs
            TBreadcrumbWithHeading(
              returnToPreviousScreen: true,
              heading: orderModel.docId,
              breadcrumbItems: [
                BreadcrumbItem(local.ordersStoragePath, route: TRoutes.orders),
                BreadcrumbItem(local.orderDetailsBreadcrumb),
              ],
              titleSmall: true,
            ),
            // Body
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side Order Information
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Order Info
                      OrderInfoScreen(orderModel: orderModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      // Items
                      OrderItems(orderModel: orderModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      // Transactions
                      OrderTransactions(orders: orderModel),
                    ],
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwSections),
                // Right Side Order
                Expanded(
                  child: Column(
                    children: [
                      // Customer Info
                      OrderCustomer(orders: orderModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
