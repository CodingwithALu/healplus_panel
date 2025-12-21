import 'package:healplus_panel/data/repositories/brands/brand_repository.dart';
import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/models/brand_category_model.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBrandsController extends GetxController {
  static EditBrandsController get instance => Get.find();
  final loading = false.obs;
  RxString imageUrl = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _barndRepository = BrandRepository.instance;
  final List<String> selectedIngredient = <String>[].obs;
  final controller = CategoryController.instance;
  final ingredientController = IngredientController.instance;
  // Init Data
  void init(CategoryModel brands) {
    // implement onInit
    name.text = brands.name;
    isFeatured.value = brands.isFeatured;
    imageUrl.value = brands.image;
    if (brands.ingredients != null) {
      selectedIngredient.addAll
      (brands.ingredients!.map((e) => e.iding).whereType<String>());
    }
  }

  // Toggle Category Selection
  // void toggleSelection(IngredientModel category) {
  //   if (selectedIngredient.contains(category.iding)) {
  //     selectedIngredient.remove(category.iding);
  //   } else {
  //     selectedIngredient.add(category.iding);
  //   }
  // }

  // Update Category
  Future<void> updateBrands(CategoryModel category) async {
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
      ApiResponse result = ApiResponse.empty();
      // bool isBrandUpdate = false;
      if (category.image != imageUrl.value ||
          category.name != name.text.trim() ||
          category.isFeatured != isFeatured.value) {
        // isBrandUpdate = true;
        // Map data
        category.image = imageUrl.value;
        category.name = name.text.trim();
        category.isFeatured = isFeatured.value;
        // Call repository to updateCategory
        result = await _barndRepository.updateBrands(category);
      }
      // Update BrandCategories
      // if (selectedIngredient.isNotEmpty) await updateBrandCategories(category);
      // Update Brand in Products
      // if (isBrandUpdate) await updateBrandInProducts(brands);
      // Update All data list
      controller.updateItemFormList(category);
      // Update Ui Listeners
      update();
      // Remove Loader
      TFullScreenLoader.stopLoading();
      Get.back();
      // Success
      TLoaders.successSnackBar(
        title: result.success ? 'Cập nhật thành công' : 'Thất bại!',
        message: result.message,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
    loading(false);
    isFeatured(false);
    name.clear();
    imageUrl.value = '';
    selectedIngredient.clear();
  }

  Future<void> updateBrandCategories(CategoryModel item) async {
    // Fetch all BrandCategories
    final brandCategories = await _barndRepository.getCategoriesOfSpecificBrand(
      item.idc,
    );
    // SelectedCategoriIds
    selectedIngredient.map((e) => e);
    // Identify new categories to add
    final newCategoriesToAdd = selectedIngredient
        .where(
          (newCategory) => !brandCategories.any(
            (existingCategory) =>
                existingCategory.categoryId == newCategory,
          ),
        )
        .toList();
    // Add new categories
    for (var newCategory in newCategoriesToAdd) {
      var brandCategory = BrandCategoryModel(
        brandId: item.idc,
        categoryId: newCategory,
      );
      brandCategory.id = await _barndRepository.createBrandCategories(
        brandCategory,
      );
    }
    // item.ingredients!.assignAll(selectedIngredient);
    controller.updateItemFormList(item);
  }

  Future<void> updateBrandInProducts(CategoryModel brands) async {
    return;
  }
}
