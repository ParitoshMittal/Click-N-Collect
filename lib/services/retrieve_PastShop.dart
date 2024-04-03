import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastShop {
  final String shopName;
  final String imageUrl;
  final String ownerName;
  final String category;
  final String shopId;

  PastShop({
    required this.shopName,
    required this.imageUrl,
    required this.ownerName,
    required this.category,
    required this.shopId,
  });
}

Future<List<PastShop>> retrievePastShop() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  String userId = user?.uid ?? '';
  List<String> ids = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('UserServices')
        .doc(userId)
        .collection("PastShop")
        .get();

    querySnapshot.docs.forEach((doc) {
      String id = doc.get('Id');
      ids.add(id);
    });

    List<PastShop> shops = [];

    QuerySnapshot<Map<String, dynamic>> productsSnapshot = await FirebaseFirestore.instance
        .collection('Shops')
        .where('shopId', whereIn: ids)
        .get();

    productsSnapshot.docs.forEach((doc) {
      String shopName = doc.get('shopName');
      String imageUrl = doc.get('imageUrl');
      String ownerName = doc.get('shopOwner');
      String category = doc.get('category');
      String shopId = doc.get('shopId');

      PastShop shop = PastShop(
        shopName: shopName,
        imageUrl: imageUrl,
        ownerName: ownerName,
        category: category,
        shopId: shopId,
      );

      shops.add(shop);
    });

    return shops;
  } catch (e) {
    print('Error retrieving IDs from Firebase: $e');
    return [];
  }
}
