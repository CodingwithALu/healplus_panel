import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:healplus_panel/features/shop/controllers/order/oder_controller.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class DashboardController extends TBaseController<OrderModel> {
  static DashboardController get instance => Get.find();
  final RxList<double> weeklySales = <double>[].obs;
  /* Tao json lay so luong va tong tien don hang theo trang thai: co khoa va trang thai don hang
  Bien bat dong bo, khong bat buoc cap nhat ui khi bien thay doi */
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;
  final orderController = OrderController.instance;
  final customerContrller = Get.put(CustomerController());
  // Order
  @override
  Future<List<OrderModel>> fetchItems() async {
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }
    if (customerContrller.allItems.isEmpty) {
      await customerContrller.fetchItems();
    }

    _calulateWeeklySales();

    _calulateOrderStatusData();
    return orderController.allItems;
  }

  @override
  void onInit() {
    // Bat cu khi nao phien ban nay dc tao, ham se tu dong chay
    _calulateWeeklySales();
    _calulateOrderStatusData();
    super.onInit();
  }

  // Tinh doanh so theo ngay trong tuan hien tai
  void _calulateWeeklySales() {
    // Reset weeklySales to zeros
    weeklySales.value = List<double>.filled(7, 0.0);
    for (var order in orderController.allItems) {
      final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(
        DateTime.parse(order.orderDate),
      );
      // Check if the order is within the current week
      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (DateTime.parse(order.orderDate).weekday - 1) % 7;
        // Ensure the index is non-negative
        index = index < 0 ? index + 7 : index;
        weeklySales[index] += order.sumMoney;
      }
    }
  }

  // Tinh so luong va tong tien theo trang thai
  void _calulateOrderStatusData() {
    // Reset satus data ( Xoa cac phan tu trong bản don)
    orderStatusData.clear();
    /* Map to store total amounts for each status (Them danh sach trong cho cac so tien) 
    => ban do se luu so tien cho tung trang thai. Khoi tao la 0.0 */
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};
    for (var order in orderController.allItems) {
      // Tong tien theo trang thai
      final status = order.status;
      // Cap nhat so luong don hang bang khoa trang thai
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;
      // Tinh  toan tong so tien theo trang thai don hang
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.sumMoney;
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delicered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return false;
  }

  @override
  Future<void> deleteItem(OrderModel item) async {}
}
