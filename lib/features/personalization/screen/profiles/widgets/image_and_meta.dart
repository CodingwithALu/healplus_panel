import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/authentication/controllers/user_controller.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/widgets/image_loader.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = Get.put(UserController());
    return TRoundedContainer(
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.lg,
        horizontal: TSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Column(
              children: [
                //User image
                TImageUpLoader(
                  right: 10,
                  bottom: 20,
                  left: null,
                  width: 200,
                  height: 200,
                  cricular: true,
                  loading: controller.loading.value,
                  icon: Iconsax.camera,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : TImages.user,
                  onIconButtonPressed: () =>
                      controller.uploadUserProfilePicture(),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  controller.user.value.fullName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(controller.user.value.email),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
