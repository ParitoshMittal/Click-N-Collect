import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopList extends StatelessWidget {
  const ShopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Shops').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        final shops = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: shops.length,
          itemBuilder: (BuildContext context, int index) {
            final shopData = shops[index].data();
            final imageUrl = shopData['imageUrl'] as String?;
            final shopName = shopData['shopName'] as String?;
            final address = shopData['address'] as String?;
            final ownerName = shopData['ownerName'] as String?;

            return Card(
              child: Column(
                children: [
                  ShopList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
