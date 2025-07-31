import 'package:healplus_panel/bindings/general_binding.dart';
import 'package:healplus_panel/features/shop/controllers/language/language_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/route/app_routes.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/utils/constants/text_strings.dart';
import 'package:healplus_panel/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo LanguageController
    Get.put(LanguageController());
    final languageController = LanguageController.instance;

    // implement build
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      initialRoute: TRoutes.dashboard,
      getPages: TAppRoute.pages,
      unknownRoute: GetPage(
        name: '/page-not-found',
        page: () => const Scaffold(body: Center(child: Text('Page Not Found'))),
      ),
      // i18n
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageController.getCurrentLanguage()),
    );
  }
}
