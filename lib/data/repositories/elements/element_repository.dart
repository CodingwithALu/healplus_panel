import 'package:healplus_panel/data/services/api_service.dart';
import 'package:healplus_panel/features/shop/models/element_model.dart';
import 'package:get/get.dart';

class ElementRepository extends GetxController {
  static ElementRepository get instance => Get.find();
  final ApiService _apiService = ApiService();
  Future<List<ElementModel>> getAllElements() async {
    try {
      final response = await _apiService.getElements();
      final resultList = response['result'] as List;
      final result = resultList
          .map((json) => ElementModel.fromJson(json))
          .toList();
      return result;
    } catch (e) {
      throw 'Failed to fetch categories: ${e.toString()}';
    }
  }

  // CreateElement
  Future<ApiResponse> createElement(ElementModel item) async {
    try {
      return await _apiService.addElement(
        item.title,
        item.url,
        item.isFeatured,
        item.iding,
      );
    } catch (e) {
      throw 'Failed to update category: ${e.toString()}';
    }
  }

  // Delete an existing category document from the 'Categories' collection
  Future<ApiResponse> deleteElement(ElementModel item) async {
    try {
      return await _apiService.deleteElement(item.ide);
    } catch (e) {
      throw 'Something went srong. Please try again';
    }
  }

  // Update Category
  Future<ApiResponse> updateElement(ElementModel item) async {
    try {
      return await _apiService.updateElement(item);
    } catch (e) {
      throw 'Failed to update category: ${e.toString()}';
    }
  }
}
