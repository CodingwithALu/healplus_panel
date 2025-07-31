import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/devices/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TTableHeader extends StatelessWidget {
  const TTableHeader({
    super.key,
    this.onPressed,
    this.buttonText = 'Add',
    this.seatrchController,
    this.searchOnChanged,
    this.showLeftWidget = true,
  });

  final Function()? onPressed;
  final String buttonText;
  final TextEditingController? seatrchController;
  final Function(String)? searchOnChanged;
  final bool showLeftWidget;
  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 3 : 1,
          child: showLeftWidget
              ? Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        child: Text(buttonText),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: seatrchController,
            onChanged: searchOnChanged,
            decoration: InputDecoration(
              hintText: local.header_search_hint,
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
