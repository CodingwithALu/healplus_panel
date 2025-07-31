import 'dart:convert';
import 'dart:io';

import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class MediaRepository extends GetxController {
  static MediaRepository get onstance => Get.find();
  //Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //Firebase Firestore íntance
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  // Connect Cloudinary use HTTP
  final String cloudName = 'dhl2sbjo5';
  final String uploadPreset = 't_stores';
  //Upload any Image using File
  Future<ImageModel> uploadImageFileInStorage({
    required Uint8List file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Tao Blob
      final blob = html.Blob([file]);
      // Refernce to the storage location
      final Reference ref = _storage.ref('$path/$imageName');
      // Upload Image
      await ref.putBlob(blob);
      // Get doeload URL
      final String downloadUrl = await ref.getDownloadURL();

      // Fetch metadata
      final FullMetadata metadata = await ref.getMetadata();
      return ImageModel.fromFirebaseMatedate(
        metadata,
        path,
        imageName,
        downloadUrl,
      );
    } on SocketException catch (e) {
      throw e.message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Upload Images to Cloudinary
  Future<ImageModel> uploadImageToCloudinary({
    required Uint8List file,
    required String path,
    required String imageName,
  }) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      final response = await http.post(
        url,
        body: {
          'file': 'data:image/png;base64,${base64Encode(file)}',
          'upload_preset': uploadPreset,
          'public_id': '$path/$imageName'.replaceFirst(RegExp(r'^/'), ''),
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ImageModel.fromCloudinaryJson(json);
      } else {
        // In chi tiết lỗi nếu upload thất bại
        throw 'Upload error: [${response.statusCode}] ${response.body}';
      }
    } catch (e) {
      // In cả lỗi và StackTrace nếu muốn debug sâu hơn
      throw 'Loi khi upload Cloudinary: $e';
    }
  }

  // Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await _store.collection("Images").add(image.toJSon());
      return data.id;
    } on SocketException catch (e) {
      throw e.message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again: ${e.toString()}';
    }
  }

  // Fetch images from FirebaseStore on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    try {
      final querySnapshot = await _store
          .collection("Images")
          .where('mediaCategory', isEqualTo: mediaCategory.name)
          .orderBy('createAt', descending: true)
          .limit(loadCount)
          .get();
      return querySnapshot.docs.map((e) => ImageModel.fromSapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  // Load more images from FireStore base on media category, load count, add last fetched date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedData,
  ) async {
    try {
      final querySnapshot = await _store
          .collection("Images")
          .where('mediaCategory', isEqualTo: mediaCategory.name)
          .orderBy('createAt', descending: true)
          .startAfter([lastFetchedData])
          .limit(loadCount)
          .get();
      return querySnapshot.docs.map((e) => ImageModel.fromSapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete file from Cloudinary
  Future<void> deleteFileFromCloudinaryAndFireStore(ImageModel image) async {
    try {
      //FireStore
      await _store.collection('Images').doc(image.id).delete();
      //Cloudinary use APi Node js
      final String publicId = image.fullPath!;
      final response = await http.post(
        Uri.parse('http://localhost:3000/delete-image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'public_id': publicId}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] == 'ok') {
        } else {
          throw 'khong xoa duoc anh: ${result['result']}';
        }
      } else {
        throw 'xoa that bai: ${response.statusCode}';
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong while deleting image';
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Loi khi upload Cloudinary: $e';
    }
  }
}
