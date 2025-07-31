import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/screens/media/widgets/media_content.dart';
import 'package:healplus_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    final controller = Get.put(MediaController());
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.marginWeb),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Breadcrumbs
                  TBreadcrumbWithHeading(
                    heading: local.media,
                    breadcrumbItems: [BreadcrumbItem(local.media)],
                  ),
                  // Toggle Images Section Button
                  Flexible(
                    child: SizedBox(
                      width: TSizes.buttonWidth * 1.5,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controller.showImagesUploaderSection.value =
                                !controller.showImagesUploaderSection.value,
                        icon: const Icon(Iconsax.cloud_add),
                        label: Text(local.uploadImages),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Uploads Area
              MediaUploader(),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Media
              MediaContent(
                allowSelection: false,
                allowMoltipleSelection: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
