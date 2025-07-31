import 'package:healplus_panel/features/shop/models/address_model.dart';
import 'package:healplus_panel/features/shop/models/cart_item_model.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(orderDate, locale: locale);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  // Static function to create an empty user
  static OrderModel empty() => OrderModel(
    id: '',
    status: OrderStatus.pending,
    items: [],
    totalAmount: 0.0,
    shippingCost: 0.0,
    taxCost: 0.0,
    orderDate: DateTime.now(),
  );

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress?.toJson(),
      'billingAddress': billingAddress?.toJson(),
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'deliveryDate': formattedDeliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
    };
  }

  // Create a OrderModel from JSON data
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      shippingAddress: json['shippingAddress'] != null
          ? AddressModel.fromJson(json['shippingAddress'])
          : null,
      billingAddress: json['billingAddress'] != null
          ? AddressModel.fromJson(json['billingAddress'])
          : null,
      shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
      taxCost: (json['taxCost'] ?? 0.0).toDouble(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      billingAddressSameAsShipping:
          json['billingAddressSameAsShipping'] ?? true,
    );
  }
  // Factory method to create a OrderModel from a Firebase document snapshot
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      docId: snapshot.id,
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',
      status: data.containsKey('status')
          ? OrderStatus.values.firstWhere((e) => e.toString() == data['status'])
          : OrderStatus.pending,
      // Default status
      totalAmount: data.containsKey('totalAmount')
          ? data['totalAmount'] as double
          : 0.0,
      shippingCost: data.containsKey('shippingCost')
          ? (data['shippingCost'] as num).toDouble()
          : 0.0,
      taxCost: data.containsKey('taxCost')
          ? (data['taxCost'] as num).toDouble()
          : 0.0,
      orderDate: data.containsKey('orderDate')
          ? (data['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      // Default to current time
      paymentMethod: data.containsKey('paymentMethod')
          ? data['paymentMethod'] as String
          : '',
      billingAddressSameAsShipping:
          data.containsKey('billingAddressSameAsShipping')
          ? data['billingAddressSameAsShipping'] as bool
          : true,
      billingAddress: data.containsKey('billingAddress')
          ? AddressModel.fromJson(
              data['billingAddress'] as Map<String, dynamic>,
            )
          : AddressModel.empty(),
      shippingAddress: data.containsKey('shippingAddress')
          ? AddressModel.fromJson(
              data['shippingAddress'] as Map<String, dynamic>,
            )
          : AddressModel.empty(),
      // ignore: unnecessary_null_comparison
      deliveryDate: data.containsKey('deliveryDate') != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,
      items: data.containsKey('items')
          ? (data['items'] as List<dynamic>)
                .map(
                  (item) =>
                      CartItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}
