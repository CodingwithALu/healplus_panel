import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ProductBottomNavigationButton extends StatelessWidget {
  const ProductBottomNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CreateProductController.instance;
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard button
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text(local.discard),
          ),
          const SizedBox(width: TSizes.spaceBtwItems / 2),
          // Save Changes button
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () => controller.createProduct(),
              child: Text(local.saveChanges),
            ),
          ),
        ],
      ),
    );
  }
}
