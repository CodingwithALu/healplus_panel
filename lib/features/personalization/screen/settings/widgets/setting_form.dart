import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/shop/controllers/settings/setting_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({super.key});

  @override
  Widget build(BuildContext context) {
    //  implement build
    final controller = SettingsController.instance;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: TSizes.lg,
            horizontal: TSizes.md,
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.appSettings,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                // App Name
                TextFormField(
                  controller: controller.appNameController,
                  decoration: InputDecoration(
                    hintText: localizations.appNameHint,
                    label: Text(localizations.appNameHint),
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                // First and Last name
                Form(
                  child: Column(
                    children: [
                      // Email and Phone
                      Row(
                        children: [
                          // Fisrt name
                          Expanded(
                            child: TextFormField(
                              controller: controller.taxController,
                              decoration: InputDecoration(
                                hintText: localizations.taxPercentHint,
                                label: Text(localizations.taxRateLabel),
                                prefixIcon: Icon(Iconsax.tag),
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          // Fisrt name
                          Expanded(
                            child: TextFormField(
                              controller: controller.shippingController,
                              decoration: InputDecoration(
                                hintText: localizations.shippingCostHint,
                                label: Text(localizations.shippingCostLabel),
                                prefixIcon: Icon(Iconsax.ship),
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          Expanded(
                            child: TextFormField(
                              controller:
                                  controller.freeShippingThresholdController,
                              decoration: InputDecoration(
                                hintText: localizations.freeShippingAfter,
                                label: Text(localizations.freeShippingAfter),
                                prefixIcon: Icon(Iconsax.ship),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.loading.value
                                ? () {}
                                : controller.updateSettingInformations(),
                            child: controller.loading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(localizations.updateAppSetting),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
