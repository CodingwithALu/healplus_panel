/* -- LIST OF Constants used in APIs -- */

// Example
const String tSecretAPIKey = "cwt_live_b2da6ds3df3e785v8ddc59198f7615ba";

class ApiConstants {
  // Base URL (update as needed)
  static const String baseUrl = "http://localhost:8000/";

  // Category
  static const String categoriesEndpoint = "fetchCategory.php";
  static const String addCategoryEndpoint = "add_category.php";
  static const String updateCategoryEndpoint = "update_category.php";
  static const String deleteCategoryEndpoint = "delete_category.php";

  // Banner
  static const String bannersEndpoint = "fetchBanner.php";

  // Ingredient
  static const String ingredientsEndpoint = "fetchIngredient.php";
  static const String ingredientCountEndpoint = "get_ingredient_count.php";
  static const String addIngredientEndpoint = "add_ingredient.php";
  static const String updateIngredientEndpoint = "update_ingredient.php";
  static const String deleteIngredientEndpoint = "delete_ingredient.php";
  static const String ingredientByCategoryEndpoint =
      "get_ingredient_by_category.php";

  // Element
  static const String elementsEndpoint = "fetchElement.php";
  static const String addElementEndpoint = "add_element.php";
  static const String updateElementEndpoint = "update_element.php";
  static const String deleteElementEndpoint =
      "update_element.php"; // Note: same as update in Kotlin

  static const String elementsByIngredientEndpoint =
      "get_elements_by_ingredient.php";

  // Product
  static const String productsAll = "get_product_all.php";
  static const String productsEndpoint = "get_product_showRecomment.php";
  static const String productByIdEndpoint = "route/get/fetch_product_by_id.php";
  static const String productsByCategoryEndpoint =
      "route/get/fetch_products_from_category.php";
  static const String productsByIngredientEndpoint =
      "get_products_by_ingredient.php";
  static const String productsByElementEndpoint = "get_products_by_element.php";
  static const String addProductEndpoint = "add_product.php";
  static const String searchEndpoint = "getsearch.php";

  // Order
  static const String ordersEndpoint = "get_oder.php";
  static const String addOrderEndpoint = "oder.php";
  static const String updateOrderStatusEndpoint = "update_oder_status.php";
  static const String ordersByStatusEndpoint = "get_oder_by_status.php";
  static const String ordersByUserEndpoint = "get_oder_by_user.php";
  static const String ordersByUserStatusEndpoint = "get_oder_by_userstatus.php";

  // User
  static const String userEndpoint = "route/get/fetch_user.php";
  static const String createUserEndpoint = "create_user.php";
  static const String updateUserEndpoint = "update_user.php";
  static const String updateIdAuthEndpoint = "update_idauth.php";

  // Review
  static const String createReviewEndpoint = "create_review.php";
  static const String updateReviewEndpoint = "update_review.php";

  // Revenue
  static const String revenueMonthEndpoint = "revenue_month.php";
  static const String revenueWeekEndpoint = "revenue_week.php";
  static const String revenueYearEndpoint = "revenue_year.php";

  // Helper to get full URL
  static String getUrl(String endpoint) => baseUrl + endpoint;
}
