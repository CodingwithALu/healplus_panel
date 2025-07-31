import 'package:healplus_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';

class LogoutController extends GetxController {
  static LogoutController get instance => Get.find();

  Future<void> logout() async {
    await AuthenticationRepository.instance.logout();
  }
}
