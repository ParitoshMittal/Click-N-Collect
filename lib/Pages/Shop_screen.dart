import 'package:click_n_collect/Components/ProductBox_.dart';
import 'package:click_n_collect/Components/Shop_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/save.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key, required this.shopId, required this.shopName}) : super(key: key);
  final String shopName;
  final String shopId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopName),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10,),
                ShopCard(shopId: shopId),
                const SizedBox(height: 10,),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .where('shopId', isEqualTo: shopId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final products = snapshot.data!.docs;
                      return Column(
                        children: products.map((product) {
                          final productData = product.data() as Map<String, dynamic>;
                          return ProductBox(
                            name: productData['productName'].toString(),
                            image: productData['imageUrl'].toString(),
                            price: productData['price'].toString(),
                            quantity: productData['size'].toString(),
                            productId: productData['productId'].toString(),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            Save(collectionName: 'SavedShops', documentId: shopId),
          ]
        ),
      ),
    );
  }
}
