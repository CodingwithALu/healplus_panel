import 'dart:typed_data';

import 'package:healplus_panel/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:healplus_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:healplus_panel/common/widgets/images/t_circular_image.dart';
import 'package:healplus_panel/common/widgets/images/t_rounded_image.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TImageUpLoader extends StatelessWidget {
  const TImageUpLoader({
    super.key,
    this.cricular = false,
    this.image,
    required this.imageType,
    this.width = 100,
    this.height = 100,
    this.memoryImage,
    this.icon = Iconsax.edit,
    this.top,
    this.bottom = 0,
    this.right,
    this.left = 0,
    this.onIconButtonPressed,
    this.loading = false,
  });

  final bool cricular;
  final String? image;
  final ImageType imageType;
  final double width;
  final double height;
  final Uint8List? memoryImage;
  final IconData icon;
  final double? top, bottom, right, left;
  final void Function()? onIconButtonPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    // implement build
    return Stack(
      children: [
        // Display the image in either cricular or rounded shpe
        cricular
            ? TCircularImage(
                image: image,
                width: width,
                height: height,
                memoryIamge: memoryImage,
                backgroundColor: TColors.primaryBackground,
                imageType: imageType,
              )
            : TRoundedImage(
                imageUrl: image,
                width: width,
                height: height,
                imageType: imageType,
                memoryImage: memoryImage,
                backgroundColor: TColors.primaryBackground,
              ),
        // Display the edit icon button on top of the image
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: loading
              ? const TCircularContainer(
                  width: TSizes.xl,
                  height: TSizes.xl,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: TColors.primary,
                    color: Colors.white,
                  ),
                )
              : TCircularIcon(
                  icon: icon,
                  size: TSizes.md,
                  color: Colors.white,
                  onPressed: onIconButtonPressed,
                  backgroundColor: TColors.primary.withAlpha(245),
                ),
        ),
      ],
    );
  }
}
