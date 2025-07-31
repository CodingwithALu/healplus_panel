import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  String? id;
  final String productId;
  final String categoryId;

  ProductCategoryModel({
    this.id,
    required this.productId,
    required this.categoryId,
  });
  Map<String, dynamic> toJson() {
    return {'ProductId': productId, 'categoryId': categoryId};
  }

  // fetch data
  factory ProductCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductCategoryModel(
      id: snapshot.id,
      productId: data['ProductId'],
      categoryId: data['categoryId'],
    );
  }
}
