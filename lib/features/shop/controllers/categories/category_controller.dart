import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/categories/category_repository_new.dart';
import 'package:healplus_panel/features/shop/models/ingredient_model.dart';
import 'package:get/get.dart';

class IngredientController extends TBaseController<IngredientModel> {
  static IngredientController get instance => Get.find();
  final _categoryRepository = Get.put(IngredientRepository());

  @override
  bool containsSearchQuery(item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(item) async {
    await _categoryRepository.deleteCategory(item.iding);
  }

  @override
  Future<List<IngredientModel>> fetchItems() async {
    return await _categoryRepository.getAllIngredient();
  }

  // sort by name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((IngredientModel category) => category.title.toLowerCase()),
    );
  }

  // sort by ParentName
  // void sortByParentName(int sortColumnIndex, bool ascending) {
  //   sortByProperty(
  //     sortColumnIndex,
  //     ascending,
  //     ((CategoryModel category) => category.parentId.toLowerCase()),
  //   );
  // }
}
