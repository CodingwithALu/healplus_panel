import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/personalization/screen/profiles/widgets/image_and_meta.dart';
import 'package:healplus_panel/features/personalization/screen/profiles/widgets/profile_form.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileTabletsScreen extends StatelessWidget {
  const ProfileTabletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breandcrumbs
              TBreadcrumbWithHeading(
                heading: local.profile,
                breadcrumbItems: [BreadcrumbItem(local.profile)],
              ),
              SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Expanded(child: Chip(label: ImageAndMeta())),
              const SizedBox(height: TSizes.spaceBtwSections),
              // From
              Expanded(flex: 2, child: ProfileForm()),
            ],
          ),
        ),
      ),
    );
  }
}
