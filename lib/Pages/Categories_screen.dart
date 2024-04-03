import 'package:flutter/material.dart';
import '../Components/CategoriesWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ProductCategory').snapshots(),
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

          return Scaffold(
            body: ListView(
              children: [
                const SizedBox(height: 10,),
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
              ],
            ),
          );
        }
      },
    );
  }
}
