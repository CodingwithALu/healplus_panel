import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/products/create_product_controller.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductCategoriesScreen extends StatelessWidget {
  const ProductCategoriesScreen({super.key});

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> _pickProductionDate(
    BuildContext context,
    CreateProductController controller,
  ) async {
    final now = DateTime.now();
    final initial = controller.productionDateValue.value ?? DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked == null) return;

    controller.productionDateValue.value = picked;
    controller.productionDateCtrl.text = _formatDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Ngày sản xuất',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Date field
          TextFormField(
            controller: controller.productionDateCtrl,
            readOnly: true,
            onTap: () => _pickProductionDate(context, controller),
            decoration: InputDecoration(
              labelText: 'Chọn ngày sản xuất',
              hintText: 'vd: 24/3/2019',
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            validator: (v) {
              if ((v ?? '').trim().isEmpty) return 'Vui lòng chọn ngày sản xuất';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
