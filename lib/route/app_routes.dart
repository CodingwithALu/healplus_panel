import 'package:healplus_panel/features/authentication/screens/login/forget_password/forget_password.dart';
import 'package:healplus_panel/features/authentication/screens/login/login.dart';
import 'package:healplus_panel/features/authentication/screens/logouts/logout.dart';
import 'package:healplus_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:healplus_panel/features/media/screens/media/media.dart';
import 'package:healplus_panel/features/personalization/screen/settings/settings.dart';
import 'package:healplus_panel/features/shop/screens/banners/all_banners/banners_screen.dart';
import 'package:healplus_panel/features/shop/screens/banners/create_banners/create_banners_screen.dart';
import 'package:healplus_panel/features/shop/screens/banners/edit_banners/edit_banners.dart';
import 'package:healplus_panel/features/shop/screens/brands/all_brands/all_brands.dart';
import 'package:healplus_panel/features/shop/screens/brands/create_brands/create_brands.dart';
import 'package:healplus_panel/features/shop/screens/brands/edit_brands/edit_brands.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/all_categories/category_screen.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/create_ingredinet/categoris_create.dart';
import 'package:healplus_panel/features/shop/screens/ingredient/edit_categories/edit_category.dart';
import 'package:healplus_panel/features/shop/screens/customers/all_customers/customer_screen.dart';
import 'package:healplus_panel/features/shop/screens/customers/customer_details/customer_details_screen.dart';
import 'package:healplus_panel/features/shop/screens/dashboard/dashboard_screen.dart';
import 'package:healplus_panel/features/shop/screens/language/language.dart';
import 'package:healplus_panel/features/shop/screens/orders/all_order/order_screen.dart';
import 'package:healplus_panel/features/shop/screens/orders/detail_order/orders_details_screen.dart';
import 'package:healplus_panel/features/shop/screens/products/all_products/product_screen.dart';
import 'package:healplus_panel/features/shop/screens/products/create_products/create_product_screen.dart';
import 'package:healplus_panel/features/personalization/screen/profiles/profiles.dart';
import 'package:healplus_panel/features/shop/screens/products/edit_products/edit_products.dart';
import 'package:healplus_panel/route/route.dart';
import 'package:healplus_panel/route/routes_middleware.dart';
import 'package:get/route_manager.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => LoginScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => ForgetPasswordScreen()),
    GetPage(
      name: TRoutes.dashboard,
      page: () => const DashBoardScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.media,
      page: () => const MediaScreen(),
      middlewares: [TRouteMiddleware()],
    ),

    // Categories
    GetPage(
      name: TRoutes.categories,
      page: () => const CategoryScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.createCategory,
      page: () => const CategorisCreateScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.editCategory,
      page: () => const EditCategoryScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    // Brands
    GetPage(
      name: TRoutes.brands,
      page: () => const BrandsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.createBrand,
      page: () => const CreateBrandsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.editbrand,
      page: () => const EditBrandsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.banners,
      page: () => const BannersScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.createBanner,
      page: () => const CreateBannersScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.editBanner,
      page: () => const EditBannersScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.products,
      page: () => const ProductScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.createProduct,
      page: () => const CreateProductScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.customers,
      page: () => const CustomerScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.detailsCustomers,
      page: () => const CustomerDeatilsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.orders,
      page: () => const OrderScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.detailsOrders,
      page: () => const OrdersDetailsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.settings,
      page: () => const SettingsSreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.profile,
      page: () => const ProfilesScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.editProduct,
      page: () => const EditProductsScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.logout,
      page: () => const LogoutScreen(),
      middlewares: [TRouteMiddleware()],
    ),
    GetPage(
      name: TRoutes.language,
      page: () => const LanguageScreen(),
      middlewares: [TRouteMiddleware()],
    ),
  ];
}
