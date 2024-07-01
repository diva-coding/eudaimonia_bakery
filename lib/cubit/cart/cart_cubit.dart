import 'package:eudaimonia_bakery/dto/cart_item_model.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

void addToCart(BuildContext context, Product product, int quantity) {
  if (state is CartLoaded) {
    final existingItemIndex = state.cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Product already exists in cart, update quantity
      final existingItem = state.cartItems[existingItemIndex];
      final updatedQuantity = existingItem.quantity + quantity;

      if (updatedQuantity > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity exceeds available stock. Only ${product.stock - existingItem.quantity} more available.')),
        );
        return;
      }

      final updatedCartItems = List<CartItem>.from(state.cartItems);
      updatedCartItems[existingItemIndex] =
          CartItem(product: product, quantity: updatedQuantity);
      emit(CartLoaded(updatedCartItems));
    } else {
      // Product is not in cart, add a new item
      if (quantity > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity exceeds available stock. Only ${product.stock} available.')),
        );
        return;
      }

      emit(CartLoaded([
        ...state.cartItems,
        CartItem(product: product, quantity: quantity)
      ]));
    }
  } else {
    // Handle initial state or other states
    if (quantity > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity exceeds available stock. Only ${product.stock} available.')),
        );
        return;
      }
    emit(CartLoaded([CartItem(product: product, quantity: quantity)]));
  }
}

  void removeFromCart(CartItem cartItem) {
    if (state is CartLoaded) {
      final updatedCartItems = (state as CartLoaded).cartItems.where((item) => item != cartItem).toList();
      emit(CartLoaded(updatedCartItems));
    }
  }

  void increaseQuantity(CartItem cartItem) {
    if (state is CartLoaded) {
      final updatedCartItems = (state as CartLoaded).cartItems.map((item) {
        return item == cartItem
            ? CartItem(product: item.product, quantity: item.quantity + 1)
            : item;
      }).toList();
      emit(CartLoaded(updatedCartItems));
    }
  }

  void decreaseQuantity(CartItem cartItem) {
    if (state is CartLoaded) {
      if (cartItem.quantity > 1) {
        final updatedCartItems = (state as CartLoaded).cartItems.map((item) {
          return item == cartItem
              ? CartItem(product: item.product, quantity: item.quantity - 1)
              : item;
        }).toList();
        emit(CartLoaded(updatedCartItems));
      } else {
        removeFromCart(cartItem);
      }
    }
  }

  void clearCart() {
    emit(CartLoaded(const [])); // Emit a new state with an empty cart
  }

  int get totalCartPrice {
    return (state as CartLoaded)
        .cartItems
        .fold(0, (sum, item) => sum + item.totalPrice);
  }
}