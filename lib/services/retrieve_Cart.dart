import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart {
  final String productName;
  final String imageUrl;
  final String size;
  final String price;
  final String productId;

  Cart({
    required this.productName,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.productId,
  });
}

Future<List<Cart>> retrieveCart() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userId = user?.uid ?? '';
  List<String> ids = [];
  List<int> itemCounts = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('UserServices')
        .doc(userId)
        .collection("Cart")
        .get();

    for (var doc in querySnapshot.docs) {
      String id = doc.get('Id');
      int count = doc.get('itemCount') as int;
      ids.add(id);
      itemCounts.add(count);
    }

    List<Cart> products = [];

    QuerySnapshot<Map<String, dynamic>> productsSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('productId', whereIn: ids)
        .get();

    for (var doc in productsSnapshot.docs) {
      String productName = doc.get('productName');
      String imageUrl = doc.get('imageUrl');
      String size = doc.get('Size');
      String price = doc.get('price');
      String productId = doc.get('productId');

      Cart product = Cart(
        productName: productName,
        imageUrl: imageUrl,
        size: size,
        price: price,
        productId: productId,
      );

      products.add(product);
    }

    return products;
  } catch (e) {
    print('Error retrieving IDs from Firebase: $e');
    return [];
  }
}

Future<double> calculateTotalPrice() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userId = user?.uid ?? '';
  List<int> itemCounts = [];
  List<Cart> productList= await retrieveCart();
  double totalPrice = 0;
  try{
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('UserServices')
        .doc(userId)
        .collection("Cart")
        .get();

    for (var doc in querySnapshot.docs) {
      int count = doc.get('itemCount') as int;
      itemCounts.add(count);
    }
  }
  catch(e) {
    print('Error retrieving IDs from Firebase: $e');
  }

  for (int i = 0; i < productList.length; i++) {
    double price = double.parse(productList[i].price);
    int count = itemCounts[i];
    totalPrice += price * count;
  }

  return totalPrice;
}
