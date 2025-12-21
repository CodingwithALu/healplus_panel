import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/shop/models/brand_category_model.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // APi Srevice instace
  final ApiService _apiService = ApiService();
  // Get all brands from the 'Brands' collection
  Future<List<CategoryModel>> getAllBrands() async {
    // try {
    //   final snapshot = await _db.collection('Brands').get();
    //   final result = snapshot.docs
    //       .map((doc) => CategoryModel.fromSnapshot(doc))
    //       .toList();
    //   return result;
    // } on FirebaseException catch (e) {
    //   throw TFirebaseException(e.code).message;
    // } on PlatformException catch (e) {
    //   throw TPlatformException(e.code).message;
    // } catch (e) {
    //   throw 'Something went srong. Please try again';
    // }
    try {
      final response = await _apiService.getCategories();
      final resultList = response['result'] as List;
      final result = resultList
          .map((json) => CategoryModel.formJson(json))
          .toList();
      return result;
    } catch (e) {
      throw 'Failed to fetch categories: ${e.toString()}';
    }
  }

  // Get all brandCategories from the 'BrandCategories' collection
  Future<List<BrandCategoryModel>> getAllBrandCategories() async {
    try {
      final snapshot = await _db.collection('BrandCategories').get();
      final result = snapshot.docs
          .map((doc) => BrandCategoryModel.fromSnapshot(doc))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  Future<List<BrandCategoryModel>> getCategoriesOfSpecificBrand(
    String brandId,
  ) async {
    try {
      final snapshot = await _db
          .collection('BrandCategories')
          .where('brandId', isEqualTo: brandId)
          .get();
      final result = snapshot.docs
          .map((doc) => BrandCategoryModel.fromSnapshot(doc))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // CreateBrands
  Future<ApiResponse> createBrands(CategoryModel item) async {
    try {
      //   final data = await _db.collection('Brands').add(item.toJson());
      //   return data.id;
      // } on FirebaseException catch (e) {
      //   throw TFirebaseException(e.code).message;
      // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
      return await _apiService.addCategory(item);
    } catch (e) {
      throw 'Failed to update category: ${e.toString()}';
    }
  }

  // CreateBrandCategories
  Future<String> createBrandCategories(BrandCategoryModel item) async {
    try {
      final data = await _db.collection('BrandCategories').add(item.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // Delete an existing category document from the 'Categories' collection
  Future<ApiResponse> deleteBrands(CategoryModel item) async {
    try {
      return await _apiService.deleteCategory(item.idc);
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  Future<void> deleteBrandCategories(String categoryId) async {
    try {
      await _db.collection('BrandCategories').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // Update Category
  Future<ApiResponse> updateBrands(CategoryModel item) async {
    try {
      return await _apiService.updateCategory(item);
    } catch (e) {
      throw 'Failed to update category: ${e.toString()}';
    }
  }
}
