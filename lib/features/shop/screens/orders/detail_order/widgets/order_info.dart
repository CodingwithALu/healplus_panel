import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/shimmer/shimmer.dart';
import 'package:healplus_panel/features/shop/controllers/order/oder_controller.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderInfoScreen extends StatelessWidget {
  const OrderInfoScreen({super.key, required this.orderModel});

  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    final controller = OrderController.instance;
    controller.orderStatus.value = orderModel.status;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.orderInformation,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.orderDate),
                    Text(
                      orderModel.formattedOrderDate(local.localeName),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.orderItems),
                    Text(
                      '${orderModel.items.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.orderStatus),
                    Obx(() {
                      if (controller.statusLoader.value) {
                        return const TShimmerEffect(
                          width: double.infinity,
                          height: 55,
                        );
                      }
                      return TRoundedContainer(
                        radius: TSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: 0,
                        ),
                        backgroundColor: THelperFunctions.getOrderStatusColor(
                          controller.orderStatus.value,
                        ).withAlpha(100),
                        child: DropdownButton<OrderStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: controller.orderStatus.value,
                          items: OrderStatus.values.map((OrderStatus status) {
                            return DropdownMenuItem<OrderStatus>(
                              value: status,
                              child: Text(
                                THelperFunctions.getStatusText(
                                  status.name.capitalize.toString(),
                                ),
                                style: TextStyle(
                                  color: THelperFunctions.getOrderStatusColor(
                                    controller.orderStatus.value,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (OrderStatus? newStatus) {
                            if (newStatus != null) {
                              controller.updateOrderStatus(
                                orderModel,
                                newStatus,
                                context,
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.orderTotal),
                    Text(
                      '\$${orderModel.totalAmount}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
