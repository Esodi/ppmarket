import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItemWidget extends StatelessWidget {
  final Product product;

  const CartItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.image, size: 40),
      title: Text(product.name),
      subtitle: Text('${product.price.toStringAsFixed(2)} ${product.currency}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // TODO: Implement item removal from cart state
        },
      ),
    );
  }
}
