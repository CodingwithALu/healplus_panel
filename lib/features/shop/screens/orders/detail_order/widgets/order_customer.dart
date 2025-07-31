import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/order/order_detail_controller.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.orders});
  final OrderModel orders;
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(OrderDetailController());
    controller.order.value = orders;
    controller.getCustomerOfCurrentOrder();
    final local = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Info
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.customers,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Obx(
                () => Row(
                  children: [
                    TRoundedImage(
                      padding: 0,
                      backgroundColor: TColors.primaryBackground,
                      imageUrl: controller.users.value.profilePicture.isNotEmpty
                          ? controller.users.value.profilePicture
                          : TImages.user,
                      imageType:
                          controller.users.value.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.users.value.fullName,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          controller.users.value.email,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        // Contact Info
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.contactPerson,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(
                    controller.users.value.fullName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    controller.users.value.email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    controller.users.value.formattedPhoneNumber.isNotEmpty
                        ? controller.users.value.formattedPhoneNumber
                        : '(+84) *** ****',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        // Context Info
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.shippingAddress,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                Text(
                  orders.shippingAddress != null
                      ? orders.shippingAddress!.name
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Text(
                  orders.shippingAddress != null
                      ? orders.shippingAddress!.toString()
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),
        // Contact Info
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.billingAddress,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                Text(
                  !orders.billingAddressSameAsShipping
                      ? orders.billingAddress!.name
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Text(
                  !orders.billingAddressSameAsShipping
                      ? orders.billingAddress!.toString()
                      : '...',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
