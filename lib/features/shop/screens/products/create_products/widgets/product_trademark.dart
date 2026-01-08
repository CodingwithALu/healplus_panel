import 'package:flutter/material.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';

class ProductTrademarkScreen extends StatelessWidget {
  const ProductTrademarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thương hiệu',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: controller.trademarkCtrl,
            decoration: const InputDecoration(
              labelText: 'Trademark',
              hintText: 'vd: Ergopharm',
            ),
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'Vui lòng nhập thương hiệu' : null,
          ),
        ],
      ),
    );
  }
}
