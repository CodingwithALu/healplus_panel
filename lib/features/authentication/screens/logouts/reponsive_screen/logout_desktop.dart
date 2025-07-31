import 'package:healplus_panel/features/authentication/controllers/logout_controller.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutDesktopScreen extends StatelessWidget {
  const LogoutDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogoutController());
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.logoutTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 64, color: Colors.redAccent),
              const SizedBox(height: 24),
              Text(
                localizations.logoutConfirmMessage,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: Text(localizations.logoutButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(160, 48),
                ),
                onPressed: () async {
                  await controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
