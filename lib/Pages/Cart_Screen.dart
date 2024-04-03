import 'package:click_n_collect/Components/ProductBox_.dart';
import 'package:click_n_collect/Pages/Details_Confirmation_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/retrieve_Cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late double totalPrice = 0.0;
  Stream<List<Cart>>? cartItemsStream;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    cartItemsStream = retrieveCartStream();
    double calculatedTotalPrice = await calculateTotalPrice();

    setState(() {
      totalPrice = calculatedTotalPrice.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Cart>>(
              stream: cartItemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Cart> cartItems = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      Cart cartItem = cartItems[index];
                      return ProductBox(
                        name: cartItem.productName,
                        image: cartItem.imageUrl,
                        price: cartItem.price,
                        quantity: cartItem.size,
                        productId: cartItem.productId,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error retrieving cart items');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<double>(
                stream: calculateTotalPriceStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double updatedTotalPrice = snapshot.data!;
                    totalPrice = updatedTotalPrice.toDouble();
                    return Text(
                      'Total: Rs.${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error calculating total price');
                  } else {
                    return Text(
                      'Total: Rs.${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  navigateToOrderConfirmation();
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToOrderConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsConfirmationPage()),
    );
  }
}

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

Stream<List<Cart>> retrieveCartStream() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userId = user?.uid ?? '';

  return FirebaseFirestore.instance
      .collection('UserServices')
      .doc(userId)
      .collection("Cart")
      .snapshots()
      .asyncMap((querySnapshot) async {
    List<Cart> cartItems = [];

    for (var doc in querySnapshot.docs) {
      String id = doc.get('productId');
      List<Cart> products = await retrieveProduct(id);

      if (products.isNotEmpty) {
        Cart product = products.first;
        cartItems.add(Cart(
          productName: product.productName,
          imageUrl: product.imageUrl,
          size: product.size,
          price: product.price,
          productId: product.productId,
        ));
      }
    }

    return cartItems;
  });
}

Future<List<Cart>> retrieveProduct(String productId) async {
  QuerySnapshot<Map<String, dynamic>> productsSnapshot =
  await FirebaseFirestore.instance
      .collection('Products')
      .where('productId', isEqualTo: productId)
      .get();

  List<Cart> products = [];

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
}

Stream<double> calculateTotalPriceStream() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userId = user?.uid ?? '';

  return FirebaseFirestore.instance
      .collection('UserServices')
      .doc(userId)
      .collection("Cart")
      .snapshots()
      .asyncMap((querySnapshot) async {
    double totalPrice = 0;

    for (var doc in querySnapshot.docs) {
      int count = doc.get('itemCount') as int;
      String productId = doc.get('productId');
      List<Cart> products = await retrieveProduct(productId);

      if (products.isNotEmpty) {
        double price = double.parse(products.first.price);
        totalPrice += price * count;
      }
    }

    return totalPrice;
  });
}
