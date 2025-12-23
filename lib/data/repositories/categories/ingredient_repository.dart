import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:healplus_panel/data/services/api_service.dart';
import 'package:get/get.dart';

class IngredientRepository extends GetxController {
  static IngredientRepository get instance => Get.find();

  // API Service instance
  final ApiService _apiService = ApiService();

  // Get all categories from API
  Future<List<IngredientModel>> getAllIngredient() async {
    try {
      final response = await _apiService.fetchIngredients();
      final resultList = response['result'] as List;
      final result = resultList
          .map((json) => IngredientModel.fromJson(json))
          .toList();
      return result;
    } catch (e) {
      throw 'Failed to fetch categories: ${e.toString()}';
    }
  }
  // Delete an existing category via API
  Future<ApiResponse> deleteIngredient(IngredientModel item) async {
    try {
      return await _apiService.deleteIngredient(item.iding);
    } catch (e) {
      throw 'Failed to delete category: ${e.toString()}';
    }
  }

  // Create Category via API
  Future<ApiResponse> createIngredient(IngredientModel item) async {
    try {
      final response = await _apiService.addIngredient(
        item.title,
        item.url,
        item.isFeatured,
        item.idc,
      );

      // Add the missing if statement
      if (response.success) {
        return response;
      } else {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to create category: ${e.toString()}';
    }
  }

  // Update ingredient
  Future<void> updateIngredient(IngredientModel item) async {
    try {
      final response = await _apiService.updateIngredient(
        item.iding,
        item.title,
        item.url,
        item.idc,
      );
      if (!response.success) {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to update ingredient: ${e.toString()}';
    }
  }
}
