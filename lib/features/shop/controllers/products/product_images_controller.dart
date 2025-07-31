import 'package:healplus_panel/features/media/controllers/media_controllet.dart';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();

  // Rx Observables for the selected thumbnail image
  Rx<String?> selectedThubnailImageUrl = Rx<String?>(null);

  // Lists to store additional product images (luu nhieu hinh anh cho mot san pham)
  final RxList<String> additionalProductImagesUrl = <String>[].obs;

  // Pick Thumbnail Image from Media
  void selectedThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();
    // handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main iage or perform any other action
      ImageModel selectedImage = selectedImages.first;
      // Update the mian image using the selectedImage
      selectedThubnailImageUrl.value = selectedImage.url;
    }
  }

  // Pick Thumbnail Image from Media
  void selectedVariationsImage(ProductVariationModel variations) async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();
    // handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main iage or perform any other action
      ImageModel selectedImage = selectedImages.first;
      // Update the mian image using the selectedImage
      variations.image.value = selectedImage.url;
    }
  }

  // Pick Multiple Images from Media
  void selectedMultipleproductImages() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia(
      multipleSelection: true,
      selectedUrls: additionalProductImagesUrl,
    );
    // handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImagesUrl.assignAll(selectedImages.map((e) => e.url));
    }
  }

  // Punction to remove Product image
  Future<void> removeImges(int index) async {
    additionalProductImagesUrl.removeAt(index);
  }
}
