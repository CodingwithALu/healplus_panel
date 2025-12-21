import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/shimmer/shimmer.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/create_category_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/widgets/image_loader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateCategoryFrom extends StatelessWidget {
  const CreateCategoryFrom({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(CreateIngredientController());
    final categoryController = CategoryController.instance;
    final local = AppLocalizations.of(context)!;
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
              local.createNewCategory,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: InputDecoration(
                labelText: local.categoryName,
                prefixIcon: Icon(Iconsax.category),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Categories Dropdown
            Obx(
              () => categoryController.isLoading.value
                  ? const TShimmerEffect(width: double.infinity, height: 55)
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: local.parentCategory,
                        labelText: local.parentCategory,
                        prefixIcon: Icon(Iconsax.bezier),
                      ),
                      items: categoryController.allItems
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [Text(item.name)],
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
                imageType: controller.imageUrl.isNotEmpty
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
                child: Text(local.featured),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.createCategory(),
                child: Text(local.create),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
