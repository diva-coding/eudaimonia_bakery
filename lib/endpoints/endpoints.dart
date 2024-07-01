class Endpoints{
    static const baseUrl = 'http://10.21.0.243:8000';

    static const String vouchers = "$baseUrl/vouchers";

    static const String baseURL = 
      "https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1";
  
  static const String baseURLLive = "https://simobile.singapoly.com"; 

  static const String datas = "$baseURLLive/api/datas";
  static const String news = "$baseURL/news";
  static const String categories = "$baseURL/categories";

  // endpoint ke customer service nim 2115091030
  static const String customerService = "$baseURLLive/api/customer-service/2215091030";

  // ! flask api for authentication
  static const String baseAPI = "https://pretty-grouse-noble.ngrok-free.app";
  //static const String baseAPI = "http://localhost:5000";
  //static const String baseImageAPI = "http://localhost";
  static const String login = "$baseAPI/api/v1/auth/login";
  static const String register = "$baseAPI/api/v1/auth/register";
  static const String logout = "$baseAPI/api/v1/auth/logout";
  static const String forgetPass = "$baseAPI/api/v1/auth/password_reset";
  static const String resetPass = "$baseAPI/api/v1/auth/reset_password";
  static const String validateResetToken = "$baseAPI/api/v1/auth/validate_reset_token";
  static const String syncUserData = "$baseAPI/api/v1/auth/update_profile";

  // ! flask api for admin
    // ! flask api for admin (product management)
  static const String products = "$baseAPI/api/v1/admin/products";
  static const String productCreate = "$baseAPI/api/v1/admin/products/create";
  static const String productsImageUpload = "$baseAPI/api/v1/admin/products/upload";
  static const String productUpdate = "$baseAPI/api/v1/admin/products/update";
  static const String productDelete = "$baseAPI/api/v1/admin/products/delete";
  static const String productCategories = "$baseAPI/api/v1/admin/product-categories";
  static const String productCategoryDatas = "$baseAPI/api/v1/admin/product-categories/read";
  static const String productCategoryCreate = "$baseAPI/api/v1/admin/product-categories/create";
  static const String productCategoryUpdate = "$baseAPI/api/v1/admin/product-categories/update";
  static const String productCategoryDelete = "$baseAPI/api/v1/admin/product-categories/delete";
  static const String productDataByCategory = "$baseAPI/api/v1/admin/product-categories/products-by-category/";

    // ! flask api for admin (user management)
  static const String users = "$baseAPI/api/v1/admin/users";

    // ! flask api for admin (order management)
  static const String orderStatusChange = "$orders/update";


  // ! flask api for user
    // ! flask api for user (order management)
  static const String orders = "$baseAPI/api/v1/products/orders";
  static const String orderCreate = "$orders/create";
  static const String getOrders = "$orders/read";

    // ! flask api for user (product management)
  static const String userProducts = "$baseAPI/api/v1/user/products";
  static const String userProductsByCategory = "$userProducts/bycategory";


  // ! flask api data protected
  static const String protectedData = "$baseAPI/api/v1/protected/data";
}