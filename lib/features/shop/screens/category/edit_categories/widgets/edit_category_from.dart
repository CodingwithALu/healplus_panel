import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/controllers/categories/edit_category_controller.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/features/shop/screens/category/create_categories/widgets/image_loader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditCategoryFromScreen extends StatelessWidget {
  const EditCategoryFromScreen({super.key, required this.category});

  final IngredientModel category;
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // implement build
    final controller = Get.put(EditCategoryController());
    final categoryController = IngredientController.instance;
    controller.init(category);
    return TRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            SizedBox(height: TSizes.sm),
            Text(
              local.updateCategory,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) =>
                  TValidator.validateEmptyText(local.name, value),
              decoration: InputDecoration(
                labelText: local.categoryName,
                prefixIcon: Icon(Iconsax.category),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
              () => DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: local.parentCategoryColumn,
                  labelText: local.parentCategoryColumn,
                  prefixIcon: Icon(Iconsax.bezier),
                ),
                value: controller.selectedParent.value.iding.isNotEmpty
                    ? controller.selectedParent.value
                    : null,
                items: categoryController.allItems
                    .map(
                      (item) => DropdownMenuItem<IngredientModel>(
                        value: item,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text(item.title)],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) =>
                    controller.selectedParent.value = newValue!,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Obx(
              () => TImageUpLoader(
                width: 80,
                height: 80,
                image: controller.imageUrl.value.isNotEmpty
                    ? controller.imageUrl.value
                    : TImages.defaultImage,
                onIconButtonPressed: () => controller.pickImage(),
                imageType: controller.imageUrl.value.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isFeatured.value,
                onChanged: (value) =>
                    controller.isFeatured.value = value ?? false,
                child: Text(local.featuredColumn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateCategory(category),
                child: Text(local.update),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
