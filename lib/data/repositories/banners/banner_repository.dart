import 'dart:io';

import 'package:healplus_panel/features/shop/models/banner_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  // fetch all banners
  Future<List<BannerModel>> fetchAllBanners() async {
    try {
      final snapshot = await _db.collection('Banners').get();
      final result = snapshot.docs
          .map((item) => BannerModel.formSnapshot(item))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong! Please try agian';
    }
  }

  // delete banners
  Future<void> deleteBanners(String bannerId) async {
    try {
      await _db.collection('Banners').doc(bannerId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong! Please try agian';
    }
  }

  // create a banners
  Future<String> createBanners(BannerModel banner) async {
    try {
      final snapshot = await _db.collection('Banners').add(banner.toJson());
      return snapshot.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong! Please try agian';
    }
  }

  // update a banners
  Future<void> updateBanners(BannerModel banners) async {
    try {
      final snapshot = await _db
          .collection('Banners')
          .doc(banners.id)
          .update(banners.toJson());
      return snapshot;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong! Please try agian';
    }
  }
}
