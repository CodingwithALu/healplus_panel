import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  // Firebase Auth Instance
  final _auth = FirebaseAuth.instance;

  // Get Authentication User Data
  User? get authUser => _auth.currentUser;

  // Get IsAuthentication User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    // implement onReady
    _auth.setPersistence(Persistence.LOCAL);
    super.onReady();
  }

  /// Function to determine the relevant screen and redirect accordingly
  void screenRedirext() async {
    final user = _auth.currentUser;
    // If the user is login in
    if (user != null) {
      // Navigate to the Home
      Get.offAllNamed(TRoutes.dashboard);
    } else {
      // Navigation to the login
      Get.offAllNamed(TRoutes.login);
    }
  }

  // Login
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Register
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Register User By Admin
  // Email Verification
  // Foget Paswors
  // Re Authentication User
  // Logout user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(TRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
