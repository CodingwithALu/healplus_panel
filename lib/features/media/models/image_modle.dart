import 'dart:typed_data';
import 'package:healplus_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  // Danh muc phuong tien
  String mediaCategory;
  final String filename;
  // tep noi dung du lieu
  final String? fullPath;
  final DateTime? createAt;
  final DateTime? updateAt;
  final String? contentType;
  // Not Mapped
  final dynamic file;
  RxBool isSelected = false.obs;
  // hinh anh cuc bo de hien thi
  final Uint8List? localImageToDisplay;
  // Contructer
  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createAt,
    this.updateAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  /// Static function to create an empty user mode
  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '');

  /// Function to get createAt
  String get createAtFormatted => TFormatter.formatDate(createAt);
  String get updateAtFormatted => TFormatter.formatDate(updateAt);

  /// Convert to Json to Store in DB
  Map<String, dynamic> toJSon() {
    return {
      'url': url,
      'folder': folder,
      'fileName': filename,
      'fullPath': fullPath,
      'createAt': createAt?.toUtc(),
      'updateAt': updateAt?.toUtc(),
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'mediaCategory': mediaCategory,
    };
  }

  /// Convert Firestore Json and Map on Model
  factory ImageModel.fromSapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      // Map Json Record to the Model
      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        filename: data['fileName'] ?? '',
        fullPath: data['fullPath'] ?? '',
        createAt: data.containsKey('createAt')
            ? data['createAt']?.toDate()
            : null,
        updateAt: data.containsKey('updateAt')
            ? data['updateAt']?.toDate()
            : null,
        sizeBytes: data['sizeBytes'],
        contentType: data['contentType'] ?? '',
        mediaCategory: data['mediaCategory'],
      );
    } else {
      return ImageModel.empty();
    }
  }

  /// Map Fribase Strorage Data
  factory ImageModel.fromFirebaseMatedate(
    FullMetadata metadata,
    String folder,
    String filenam,
    String dowloadUrl,
  ) {
    return ImageModel(
      url: dowloadUrl,
      folder: folder,
      filename: filenam,
      sizeBytes: metadata.size,
      updateAt: metadata.updated,
      fullPath: metadata.fullPath,
      createAt: metadata.timeCreated,
      contentType: metadata.contentType,
    );
  }

  /// Map Cloudinary Data
  factory ImageModel.fromCloudinaryJson(Map<String, dynamic> json) {
    final publicId = json['public_id'] as String;
    final parts = publicId.split('/');
    final imageName = parts.isNotEmpty ? parts.last : '';
    final path = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('/')
        : '';
    return ImageModel(
      url: json['secure_url'],
      folder: "/$path",
      filename: imageName,
      sizeBytes: json['bytes'],
      updateAt: DateTime.parse(json['created_at']),
      createAt: DateTime.parse(json['created_at']),
      fullPath: json['public_id'],
      contentType: "image/${json['format']}",
    );
  }
}
