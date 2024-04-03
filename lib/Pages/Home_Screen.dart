import 'package:click_n_collect/Components/PastShopList.dart';
import 'package:click_n_collect/Components/Past_Product_list.dart';
import 'package:click_n_collect/Components/Saved_Shop_List.dart';
import 'package:click_n_collect/Components/Wishlist_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Components/CategoriesWidget.dart';
import '../Components/Slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('ProductCategory').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          List<Category> categories = documents.map((doc) {
            String text = doc.get('text');
            String imagePath = doc.get('image');

            return Category(text: text, imagePath: imagePath);
          }).toList();

          return Scaffold(
            body: ListView(
              children: [
                const SizedBox(height: 10),
                const CSlider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Shop By Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CategoriesWidget(categories: categories),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Wishlist',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const WishlistList(),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Saved Shops',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SavedShopList(),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Order Again',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const PastProductList(),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Shop List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const PastShopList(),
              ],
            ),
          );
        }
      },
    );
  }
}
