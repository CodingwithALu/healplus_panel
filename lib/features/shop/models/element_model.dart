import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class ElementModel {
  String ide;
  String iding;
  String title;
  String url;
  bool isFeatured;
  int? quantity;
  int? percentage;
  DateTime? createAt;
  DateTime? updateAt;
  List<ProductModel>? products;
  ElementModel({
    required this.ide,
    required this.iding,
    required this.title,
    required this.url,
    this.isFeatured = false,
    this.quantity,
    this.createAt,
    this.percentage,
    this.updateAt,
    this.products,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(createAt!, locale: locale);
  String get formattedDate => TFormatter.formatDate(createAt);
  // ignore: non_constant_identifier_names
  String get FormattedUpdate => TFormatter.formatDate(updateAt);
  // Empty
  static ElementModel empty() {
    return ElementModel(ide: '', title: '', url: '', iding: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Image': url,
      'IsFeatures': isFeatured,
      'Ide': ide,
      'CreateAt': createAt,
      'UpdateAt': updateAt,
    };
  }

  // Map Jdon oriented document snapshot for Firebase to CategoryModels
  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      iding: json['iding']?.toString() ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      isFeatured: json['isFeatured'] == 1 || json['isFeatured'] == true,
      ide: json['ide'] ?? '',
      quantity: json['quantity'] ?? 0,
      percentage: json['percentage'] ?? 0,
      createAt: json['createAt'] != null
          ? DateTime.tryParse(json['createAt'])
          : null,
      updateAt: json['updateAt'] != null
          ? DateTime.tryParse(json['updateAt'])
          : null,
      products: json['products'],
    );
  }
}
