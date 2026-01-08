import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image(image: AssetImage(TImages.hmoobLogos), width: 130, height: 55),
          // const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            local.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            local.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
