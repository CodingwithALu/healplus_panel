import 'package:healplus_panel/data/repositories/categories/ingredient_repository.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditIngredientController extends GetxController {
  static EditIngredientController get instance => Get.find();
  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageUrl = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _categoryIngredint = IngredientRepository.instance;
  final List<String> selectedElement = <String>[].obs;
  final controller = Get.put(IngredientController());
  final categoryController = Get.put(CategoryController());
  // Init Data
  void init(IngredientModel item) {
    // implement onInit
    name.text = item.title;
    isFeatured.value = item.isFeatured;
    imageUrl.value = item.url;
    if (item.idc.isNotEmpty) {
      selectedParent.value = categoryController.allItems
          .where((c) => c.idc == item.idc)
          .single;
    }
    // selecElement
    if (item.elements != null) {
      selectedElement.addAll(
        item.elements!.map((e) => e.ide).whereType<String>(),
      );
    }
  }

  // Pick Thumbnail Image from Media

  // Update Category
  Future<void> updateIngredient(IngredientModel item) async {
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
      item.url = imageUrl.value;
      item.title = name.text.trim();
      item.isFeatured = isFeatured.value;
      item.idc = selectedParent.value.idc;

      // Call repository to updateCategory
      await _categoryIngredint.updateIngredient(item);
      // Update All Data List
      controller.updateItemFormList(item);
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
