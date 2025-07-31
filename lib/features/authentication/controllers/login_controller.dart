import 'package:healplus_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:healplus_panel/data/repositories/settings/setting_repository.dart';
import 'package:healplus_panel/features/shop/models/setting_model.dart';
import 'package:healplus_panel/features/shop/models/user_model.dart';
import 'package:healplus_panel/data/repositories/users/user_repository.dart';
import 'package:healplus_panel/features/authentication/controllers/user_controller.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/helpers/network_manager.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // implement onInit
    super.onInit();
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
  }

  /// handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Get current context for localization
      final context = Get.context!;
      final localizations = AppLocalizations.of(context)!;

      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        localizations.loginLoadingMessage,
        TImages.docerAnimation,
      );
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: localizations.networkError,
          message: localizations.networkErrorMessage,
        );
        return;
      }
      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: localizations.formValidationError,
          message: localizations.formValidationErrorMessage,
        );
        return;
      }
      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      // Login user with Email and password
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      // Fetch user details and assign tu UserController
      final user = await UserController.instance.fetchUserDetails();

      // Remove Loader
      TFullScreenLoader.stopLoading();
      // If user is not admin, logout and return
      if (user.role != AppRole.admin) {
        await AuthenticationRepository.instance.logout();
        TLoaders.errorSnackBar(
          title: localizations.notAuthorized,
          message: localizations.notAuthorizedMessage,
        );
      } else {
        // Show success message
        TLoaders.successSnackBar(
          title: localizations.loginSuccess,
          message: localizations.loginSuccessMessage,
        );
        //Redirect
        AuthenticationRepository.instance.screenRedirext();
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      final localizations = AppLocalizations.of(Get.context!)!;
      TLoaders.errorSnackBar(
        title: localizations.ohSnap,
        message: e.toString(),
      );
    }
  }

  /// Handles registraion of admin user
  Future<void> registerAdmin() async {
    try {
      // Get current context for localization
      final context = Get.context!;
      final localizations = AppLocalizations.of(context)!;

      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        localizations.registerLoadingMessage,
        TImages.docerAnimation,
      );
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: localizations.networkError,
          message: localizations.networkErrorMessage,
        );
        return;
      }
      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: localizations.formValidationError,
          message: localizations.formValidationErrorMessage,
        );
        return;
      }
      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      // Register user with Email and password
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      // Create admin record in the Firebase
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: 'CWL',
          lastName: 'Admin',
          email: email.text.trim(),
          role: AppRole.admin,
          createdAt: DateTime.now(),
        ),
      );
      // Create setting revord in the Firebase
      final settingRepository = Get.put(SettingsRepository());
      await settingRepository.registerSettings(
        SettingsModel(
          appLogo: '',
          appName: 'My App',
          taxRate: 0,
          shippingCost: 0,
        ),
      );
      // Remove Loader
      TFullScreenLoader.stopLoading();
      // Show success message
      TLoaders.successSnackBar(
        title: localizations.adminAccountCreated,
        message: localizations.adminAccountCreatedMessage,
      );
      // Redirect
      AuthenticationRepository.instance.screenRedirext();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      final localizations = AppLocalizations.of(Get.context!)!;
      TLoaders.errorSnackBar(
        title: localizations.ohSnap,
        message: e.toString(),
      );
    }
  }
}
