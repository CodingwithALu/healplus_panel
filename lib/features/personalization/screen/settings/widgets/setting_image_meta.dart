import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/settings/setting_controller.dart';
import 'package:healplus_panel/features/shop/screens/category/create_categories/widgets/image_loader.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingImageMeta extends StatelessWidget {
  const SettingImageMeta({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = SettingsController.instance;
    return TRoundedContainer(
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.lg,
        horizontal: TSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              //User image
              Obx(
                () => TImageUpLoader(
                  right: 10,
                  bottom: 20,
                  left: null,
                  width: 200,
                  height: 200,
                  cricular: true,
                  loading: controller.loading.value,
                  onIconButtonPressed: () => controller.updateAppLogo(),
                  icon: Iconsax.camera,
                  imageType: controller.settings.value.appLogo.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.settings.value.appLogo.isNotEmpty
                      ? controller.settings.value.appLogo
                      : TImages.user,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(
                () => Text(
                  controller.settings.value.appName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}
