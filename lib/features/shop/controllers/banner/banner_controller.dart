import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/banners/banner_repository.dart';
import 'package:healplus_panel/features/shop/models/banner_model.dart';
import 'package:get/get.dart';

class BannerController extends TBaseController<BannerModel> {
  static BannerController get instance => Get.find();
  final _bannerRepository = Get.put(BannerRepository());
  @override
  bool containsSearchQuery(item, String query) {
    return item.targetScreen.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(item) async {
    await _bannerRepository.deleteBanners(item.id ?? '');
  }

  @override
  Future<List<BannerModel>> fetchItems() async {
    return await _bannerRepository.fetchAllBanners();
  }

  // methood fomartting a route string;
  String fromatRoute(String route) {
    if (route.isEmpty) return '';
    String formatted = route.substring(1);
    formatted = formatted[0].toUpperCase() + formatted.substring(1);
    return formatted;
  }

  // sort by name
  void sortByParentRout(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((BannerModel item) => item.targetScreen.toLowerCase()),
    );
  }
}
