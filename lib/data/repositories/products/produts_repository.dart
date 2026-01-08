import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/shop/models/product_category_model.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  // create product
  Future<ApiResponse> createProducts(ProductModel produts) async {
    try {
      final result = await _apiService.createProduct(produts);
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  // create productCategory
  Future<String> createProductCategory(ProductCategoryModel produts) async {
    try {
      final result = await _db
          .collection('ProductCategories')
          .add(produts.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  // fetch Products
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _apiService.getAllProduct();
      print('API getAllProduct response:');
      print(response);
      final resultList = response['result'] as List;
      final result = resultList
          .map((json) => ProductModel.fromJson(json))
          .toList();
      print('Parsed ProductModel list:');
      print(result);
      return result;
    } catch (e, stack) {
      print('Error in fetchProducts: $e');
      print('StackTrace: $stack');
      throw 'something went wrong. Please try again. Error: $e';
    }
  }

  // fetch ProductCategories
  Future<List<ProductCategoryModel>> fetchProductCategories(
    String productId,
  ) async {
    try {
      final snapshot = await _db
          .collection('ProductCategories')
          .where('ProductId', isEqualTo: productId)
          .get();
      final result = snapshot.docs
          .map((item) => ProductCategoryModel.fromSnapshot(item))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  // update product
  Future<void> updateProducts(ProductModel item) async {
    // try {
    //   await _db.collection('Products').doc(item.id).update(item.toJson());
    // } on FirebaseException catch (e) {
    //   throw TFirebaseException(e.code).message;
    // } on FormatException catch (e) {
    //   throw TFormatException(e.message);
    // } on PlatformException catch (e) {
    //   throw TPlatformException(e.code).message;
    // } catch (e) {
    //   throw 'something went wrong. Please try again';
    // }
  }

  // dalete product
  Future<void> deleteProducts(String products) async {
    try {
      return _apiService.deleteProduct(products);
      // await _db.runTransaction((transition) async {
      //   final brandRef = _db.collection('Products').doc(products.id);
      //   final brandSnap = await transition.get(brandRef);

      //   if (!brandSnap.exists) {
      //     throw Exception('Brand not foud');
      //   }
      //   final brandCategoriesSnapshot = await _db
      //       .collection('ProductCategories')
      //       .where('ProductId', isEqualTo: products.id)
      //       .get();
      //   final brandCategories = brandCategoriesSnapshot.docs.map(
      //     (e) => ProductCategoryModel.fromSnapshot(e),
      //   );
      //   if (brandCategories.isNotEmpty) {
      //     for (var brandCategory in brandCategories) {
      //       transition.delete(
      //         _db.collection('ProductCategories').doc(brandCategory.id),
      //       );
      //     }
      //   }
      //   transition.delete(brandRef);
      // });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  // Remove Products Category
  Future<void> removeProductcategory(
    String productId,
    String categoryId,
  ) async {
    try {
      final result = await _db
          .collection('ProductCategories')
          .where('ProductId', isEqualTo: productId)
          .where('categoryId', isEqualTo: categoryId)
          .get();
      for (final doc in result.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }
}
