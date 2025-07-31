import 'package:healplus_panel/data/repositories/categories/category_reponsitory.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();
  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageUrl = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _categoryReponsitory = CategoryReponsitory.instance;
  final categoryController = CategoryController.instance;
  // Init Data
  void init(CategoryModel category) {
    // implement onInit
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    imageUrl.value = category.image;
    if (category.parentId.isNotEmpty) {
      selectedParent.value = categoryController.allItems
          .where((c) => c.id == category.parentId)
          .single;
    }
  }

  // Pick Thumbnail Image from Media

  // Update Category
  Future<void> updateCategory(CategoryModel category) async {
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
      category.image = imageUrl.value;
      category.name = name.text.trim();
      category.updateAt = DateTime.now();
      category.isFeatured = isFeatured.value;
      category.parentId = selectedParent.value.id;

      // Call repository to updateCategory
      await _categoryReponsitory.updateCategory(category);
      // Update All Data List
      categoryController.updateItemFormList(category);
      resetFields();
      // Remove Loader
      TFullScreenLoader.stopLoading();
      Get.back();
      // Success
      TLoaders.successSnackBar(
        title: AppLocalizations.of(Get.context!)!.congratulations,
        message: AppLocalizations.of(Get.context!)!.recordUpdatedSuccessfully,
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

  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);
    isFeatured(false);
    name.clear();
    imageUrl.value = '';
  }
}
