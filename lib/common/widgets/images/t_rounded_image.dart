import 'dart:io';
import 'dart:typed_data';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../shimmer/shimmer.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.imageUrl,
    this.applyImageRadius = true,
    this.margin,
    this.backgroundColor = TColors.light,
    this.fit = BoxFit.contain,
    this.padding,
    this.borderRadius = TSizes.md,
    this.file,
    this.memoryImage,
    this.overlayColor,
    required this.imageType,
    this.border,
  });

  final double? width, height, padding;
  final String? imageUrl;
  final bool applyImageRadius;
  final double? margin;
  final Color? backgroundColor;
  final BoxFit? fit;
  final File? file;
  final Uint8List? memoryImage;
  final Color? overlayColor;
  final ImageType imageType;
  final double borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin != null ? EdgeInsets.all(margin!) : null,
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
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
      borderRadius: applyImageRadius
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.zero,
      child: imageWidget,
    );
  }

  // Function to build the File image widget
  Widget _buildNetworkImage() {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: fit,
        color: overlayColor,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        progressIndicatorBuilder: (context, url, dowloadProgress) =>
            TShimmerEffect(width: width!, height: height!),
      );
    } else {
      return Container();
    }
  }

  // Function to build the Memory image widget
  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      return Image(
        image: MemoryImage(memoryImage!),
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
    if (imageUrl != null) {
      return Image(image: AssetImage(imageUrl!), color: overlayColor, fit: fit);
    } else {
      return Container();
    }
  }
}
