import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/features/shop/controllers/banner/edit_banner_controller.dart';
import 'package:healplus_panel/features/shop/models/banner_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBannersForm extends StatelessWidget {
  const EditBannersForm({super.key, required this.banner});
  final BannerModel banner;
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // implement build
    final controller = Get.put(EditBannerController());
    controller.init(banner);
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
              local.updateBanners,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Column(
              children: [
                Obx(
                  () => TRoundedImage(
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
            Obx(
              () => DropdownButton<String>(
                value: controller.targetSceen.value,
                onChanged: (String? neValue) =>
                    controller.targetSceen.value = neValue!,
                items: TRoutes.sidebarMenuItems.map<DropdownMenuItem<String>>((
                  item,
                ) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateBanners(banner),
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
