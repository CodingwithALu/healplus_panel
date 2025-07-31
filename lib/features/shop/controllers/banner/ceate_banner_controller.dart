import 'package:healplus_panel/data/repositories/banners/banner_repository.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:healplus_panel/features/shop/models/banner_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();
  RxString imageUrl = ''.obs;
  final isLoading = false.obs;
  final isActive = false.obs;
  final targetSceen = TRoutes.sidebarMenuItems[0].obs;
  final formKey = GlobalKey<FormState>();

  final _bannerRepository = BannerRepository.instance;
  final bannerController = BannerController.instance;

  // Register new Category
  Future<void> createBanners() async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCirular();
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

      // Map data
      final newRecord = BannerModel(
        id: '',
        image: imageUrl.value,
        targetScreen: targetSceen.value,
        active: isActive.value,
      );

      newRecord.id = await _bannerRepository.createBanners(newRecord);

      // Update all Data List
      bannerController.addItemToList(newRecord);
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Back
      Get.back();
      // Success
      final local = AppLocalizations.of(Get.context!)!;
      TLoaders.successSnackBar(
        title: local.congratulations,
        message: local.newRecordAdded,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.ohSnap,
        message: e.toString(),
      );
    }
  }

  // pick Image
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();
    // Handle the selected image
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main image or perform any pther action
      ImageModel selectedImage = selectedImages.first;
      // Update the main image using the selectedImage
      imageUrl.value = selectedImage.url;
    }
  }
}
