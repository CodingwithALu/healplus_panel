// ignore: unused_import
import 'package:healplus_panel/data/repositories/categories/ingredient_repository.dart';
import 'package:healplus_panel/features/authentication/controllers/user_controller.dart';
import 'package:healplus_panel/features/shop/controllers/language/language_controller.dart';
import 'package:healplus_panel/features/shop/controllers/order/oder_controller.dart';
import 'package:healplus_panel/features/shop/controllers/settings/setting_controller.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  // ignore: void_checks
  void dependencies() {
    /// Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    // Get.put(IngredientRepository());
  }
}
