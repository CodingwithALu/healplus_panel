import 'package:flutter/material.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';

class ProductExpiryScreen extends StatelessWidget {
  const ProductExpiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hạn sử dụng',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: controller.expiryCtrl,
            decoration: const InputDecoration(
              labelText: 'Expiry',
              hintText: 'vd: 9 tháng kể từ ngày sản xuất',
            ),
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'Vui lòng nhập hạn sử dụng' : null,
          ),
        ],
      ),
    );
  }
}
