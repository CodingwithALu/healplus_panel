import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/brands/brand_repository.dart';
import 'package:healplus_panel/features/shop/controllers/categories/category_controller.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

class CategoryController extends TBaseController<CategoryModel> {
  static CategoryController get instance => Get.find();

  final _brandRepository = Get.put(BrandRepository());
  final ingredientController = Get.put(IngredientController());

  @override
  bool containsSearchQuery(item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(item) async {
    await _brandRepository.deleteBrands(item);
  }

  @override
  Future<List<CategoryModel>> fetchItems() async {
    final fetchenBrands = await _brandRepository.getAllBrands();
    // // get all brandsCategories
    // final fetchedBrandsCategories = await _brandRepository
    //     .getAllBrandCategories();
    // // fetch all categories is data does not already exits
    // if (categoryController.allItems.isNotEmpty) {
    //   await categoryController.fetchItems();
    // }
    // for (var brand in fetchenBrands) {
    //   //extract categoryIds from the documents
    //   List<String> categoryIds = fetchedBrandsCategories
    //       .where((brandCategory) => brandCategory.brandId == brand.id)
    //       .map((brandCategory) => brandCategory.categoryId)
    //       .toList();
    //   brand.ingredients = categoryController.allItems
    //       .where((category) => categoryIds.contains(category.iding))
    //       .toList();
    // }
    return fetchenBrands;
  }

  // sort bay name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((CategoryModel item) => item.name.toLowerCase()),
    );
  }
}
