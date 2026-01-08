import 'package:flutter/foundation.dart';
import 'package:healplus_panel/features/shop/controllers/products/product_attribute_controller.dart';
import 'package:healplus_panel/features/shop/models/product_variation_model.dart';
import 'package:healplus_panel/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductVariationController extends GetxController {
  static ProductVariationController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in productVariations and sync controllers
    ever(productVariations, (_) => _ensureControllersSync());
  }

  // Obsevable for loading
  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations =
      <ProductVariationModel>[].obs;
  // List to store
  List<Map<ProductVariationModel, TextEditingController>> stockControllerList =
      [];
  List<Map<ProductVariationModel, TextEditingController>> priceControllerList =
      [];
  List<Map<ProductVariationModel, TextEditingController>>
  salePriceControllerList = [];
  List<Map<ProductVariationModel, TextEditingController>>
  descriprionControllerList = [];

  // instance AttributeController
  final attributeController = Get.put(ProductIngradientController());

  // Method to ensure controllers are in sync with variations
  void _ensureControllersSync() {
    // Clear existing controllers
    stockControllerList.clear();
    priceControllerList.clear();
    salePriceControllerList.clear();
    descriprionControllerList.clear();

    // Create controllers for each variation
    for (var variation in productVariations) {
      // Stock Controllers
      Map<ProductVariationModel, TextEditingController> stockControllers = {};
      stockControllers[variation] = TextEditingController(
        text: variation.stock.toString(),
      );
      stockControllerList.add(stockControllers);

      // Price Controllers
      Map<ProductVariationModel, TextEditingController> priceControllers = {};
      priceControllers[variation] = TextEditingController(
        text: variation.price.toString(),
      );
      priceControllerList.add(priceControllers);

      // Sale Price Controllers
      Map<ProductVariationModel, TextEditingController> salePriceControllers =
          {};
      salePriceControllers[variation] = TextEditingController(
        text: variation.salePrice.toString(),
      );
      salePriceControllerList.add(salePriceControllers);

      // Description Controllers
      Map<ProductVariationModel, TextEditingController> descriptionControllers =
          {};
      descriptionControllers[variation] = TextEditingController(
        text: variation.description ?? '',
      );
      descriprionControllerList.add(descriptionControllers);
    }
  }

  void initializeVariationController(List<ProductVariationModel> variations) {
    /// Clear existing list
    stockControllerList.clear();
    priceControllerList.clear();
    salePriceControllerList.clear();
    descriprionControllerList.clear();

    // Assign variations first
    productVariations.assignAll(variations);

    // Ensure controllers are in sync
    _ensureControllersSync();
  }

  // Function remove variations
  void removeVariations(BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      title: 'Remove Variations',
      onConfirm: () {
        productVariations.value = [];
        resetAllValues();
        Navigator.of(context).pop();
      },
    );
  }

  // Function to generate
  void generateVariationsConfirmation(BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      confirmText: 'Generate',
      title: 'Generate Variations',
      content:
          'Once the variations are created, you cannot add more attributes. '
          'In order to add more variations, you have to delete any of the attributes.',
      onConfirm: () {
        generateVariationsFromAttributes();
      },
    );
  }

  // Function to generate variations from attributes
  void generateVariationsFromAttributes() {
    // Close the previous Popup
    Get.back();

    final List<ProductVariationModel> variations = [];

    // Check if there are attributes
    // if (attributeController.productAttributes.isNotEmpty) {
    //   // Get all combinations of attribute values, e.g., [Green, Blue], [Small, Large]
    //   final List<List<String>> attributeCombinations = getCombinations(
    //     attributeController.productAttributes
    //         .map((attr) => attr.value ?? <String>[])
    //         .toList(),
    //   );

    //   // Generate ProductVariationModel for each combination
    //   for (final combination in attributeCombinations) {
    //     final Map<String, String> attributeValues = Map.fromIterables(
    //       attributeController.productAttributes.map((attr) => attr.title),
    //       combination,
    //     );

    //     // You can set default values for other properties if needed
    //     final ProductVariationModel variation = ProductVariationModel(
    //       id: UniqueKey().toString(),
    //       attributeValue: attributeValues,
    //     );

    //     variations.add(variation);
    //   }
    // }

    // Assign variations and sync controllers
    productVariations.assignAll(variations);
    _ensureControllersSync();
  }

  void resetAllValues() {
    stockControllerList.clear();
    priceControllerList.clear();
    salePriceControllerList.clear();
    descriprionControllerList.clear();
    productVariations.clear();
  }

  // Method to safely get controller at index
  TextEditingController? getStockController(
    int index,
    ProductVariationModel variation,
  ) {
    if (index >= 0 && index < stockControllerList.length) {
      return stockControllerList[index][variation];
    }
    // If index is out of range, sync controllers and try again
    _ensureControllersSync();
    if (index >= 0 && index < stockControllerList.length) {
      return stockControllerList[index][variation];
    }
    return null;
  }

  TextEditingController? getPriceController(
    int index,
    ProductVariationModel variation,
  ) {
    if (index >= 0 && index < priceControllerList.length) {
      return priceControllerList[index][variation];
    }
    // If index is out of range, sync controllers and try again
    _ensureControllersSync();
    if (index >= 0 && index < priceControllerList.length) {
      return priceControllerList[index][variation];
    }
    return null;
  }

  TextEditingController? getSalePriceController(
    int index,
    ProductVariationModel variation,
  ) {
    if (index >= 0 && index < salePriceControllerList.length) {
      return salePriceControllerList[index][variation];
    }
    // If index is out of range, sync controllers and try again
    _ensureControllersSync();
    if (index >= 0 && index < salePriceControllerList.length) {
      return salePriceControllerList[index][variation];
    }
    return null;
  }

  TextEditingController? getDescriptionController(
    int index,
    ProductVariationModel variation,
  ) {
    if (index >= 0 && index < descriprionControllerList.length) {
      return descriprionControllerList[index][variation];
    }
    // If index is out of range, sync controllers and try again
    _ensureControllersSync();
    if (index >= 0 && index < descriprionControllerList.length) {
      return descriprionControllerList[index][variation];
    }
    return null;
  }

  // Debug method to check sync status
  void debugControllerStatus() {
    print('ProductVariations count: ${productVariations.length}');
    print('StockControllerList count: ${stockControllerList.length}');
    print('PriceControllerList count: ${priceControllerList.length}');
    print('SalePriceControllerList count: ${salePriceControllerList.length}');
    print(
      'DescriptionControllerList count: ${descriprionControllerList.length}',
    );

    if (productVariations.length != stockControllerList.length) {
      if (kDebugMode) {
        print('WARNING: Controller lists are out of sync with variations!');
      }
      _ensureControllersSync();
    }
  }

  List<List<String>> getCombinations(List<List<String>> list) {
    final List<List<String>> result = [];
    // Start combing
    combine(list, 0, <String>[], result);

    return result;
  }

  void combine(
    List<List<String>> lists,
    int index,
    List<String> current,
    List<List<String>> result,
  ) {
    // If we have reached the end of the lists, add the current combination to the result
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    // Iterate over the values of the current attribute
    for (final item in lists[index]) {
      // Create an updated list with the current value added
      final List<String> updated = List.from(current)..add(item);

      // Recursively combine with the next attribute
      combine(lists, index + 1, updated, result);
    }
  }
}
