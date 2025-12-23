import 'package:healplus_panel/features/shop/models/element_model.dart';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientModel {
  String iding;
  String title;
  String url;
  String idc;
  bool isFeatured;
  int? quantity;
  double? percentage;
  DateTime? createAt;
  DateTime? updateAt;
  List<ElementModel>? elements;
  IngredientModel({
    required this.iding,
    required this.title,
    required this.url,
    this.isFeatured = false,
    this.idc = '',
    this.quantity,
    this.percentage,
    this.createAt,
    this.updateAt,
    this.elements,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(createAt!, locale: locale);
  String get formattedDate => TFormatter.formatDate(createAt);
  // ignore: non_constant_identifier_names
  String get FormattedUpdate => TFormatter.formatDate(updateAt);
  // Empty
  static IngredientModel empty() {
    return IngredientModel(iding: '', title: '', url: '', quantity: 0);
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Image': url,
      'IsFeatures': isFeatured,
      'Idc': idc,
      'CreateAt': createAt,
      'UpdateAt': updateAt,
    };
  }

  // Map Jdon oriented document snapshot for Firebase to CategoryModels
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      iding: json['iding']?.toString() ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      isFeatured: json['isFeatured'] == 1 || json['isFeatured'] == true,
      idc: json['idc'] ?? '',
      quantity: json['quantity'] ?? 0,
      percentage: json['percentage'] ?? 0.0,
      createAt: json.containsKey('createAt') && json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      updateAt: json.containsKey('updateAt') && json['updateAt'] != null
          ? DateTime.parse(json['updateAt'])
          : null,
      elements: (json['elements'] as List<dynamic>?)
        ?.map((e) => ElementModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}
