import 'package:healplus_panel/data/repositories/brands/brand_repository.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/models/brand_category_model.dart';
import 'package:healplus_panel/features/shop/models/brand_model.dart';
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
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  final brandCotorller = BrandController.instance;
  final categoryController = CategoryController.instance;
  // Init Data
  void init(BrandModel brands) {
    // implement onInit
    name.text = brands.name;
    isFeatured.value = brands.isFeatured;
    imageUrl.value = brands.image;
    if (brands.brandCategories != null) {
      selectedCategories.addAll(brands.brandCategories ?? []);
    }
  }

  // Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  // Update Category
  Future<void> updateBrands(BrandModel brands) async {
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

      bool isBrandUpdate = false;
      if (brands.image != imageUrl.value ||
          brands.name != name.text.trim() ||
          brands.isFeatured != isFeatured.value) {
        isBrandUpdate = true;
        // Map data
        brands.image = imageUrl.value;
        brands.name = name.text.trim();
        brands.updateAt = DateTime.now();
        brands.isFeatured = isFeatured.value;
        // Call repository to updateCategory
        await _barndRepository.updateBrands(brands);
      }
      // Update BrandCategories
      if (selectedCategories.isNotEmpty) await updateBrandCategories(brands);
      // Update Brand in Products
      if (isBrandUpdate) await updateBrandInProducts(brands);
      // Update All data list
      brandCotorller.updateItemFormList(brands);
      // Update Ui Listeners
      update();
      // Remove Loader
      TFullScreenLoader.stopLoading();
      Get.back();
      // Success
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'New Record has been added',
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
    selectedCategories.clear();
  }

  Future<void> updateBrandCategories(BrandModel item) async {
    // Fetch all BrandCategories
    final brandCategories = await _barndRepository.getCategoriesOfSpecificBrand(
      item.id,
    );
    // SelectedCategoriIds
    selectedCategories.map((e) => e.id);
    // Identify new categories to add
    final newCategoriesToAdd = selectedCategories
        .where(
          (newCategory) => !brandCategories.any(
            (existingCategory) => existingCategory.categoryId == newCategory.id,
          ),
        )
        .toList();
    // Add new categories
    for (var newCategory in newCategoriesToAdd) {
      var brandCategory = BrandCategoryModel(
        brandId: item.id,
        categoryId: newCategory.id,
      );
      brandCategory.id = await _barndRepository.createBrandCategories(
        brandCategory,
      );
    }
    item.brandCategories!.assignAll(selectedCategories);
    brandCotorller.updateItemFormList(item);
  }

  Future<void> updateBrandInProducts(BrandModel brands) async {
    return;
  }
}
