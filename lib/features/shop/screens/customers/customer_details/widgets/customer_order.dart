import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_details_controller.dart';
import 'package:healplus_panel/features/shop/screens/customers/customer_details/tables/customer_tables_order.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/Tcurrency_formatter.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/loaders/animation_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CustomerDetailController.instance;
    final local = AppLocalizations.of(context)!;
    controller.getCustomerOrders();
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        if (controller.ordersLoading.value) return const TLoaderAnimation();
        if (controller.allCustomerOrders.isEmpty) {
          return TAnimationLoaderWidget(
            text: local.noOrdersFound,
            animation: TImages.pencilanimation,
          );
        }

        final totalAmount = controller.allCustomerOrders.fold(
          0.0,
          (previousValue, element) => previousValue + element.sumMoney,
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.order,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${local.totalSpent} '),
                      TextSpan(
                        text: TCurrencyFormatter.formatVND(totalAmount.toInt()),
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.apply(color: TColors.primary),
                      ),
                      TextSpan(
                        text:
                            ' ${local.onOrders(controller.allCustomerOrders.length)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              decoration: InputDecoration(
                hintText: local.searchOrders,
                prefixIcon: const Icon(Iconsax.search_normal),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            const CustomerOrderTablets(),
          ],
        );
      }),
    );
  }
}
