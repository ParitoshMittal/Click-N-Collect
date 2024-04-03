import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastProduct {
  final String productName;
  final String imageUrl;
  final String size;
  final String price;
  final String productId;

  PastProduct({
    required this.productName,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.productId,
  });
}

Future<List<PastProduct>> retrievePastOrders() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  String userId = user?.uid ?? '';
  List<String> ids = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('UserServices')
        .doc(userId)
        .collection("PastOrder")
        .get();

    querySnapshot.docs.forEach((doc) {
      String id = doc.get('Id');
      ids.add(id);
    });

    List<PastProduct> products = [];

    QuerySnapshot<Map<String, dynamic>> productsSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('productId', whereIn: ids)
        .get();

    productsSnapshot.docs.forEach((doc) {
      String productName = doc.get('productName');
      String imageUrl = doc.get('imageUrl');
      String size = doc.get('Size');
      String price = doc.get('price');
      String productId = doc.get('productId');

      PastProduct product = PastProduct(
        productName: productName,
        imageUrl: imageUrl,
        size: size,
        price: price,
        productId: productId,
      );

      products.add(product);
    });

    return products;
  } catch (e) {
    print('Error retrieving IDs from Firebase: $e');
    return [];
  }
}
