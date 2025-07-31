import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MediaFolderDropdown extends StatelessWidget {
  const MediaFolderDropdown({super.key, this.onChanged});
  final void Function(MediaCategory?)? onChanged;
  @override
  Widget build(BuildContext context) {
    //implement build
    final controller = MediaController.instance;
    final local = AppLocalizations.of(context)!;
    String getCategoryLabel(MediaCategory category) {
      switch (category) {
        case MediaCategory.folders:
          return local.mediaFolderAll;
        case MediaCategory.products:
          return local.products;
        case MediaCategory.banners:
          return local.banners;
        case MediaCategory.brands:
          return local.brands;
        case MediaCategory.categories:
          return local.categories;
        case MediaCategory.users:
          return local.users;
      }
    }

    return Obx(
      () => SizedBox(
        width: 155,
        child: DropdownButtonFormField(
          isExpanded: false,
          value: controller.selectedPath.value,
          items: MediaCategory.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(getCategoryLabel(category)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
