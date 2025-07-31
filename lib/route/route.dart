class TRoutes {
  static const login = '/login';
  static const forgetPassword = '/forget-password';
  static const resetPassword = '/reset-password';

  static const dashboard = '/dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProduct';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/ceateCategory';
  static const editCategory = '/editCategory';

  static const brands = '/communitys';
  static const createBrand = '/createCommunity';
  static const editbrand = '/editCommunity';

  static const customers = '/customers';
  static const detailsCustomers = '/detailsCustomers';
  static const deleteCustomers = '/deleteCustomers';

  static const orders = '/orders';
  static const detailsOrders = '/detailsOrders';
  static const deleteOrders = '/deleteOrders';

  static const logout = '/logout';
  static const settings = '/settings';
  static const profile = '/profile';
  static const coupons = '/coupons';
  static const language = '/language';

  static List<String> sidebarMenuItems = [
    dashboard,
    forgetPassword,
    resetPassword,
    media,
    categories,
    createCategory,
    editCategory,
    brands,
    banners,
    createBanner,
    editBanner,
    editbrand,
    logout,
    products,
    createProduct,
    editProduct,
    customers,
    detailsCustomers,
    deleteCustomers,
    orders,
    detailsOrders,
    deleteOrders,
    settings,
    profile,
    coupons,
    createBrand,
  ];
}
