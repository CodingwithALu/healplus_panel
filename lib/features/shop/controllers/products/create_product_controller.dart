import 'package:healplus_panel/data/repositories/products/produts_repository.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_attribute_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_images_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_inut_name_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_controller.dart';
import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/features/shop/models/element_model.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
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
  final variationsController = Get.put(ProductVariationController());

  // Text editing controlller for input fields
  TextEditingController title = TextEditingController();
  // update
  TextEditingController preparation = TextEditingController();
  TextEditingController specfication = TextEditingController();

  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  // NEW: production date
  final TextEditingController productionDateCtrl = TextEditingController();
  final Rxn<DateTime> productionDateValue = Rxn<DateTime>();

  // NEW: product meta fields
  final TextEditingController trademarkCtrl =
      TextEditingController();
  final TextEditingController expiryCtrl =
      TextEditingController();
  final TextEditingController originCtrl = TextEditingController();
  final TextEditingController manufacturerCtrl =
      TextEditingController();

  // NEW: extra info fields
  final TextEditingController uses = TextEditingController();
  final TextEditingController toUse = TextEditingController();
  final TextEditingController sideEffects = TextEditingController();
  final TextEditingController preserver = TextEditingController();

  // Rx obvervable for selected brand and categories
  final Rx<ElementModel?> selectedBrand = Rx<ElementModel?>(null);
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
      if (selectedBrand.value == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.customToast(message: "Vui lòng chọn danh mục phụ thuộc");
        return;
      }
      final brandIde = selectedBrand.value!.ide;

      // Validation stock anf pricing
      // if (productType.value == ProductType.single &&
      //     !stockPriceFromKey.currentState!.validate()) {
      //   TFullScreenLoader.stopLoading();
      //   return;
      // }
      // if (selectedBrand.value == null) throw 'Select Brand for this product';
      // // Check variation data if ProductType = Variable
      // if (productType.value == ProductType.variable &&
      //     ProductVariationController.instance.productVariations.isEmpty) {
      //   throw 'There are no variations for the Product Type Variable. Create some variations or change Product type.';
      // }

      // if (productType.value == ProductType.variable) {
      //   final variationCheckFailed = ProductVariationController
      //       .instance
      //       .productVariations
      //       .any(
      //         (element) =>
      //             element.price.isNaN ||
      //             element.price < 0 ||
      //             element.salePrice.isNaN ||
      //             element.salePrice < 0 ||
      //             element.stock.isNaN ||
      //             element.stock < 0 ||
      //             element.image.value.isEmpty,
      //       );

      //   if (variationCheckFailed) {
      //     throw 'Variation data is not accurate. Please recheck variations';
      //   }
      // }

      // Upload Product Thumbnail Image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      final thumbnailUrl = imagesController.selectedThubnailImageUrl.value;
      if (thumbnailUrl == null) {
        throw 'Select Product Thumbnail Image';
      }
      additionalImageUploader.value = true;
      if (imagesController.additionalProductImagesUrl.isNotEmpty &&
          imagesController.additionalProductImagesUrl.first == thumbnailUrl) {
      } else {
        imagesController.additionalProductImagesUrl.remove(thumbnailUrl);
        imagesController.additionalProductImagesUrl.insert(0, thumbnailUrl);
      }

      final ingredients =
          ProductIngradientController.instance.productAttributes;
      final ingredientText = ingredients
          .map(
            (e) => (e.title).trim(),
          )
          .where((t) => t.isNotEmpty)
          .join(', ');
      final unitNam = ProductUnitNameController.instance.productUnitName;
      // Map Product Data to ProductModel
      final newRecord = ProductModel(
        // productVariations: variations,
        description: description.text.trim(),
        idp: '',
        name: title.text.trim(),
        trademark: trademarkCtrl.text.trim(),
        rating: 5,
        review: 0,
        sold: 0,
        expiry: expiryCtrl.text.trim(),
        preparation: preparation.text.trim(),
        origin: originCtrl.text.trim(),
        manufacturer: manufacturerCtrl.text.trim(),
        ide: brandIde,
        productionDate: productionDateCtrl.text.trim(),
        specification: specfication.text.trim(),
        ingredient: ingredientText,
        quantity: int.tryParse(stock.text) ?? 0,
        uses: uses.text.trim(),
        toUse: toUse.text.trim(),
        sideEffects: sideEffects.text.trim(),
        preserver: preserver.text.trim(),

        urls: imagesController.additionalProductImagesUrl,
        price: unitNam.first.price.toString(),
        unitNames: unitNam,
        ingredients: ingredients,
      );
      productDataUploader.value = true;
      final result = await ProductRepository.instance.createProducts(newRecord);
      newRecord.idp = result.id!;
      // Register product categories if any
      // if (selectedCategories.isNotEmpty) {
      //   if (newRecord.idp.isEmpty) throw 'Error storing data. Try again';

      //   // Loop through selected Product Categories
      //   categoriesRelationShipUploader.value = true;
      //   for (var category in selectedCategories) {
      //     // Map Data
      //     final productCategory = ProductCategoryModel(
      //       productId: newRecord.idp,
      //       categoryId: category.iding,
      //     );
      //     await ProductRepository.instance.createProductCategory(
      //       productCategory,
      //     );
      //   }
      // }
      // Update Product List
      // productController.addItemToList(newRecord);
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

    // NEW
    productionDateCtrl.clear();
    productionDateValue.value = null;

    trademarkCtrl.clear();
    expiryCtrl.clear();
    originCtrl.clear();
    manufacturerCtrl.clear();

    // NEW: clear extra fields (giữ default thì đổi sang setText tùy bạn)
    uses.clear();
    toUse.clear();
    sideEffects.clear();
    preserver.clear();

    selectedBrand.value = null;
    selectedCategories.clear();
    variationsController.resetAllValues();
    ProductIngradientController.instance.resetProductAttributes();

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

  @override
  void onClose() {
    // NEW: dispose controllers (ít nhất 4 cái mới, tiện dispose luôn cái đang có)
    title.dispose();
    preparation.dispose();
    specfication.dispose();
    stock.dispose();
    price.dispose();
    salePrice.dispose();
    description.dispose();
    brandTextField.dispose();

    productionDateCtrl.dispose();

    trademarkCtrl.dispose();
    expiryCtrl.dispose();
    originCtrl.dispose();
    manufacturerCtrl.dispose();

    uses.dispose();
    toUse.dispose();
    sideEffects.dispose();
    preserver.dispose();
    super.onClose();
  }
}
