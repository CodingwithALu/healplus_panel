// Chuyển đổi chuỗi status tiếng Việt sang enum OrderStatus

import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final int id;
  final String docId;
  final String idauth;
  final String email;
  final String name;
  final int quantity;
  final String? note;
  final String? pay;
  OrderStatus status = OrderStatus.pending;
  final double sumMoney;
  final double? shippingCost;
  final double? taxCost;
  final String orderDate;
  final String address;
  final DateTime? deliveryDate;
  final List<ProductModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.idauth = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.sumMoney,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    required this.email,
    required this.quantity,
    required this.name,
    this.address = 'Cash on Delivery',
    this.note,
    this.pay,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(DateTime.tryParse(orderDate) ?? DateTime.now(), locale: locale);

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
    id: 0,
    status: OrderStatus.pending,
    items: [],
    sumMoney: 0.0,
    shippingCost: 0.0,
    taxCost: 0.0,
    orderDate: "",
    email: "",
    quantity: 0,
    name: ""
  );

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': idauth,
      'status': status.toString(),
      'totalAmount': sumMoney,
      'orderDate': orderDate,
      'paymentMethod': address,
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
      id: json['id'] ?? 0,
      docId: json['docId'] ?? '',
      idauth: json['idauth'] ?? '',
      status: _parseOrderStatus(json['status']),
      sumMoney: (json['sumMoney'] ?? 0.0).toDouble(),
      orderDate: (json['datetime'] ?? ""),
      address: json['address'] ?? 'Cash on Delivery',
      email: (json['email'] ?? ""),
      name: (json['name'] ?? ""),
      note: (json['note'] ?? ""),
      pay: (json['pay'] ?? ""),
      quantity: (json['quantity'] ?? 0).toInt(),
      shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
      taxCost: (json['taxCost'] ?? 0.0).toDouble(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => ProductModel.fromJson(item))
              .toList() ??
          [],
      billingAddressSameAsShipping:
          json['billingAddressSameAsShipping'] ?? true,
    );
  }
  // Factory method to create a OrderModel from a Firebase document snapshot
  // factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   final data = snapshot.data() as Map<String, dynamic>;
  //   return OrderModel(
  //     docId: snapshot.id,
  //     id: data.containsKey('id') ? data['id'] as String : '',
  //     idauth: data.containsKey('userId') ? data['userId'] as String : '',
  //     status: data.containsKey('status')
  //         ? OrderStatus.values.firstWhere((e) => e.toString() == data['status'])
  //         : OrderStatus.pending,
  //     // Default status
  //     sumMoney: data.containsKey('totalAmount')
  //         ? data['totalAmount'] as double
  //         : 0.0,
  //     shippingCost: data.containsKey('shippingCost')
  //         ? (data['shippingCost'] as num).toDouble()
  //         : 0.0,
  //     taxCost: data.containsKey('taxCost')
  //         ? (data['taxCost'] as num).toDouble()
  //         : 0.0,
  //     orderDate: data.containsKey('orderDate')
  //         ? (data['orderDate']).toString()
  //         : "",
  //     // Default to current time
  //     address: data.containsKey('paymentMethod')
  //         ? data['paymentMethod'] as String
  //         : '',
  //     billingAddressSameAsShipping:
  //         data.containsKey('billingAddressSameAsShipping')
  //         ? data['billingAddressSameAsShipping'] as bool
  //         : true,
  //     // billingAddress: data.containsKey('billingAddress')
  //     //     ? AddressModel.fromJson(
  //     //         data['billingAddress'] as Map<String, dynamic>,
  //     //       )
  //     //     : AddressModel.empty(),
  //     // shippingAddress: data.containsKey('shippingAddress')
  //     //     ? AddressModel.fromJson(
  //     //         data['shippingAddress'] as Map<String, dynamic>,
  //     //       )
  //     //     : AddressModel.empty(),
  //     // ignore: unnecessary_null_comparison
  //     deliveryDate: data.containsKey('deliveryDate') != null
  //         ? (data['deliveryDate'] as Timestamp).toDate()
  //         : null,
  //     items: data.containsKey('items')
  //         ? (data['items'] as List<dynamic>)
  //               .map(
  //                 (item) => ProductModel.fromJson(item as Map<String, dynamic>),
  //               )
  //               .toList()
  //         : [],
  //   );
  // }
  static OrderStatus _parseOrderStatus(dynamic status) {
    if (status == null) return OrderStatus.pending;
    final statusStr = status.toString().trim();
    switch (statusStr) {
      case 'Đang chờ xử lý':
        return OrderStatus.pending;
      case 'Đang xử lý':
        return OrderStatus.processing;
      case 'Đang vận chuyển':
        return OrderStatus.shipped;
      case 'Đã giao hàng':
        return OrderStatus.delivered;
      case 'Đã hủy':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
