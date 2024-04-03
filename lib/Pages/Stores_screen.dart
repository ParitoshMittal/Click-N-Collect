import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/CategoriesWidget.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('ShopCategory').get(),
        builder: (context, snapshot) {
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

            return ListView(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Shop',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CategoriesWidget(categories: categories),
              ],
            );
          }
        },
      ),
    );
  }
}
