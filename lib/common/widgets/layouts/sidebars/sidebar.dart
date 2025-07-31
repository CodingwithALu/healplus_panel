import 'package:healplus_panel/common/widgets/images/t_circular_image.dart';
import 'package:healplus_panel/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:healplus_panel/features/shop/controllers/settings/setting_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../route/route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSizebar extends StatelessWidget {
  const TSizebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    final local = AppLocalizations.of(context)!;
    return Drawer(
      shape: BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Obx(
                    () => TCircularImage(
                      imageType: controller.settings.value.appLogo.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                      image: controller.settings.value.appLogo.isNotEmpty
                          ? controller.settings.value.appLogo
                          : TImages.darkAppLogo,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.settings.value.appName,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      local.menu,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    // menu Items
                    TMenuTem(
                      route: TRoutes.dashboard,
                      icon: Iconsax.status,
                      itemName: local.dashboard,
                    ),
                    TMenuTem(
                      route: TRoutes.media,
                      icon: Iconsax.image,
                      itemName: local.media,
                    ),
                    TMenuTem(
                      route: TRoutes.categories,
                      icon: Iconsax.category,
                      itemName: local.categories,
                    ),
                    TMenuTem(
                      route: TRoutes.products,
                      icon: Iconsax.shopping_bag,
                      itemName: local.products,
                    ),
                    TMenuTem(
                      route: TRoutes.customers,
                      icon: Iconsax.profile_2user,
                      itemName: local.customers,
                    ),
                    TMenuTem(
                      route: TRoutes.banners,
                      icon: Iconsax.picture_frame,
                      itemName: local.banners,
                    ),
                    TMenuTem(
                      route: TRoutes.orders,
                      icon: Iconsax.box,
                      itemName: local.orders,
                    ),
                    TMenuTem(
                      route: TRoutes.brands,
                      icon: Iconsax.dcube,
                      itemName: local.brands,
                    ),
                    // Other Menu Items
                    Text(
                      local.other,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    TMenuTem(
                      route: TRoutes.profile,
                      icon: Iconsax.user,
                      itemName: local.profile,
                    ),
                    TMenuTem(
                      route: TRoutes.settings,
                      icon: Iconsax.setting_2,
                      itemName: local.settings,
                    ),
                    TMenuTem(
                      route: TRoutes.language,
                      icon: Iconsax.global,
                      itemName: local.language,
                    ),
                    TMenuTem(
                      route: TRoutes.logout,
                      icon: Iconsax.logout,
                      itemName: local.logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
