import 'dart:io';
import 'dart:typed_data';

import 'package:healplus_panel/data/repositories/media/media_repository.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/media/screens/media/widgets/media_content.dart';
import 'package:healplus_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/constants/text_strings.dart';
import 'package:healplus_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:healplus_panel/utils/exceptions/format_exceptions.dart';
import 'package:healplus_panel/utils/loaders/circular_loader.dart';
import 'package:healplus_panel/utils/popups/dialogs.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  final RxBool loading = false.obs;
  final int inittialLoadCount = 20;
  final int laodMoreCount = 25;
  // bo dieu khien che do xem drop zone
  late DropzoneViewController dropzoneController;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxList<ImageModel> selectedImagesTopUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserIamges = <ImageModel>[].obs;

  final MediaRepository mediaRepository = MediaRepository();

  // Get Images
  void getMediaImages() async {
    try {
      loading.value = true;
      RxList<ImageModel> targetList = <ImageModel>[].obs;
      if (selectedPath.value == MediaCategory.banners &&
          allBannerImages.isEmpty) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands &&
          allBrandImages.isEmpty) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories &&
          allCategoryImages.isEmpty) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products &&
          allProductImages.isEmpty) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users &&
          allUserIamges.isEmpty) {
        targetList = allUserIamges;
      }
      final images = await mediaRepository.fetchImagesFromDatabase(
        selectedPath.value,
        inittialLoadCount,
      );
      targetList.assignAll(images);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.media_error_title,
        message: AppLocalizations.of(Get.context!)!.media_error_fetch,
      );
    }
  }

  // Load more Image
  void loadMoreMediaImages() async {
    try {
      loading.value = true;
      RxList<ImageModel> targetList = switch (selectedPath.value) {
        MediaCategory.banners => allBannerImages,
        MediaCategory.brands => allBrandImages,
        MediaCategory.categories => allCategoryImages,
        MediaCategory.products => allProductImages,
        MediaCategory.users => allUserIamges,
        _ => <ImageModel>[].obs,
      };
      if (selectedPath.value == MediaCategory.banners) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users) {
        targetList = allUserIamges;
      }
      final images = await mediaRepository.loadMoreImagesFromDatabase(
        selectedPath.value,
        inittialLoadCount,
        targetList.last.createAt ?? DateTime.now(),
      );
      targetList.addAll(images);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.media_error_title,
        message: AppLocalizations.of(Get.context!)!.media_error_fetch,
      );
    }
  }

  // selecLocalImages
  Future<void> selectLocalImages() async {
    final files = await dropzoneController.pickFiles(
      multiple: true,
      mime: ['image/jpeg', 'image/png'],
    );
    if (files.isNotEmpty) {
      for (var file in files) {
        final bytes = await dropzoneController.getFileData(file);
        final image = ImageModel(
          url: '',
          file: file,
          folder: '',
          filename: file.name,
          localImageToDisplay: Uint8List.fromList(bytes),
        );
        selectedImagesTopUpload.add(image);
      }
    }
  }

  // uploadImages
  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.folders) {
      TLoaders.warningSnackBar(
        title: AppLocalizations.of(Get.context!)!.media_select_folder_title,
        message: AppLocalizations.of(Get.context!)!.media_select_folder_message,
      );
      return;
    }
    TDialogs.defaultDialog(
      context: Get.context!,
      title: AppLocalizations.of(Get.context!)!.media_upload_confirm_title,
      confirmText: AppLocalizations.of(
        Get.context!,
      )!.media_upload_confirm_button,
      onConfirm: () async => await uploadImages(),
      content:
          '${AppLocalizations.of(Get.context!)!.media_upload_confirm_message} ${selectedPath.value.name.toLowerCase()} folder',
    );
  }

  Future<void> uploadImages() async {
    try {
      // Remove confirmation box
      Get.back();
      // Loader
      uploadImagesLoader();
      // Get the selected category
      MediaCategory selectedCategory = selectedPath.value;
      // Get the corresponding list to update
      RxList<ImageModel> targetList;
      // Check the selected category and uplosd the corresponfing list
      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserIamges;
          break;
        default:
          return;
      }
      // Upload and add images to the target list
      // Using a reverse loop to avoid 'Concurrent modification durng iteration' error
      for (int i = selectedImagesTopUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesTopUpload[i];
        final image = selectedImage.file!;
        // Lấy Uint8List
        final bytes = await dropzoneController.getFileData(image);
        // Upload Image ti the Storage
        final ImageModel uploadeImage = await mediaRepository
            .uploadImageToCloudinary(
              file: bytes,
              path: getSelectedPath(),
              imageName: selectedImage.filename,
            );
        // Upload Image to the Firestỏe
        uploadeImage.mediaCategory = selectedCategory.name;
        final result = await mediaRepository.uploadImageFileInDatabase(
          uploadeImage,
        );
        uploadeImage.id = result.id!;
        selectedImagesTopUpload.removeAt(i);
        targetList.add(uploadeImage);
      }
    } on SocketException catch (e) {
      throw e.message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } catch (e) {
      // Stop Loader in csae of an error
      TFullScreenLoader.stopLoading();
      // Show a warning snack-bar for the error
      TLoaders.warningSnackBar(
        title: AppLocalizations.of(Get.context!)!.media_error_upload_title,
        message:
            '${AppLocalizations.of(Get.context!)!.media_error_upload_message}: ${e.toString()}',
      );
    } finally {
      Get.back();
    }
  }

  void uploadImagesLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.media_uploading_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                TImages.uploadingImageIllustration,
                height: 300,
                width: 300,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(AppLocalizations.of(context)!.media_uploading_content),
            ],
          ),
        ),
      ),
    );
  }

  String getSelectedPath() {
    final Map<MediaCategory, String> storagePaths = {
      MediaCategory.banners: TTexts.bannersStoragePath,
      MediaCategory.brands: TTexts.brandsStoragePath,
      MediaCategory.categories: TTexts.categoriesStoragePath,
      MediaCategory.products: TTexts.productsStoragePath,
      MediaCategory.users: TTexts.usersStoragePath,
    };
    return storagePaths[selectedPath.value] ?? 'Others';
  }

  // Popup confirmation to remove cloud image
  void removeCloudImageConfirmation(ImageModel image) {
    // Delete Confirmation
    TDialogs.defaultDialog(
      context: Get.context!,
      content: AppLocalizations.of(Get.context!)!.media_delete_confirm,
      onConfirm: () {
        Get.back();
        removeClouImage(image);
      },
      onCancel: () => Get.back(),
    );
  }

  void removeClouImage(ImageModel image) async {
    try {
      Get.back();
      // Show Loader
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(
          canPop: false,
          child: SizedBox(width: 150, height: 150, child: TCircularLoader()),
        ),
      );
      // Delete Image
      await mediaRepository.deleteFileFromCloudinaryAndFireStore(image);
      // Check the selected category and update the corresponding list
      RxList<ImageModel> targetList = switch (selectedPath.value) {
        MediaCategory.banners => allBannerImages,
        MediaCategory.brands => allBrandImages,
        MediaCategory.categories => allCategoryImages,
        MediaCategory.products => allProductImages,
        MediaCategory.users => allUserIamges,
        _ => <ImageModel>[].obs,
      };
      // Remove form the list
      targetList.remove(image);
      update();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: AppLocalizations.of(Get.context!)!.media_delete_success_title,
        message: AppLocalizations.of(
          Get.context!,
        )!.media_delete_success_message,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.ohSnap,
        message: e.toString(),
      );
    }
  }

  // Image Selection Bootom Sheet
  Future<List<ImageModel>?> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    showImagesUploaderSection.value = true;
    List<ImageModel>? selectedImages = await Get.bottomSheet<List<ImageModel>>(
      backgroundColor: TColors.primaryBackground,
      isScrollControlled: true,
      FractionallySizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const MediaUploader(),
                MediaContent(
                  allowSelection: allowSelection,
                  alreadySelectedUrls: selectedUrls ?? [],
                  allowMoltipleSelection: multipleSelection,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return selectedImages;
  }
}
