import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_details_controller.dart';
import 'package:healplus_panel/features/shop/models/address_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CustomerDetailController.instance;
    final local = AppLocalizations.of(context)!;
    controller.getCustomerAddresses();
    return Obx(() {
      if (controller.addressesLoading.value) return const TLoaderAnimation();
      AddressModel selectedAddress = AddressModel.empty();
      if (controller.customer.value.addresses != null) {
        if (controller.customer.value.addresses!.isNotEmpty) {
          selectedAddress = controller.customer.value.addresses!
              .where((element) => element.selectedAddress)
              .single;
        }
      }
      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              local.address,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Meta data
            Row(
              children: [
                SizedBox(width: 120, child: Text(local.name)),
                const Text(':'),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    selectedAddress.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Meta data
            Row(
              children: [
                SizedBox(width: 120, child: Text(local.country)),
                const Text(':'),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    selectedAddress.country,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Meta data
            Row(
              children: [
                SizedBox(width: 120, child: Text(local.phoneNumber)),
                const Text(':'),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    selectedAddress.phoneNumber,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Meta data
            Row(
              children: [
                SizedBox(width: 120, child: Text(local.address)),
                const Text(':'),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    selectedAddress.id.isNotEmpty
                        ? selectedAddress.toString()
                        : '...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
