import 'package:click_n_collect/Components/Shops_Category_Tile_List.dart';
import 'package:click_n_collect/Components/add_Shop_Category.dart';
import 'package:flutter/material.dart';

class ShopCategoryEditScreen extends StatelessWidget {
  const ShopCategoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Column(
          children: [
            AddShopCategory(),
            Text('Category List', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            ShopsCategoryTileList(),
          ],
        ),
      ),
    );
  }
}
