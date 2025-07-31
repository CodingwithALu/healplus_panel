import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = CreateProductController.instance;
    final local = AppLocalizations.of(context)!;
    return TRoundedContainer(
      child: Form(
        key: controller.titleDescriptionFromKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Text
            Text(
              local.basicInformation,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            // Product Title Input Field
            TextFormField(
              controller: controller.title,
              validator: (value) =>
                  TValidator.validateEmptyText(local.productTitle, value),
              decoration: InputDecoration(labelText: local.productTitle),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Product Description Input Field
            SizedBox(
              height: 300,
              child: TextFormField(
                controller: controller.description,
                expands: false,
                maxLines: null,
                minLines: 13,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                validator: (value) => TValidator.validateEmptyText(
                  local.productDescription,
                  value,
                ),
                decoration: InputDecoration(
                  labelText: local.productDescription,
                  hintText: local.addProductDescriptionHint,
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
