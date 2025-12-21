import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/models/user_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});
  final UserModel customer;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.customerInformation,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Personal Info Card
          Row(
            children: [
              TRoundedImage(
                padding: 0,
                backgroundColor: TColors.primaryBackground,
                imageUrl: customer.profilePicture.isNotEmpty
                    ? customer.profilePicture
                    : TImages.user,
                imageType: customer.profilePicture.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      customer.email,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Meta data
          Row(
            children: [
              SizedBox(width: 120, child: Text(local.username)),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  customer.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              SizedBox(width: 120, child: Text(local.country)),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  local.vietnamCountry,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              SizedBox(width: 120, child: Text(local.phoneNumber)),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  customer.formattedPhoneNumber,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Divider
          const Divider(),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Aditional Detials
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.lastOrder,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(local.daysAgoOrder),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.averageOrderValue,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Text('\$352'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.registered,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(customer.formattedAtDate),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.emailMarketing,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(local.subscribed),
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
