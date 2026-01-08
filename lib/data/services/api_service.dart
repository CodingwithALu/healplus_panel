import 'dart:convert';
import 'package:healplus_panel/features/media/models/image_modle.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:healplus_panel/features/shop/models/element_model.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:healplus_panel/utils/constants/enums.dart';
import 'package:http/http.dart' as http;
import 'package:healplus_panel/utils/constants/api_constants.dart';

/// API Response Model
class ApiResponse {
  final bool success;
  final String message;
  final dynamic result;
  final String? id;

  ApiResponse({
    required this.success,
    required this.message,
    this.result,
    this.id,
  });

  static ApiResponse empty() {
    return ApiResponse(success: false, message: '', result: null);
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    String? id =
        json['id']?.toString() ??
        json['idc']?.toString() ??
        json['iding']?.toString() ??
        json['ide']?.toString() ??
        json['idp']?.toString();
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: json['result'],
      id: id,
    );
  }
}

/// ApiService - Similar to Retrofit in Kotlin
/// Centralized API service for all HTTP requests
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Http client
  final http.Client _client = http.Client();

  // Headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> get _formHeaders => {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  /// Generic GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        ApiConstants.getUrl(endpoint),
      ).replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: ${e.toString()}';
    }
  }

  /// Generic POST request with JSON body
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse(ApiConstants.getUrl(endpoint));

      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: ${e.toString()}';
    }
  }

  /// POST request with form data (for PHP compatibility)
  Future<dynamic> postForm(
    String endpoint, {
    Map<String, String>? fields,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.getUrl(endpoint));

      final response = await _client.post(
        uri,
        headers: _formHeaders,
        body: fields,
      );

      return _handleResponse(response);
    } catch (e) {
      throw 'Network error: ${e.toString()}';
    }
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        // If response is not JSON, return raw body
        return response.body;
      }
    } else {
      throw 'HTTP Error ${response.statusCode}: ${response.body}';
    }
  }

  // ========== CATEGORY ENDPOINTS ==========

  /// Get all categories
  Future<Map<String, dynamic>> getCategories() async {
    return await get(ApiConstants.categoriesEndpoint);
  }

  /// Add a new category
  Future<ApiResponse> addCategory(CategoryModel item) async {
    final data = item.toJson();
    final fields = {
      'title': (data['Name'] ?? '').toString(),
      'image': (data['Image'] ?? '').toString(),
      'isFeatured': (data['IsFeatured'] ?? false).toString(),
    };
    final result = await postForm(
      ApiConstants.addCategoryEndpoint,
      fields: fields,
    );
    return ApiResponse.fromJson(result);
  }

  /// Update category
  Future<ApiResponse> updateCategory(CategoryModel item) async {
    final data = item.toJson();
    final fields = {
      'idc': (data['Idc'] ?? '').toString(),
      'title': (data['Name'] ?? '').toString(),
      'image': (data['Image'] ?? '').toString(),
      'isFeatured': (data['IsFeatured'] ?? false).toString(),
    };
    final result = await postForm(
      ApiConstants.updateCategoryEndpoint,
      fields: fields,
    );
    return ApiResponse.fromJson(result);
  }

  /// Delete category
  Future<ApiResponse> deleteCategory(String id) async {
    final result = await postForm(
      ApiConstants.deleteCategoryEndpoint,
      fields: {'idc': id},
    );
    return ApiResponse.fromJson(result);
  }

  // ========== BANNER ENDPOINTS ==========

  /// Get all banners
  Future<List<dynamic>> getBanners() async {
    return await get(ApiConstants.bannersEndpoint);
  }

  // ========== IMAGES ENDPOINTS ==========
  Future<ApiResponse> addImages(ImageModel item) async {
    final data = item.toJSon();
    final fields = <String, String>{
      'url': (data['url'] ?? '').toString(),
      'folder': (data['folder'] ?? '').toString(),
      'fileName': (data['fileName'] ?? '').toString(),
      'fullPath': (data['fullPath'] ?? '').toString(),
      'createAt': (data['createAt'] ?? '').toString(),
      'updateAt': (data['updateAt'] ?? '').toString(),
      'contentType': (data['contentType'] ?? '').toString(),
      'sizeBytes': (data['sizeBytes'] ?? 0).toString(),
      'mediaCategory': (data['mediaCategory'] ?? '').toString(),
    };
    final result = await postForm(
      ApiConstants.addImageEndpoint,
      fields: fields,
    );
    print("result: ${ApiResponse.fromJson(result)}");
    return ApiResponse.fromJson(result);
  }

  // Fetch Image
  Future<Map<String, dynamic>> fetchImages(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    final fields = <String, String>{
      'mediaCategory': mediaCategory.name.toString(),
      'loadCount': loadCount.toString(),
    };
    final result = await get(
      ApiConstants.fetchImageEndpoint,
      queryParams: fields,
    );
    print("result: $result");
    return result;
  }
  // ========== INGREDIENT ENDPOINTS ==========

  /// Get all ingredients
  Future<Map<String, dynamic>> fetchIngredients() async {
    return await get(ApiConstants.ingredientsEndpoint);
  }

  /// Get ingredient count
  Future<List<dynamic>> getIngredientCount() async {
    return await get(ApiConstants.ingredientCountEndpoint);
  }

  /// Add ingredient
  Future<ApiResponse> addIngredient(
    String title,
    String url,
    bool isFeatured,
    String idc,
  ) async {
    final result = await postForm(
      ApiConstants.addIngredientEndpoint,
      fields: {
        'title': title,
        'url': url,
        'isFeatured': isFeatured.toString(),
        'idc': idc,
      },
    );
    return ApiResponse.fromJson(result);
  }

  /// Update ingredient
  Future<ApiResponse> updateIngredient(
    String id,
    String title,
    String url,
    String idc,
  ) async {
    final result = await postForm(
      ApiConstants.updateIngredientEndpoint,
      fields: {'iding': id, 'title': title, 'url': url, 'idc': idc},
    );
    return ApiResponse.fromJson(result);
  }

  /// Delete ingredient
  Future<ApiResponse> deleteIngredient(String id) async {
    final result = await postForm(
      ApiConstants.deleteIngredientEndpoint,
      fields: {'iding': id},
    );
    return ApiResponse.fromJson(result);
  }

  // ========== ELEMENT ENDPOINTS ==========

  /// Get all elements
  Future<Map<String, dynamic>> getElements() async {
    return await get(ApiConstants.elementsEndpoint);
  }

  /// Add element
  Future<ApiResponse> addElement(
    String title,
    String url,
    bool isFeatured,
    String ingredientId,
  ) async {
    final result = await postForm(
      ApiConstants.addElementEndpoint,
      fields: {
        'title': title,
        'url': url,
        'isFeatured': isFeatured.toString(),
        'iding': ingredientId,
      },
    );
    return ApiResponse.fromJson(result);
  }

  /// Update element
  Future<ApiResponse> updateElement(ElementModel item) async {
    final data = item.toJson();
    final fields = {
      'ide': (data['ide'] ?? '').toString(),
      'title': (data['title'] ?? '').toString(),
      'url': (data['url'] ?? '').toString(),
      'isFeatured': (data['isFeatured'] ?? false).toString(),
      'iding': (data['iding'] ?? '').toString(),
    };
    final result = await postForm(
      ApiConstants.updateElementEndpoint,
      fields: fields,
    );
    return ApiResponse.fromJson(result);
  }

  /// Delete element
  Future<ApiResponse> deleteElement(String id) async {
    final result = await postForm(
      ApiConstants.deleteElementEndpoint,
      fields: {'ide': id},
    );
    return ApiResponse.fromJson(result);
  }

  // ========== PRODUCT ENDPOINTS ==========

  /// Get recommended products
  Future<Map<String, dynamic>> getRecommendedProducts() async {
    return await get(ApiConstants.productsEndpoint);
  }

  /// Get all product
  Future<Map<String, dynamic>> getAllProduct() async {
    return await get(ApiConstants.productsAll);
  }

  /// Get product by ID
  Future<dynamic> getProductById(String id) async {
    return await get(
      ApiConstants.productByIdEndpoint,
      queryParams: {'idp': id},
    );
  }

  /// Get products by category
  Future<List<dynamic>> getProductsByCategory(String categoryId) async {
    return await get(
      ApiConstants.productsByCategoryEndpoint,
      queryParams: {'idc': categoryId},
    );
  }

  /// Get products by ingredient
  Future<List<dynamic>> getProductsByIngredient(String ingredientId) async {
    return await get(
      ApiConstants.productsByIngredientEndpoint,
      queryParams: {'id': ingredientId},
    );
  }

  /// Get products by element
  Future<void> deleteProduct(String idp) async {
    return await postForm(ApiConstants.deteleProduct, fields: {'idp': idp});
  }

  /// Search products
  Future<List<dynamic>> searchProducts(String query) async {
    return await get(
      ApiConstants.searchEndpoint,
      queryParams: {'search': query},
    );
  }

  /// Create products
  Future<ApiResponse> createProduct(ProductModel product) async {
    final data = product.toJson();
    final fields = <String, String>{
      'name': (data['name'] ?? '').toString(),
      'trademark': (data['trademark'] ?? '').toString(),
      'expiry': (data['expiry'] ?? '').toString(),
      'preparation': (data['preparation'] ?? '').toString(),
      'specification': (data['specification'] ?? '').toString(),
      'origin': (data['origin'] ?? '').toString(),
      'manufacturer': (data['manufacturer'] ?? '').toString(),
      'production': (data['production'] ?? '').toString(),
      'ingredient': (data['ingredient'] ?? false).toString(),
      'description': (data['description'] ?? '').toString(),
      'quantity': (data['quantity'] ?? 0).toString(),
      'ide': (data['ide'] ?? '').toString(),
      'productiondate': (data['productionDate'] ?? '').toString(),
      'uses': (data['uses'] ?? false).toString(),
      'toUse': (data['toUse'] ?? '').toString(),
      'sideEffects': (data['sideEffects'] ?? '').toString(),
      'preserver': (data['preserver'] ?? '').toString(),
      'urls': jsonEncode(data['urls'] ?? []),
      'unitNames': jsonEncode(data['unitNames'] ?? []),
      'ingredients': jsonEncode(data['ingredients'] ?? []),
    };
    final result = await postForm(ApiConstants.createProduct, fields: fields);
    return ApiResponse.fromJson(result);
  }

  // ========== ORDER ENDPOINTS ==========

  /// Get all orders
  Future<List<dynamic>> getOrders() async {
    return await get(ApiConstants.ordersEndpoint);
  }

  /// Get orders by status
  Future<List<dynamic>> getOrdersByStatus(String status) async {
    final result = await postForm(
      ApiConstants.ordersByStatusEndpoint,
      fields: {'status': status},
    );
    return result;
  }

  /// Get orders by user
  Future<List<dynamic>> getOrdersByUser(String userId) async {
    final result = await postForm(
      ApiConstants.ordersByUserEndpoint,
      fields: {'idauth': userId},
    );
    return result;
  }

  /// Update order status
  Future<ApiResponse> updateOrderStatus(int orderId, String status) async {
    final result = await postForm(
      ApiConstants.updateOrderStatusEndpoint,
      fields: {'id': orderId.toString(), 'status': status},
    );
    return ApiResponse.fromJson(result);
  }

  Future<void> deleteOrder(String idp) async {
    return await postForm(ApiConstants.deleteOrder, fields: {'id': idp});
  }

  // ========== USER ENDPOINTS ==========

  /// Get user by ID
  Future<dynamic> getUserById(String id) async {
    return await get(ApiConstants.userEndpoint, queryParams: {'id': id});
  }

  /// Create user
  Future<ApiResponse> createUser(
    String id,
    String name,
    String email,
    String password,
  ) async {
    final result = await postForm(
      ApiConstants.createUserEndpoint,
      fields: {'id': id, 'name': name, 'email': email, 'password': password},
    );
    return ApiResponse.fromJson(result);
  }

  /// Update user
  Future<ApiResponse> updateUser({
    required String name,
    required String email,
    required String gender,
    required String phone,
    required String url,
    required String dateBirth,
    required String idAuth,
  }) async {
    final result = await postForm(
      ApiConstants.updateUserEndpoint,
      fields: {
        'name': name,
        'email': email,
        'gender': gender,
        'phone': phone,
        'url': url,
        'dateBirth': dateBirth,
        'idauth': idAuth,
      },
    );
    return ApiResponse.fromJson(result);
  }

  // ========== REVENUE ENDPOINTS ==========

  /// Get revenue by month
  Future<dynamic> getRevenueMonth(int month, int year) async {
    return await get(
      ApiConstants.revenueMonthEndpoint,
      queryParams: {'month': month.toString(), 'year': year.toString()},
    );
  }

  /// Get revenue by week
  Future<dynamic> getRevenueWeek(String startDate) async {
    return await get(
      ApiConstants.revenueWeekEndpoint,
      queryParams: {'start_date': startDate},
    );
  }

  /// Get revenue by year
  Future<dynamic> getRevenueYear(int year) async {
    return await get(
      ApiConstants.revenueYearEndpoint,
      queryParams: {'year': year.toString()},
    );
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
