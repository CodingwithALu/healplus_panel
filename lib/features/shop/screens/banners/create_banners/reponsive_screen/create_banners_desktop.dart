import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/screens/banners/create_banners/widgets/create_banners_form.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CreateBannersDesktopScreen extends StatelessWidget {
  const CreateBannersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breand crumder
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.bannerCreateHeading,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.bannersStoragePath,
                    route: TRoutes.banners,
                  ),
                  BreadcrumbItem(local.bannerCreateHeading),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Form
              CreateBannersForm(),
            ],
          ),
        ),
      ),
    );
  }
}
