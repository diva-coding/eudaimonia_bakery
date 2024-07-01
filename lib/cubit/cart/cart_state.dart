part of 'cart_cubit.dart';

@immutable
abstract class CartState {
  List<CartItem> get cartItems;
}

class CartInitial extends CartState {
  @override
  List<CartItem> get cartItems => []; // Empty cart for the initial state
}

class CartLoading extends CartState {
  @override
  List<CartItem> get cartItems => []; // Empty cart while loading
}

class CartLoaded extends CartState {
  @override
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);
}