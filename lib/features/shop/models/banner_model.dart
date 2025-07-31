import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String image;
  bool active;
  String targetScreen;
  BannerModel({
    this.id,
    required this.image,
    required this.active,
    required this.targetScreen,
  });
  // Map to store data firebase
  Map<String, dynamic> toJson() {
    return {'ImageUrl': image, 'Active': active, 'TragetScreen': targetScreen};
  }

  // form Snapshot to fetch all banner
  factory BannerModel.formSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return BannerModel(
      id: document.id,
      image: data['ImageUrl'] ?? '',
      active: data['Active'] ?? '',
      targetScreen: data['TragetScreen'] ?? '',
    );
  }
}
