import 'package:healplus_panel/data/repositories/settings/setting_repository.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/models/setting_model.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<SettingsModel> settings = SettingsModel().obs;

  final formKey = GlobalKey<FormState>();
  final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingThresholdController = TextEditingController();

  // Dependencies
  final settingRepository = Get.put(SettingsRepository());

  @override
  void onInit() {
    // Fetch setting details on controller initialization
    fetchSettingDetails();
    super.onInit();
  }

  /// Fetches setting details from the repository
  Future<SettingsModel> fetchSettingDetails() async {
    try {
      loading.value = true;

      // Fetch settings from repository
      final settingsData = await settingRepository.fetchSettings();

      // Update observable settings
      settings.value = settingsData;

      // Update form controllers with fetched data
      appNameController.text = settingsData.appName;
      taxController.text = settingsData.taxRate.toString();
      shippingController.text = settingsData.shippingCost.toString();
      freeShippingThresholdController.text =
          settingsData.freeShippingThreshold == null
          ? ''
          : settingsData.freeShippingThreshold.toString();
      loading.value = false;
      return settingsData;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Something went wrong.',
        message: e.toString(),
      );
      return SettingsModel();
    } finally {
      loading.value = false;
    }
  }

  void updateAppLogo() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller
          .selectImagesFromMedia();

      // Handle the selected images
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // Set the selected image to the main image or perform any other action
        ImageModel selectedImage = selectedImages.first;

        // Update Profile in Firestore
        await settingRepository.updateSingleField({
          'appLogo': selectedImage.url,
        });

        // Update the main image using the selectedImage
        settings.value.appLogo = selectedImage.url;
        settings.refresh();

        TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'App Logo has been updated.',
        );
      }
      loading.value = false;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  void updateSettingInformations() async {
    try {
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      settings.value.appName = appNameController.text.trim();
      settings.value.taxRate =
          double.tryParse(taxController.text.trim()) ?? 0.0;
      settings.value.shippingCost =
          double.tryParse(shippingController.text.trim()) ?? 0.0;
      settings.value.freeShippingThreshold =
          double.tryParse(freeShippingThresholdController.text.trim()) ?? 0.0;

      await settingRepository.updateSettingDetials(settings.value);
      settings.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'App Settings has been updated.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}
