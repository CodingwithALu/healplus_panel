import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final String? id;
  double taxRate;
  double shippingCost;
  double? freeShippingThreshold;
  String appName;
  String appLogo;
  // Contrustor
  SettingsModel({
    this.id,
    this.taxRate = 0.0,
    this.shippingCost = 0.0,
    this.freeShippingThreshold,
    this.appName = '',
    this.appLogo = '',
  });
  // Convert model to Json structrue for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'taxRate': taxRate,
      'shippingCost': shippingCost,
      'freeShippingThreShold': freeShippingThreshold,
      'appName': appName,
      'appLogo': appLogo,
    };
  }

  /// Factory methood to create a settingModel form a Fireabase doxcument
  factory SettingsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return SettingsModel(
        id: document.id,
        taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
        shippingCost: (data['shippingCost'] as num?)?.toDouble() ?? 0.0,
        freeShippingThreshold:
            (data['freeShippingThreShold'] as num?)?.toDouble() ?? 0.0,
        appName: data.containsKey('appName') ? data['appName'] ?? '' : '',
        appLogo: data.containsKey('appLogo') ? data['appLogo'] ?? '' : '',
      );
    } else {
      return SettingsModel();
    }
  }

  static SettingsModel empty() => SettingsModel();
}
