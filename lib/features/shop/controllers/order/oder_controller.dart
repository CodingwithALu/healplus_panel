// ignore_for_file: use_build_context_synchronously

import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/orders/order_repository.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends TBaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var orderStatus = OrderStatus.delivered.obs;
  final _orderRepository = Get.put(OrderRepository());

  @override
  Future<List<OrderModel>> fetchItems() async {
    sortAscending.value = false;
    return await _orderRepository.getAllOrders();
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    await _orderRepository.deleteOrder(item.docId);
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (OrderModel o) => o.totalAmount.toString().toLowerCase(),
    );
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (OrderModel o) => o.orderDate.toString().toLowerCase(),
    );
  }

  /// Update Product Status
  Future<void> updateOrderStatus(
    OrderModel order,
    OrderStatus newStatus,
    BuildContext context,
  ) async {
    try {
      final local = AppLocalizations.of(context)!;
      statusLoader.value = true;
      order.status = newStatus;
      await _orderRepository.updateOrderSpecificValue(order.docId, {
        'status': newStatus.toString(),
      });
      updateItemFormList(order);
      orderStatus.value = newStatus;
      TLoaders.successSnackBar(
        title: local.updated,
        message: local.orderStatusUpdated,
      );
    } catch (e) {
      TLoaders.warningSnackBar(
        title: AppLocalizations.of(context)!.ohSnap,
        message: e.toString(),
      );
    } finally {
      statusLoader.value = false;
    }
  }
}
