import 'package:healplus_panel/features/shop/models/brand_category_model.dart';
import 'package:healplus_panel/features/shop/models/brand_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all brands from the 'Brands' collection
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      final result = snapshot.docs
          .map((doc) => BrandModel.fromSnapshot(doc))
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
  Future<String> createBrands(BrandModel item) async {
    try {
      final data = await _db.collection('Brands').add(item.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
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
  Future<void> deleteBrands(BrandModel brands) async {
    try {
      await _db.runTransaction((transition) async {
        final brandRef = _db.collection('Brands').doc(brands.id);
        final brandSnap = await transition.get(brandRef);

        if (!brandSnap.exists) {
          throw Exception('Brand not foud');
        }
        final brandCategoriesSnapshot = await _db
            .collection('BrandCategories')
            .where('brandId', isEqualTo: brands.id)
            .get();
        final brandCategories = brandCategoriesSnapshot.docs.map(
          (e) => BrandCategoryModel.fromSnapshot(e),
        );
        if (brandCategories.isNotEmpty) {
          for (var brandCategory in brandCategories) {
            transition.delete(
              _db.collection('BrandCategories').doc(brandCategory.id),
            );
          }
        }
        transition.delete(brandRef);
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
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
  Future<void> updateBrands(BrandModel item) async {
    try {
      await _db.collection('Brands').doc(item.id).update(item.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }
}
