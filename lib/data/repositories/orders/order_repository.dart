import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/shop/models/order_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();
  final ApiService _apiService = ApiService();
  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ----------------------------- FUNCTIONS ----------------------------- */

  // Get all orders related to the current user
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final result = await _apiService.getOrders();
      print('API getOrders result:');
      print(result);
      final orders = result
          .map((documentSnapshot) => OrderModel.fromJson(documentSnapshot))
          .toList();
      print('Parsed OrderModel list:');
      print(orders);
      return orders;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      print('FormatException: ${e.toString()}');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e, stack) {
      print('Unknown error: ${e.toString()}');
      print('StackTrace: $stack');
      throw 'Something went wrong. Please try again. Error: ${e.toString()}';
    }
  }

  // Store a new user order
  Future<void> addOrder(OrderModel order) async {
    try {
      await _db.collection('Orders').add(order.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update a specific value of an order instance
  Future<ApiResponse> updateOrderSpecificValue(int orderId, String data) async {
    try {
      final result = _apiService.updateOrderStatus(orderId, data);
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      return await _apiService.deleteOrder(orderId);
      // await _db.collection('Orders').doc(orderId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _db.collection('Orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.empty();
      }
      return null;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
