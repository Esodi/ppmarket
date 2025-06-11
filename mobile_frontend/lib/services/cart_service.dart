import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addItem(CartItem item) {
    if (_items.containsKey(item.productId)) {
      _items[item.productId]!.quantity += 1;
    } else {
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity -= 1;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Add this getter that was referenced in home_screen.dart
  int get itemCount => totalItems;
}
