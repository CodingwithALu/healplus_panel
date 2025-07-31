import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TTabletActionButtons extends StatelessWidget {
  const TTabletActionButtons({
    super.key,
    this.view = false,
    this.edit = true,
    this.delete = true,
    this.onViewPressed,
    this.onEditPressed,
    this.onDeletePressed,
  });
  // view button
  final bool view;
  // edit button
  final bool edit;
  // delete button
  final bool delete;
  // callback function for the view button
  final VoidCallback? onViewPressed;
  // callback function for the edit button
  final VoidCallback? onEditPressed;
  // callback function for the delete button
  final VoidCallback? onDeletePressed;
  @override
  Widget build(BuildContext context) {
    // implement build
    return Row(
      children: [
        if (view)
          IconButton(
            onPressed: onViewPressed,
            icon: const Icon(Iconsax.eye, color: TColors.darkerGrey),
          ),
        if (edit)
          IconButton(
            onPressed: onEditPressed,
            icon: const Icon(Iconsax.pen_add, color: TColors.primary),
          ),
        if (delete)
          IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(Iconsax.trash, color: Colors.red),
          ),
      ],
    );
  }
}
