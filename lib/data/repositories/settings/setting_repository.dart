import 'package:healplus_panel/features/shop/models/setting_model.dart';
import 'package:healplus_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Repository class for setting related operations.
class SettingsRepository extends GetxController {
  static SettingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save setting data to Firestore.
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .set(setting.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch setting data from Firestore.
  Future<SettingsModel> fetchSettings() async {
    try {
      final querySnapshot = await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .get();

      if (querySnapshot.exists) {
        return SettingsModel.fromSnapshot(querySnapshot);
      } else {
        // Return default settings if no settings found
        return SettingsModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update specific setting fields.
  Future<void> updateSettingDetials(SettingsModel updates) async {
    try {
      await _db
          .collection("Settings")
          .doc('GLOBAL_SETTINGS')
          .update(updates.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> updates) async {
    try {
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').update(updates);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to delete settings document.
  Future<void> deleteSettings() async {
    try {
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
