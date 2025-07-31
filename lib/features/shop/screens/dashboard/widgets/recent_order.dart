import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/table/data_table.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TRecentOrderScreen extends StatelessWidget {
  const TRecentOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.receipt_discount,
                backgroundColor: Colors.green.withAlpha(100),
                color: Colors.green,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                local.recentOrders,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const DashboardOrderTable(),
        ],
      ),
    );
  }
}
