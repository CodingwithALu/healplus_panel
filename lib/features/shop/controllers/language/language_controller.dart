import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();

  final _storage = GetStorage();
  static const String _languageKey = 'selected_language';

  // Observable current language
  final _currentLanguage = 'vi'.obs;
  String get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load saved language from storage
  void _loadSavedLanguage() {
    final savedLanguage = _storage.read(_languageKey) ?? 'vi';
    _currentLanguage.value = savedLanguage;
    final locale = Locale(savedLanguage);
    Get.updateLocale(locale);
  }

  /// Change language and save to storage
  void changeLanguage(String languageCode) {
    final locale = Locale(languageCode);
    Get.updateLocale(locale);
    _storage.write(_languageKey, languageCode);
    _currentLanguage.value = languageCode;

    // Show confirmation message
    final message = languageCode == 'vi'
        ? 'Đã chuyển sang tiếng Việt'
        : 'Changed to English';

    Get.snackbar(
      languageCode == 'vi' ? 'Ngôn ngữ' : 'Language',
      message,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Get current language code
  String getCurrentLanguage() {
    return _storage.read(_languageKey) ?? 'vi'; // Default to Vietnamese
  }
}
