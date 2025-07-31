import 'package:healplus_panel/utils/devices/device_utility.dart';
import '../../../../../route/route.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  final activeItem = TRoutes.dashboard.obs;
  final hoverItem = ''.obs;
  void changeActiveItem(String route) => activeItem.value = route;
  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  @override
  void onInit() {
    // implement onInit
    activeItem.value = Get.currentRoute;
    super.onInit();
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (!isActive(route)) {
      changeActiveItem(route);
      if (TDeviceUtils.isMobileScreen(Get.context!)) Get.back();
      Get.toNamed(route);
    }
  }
}
