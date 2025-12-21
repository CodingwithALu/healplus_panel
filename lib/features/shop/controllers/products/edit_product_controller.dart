import 'package:healplus_panel/data/repositories/products/produts_repository.dart';
import 'package:healplus_panel/features/shop/controllers/ingredient/category_controller.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();
  // Observable for loading state and product details
  final isLoading = false.obs;
  final selectedCategoriesLoader = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  // Controller and key
  final stockPriceFromKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFromKey = GlobalKey<FormState>();
  final imagesController = Get.put(ProductImagesController());
  final attributesController = Get.put(ProductAttributeController());
  final variationsController = Get.put(ProductVariationController());

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
  final List<IngredientModel> alreadyAddedCategories = <IngredientModel>[];
  // Flag for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImageUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationShipUploader = false.obs;
  // Function create Product
  Future<void> initProductData(ProductModel product) async {
    try {
      isLoading.value = true; // Set loading state while initializing data

      // Basic Information
      title.text = product.title;
      description.text = product.description ?? '';
      productType.value = product.productType == ProductType.single.toString()
          ? ProductType.single
          : ProductType.variable;

      // Stock & Pricing (assuming productType and productVisibility are handled elsewhere)
      if (product.productType == ProductType.single.toString()) {
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrices.toString();
      }
      // Product Brand
      selectedBrand.value = product.brand;
      brandTextField.text = product.brand?.name ?? '';

      // Product Thumbnail and Images
      if (product.images != null) {
        // Set the first image as the thumbnail
        imagesController.selectedThubnailImageUrl.value = product.thumbnail;
        imagesController.additionalProductImagesUrl.assignAll(
          product.images ?? [],
        );

        // Product Attributes & Variations
        attributesController.productAttributes.assignAll(
          product.productAttribute ?? [],
        );
        variationsController.productVariations.assignAll(
          product.productVariations ?? [],
        );
        variationsController.initializeVariationController(
          product.productVariations ?? [],
        );

        isLoading.value = false;

        update();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<List<IngredientModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;
    // Product Categories
    final productCategories = await productRepository.fetchProductCategories(
      productId,
    );
    final categoriesController = Get.put(IngredientController());
    if (categoriesController.allItems.isEmpty) {
      await categoriesController.fetchItems();
    }

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories = categoriesController.allItems
        .where((element) => categoriesIds.contains(element.iding))
        .toList();
    selectedCategories.assignAll(categories);
    alreadyAddedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;
    return categories;
  }

  Future<void> updateProduct(ProductModel product) async {
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
      product.sku = '';
      product.isFeatured = true;
      product.title = title.text.trim();
      product.brand = selectedBrand.value;
      product.description = description.text.trim();
      product.productType = productType.value.toString();
      product.stock = int.tryParse(stock.text.trim()) ?? 0;
      product.price = double.tryParse(price.text.trim()) ?? 0;
      product.images = imagesController.additionalProductImagesUrl;
      product.salePrices = double.tryParse(salePrice.text.trim()) ?? 0;
      product.thumbnail = imagesController.selectedThubnailImageUrl.value ?? '';
      product.productAttribute =
          ProductAttributeController.instance.productAttributes;
      product.productVariations = variations;
      // Call Repository to Create New Product
      productDataUploader.value = true;
      await ProductRepository.instance.updateProducts(product);

      // Register product categories if any
      if (selectedCategories.isNotEmpty) {
        // Loop through selected Product Categories
        categoriesRelationShipUploader.value = true;
        // Get the exiting category Ids
        List<String> existingCategoryId = alreadyAddedCategories
            .map((item) => item.iding)
            .toList();
        for (var category in selectedCategories) {
          // Map Data
          if (!existingCategoryId.contains(category.iding)) {
            final productCategory = ProductCategoryModel(
              productId: product.id,
              categoryId: category.iding,
            );
            await ProductRepository.instance.createProductCategory(
              productCategory,
            );
          }
        }
        // Remove categories not selected by the user
        for (var existingCategoryId in existingCategoryId) {
          // Check if the category is not present in the selected categories
          if (!selectedCategories.any(
            (category) => category.iding == existingCategoryId,
          )) {
            // Remove the association
            await ProductRepository.instance.removeProductcategory(
              product.id,
              existingCategoryId,
            );
          }
        }
      }
      // Update Product List
      ProductController.instace.updateItemFormList(product);
      // Close the Progares Loader
      TFullScreenLoader.stopLoading();
      // Show Success Message Loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
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
