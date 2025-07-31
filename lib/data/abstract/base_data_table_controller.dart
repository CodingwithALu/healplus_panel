import 'package:healplus_panel/l10n/app_localizations.dart';
import 'package:healplus_panel/utils/constants/colors.dart';
import 'package:healplus_panel/utils/constants/sizes.dart';
import 'package:healplus_panel/utils/popups/full_screen_loader.dart';
import 'package:healplus_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class TBaseController<T> extends GetxController {
  RxBool isLoading = false.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  final searchTextController = TextEditingController();
  @override
  void onInit() {
    // implement onInit
    fetchData();
    super.onInit();
  }

  /// Abtrach method to be implemented by subclasses for fetching items
  Future<List<T>> fetchItems();

  // Function FetchData
  void fetchData() async {
    try {
      isLoading.value = true;
      List<T> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems = await fetchItems();
      }
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(allItems);
      selectedRows.assignAll(List.generate(allItems.length, (_) => false));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.ohSnap,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sort by parentName
  void sortByProperty(int columnIndex, bool ascending, Function(T) property) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
  }

  // Search
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  // Delete Categories
  void confirmAndDeleteItem(T item) {
    final local = AppLocalizations.of(Get.context!)!;
    // show a confirmation dialog
    Get.defaultDialog(
      title: local.deleteItem,
      content: Text(local.deleteItemConfirmation),
      actions: [
        SizedBox(
          width: 60,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
              ),
            ),
            onPressed: () async => await deleteOnConfirm(item),
            child: Text(local.ok),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields),
        SizedBox(
          width: 60,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: TColors.darkerGrey.withAlpha(128),
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
              ),
            ),
            onPressed: () => Get.back(),
            child: Text(local.cancel),
          ),
        ),
      ],
    );
  }

  deleteOnConfirm(T item) async {
    try {
      final local = AppLocalizations.of(Get.context!)!;
      // Loader
      TFullScreenLoader.stopLoading();
      // Start the loader
      TFullScreenLoader.popUpCirular();
      // Delete FrieStore
      await deleteItem(item);
      removeItemFromLists(item);
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: local.itemDeleted,
        message: local.itemDeletedMessage,
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalizations.of(Get.context!)!.ohSnap,
        message: e.toString(),
      );
    }
  }

  /// Method for removing an item from the lists
  void removeItemFromLists(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
    update();
  }

  void addItemToList(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
    filteredItems.refresh();
  }

  // update Category to Data List
  void updateItemFormList(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);
    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;
    filteredItems.refresh();
  }

  /// Abtrach method to be implemented by subclasses for checking if an item contains the search query
  bool containsSearchQuery(T item, String query);

  /// Abtrach method to be implemented by subclasses for delete an item.
  Future<void> deleteItem(T item);
}
