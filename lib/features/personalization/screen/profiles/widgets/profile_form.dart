import 'package:healplus_panel/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:healplus_panel/features/authentication/controllers/user_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    final controller = UserController.instance;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: TSizes.lg,
            horizontal: TSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.profileDetails,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              // First and Last name
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Fisrt name
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: InputDecoration(
                              hintText: localizations.firstNameHint,
                              label: Text(controller.user.value.firstName),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                              localizations.firstNameHint,
                              value,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: InputDecoration(
                              hintText: localizations.lastNameHint,
                              label: Text(controller.user.value.lastName),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                              localizations.lastNameHint,
                              value,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    // Email and Phone
                    Row(
                      children: [
                        // Fisrt name
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: localizations.emailHint,
                              label: Text(controller.user.value.email),
                              prefixIcon: Icon(Iconsax.forward),
                              enabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: InputDecoration(
                              hintText: localizations.phoneNumberHint,
                              label:
                                  controller.user.value.phoneNumber.isNotEmpty
                                  ? Text(controller.user.value.phoneNumber)
                                  : Text(localizations.phoneNumberHint),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator: (value) =>
                                TValidator.validatePhoneNumber(value),
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
                              : controller.updateUserInformation(),
                          child: controller.loading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(localizations.updateProfile),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
