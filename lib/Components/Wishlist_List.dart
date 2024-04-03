import 'package:flutter/material.dart';
import '../Pages/Product_screen.dart';
import '../services/retrieve_Wishlist.dart';
import 'add_item_Box.dart';

class WishlistList extends StatefulWidget {
  const WishlistList({Key? key}) : super(key: key);

  @override
  _WishlistListState createState() => _WishlistListState();
}

class _WishlistListState extends State<WishlistList> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    List<Wishlist> wishlistItems = await retrieveWishlist();

    setState(() {
      products = wishlistItems.map((wishlistItem) => Product(
        productName: wishlistItem.productName,
        imageUrl: wishlistItem.imageUrl,
        size: wishlistItem.size,
        price: wishlistItem.price,
        productId: wishlistItem.productId,
      )).toList();
    });
  }

  void navigateToProductScreen(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: products.length + 1, // Add 1 for the final card
              separatorBuilder: (context, _) => const SizedBox(width: 5),
              itemBuilder: (BuildContext context, int index) {
                if (products.isEmpty) {
                  // No products
                  return Card(
                    elevation: 1.5,
                    child: Container(
                      height: 300,
                      width: 130,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                        child: Text(
                          "No wishlist items",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (index == products.length) {
                  // Last card
                  return Card(
                    elevation: 1.5,
                    child: Container(
                      height: 300,
                      width: 130,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                        child: Text(
                          "That's all, folks!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  Product product = products[index];
                  return GestureDetector(
                    onTap: () => navigateToProductScreen(product.productId),
                    child: Card(
                      elevation: 1.5,
                      child: Container(
                        height: 300,
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 120,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.size,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Rs. ${product.price}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            AddItemBox(productId: product.productId),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String productName;
  final String imageUrl;
  final String size;
  final String price;
  final String productId;

  Product({
    required this.productName,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.productId,
  });
}
