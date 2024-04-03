import 'package:click_n_collect/Components/Product_Category_Tile_List.dart';
import 'package:click_n_collect/Components/add_product_category.dart';
import 'package:flutter/material.dart';

class ProductCategoryEditScreen extends StatelessWidget {
  const ProductCategoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Column(
          children: [
            AddProductCategory(),
            Text('Category List', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            ProductCategoryTileList(),
          ],
        ),
      ),
    );
  }
}
