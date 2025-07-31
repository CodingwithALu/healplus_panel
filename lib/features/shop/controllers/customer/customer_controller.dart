import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/users/user_repository.dart';
import 'package:healplus_panel/features/shop/models/user_model.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

class CustomerController extends TBaseController<UserModel> {
  static CustomerController get instance => Get.find();
  final _custonerRepository = Get.put(UserRepository());
  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(UserModel item) async {
    return await _custonerRepository.deleteUser(item.id ?? '');
  }

  @override
  Future<List<UserModel>> fetchItems() async {
    return await _custonerRepository.fetchAllUser();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel o) => o.fullName.toString().toLowerCase(),
    );
  }
}
