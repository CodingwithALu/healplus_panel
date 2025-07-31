import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CreateProductController.instance;
    final local = AppLocalizations.of(context)!;
    return Obx(
      () => Row(
        children: [
          Text(
            local.productType,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          // Radio button for Single Type
          RadioMenuButton(
            value: ProductType.single,
            groupValue: controller.productType.value,
            onChanged: (value) =>
                controller.productType.value = value ?? ProductType.single,
            child: Text(local.single),
          ),
          // Radio button for variable Product type
          RadioMenuButton(
            value: ProductType.variable,
            groupValue: controller.productType.value,
            onChanged: (value) =>
                controller.productType.value = value ?? ProductType.single,
            child: Text(local.variable),
          ),
        ],
      ),
    );
  }
}
