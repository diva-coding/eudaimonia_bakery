import 'package:eudaimonia_bakery/components/auth_wrapper.dart';
// * cubit
import 'package:eudaimonia_bakery/cubit/auth/auth_cubit.dart';
import 'package:eudaimonia_bakery/cubit/cart/cart_cubit.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Account%20Management/user_detail_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Account%20Management/user_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_dashboard.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_home_page.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Order%20Management/order_detail_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Order%20Management/order_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product%20Management/product_create_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product%20Management/product_detail_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product%20Management/product_list_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Product%20Management/product_update_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Auth/LoginScreen/login_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/Auth/RegisterScreen/register.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/home_page.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/home_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/menu_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/order_history_detail_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/order_history_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/profile_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Dashboard/profileaccount_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Menu/detail_category.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Menu/detail_product.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Menu/list_type_product.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Transaction/cart_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Transaction/checkout_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Transaction/order_confirmation_screen.dart';
import 'package:eudaimonia_bakery/screens/routes/User/Transaction/shopping_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<CartCubit>(create: (context) => CartCubit())
      ],
      child: MaterialApp(
        title: 'Eudaimonia Bakery',
        theme: ThemeData(
        	primaryColor: const Color.fromARGB(255, 179, 126, 89),
        	fontFamily: 'Poppins'
      	),
	  debugShowCheckedModeBanner: false,
    //home: const HomePage(),
    initialRoute: '/login-screen',
        routes: {
          '/create-account': (context) => const CreateAccount(),
          '/login-screen': (context) => const AuthWrapper(allowedRole: '', child: LoginScreen()),
          // ! This route is for user accounts
          '/home-page': (context) => const AuthWrapper(allowedRole: 'user', child: HomePage()),
          '/home-screen' :(context) => const AuthWrapper(allowedRole: 'user', child: HomeScreen()),
          '/profile-screen': (context) => const AuthWrapper(allowedRole: 'user', child: ProfileScreen()),
          '/detail-category-screen': (context) => const AuthWrapper(allowedRole: 'user', child: DetailCategoryScreen()),
          '/detail-product-screen': (context) => const AuthWrapper(allowedRole: 'user', child: UserProductDetailScreen()),
          '/list-type-product': (context) => const AuthWrapper(allowedRole: 'user', child: CategoryListScreen()),
          '/menu-screen': (context) => const AuthWrapper( allowedRole: 'user', child: MenuScreen()),
          '/profile-account-screen': (context) => const AuthWrapper(allowedRole: 'user', child: AccountScreen()),
          '/shopping-cart-screen': (context) => const AuthWrapper(allowedRole: 'user', child: ShoppingCartScreen()),
          '/cart-screen': (context) => const AuthWrapper(allowedRole: 'user', child: CartScreen()),
          '/checkout-screen': (context) => const AuthWrapper(allowedRole: 'user', child: CheckoutScreen()),
          '/order-confirmation': (context) => const AuthWrapper(allowedRole: 'user', child: OrderConfirmationScreen()),
          '/order-history': (context) => const AuthWrapper(allowedRole: 'user', child: OrderHistoryScreen()),
          '/order-detail-history': (context) => const AuthWrapper(allowedRole: 'user', child: OrderDetailsScreen()),
          // ! This route is for admin accounts
          'admin-dashboard': (context) => const AuthWrapper(allowedRole: 'admin', child: AdminDashboardScreen()),
          '/admin-home-page': (context) => const AuthWrapper(allowedRole: 'admin', child: AdminHomePage()),
          '/admin-order-lists-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: OrderListScreen()),
          '/admin-order-detail-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: AdminDetailOrderScreen()),
            // ! product route (admin)
          '/admin-product-lists-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: ProductListScreen()),
          '/admin-product-detail-screen': (context) => const AuthWrapper(allowedRole: 'admin', child:  ProductDetailScreen()),
          '/admin-product-update-screen': (context) => AuthWrapper(allowedRole: 'admin', child: ProductUpdateScreen(
            productToUpdate: ModalRoute.of(context)!.settings.arguments as Product,
          )),
          '/admin-product-create-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: ProductCreateScreen()),
            // ! user route (admin)
          '/admin-user-lists-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: UserListScreen()),
          '/admin-user-detail-screen': (context) => const AuthWrapper(allowedRole: 'admin', child: UserDetailScreen()),
    }));
  }
}