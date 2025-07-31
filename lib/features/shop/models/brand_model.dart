import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String id;
  String image;
  String name;
  bool isFeatured;
  int? productsCount;
  DateTime? createAt;
  DateTime? updateAt;
  // not mapped
  List<CategoryModel>? brandCategories;
  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured = false,
    this.productsCount,
    this.createAt,
    this.updateAt,
    this.brandCategories,
  });
  // Empty Helper Function
  String get formattedDate => TFormatter.formatDate(createAt);
  // ignore: non_constant_identifier_names
  String get FormattedUpdate => TFormatter.formatDate(updateAt);
  // Empty
  static BrandModel empty() {
    return BrandModel(id: '', name: '', image: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'IsFeatures': isFeatured,
      'ProductCount': productsCount = 0,
      'CreateAt': createAt,
      'UpdateAt': updateAt,
    };
  }

  // Map Jdon oriented document snapshot for Firebase to CategoryModels
  factory BrandModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      // Map Json Record to the Model
      return BrandModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatures'] ?? false,
        productsCount: data['ProductCount'] ?? '',
        createAt: data.containsKey('CreateAt')
            ? data['CreateAt']?.toDate()
            : null,
        updateAt: data.containsKey('UpdateAt')
            ? data['UpdateAt']?.toDate()
            : null,
      );
    } else {
      return BrandModel.empty();
    }
  }

  factory BrandModel.formJson(Map<String, dynamic> document) {
    final data = document;
    // Map Json Record to the Model
    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatures'] ?? false,
      productsCount: int.parse((data['ProductCount'] ?? 0).toString()),
      createAt: data.containsKey('CreateAt')
          ? data['CreateAt']?.toDate()
          : null,
      updateAt: data.containsKey('UpdateAt')
          ? data['UpdateAt']?.toDate()
          : null,
    );
  }
}
