import 'package:healplus_panel/features/shop/controllers/products/products_variation_controller.dart';
import 'package:healplus_panel/features/shop/models/unit_name_model.dart';
import 'package:healplus_panel/utils/popups/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductUnitNameController extends GetxController {
  static ProductUnitNameController get instance => Get.find();
  // Controller and key
  final isLoading = false.obs;
  final attributesFormKeys = GlobalKey<FormState>();
  TextEditingController inagredientNames = TextEditingController();
  TextEditingController body = TextEditingController();
  final RxList<UnitNameModel> productUnitName =
      <UnitNameModel>[].obs;
  // Function to add new attributes
  void addNewUnitName() {
    // From Validation
    if (!attributesFormKeys.currentState!.validate()) {
      return;
    }
    // Add Attribute into the List of Attributes
    productUnitName.add(
      UnitNameModel(
        name: inagredientNames.text.trim(),
        price: body.text.trim(),
      ),
    );
    //Clear text fields after adding
    inagredientNames.text = '';
    body.text = '';
  }

  // Function remove an attribute
  void removeUnitName(int index, BuildContext context) {
    // Show a confirmation dialog
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop();
        productUnitName.removeAt(index);
        //Reset
        ProductVariationController.instance.productVariations.value = [];
      },
    );
  }

  // Function reset Attributes
  void resetProductUnitName() {
    productUnitName.clear();
  }
}
