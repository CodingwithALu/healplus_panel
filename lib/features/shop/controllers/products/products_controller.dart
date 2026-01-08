import 'package:healplus_panel/data/abstract/base_data_table_controller.dart';
import 'package:healplus_panel/data/repositories/products/produts_repository.dart';
import 'package:healplus_panel/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends TBaseController<ProductModel> {
  static ProductController get instace => Get.find();
  final _productRepository = Get.put(ProductRepository());
  @override
  bool containsSearchQuery(ProductModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.elements!.toLowerCase().contains(query.toLowerCase()) ||
        item.quantity.toString().contains(query.toLowerCase()) ||
        item.price.toString().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    return await _productRepository.deleteProducts(item.idp);
  }

  @override
  Future<List<ProductModel>> fetchItems() async {
    return await _productRepository.fetchProducts();
  }

  // sort bay name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ProductModel item) => item.name.toLowerCase()),
    );
  }

  // sort bay name
  void sortByPrice(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ProductModel item) => item.price),
    );
  }

  // sort bay name
  void sortByTock(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ProductModel item) => item.quantity),
    );
  }

  // sort bay name
  void sortBySoldItem(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      ((ProductModel item) => item.sold),
    );
  }

  // get the product price or price range for valiation
  String getProductPrice(ProductModel product) {
    return product.ide.toString();
    // if (product.productType == ProductType.single.toString() ||
    //     product.productVariations!.isEmpty) {
    //   return (product.salePrices > 0.0 ? product.salePrices : product.price)
    //       .toString();
    // } else {
    //   double smallestPrice = double.infinity;
    //   double largePrice = 0.0;
    //   for (var variation in product.productVariations!) {
    //     double priceToconsider = variation.salePrice > 0.0
    //         ? variation.salePrice
    //         : variation.price;
    //     if (priceToconsider < smallestPrice) {
    //       smallestPrice = priceToconsider;
    //     }
    //     if (priceToconsider > largePrice) {
    //       largePrice = priceToconsider;
    //     }
    //   }
    //   if (smallestPrice.isEqual(largePrice)) {
    //     return largePrice.toString();
    //   } else {
    //     return '$smallestPrice - \$$largePrice';
    //   }
    // }
  }

  // Calculate Discount Percentage
  String? calulateSalePercantage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;
    double percentahe = ((originalPrice = salePrice) / originalPrice * 100);
    return percentahe.toStringAsFixed(0);
  }

  // Calulate Product Stock
  String getProductStockTotal(ProductModel product) {
    return product.quantity.toString();
    // return product.productType == ProductType.single.toString()
    //     ? product.quantity.toString()
    //     : product.productVariations!
    //           .fold<int>(
    //             0,
    //             (previousValie, elment) => previousValie + elment.stock,
    //           )
    //           .toString();
  }

  // Calulate Product Sold Quantity
  String getProductSoldQuantity(ProductModel product) {
    return product.sold.toString();
    // return product.productType == ProductType.single.toString()
    //     ? product.soldQuantity.toString()
    //     : product.productVariations!
    //           .fold<int>(
    //             0,
    //             (previousValie, elment) => previousValie + elment.soldQuantity,
    //           )
    //           .toString();
  }

  // Check Product Stock Status
  String getProductStockStatus(ProductModel product) {
    return product.quantity > 0 ? 'In Stock' : 'Out of Stock';
  }
}
