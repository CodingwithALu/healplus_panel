import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/features/shop/models/product_attribute_model.dart';
import 'package:healplus_panel/utils/popups/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductAttributeController extends GetxController {
  static ProductAttributeController get instance => Get.find();
  // Controller and key
  final isLoading = false.obs;
  final attributesFormKeys = GlobalKey<FormState>();
  TextEditingController attributeNames = TextEditingController();
  TextEditingController attributes = TextEditingController();
  final RxList<ProductAttributeModel> productAttributes =
      <ProductAttributeModel>[].obs;
  // Function to add new attributes
  void addNewAttributes() {
    // From Validation
    if (!attributesFormKeys.currentState!.validate()) {
      return;
    }
    // Add Attribute into the List of Attributes
    productAttributes.add(
      ProductAttributeModel(
        name: attributeNames.text.trim(),
        value: attributes.text.trim().split('|').toList(),
      ),
    );
    //Clear text fields after adding
    attributeNames.text = '';
    attributes.text = '';
  }

  // Function remove an attribute
  void removeAttributes(int index, BuildContext context) {
    // Show a confirmation dialog
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop();
        productAttributes.removeAt(index);
        //Reset
        ProductVariationController.instance.productVariations.value = [];
      },
    );
  }

  // Function reset Attributes
  void resetProductAttributes() {
    productAttributes.clear();
  }
}
