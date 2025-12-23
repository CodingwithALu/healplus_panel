import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/elements/element_repository.dart';
import 'package:healplus_panel/features/shop/models/element_model.dart';
import 'package:get/get.dart';

class ElementController extends TBaseController<ElementModel> {
  static ElementController get instance => Get.find();
  final _elementRepository = Get.put(ElementRepository());

  @override
  bool containsSearchQuery(item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(item) async {
    await _elementRepository.deleteElement(item);
  }

  @override
  Future<List<ElementModel>> fetchItems() async {
    return await _elementRepository.getAllElements();
  }

  // sort by name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ElementModel category) => category.title.toLowerCase()),
    );
  }

  // sort by ParentName
  void sortByParentName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ElementModel ingredient) => ingredient.iding.toLowerCase()),
    );
  }
}
