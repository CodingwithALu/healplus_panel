import 'package:healplus_panel/common/widgets/layouts/templates/site_layouts.dart';
import 'package:healplus_panel/features/shop/controllers/products/edit_product_controller.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/reponsive_screen/edit_product_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class EditProductsScreen extends StatelessWidget {
  const EditProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    final controller = Get.put(EditProductController());
    final product = Get.arguments;
    controller.initProductData(product);
    return TSizeTemplate(desktop: EditProductDesktop(product: product));
  }
}
