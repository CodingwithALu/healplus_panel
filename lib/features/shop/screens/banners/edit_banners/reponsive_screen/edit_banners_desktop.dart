import 'package:healplus_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:healplus_panel/features/shop/models/banner_model.dart';
import 'package:healplus_panel/features/shop/screens/banners/edit_banners/widgets/edit_banners_form.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/breadcrumb_item.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class EditBannersDesktopScreen extends StatelessWidget {
  const EditBannersDesktopScreen({super.key, required this.banner});
  final BannerModel banner;
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
              // Header crumbe
              TBreadcrumbWithHeading(
                returnToPreviousScreen: true,
                heading: local.bannerEditHeading,
                breadcrumbItems: [
                  BreadcrumbItem(
                    local.bannersStoragePath,
                    route: TRoutes.banners,
                  ),
                  BreadcrumbItem(local.bannerEditHeading),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Form
              EditBannersForm(banner: banner),
            ],
          ),
        ),
      ),
    );
  }
}
