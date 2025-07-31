import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/categories/category_reponsitory.dart';
import 'package:healplus_panel/features/shop/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends TBaseController<CategoryModel> {
  static CategoryController get instance => Get.find();
  final _categoryRepository = Get.put(CategoryReponsitory());

  @override
  bool containsSearchQuery(item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(item) async {
    await _categoryRepository.deleteCategory(item.id);
  }

  @override
  Future<List<CategoryModel>> fetchItems() async {
    return await _categoryRepository.getAllCategories();
  }

  // sort by name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((CategoryModel category) => category.name.toLowerCase()),
    );
  }

  // sort by ParentName
  void sortByParentName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((CategoryModel category) => category.parentId.toLowerCase()),
    );
  }
}
