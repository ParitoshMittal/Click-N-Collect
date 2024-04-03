import 'package:click_n_collect/Components/ProductBox_.dart';
import 'package:flutter/material.dart';
class CategorizedList extends StatelessWidget {
  const CategorizedList({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductBox(name: 'productName', image: 'imageUrl', price: 'price', quantity: 'Size', productId: 'porductId',)
          ],
        ),
      ),
    );
  }
}