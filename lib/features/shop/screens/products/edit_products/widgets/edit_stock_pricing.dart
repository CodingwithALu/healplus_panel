import 'package:healplus_panel/features/shop/controllers/products/edit_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EditProductStockAndPricing extends StatelessWidget {
  const EditProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = EditProductController.instance;
    final localizations = AppLocalizations.of(context)!;
    return Obx(
      () => controller.productType.value == ProductType.single
          ? Form(
              key: controller.stockPriceFromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stock
                  FractionallySizedBox(
                    widthFactor: 0.45,
                    child: TextFormField(
                      controller: controller.stock,
                      decoration: InputDecoration(
                        labelText: localizations.stockLabel,
                        hintText: localizations.stockHint,
                      ),
                      validator: (value) => TValidator.validateEmptyText(
                        localizations.stockLabel,
                        value,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  // Pricing
                  Row(
                    children: [
                      // Price
                      Expanded(
                        child: TextFormField(
                          controller: controller.price,
                          decoration: InputDecoration(
                            labelText: localizations.priceLabel,
                            hintText: localizations.priceHint,
                          ),
                          validator: (value) => TValidator.validateEmptyText(
                            localizations.priceLabel,
                            value,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      // Sale Price
                      Expanded(
                        child: TextFormField(
                          controller: controller.salePrice,
                          decoration: InputDecoration(
                            labelText: localizations.discountedPrice,
                            hintText: localizations.priceHint,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
