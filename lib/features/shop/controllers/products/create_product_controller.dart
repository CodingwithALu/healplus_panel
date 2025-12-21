import 'package:healplus_panel/data/repositories/products/produts_repository.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_attribute_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_images_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/features/shop/models/product_category_model.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();
  // Observable for loading state and product details
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  // Controller and key
  final stockPriceFromKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFromKey = GlobalKey<FormState>();
  final productController = Get.put(ProductController());

  // Text editing controlller for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();
  // Rx obvervable for selected brand and categories
  final Rx<CategoryModel?> selectedBrand = Rx<CategoryModel?>(null);
  final RxList<IngredientModel> selectedCategories = <IngredientModel>[].obs;
  // Flag for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImageUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationShipUploader = false.obs;
  // Function create Product
  Future<void> createProduct() async {
    try {
      // show progress dialog
      showProgressDialog();
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!titleDescriptionFromKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Validation stock anf pricing
      if (productType.value == ProductType.single &&
          !stockPriceFromKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (selectedBrand.value == null) throw 'Select Brand for this product';
      // Check variation data if ProductType = Variable
      if (productType.value == ProductType.variable &&
          ProductVariationController.instance.productVariations.isEmpty) {
        throw 'There are no variations for the Product Type Variable. Create some variations or change Product type.';
      }

      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController
            .instance
            .productVariations
            .any(
              (element) =>
                  element.price.isNaN ||
                  element.price < 0 ||
                  element.salePrice.isNaN ||
                  element.salePrice < 0 ||
                  element.stock.isNaN ||
                  element.stock < 0 ||
                  element.image.value.isEmpty,
            );

        if (variationCheckFailed) {
          throw 'Variation data is not accurate. Please recheck variations';
        }
      }

      // Upload Product Thumbnail Image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThubnailImageUrl.value == null) {
        throw 'Select Product Thumbnail Image';
      }

      // Additional Product Images
      additionalImageUploader.value = true;
      // Product Variation Images
      final variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        // If admin added variations and then changed the Product Type, remove all variations
        ProductVariationController.instance.resetAllValues();
        variations.value = [];
      }

      // Map Product Data to ProductModel
      final newRecord = ProductModel(
        id: '',
        sku: '',
        isFeatured: true,
        title: title.text.trim(),
        brand: selectedBrand.value,
        productVariations: variations,
        description: description.text.trim(),
        productType: productType.value.toString(),
        stock: int.tryParse(stock.text.trim()) ?? 0,
        price: double.tryParse(price.text.trim()) ?? 0,
        images: imagesController.additionalProductImagesUrl,
        salePrices: double.tryParse(salePrice.text.trim()) ?? 0,
        thumbnail: imagesController.selectedThubnailImageUrl.value ?? '',
        productAttribute: ProductAttributeController.instance.productAttributes,
        date: DateTime.now(),
      );
      // Call Repository to Create New Product
      productDataUploader.value = true;
      newRecord.id = await ProductRepository.instance.createProducts(newRecord);

      // Register product categories if any
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error storing data. Try again';

        // Loop through selected Product Categories
        categoriesRelationShipUploader.value = true;
        for (var category in selectedCategories) {
          // Map Data
          final productCategory = ProductCategoryModel(
            productId: newRecord.id,
            categoryId: category.iding,
          );
          await ProductRepository.instance.createProductCategory(
            productCategory,
          );
        }
      }
      // Update Product List
      productController.addItemToList(newRecord);
      // Close the Progares Loader
      TFullScreenLoader.stopLoading();
      // Show Success Message Loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Reset form values and flags
  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    productVisibility.value = ProductVisibility.hidden;
    stockPriceFromKey.currentState?.reset();
    titleDescriptionFromKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategories.clear();
    ProductVariationController.instance.resetAllValues();
    ProductAttributeController.instance.resetProductAttributes();

    // Reset Upload Flags
    thumbnailUploader.value = false;
    additionalImageUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationShipUploader.value = false;
  }

  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Creating Product'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  TImages.creatingProductIllustration,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                buildCheckbox('Thumbnail Image', thumbnailUploader),
                buildCheckbox('Additional Images', additionalImageUploader),
                buildCheckbox(
                  'Product Data, Attributes & Variations',
                  productDataUploader,
                ),
                buildCheckbox(
                  'Product Categories',
                  categoriesRelationShipUploader,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text('Sit Tight, Your product is uploading...'),
              ],
            ), // Column
          ), // Obx
        ), // AlertDialog
      ), // PopScope
    );
  }

  void showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Congratulations'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              resetValues();
            },
            child: const Text('Go to Products'),
          ), // TextButton
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(TImages.productsIllustration, height: 200, width: 200),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'Congratulations',
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            const Text('Your Product has been Created'),
          ],
        ),
      ),
    );
  }

  buildCheckbox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value.value
              ? const Icon(
                  CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.blue,
                )
              : const Icon(CupertinoIcons.checkmark_alt_circle),
        ), // AnimatedSwitcher
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(label),
      ],
    ); //
  }
}
