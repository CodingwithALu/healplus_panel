import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/screens/category/create_categories/widgets/image_loader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax/iconsax.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({
    super.key,
    required this.additionalProductImagesURLs,
    this.onTapToAddImages,
    this.onTapToRemoveImage,
  });

  final RxList<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImage;
  @override
  Widget build(BuildContext context) {
    // implement build
    final localizations = AppLocalizations.of(context)!;
    return Obx(
      () => SizedBox(
        height: 300,
        child: Column(
          children: [
            // Section to additiobnal Product images
            Expanded(
              child: GestureDetector(
                onTap: onTapToAddImages,
                child: TRoundedContainer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          TImages.defaultMultiImageIcon,
                          width: 50,
                          height: 50,
                        ),
                        Text(localizations.addAdditionalProductImages),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Section to Display Uplaod Images
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 80,
                      child: _uploadedImagesOrEmptyList(),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems / 2),
                  // Add more Images Button
                  TRoundedContainer(
                    width: 80,
                    height: 80,
                    showBorder: true,
                    borderColor: TColors.grey,
                    backgroundColor: TColors.white,
                    onTap: onTapToAddImages,
                    child: const Center(child: Icon(Iconsax.add)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadedImagesOrEmptyList() {
    return additionalProductImagesURLs.isNotEmpty
        ? _uploaderImages()
        : emptyList();
  }

  // Widget to display uploaded images
  Widget _uploaderImages() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final image = additionalProductImagesURLs[index];
        return TImageUpLoader(
          width: 80,
          height: 80,
          top: 0,
          right: 0,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => onTapToRemoveImage!(index),
        );
      },
      separatorBuilder: (context, index) =>
          const SizedBox(width: TSizes.spaceBtwItems / 2),
      scrollDirection: Axis.horizontal,
      itemCount: additionalProductImagesURLs.length,
    );
  }

  Widget emptyList() {
    return ListView.separated(
      itemBuilder: (context, index) => const TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        width: 80,
        height: 80,
      ),
      separatorBuilder: (context, index) =>
          const SizedBox(width: TSizes.spaceBtwItems / 2),
      scrollDirection: Axis.horizontal,
      itemCount: 6,
    );
  }
}
