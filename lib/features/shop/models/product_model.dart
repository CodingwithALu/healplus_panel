import 'package:healplus_panel/features/shop/models/product_ingre_model.dart';
import 'package:healplus_panel/features/shop/models/review_item_model.dart';
import 'package:healplus_panel/features/shop/models/unit_name_model.dart';

class ProductModel {
  String idp;
  String name;
  String trademark;
  double rating;
  int review;
  int sold;
  String expiry;
  String price;
  String preparation;
  String origin;
  String manufacturer;
  String description;
  String ide;
  String productionDate;
  String specification;
  String ingredient;
  int quantity;
  String uses;
  String toUse;
  String sideEffects;
  String preserver;
  List<String>? urls;
  List<UnitNameModel>? unitNames;
  String? elements;
  List<ProductIngreModel>? ingredients;
  List<ReviewItemModel>? reviewItems;

  ProductModel({
    required this.idp,
    required this.name,
    required this.trademark,
    required this.rating,
    required this.review,
    required this.sold,
    required this.expiry,
    required this.price,
    required this.preparation,
    required this.origin,
    required this.manufacturer,
    required this.description,
    required this.ide,
    required this.productionDate,
    required this.specification,
    required this.ingredient,
    required this.quantity,
    required this.uses,
    required this.toUse,
    required this.sideEffects,
    required this.preserver,
    this.urls,
    this.unitNames,
    this.elements,
    this.ingredients,
    this.reviewItems,
  });
  // String formattedOrderDate([String? locale]) =>
  //     THelperFunctions.getFormattedDate(productionDate, locale: locale);
  // String get formattedDate => TFormatter.formatDate(productionDate);

  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(
    idp: '',
    name: '',
    trademark: '',
    rating: 0.0,
    review: 0,
    sold: 0,
    expiry: '',
    price: '',
    preparation: '',
    origin: '',
    manufacturer: '',
    description: '',
    ide: '',
    productionDate: '',
    specification: '',
    ingredient: '',
    quantity: 0,
    uses: '',
    toUse: '',
    sideEffects: '',
    preserver: '',
    urls: [],
    unitNames: [],
    elements: '',
    ingredients: [],
    reviewItems: [],
  );

  /// Json Format
  Map<String, dynamic> toJson() {
    return {
      'idp': idp,
      'name': name,
      'trademark': trademark,
      'rating': rating,
      'review': review,
      'sold': sold,
      'expiry': expiry,
      'price': price,
      'preparation': preparation,
      'origin': origin,
      'manufacturer': manufacturer,
      'description': description,
      'ide': ide,
      'productionDate': productionDate,
      'specification': specification,
      'ingredient': ingredient,
      'quantity': quantity,
      'uses': uses,
      'toUse': toUse,
      'sideEffects': sideEffects,
      'preserver': preserver,
      'urls': urls,
      'unitNames': unitNames?.map((e) => e.toJson()).toList(),
      'elements': elements,
      'ingredients': ingredients?.map((e) => e.toJson()).toList(),
      'reviewItems': reviewItems?.map((e) => e.toJson()).toList(),
    };
  }

  // Map JSON to Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idp: json['idp'].toString(),
      name: json['name'] ?? '',
      trademark: json['trademark'] ?? '',
      rating: json['rating'] ?? 0.0,
      review: json['review'] ?? 0,
      sold: json['sold'] ?? 0,
      expiry: json['expiry'] ?? '',
      price: json['price'] ?? '',
      preparation: json['preparation'] ?? '',
      origin: json['origin'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      description: json['description'] ?? '',
      ide: json['ide'] ?? '',
      productionDate: json['productionDate'] ?? '',
      specification: json['specification'] ?? '',
      ingredient: json['ingredient'] ?? '',
      quantity: json['quantity'] ?? 0,
      uses: json['uses'] ?? '',
      toUse: json['toUse'] ?? '',
      sideEffects: json['sideEffects'] ?? '',
      preserver: json['preserver'] ?? '',
      urls: (json['urls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      unitNames: (json['unitNames'] as List<dynamic>? ?? [])
          .map((e) => UnitNameModel.formJson(e as Map<String, dynamic>))
          .toList(),
      elements: json['elements'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => ProductIngreModel.formJson(e as Map<String, dynamic>))
          .toList(),
      reviewItems: (json['reviewItems'] as List<dynamic>? ?? [])
          .map((e) => ReviewItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
