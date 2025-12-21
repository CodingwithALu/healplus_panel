import 'package:healplus_panel/features/shop/models/product_attribute_model.dart';
import 'package:healplus_panel/features/shop/models/product_variation_model.dart';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:healplus_panel/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrices;
  String thumbnail;
  bool? isFeatured;
  CategoryModel? brand;
  String? description;
  List<String>? images;
  String productType;
  int soldQuantity;
  List<ProductAttributeModel>? productAttribute;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrices = 0.0,
    this.isFeatured,
    this.description,
    this.productAttribute,
    this.productVariations,
  });
  String formattedOrderDate([String? locale]) =>
      THelperFunctions.getFormattedDate(date!, locale: locale);
  String get formattedDate => TFormatter.formatDate(date);

  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(
    id: '',
    title: '',
    stock: 0,
    price: 0,
    thumbnail: '',
    productType: '',
  );

  /// Json Format
  toJson() {
    return {
      'Title': title,
      'SKU': sku,
      'Stock': stock,
      'Price': price,
      'Image': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrices,
      'IsFeatured': isFeatured,
      'Brand': brand!.toJson(),
      'Description': description,
      'ProductType': productType,
      'SoldQuantity': soldQuantity,
      'ProductAttributes': productAttribute != null
          ? productAttribute!.map((item) => item.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((item) => item.toJson()).toList()
          : [],
      'Data': date,
    };
  }

  // Map Jon oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return ProductModel(
        id: document.id,
        sku: data['SKU'] ?? '',
        title: data['Title'] ?? '',
        stock: data['Stock'] ?? 0,
        price: double.parse((data['Price'] ?? 0.0).toString()),
        salePrices: double.parse((data['SalePrice'] ?? 0.0).toString()),
        thumbnail: data['Thumbnail'] ?? '',
        description: data['Description'] ?? '',
        productType: data['ProductType'] ?? '',
        brand: CategoryModel.formJson(data['Brand']),
        images: data['Image'] != null ? List<String>.from(data['Image']) : [],
        productAttribute: (data['ProductAttributes'] as List<dynamic>)
            .map((e) => ProductAttributeModel.fromJson(e))
            .toList(),
        productVariations: (data['ProductVariations'] as List<dynamic>)
            .map((e) => ProductVariationModel.fromJson(e))
            .toList(),
        soldQuantity: data.containsKey('SoldQuantity')
            ? data['SoldQuantity'] ?? 0
            : 0,
        isFeatured: data['IsFeatured'] ?? false,
        date: data['Date'] ?? DateTime.now(),
      );
    } else {
      return ProductModel.empty();
    }
  }
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel.empty();
    // return ProductModel(
    //   id: json['ide']?.toString() ?? '',
    //   sku: json['sku'] ?? '',
    //   title: json['title'] ?? '',
    //   stock: json['url'] ?? '',
    //   isFeatured: json['isFeatured'] == 1 || json['isFeatured'] == true,
    //   price: json['iding'] ?? '',
    //   salePrices: json['quantity'] ?? 0,
    //   thumbnail: json['percentage'] ?? 0,
    //   createAt: json.containsKey('createAt') && json['createAt'] != null
    //       ? DateTime.parse(json['createAt'])
    //       : null,
    //   updateAt: json.containsKey('updateAt') && json['updateAt'] != null
    //       ? DateTime.parse(json['updateAt'])
    //       : null,
    //   products: (json['products'] as List<dynamic>?)
    //     ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
    //     .toList(),
    // );
  }
}
