import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:healplus_panel/features/shop/controllers/banner/ceate_banner_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBannersForm extends StatelessWidget {
  const CreateBannersForm({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // implement build
    final controller = Get.put(CreateBannerController());
    final bannerController = BannerController.instance;
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
              local.createNewBanners,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Column(
              children: [
                Obx(
                  () => GestureDetector(
                    child: TRoundedImage(
                      width: 400,
                      height: 200,
                      imageUrl: controller.imageUrl.value.isNotEmpty
                          ? controller.imageUrl.value
                          : TImages.acerlogo,
                      imageType: controller.imageUrl.value.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                      backgroundColor: TColors.primaryBackground,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextButton(
                  onPressed: () => controller.pickImage(),
                  child: Text(local.selectedImages),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Text(
              local.bannerActiveDescription,
              style: Theme.of(Get.context!).textTheme.bodyMedium,
            ),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isActive.value,
                onChanged: (value) =>
                    controller.isActive.value = value ?? false,
                child: Text(local.active),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Dropdown
            Obx(() {
              return DropdownButton<String>(
                value: controller.targetSceen.value,
                onChanged: (String? newValue) =>
                    controller.targetSceen.value = newValue!,
                items: TRoutes.sidebarMenuItems.map<DropdownMenuItem<String>>((
                  item,
                ) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(bannerController.fromatRoute(item)),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.createBanners(),
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
