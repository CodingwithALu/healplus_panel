import 'package:healplus_panel/common/widgets/chips/choice_chip.dart';
import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/layouts/templates/loader_animation.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/element/element_controller.dart';
// ignore: unused_import
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/edit_ingredient_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/widgets/image_loader.dart';
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
    final controller = Get.put(EditIngredientController());
    final categoryController = CategoryController.instance;
    final elementController = Get.put(ElementController());
    final localizations = AppLocalizations.of(context)!;
    controller.init(category);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: TRoundedContainer(
            width: double.infinity,
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
                      value: controller.selectedParent.value.idc.isNotEmpty
                          ? controller.selectedParent.value
                          : null,
                      items: categoryController.allItems
                          .map(
                            (item) => DropdownMenuItem<CategoryModel>(
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
                      onPressed: () => controller.updateIngredient(category),
                      child: Text(local.update),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields * 2),
                ],
              ),
            ),
          ),
        ),
        if (category.elements != null) ...[
          const SizedBox(width: TSizes.spaceBtwSections),
          Expanded(
            flex: 6,
            child: TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.selectedCategories,
                    style: Theme.of(Get.context!).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                  Obx(
                    () => Wrap(
                      spacing: TSizes.xs,
                      children: elementController.allItems.map((element) {
                        print("element: $element");
                        if (elementController.isLoading.value) {
                          return const TLoaderAnimation();
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(bottom: TSizes.sm),
                            child: TChoiceChip(
                              text: element.title,
                              selected: controller.selectedElement.contains(
                                element.ide,
                              ),
                              onSelected: null,
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
