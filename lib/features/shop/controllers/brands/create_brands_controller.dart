import 'package:healplus_panel/data/repositories/category/category_repository.dart';
import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/controllers/brands/brand_controller.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateBrandsController extends GetxController {
  static CreateBrandsController get instace => Get.find();
  final loading = false.obs;
  RxString imageUrl = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _brandReponsitory = CategoryRepository.instance;
  final categoryController = CategoryController.instance;
  // ignore: unused_field
  final _ingredientController = IngredientController.instance;
  // List categories
  final List<String> selectedCategories = <String>[].obs;

  // Toggle Category selection
  // void toglSelection(IngredientModel ingredient) {
  //   if (selectedCategories.contains(ingredient.iding)) {
  //     selectedCategories.remove(ingredient.iding);
  //   } else {
  //     selectedCategories.add(ingredient.iding);
  //   }
  // }

  // create new Brands
  Future<void> createBrands() async {
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
      final newRecord = CategoryModel(
        idc: '',
        quantity: 0,
        image: imageUrl.value,
        name: name.text.trim(),
        createAt: DateTime.now(),
        isFeatured: isFeatured.value,
      );
      ApiResponse result = await _brandReponsitory.createBrands(newRecord);
      // Call Reponsitory to Create New Brand
      newRecord.idc = result.id!;
      // Register brand categoried if any
      // if (selectedCategories.isNotEmpty) {
      //   if (newRecord.idc.isEmpty) {
      //     throw 'Error storing relationd data. Tru again';
      //   }
      //   for (var category in selectedCategories) {
      //     // Map data
      //     final brandCategory = BrandCategoryModel(
      //       brandId: newRecord.idc,
      //       categoryId: category.idc,
      //     );
      //     await _brandReponsitory.createBrandCategories(brandCategory);
      //   }
      //   newRecord.ingredients ??= [];
      //   newRecord.ingredients!.addAll(selectedCategories);
      // }
      // Update all Data list
      categoryController.addItemToList(newRecord);
      resetFields();
      // Stop loader
      TFullScreenLoader.stopLoading();
      // Back
      Get.back();
      // Success
      TLoaders.successSnackBar(
        title: result.success ? 'Thành công' : "Thất bại!",
        message: result.message,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Pick Images
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
}
