import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;
  DateTime? createAt;
  DateTime? updateAt;
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.createAt,
    this.updateAt,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(createAt!, locale: locale);
  String get formattedDate => TFormatter.formatDate(createAt);
  // ignore: non_constant_identifier_names
  String get FormattedUpdate => TFormatter.formatDate(updateAt);
  // Empty
  static CategoryModel empty() {
    return CategoryModel(id: '', name: '', image: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Image': image,
      'IsFeatures': isFeatured,
      'ParentId': parentId,
      'CreateAt': createAt,
      'UpdateAt': updateAt,
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
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatures'] ?? false,
        parentId: data['ParentId'] ?? '',
        createAt: data.containsKey('CreateAt')
            ? data['CreateAt']?.toDate()
            : null,
        updateAt: data.containsKey('UpdateAt')
            ? data['UpdateAt']?.toDate()
            : null,
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
