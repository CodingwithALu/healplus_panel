import 'dart:io';
import 'dart:typed_data';

import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../shimmer/shimmer.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
    this.fit = BoxFit.cover,
    this.image,
    this.overlayColor,
    this.backgroundColor,
    this.file,
    this.memoryIamge,
    required this.imageType,
  });
  final double width, height, padding;
  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Uint8List? memoryIamge;
  final Color? overlayColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (dark ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(width >= height ? width : height),
      ),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;
    switch (imageType) {
      case ImageType.network:
        imageWidget = _buildNetworkImage();
        break;
      case ImageType.asset:
        imageWidget = _buildAssetImage();
        break;
      case ImageType.memory:
        imageWidget = _buildMemoryImage();
        break;
      case ImageType.file:
        imageWidget = _buildFileImage();
        break;
    }
    // Apply ClipRRect dorectly to thr image widget
    return ClipRRect(
      borderRadius: BorderRadius.circular(width >= height ? width : height),
      child: imageWidget,
    );
  }

  // Function to build the File image widget
  Widget _buildNetworkImage() {
    if (image != null) {
      return CachedNetworkImage(
        imageUrl: image!,
        fit: fit,
        color: overlayColor,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        progressIndicatorBuilder: (context, url, dowloadProgress) =>
            TShimmerEffect(width: width, height: height),
      );
    } else {
      return Container();
    }
  }

  // Function to build the Memory image widget
  Widget _buildMemoryImage() {
    if (memoryIamge != null) {
      return Image(
        image: MemoryImage(memoryIamge!),
        color: overlayColor,
        fit: fit,
      );
    } else {
      return Container();
    }
  }

  // Function to build the File image widget
  Widget _buildFileImage() {
    if (file != null) {
      return Image(image: FileImage(file!), color: overlayColor, fit: fit);
    } else {
      return Container();
    }
  }

  // Function to build the asset image widget
  Widget _buildAssetImage() {
    if (image != null) {
      return Image(image: AssetImage(image!), color: overlayColor, fit: fit);
    } else {
      return Container();
    }
  }
}
