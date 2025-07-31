import 'package:healplus_panel/features/shop/controllers/language/language_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguaneDesktop extends StatelessWidget {
  const LanguaneDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languageController = Get.put(LanguageController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.selectLanguage,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.chooseYourLanguage,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => ListTile(
                      leading: const Icon(Icons.language, color: Colors.red),
                      title: Text(localizations.vietnameseLanguage),
                      trailing: languageController.currentLanguage == 'vi'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        languageController.changeLanguage('vi');
                      },
                    ),
                  ),
                  const Divider(),
                  Obx(
                    () => ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: Text(localizations.englishLanguage),
                      trailing: languageController.currentLanguage == 'en'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        languageController.changeLanguage('en');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
