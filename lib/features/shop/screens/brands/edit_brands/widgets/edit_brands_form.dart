import 'package:healplus_panel/common/widgets/chips/choice_chip.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/brands/edit_brands_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/widgets/image_loader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditBrandsForm extends StatelessWidget {
  const EditBrandsForm({super.key, required this.brands});
  final CategoryModel brands;
  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(EditBrandsController());
    final ingredientController = IngredientController.instance;
    final localizations = AppLocalizations.of(context)!;
    controller.init(brands);
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            SizedBox(height: TSizes.sm),
            Text(
              localizations.updateBrands,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) =>
                  TValidator.validateEmptyText(localizations.name, value),
              decoration: InputDecoration(
                labelText: localizations.brandsName,
                prefixIcon: Icon(Iconsax.category),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Categories
            Text(
              localizations.selectedCategories,
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(
              () => Wrap(
                spacing: TSizes.xs,
                children: ingredientController.allItems
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: TSizes.sm),
                        child: TChoiceChip(
                          text: item.title,
                          selected: controller.selectedIngredient.contains(
                            item.iding,
                          ),
                          onSelected: null,
                          // controller.toggleSelection(item),
                        ),
                      ),
                    )
                    .toList(),
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
                child: Text(localizations.featured),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateBrands(brands),
                child: Text(localizations.update),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
