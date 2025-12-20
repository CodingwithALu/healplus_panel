import 'package:healplus_panel/data/services/api_service.dart';
import 'package:get/get.dart';

/// Banner Repository
/// Similar to Kotlin's HomeRepository pattern
class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  // API Service instance
  final ApiService _apiService = ApiService();

  // Fetch all banners
  Future<List<dynamic>> fetchBanners() async {
    try {
      final response = await _apiService.getBanners();
      return response;
    } catch (e) {
      throw 'Failed to fetch banners: ${e.toString()}';
    }
  }
}

/// Ingredient Repository
class IngredientRepository extends GetxController {
  static IngredientRepository get instance => Get.find();

  final ApiService _apiService = ApiService();

  // Fetch all ingredients
  Future<Map<String, dynamic>> fetchIngredients() async {
    try {
      final response = await _apiService.fetchIngredients();
      return response;
    } catch (e) {
      throw 'Failed to fetch ingredients: ${e.toString()}';
    }
  }

  // Fetch ingredient count
  Future<List<dynamic>> fetchIngredientCount() async {
    try {
      final response = await _apiService.getIngredientCount();
      return response;
    } catch (e) {
      throw 'Failed to fetch ingredient count: ${e.toString()}';
    }
  }

  // Add ingredient
  Future<void> addIngredient(
    String title,
    String url,
    String categoryId,
  ) async {
    try {
      final response = await _apiService.addIngredient(title, url, categoryId);
      if (!response.success) {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to add ingredient: ${e.toString()}';
    }
  }

  // Update ingredient
  Future<void> updateIngredient(
    String id,
    String title,
    String url,
    String categoryId,
  ) async {
    try {
      final response = await _apiService.updateIngredient(
        id,
        title,
        url,
        categoryId,
      );
      if (!response.success) {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to update ingredient: ${e.toString()}';
    }
  }

  // Delete ingredient
  Future<void> deleteIngredient(String id) async {
    try {
      final response = await _apiService.deleteIngredient(id);
      if (!response.success) {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to delete ingredient: ${e.toString()}';
    }
  }
}

/// Product Repository
class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final ApiService _apiService = ApiService();

  // Fetch recommended products
  Future<List<dynamic>> fetchRecommendedProducts() async {
    try {
      final response = await _apiService.getRecommendedProducts();
      return response;
    } catch (e) {
      throw 'Failed to fetch recommended products: ${e.toString()}';
    }
  }

  // Fetch product by ID
  Future<dynamic> fetchProductById(String id) async {
    try {
      final response = await _apiService.getProductById(id);
      return response;
    } catch (e) {
      throw 'Failed to fetch product: ${e.toString()}';
    }
  }

  // Fetch products by category
  Future<List<dynamic>> fetchProductsByCategory(String categoryId) async {
    try {
      final response = await _apiService.getProductsByCategory(categoryId);
      return response;
    } catch (e) {
      throw 'Failed to fetch products by category: ${e.toString()}';
    }
  }

  // Fetch products by ingredient
  Future<List<dynamic>> fetchProductsByIngredient(String ingredientId) async {
    try {
      final response = await _apiService.getProductsByIngredient(ingredientId);
      return response;
    } catch (e) {
      throw 'Failed to fetch products by ingredient: ${e.toString()}';
    }
  }

  // Search products
  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await _apiService.searchProducts(query);
      return response;
    } catch (e) {
      throw 'Failed to search products: ${e.toString()}';
    }
  }
}

/// Order Repository
class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final ApiService _apiService = ApiService();

  // Fetch all orders
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await _apiService.getOrders();
      return response;
    } catch (e) {
      throw 'Failed to fetch orders: ${e.toString()}';
    }
  }

  // Fetch orders by status
  Future<List<dynamic>> fetchOrdersByStatus(String status) async {
    try {
      final response = await _apiService.getOrdersByStatus(status);
      return response;
    } catch (e) {
      throw 'Failed to fetch orders by status: ${e.toString()}';
    }
  }

  // Fetch orders by user
  Future<List<dynamic>> fetchOrdersByUser(String userId) async {
    try {
      final response = await _apiService.getOrdersByUser(userId);
      return response;
    } catch (e) {
      throw 'Failed to fetch orders by user: ${e.toString()}';
    }
  }

  // Update order status
  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await _apiService.updateOrderStatus(orderId, status);
      if (!response.success) {
        throw response.message;
      }
    } catch (e) {
      throw 'Failed to update order status: ${e.toString()}';
    }
  }
}
