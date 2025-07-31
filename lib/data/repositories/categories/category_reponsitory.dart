import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryReponsitory extends GetxController {
  static CategoryReponsitory get instance => Get.find();
  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all categories from the 'Categories' collection
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final result = snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
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

  // Delete an existing category document from the 'Categories' collection
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _db.collection('Categories').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // CreateCategory
  Future<String> createCategory(CategoryModel category) async {
    try {
      final data = await _db.collection('Categories').add(category.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // Update Category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _db
          .collection('Categories')
          .doc(category.id)
          .update(category.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }
}
