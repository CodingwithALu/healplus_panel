import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String idc;
  String image;
  String name;
  bool isFeatured;
  int? quantity;
  int? percentage;
  DateTime? createAt;
  DateTime? updateAt;
  List<IngredientModel>? ingredients;
  CategoryModel({
    required this.idc,
    required this.image,
    required this.name,
    this.isFeatured = false,
    this.quantity,
    this.percentage,
    this.createAt,
    this.updateAt,
    this.ingredients,
  });
  // Empty Helper Function
  String get formattedDate => TFormatter.formatDate(createAt);
  // ignore: non_constant_identifier_names
  String get FormattedUpdate => TFormatter.formatDate(updateAt);
  // Empty
  static CategoryModel empty() {
    return CategoryModel(idc: '', name: '', image: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Id': idc,
      'Name': name,
      'Image': image,
      'IsFeatures': isFeatured,
      'ProductCount': quantity = 0,
      'CreateAt': createAt,
      'UpdateAt': updateAt,
      'ingredinet': ingredients,
    };
  }

  // Map Jdon oriented document snapshot for Firebase to CategoryModels
  factory CategoryModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      // Map Json Record to the Model
      return CategoryModel(
        idc: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatures'] ?? false,
        quantity: data['ProductCount'] ?? '',
        createAt: data.containsKey('CreateAt')
            ? data['CreateAt']?.parse()
            : null,
        updateAt: data.containsKey('UpdateAt')
            ? data['UpdateAt']?.parse()
            : null,
      );
    } else {
      return CategoryModel.empty();
    }
  }

  factory CategoryModel.formJson(Map<String, dynamic> document) {
    final data = document;
    // Map Json Record to the Model
    return CategoryModel(
      idc: data['idc'] ?? '',
      name: data['title'] ?? '',
      image: data['imgae'] ?? '',
      isFeatured: data['isFeatures'] ?? false,
      quantity: int.parse((data['quantity'] ?? 0).toString()),
      percentage: int.parse((data['percentage'] ?? 0).toString()),
      createAt: data.containsKey('createAt') && data['createAt'] != null
          ? DateTime.parse(data['createAt'])
          : null,
      updateAt: data.containsKey('updateAt') && data['updateAt'] != null
          ? DateTime.parse(data['updateAt'])
          : null,
      ingredients: (data['ingredients'] as List<dynamic>?)
        ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}
