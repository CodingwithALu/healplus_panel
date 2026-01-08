
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/Tcurrency_formatter.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:flutter/material.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.orderModel});
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    final subTotal = orderModel.items.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (double.tryParse(element.price.toString()) ?? 0) *
              (int.tryParse(element.quantity.toString()) ?? 0),
    );
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.items, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Items
          ListView.separated(
            shrinkWrap: true,
            itemCount: orderModel.items.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final item = orderModel.items[index];
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        TRoundedImage(
                          backgroundColor: TColors.primaryBackground,
                          imageType: item.urls?.first != null
                              ? ImageType.network
                              : ImageType.asset,
                          imageUrl: item.urls?.first ?? TImages.defaultImage,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (item.unitNames != null)
                                Text(
                                  item.unitNames!
                                      .map(
                                        (unit) =>
                                            ('${unit.name} : ${unit.price}'),
                                      )
                                      .join(', '),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: TSizes.xl * 2,
                          child: Text(
                            TCurrencyFormatter.formatVND(
                              int.tryParse(item.price.toString()) ?? 0,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(
                          width: TDeviceUtils.isMobileScreen(context)
                              ? TSizes.xl * 1.4
                              : TSizes.xl * 2,
                          child: Text(
                            item.quantity.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(
                          width: TDeviceUtils.isMobileScreen(context)
                              ? TSizes.xl * 1.4
                              : TSizes.xl * 2,
                          child: Text(
                            TCurrencyFormatter.formatVND(item.quantity),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(
                          width: TDeviceUtils.isMobileScreen(context)
                              ? TSizes.xl * 1.4
                              : TSizes.xl * 2,
                          child: Text(
                            TCurrencyFormatter.formatVND(item.total!),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Items Total
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local.subtotal,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      TCurrencyFormatter.formatVND(subTotal.toInt()),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local.discount,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '0.00 d',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local.shipping,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      TCurrencyFormatter.formatVND(
                        (orderModel.shippingCost ?? 0.0).toInt(),
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local.tax,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      TCurrencyFormatter.formatVND(subTotal.toInt()),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      local.orderTotal,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      TCurrencyFormatter.formatVND(orderModel.sumMoney.toInt()),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
