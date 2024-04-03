import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:click_n_collect/Components/add_product.dart';
import 'package:click_n_collect/Components/product_Tile_Admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Components/Shop_card.dart';

class ShopsEditScreen extends StatefulWidget {
  const ShopsEditScreen({Key? key, required this.shopId, required this.imageName})
      : super(key: key);

  final String shopId;
  final String imageName;

  @override
  _ShopsEditScreenState createState() => _ShopsEditScreenState();
}

class _ShopsEditScreenState extends State<ShopsEditScreen> {
  bool isRefreshing = false; // Track the refreshing state
  bool _isSearchEnabled = true; // Track the search bar state
  String _searchText = ''; // Store the current search text

  Future<void> deleteProduct(String productId) async {
    try {
      // Delete product image from Firebase Storage
      final productImageRef =
      firebase_storage.FirebaseStorage.instance.ref().child(productId);
      await productImageRef.delete();
    } catch (e) {
      // Handle error deleting product image from Firebase Storage
      print('Error deleting product image: $e');
    }

    // Delete product document from Firestore collection
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(productId)
        .delete();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product deleted successfully')),
    );

    // Trigger a refresh of the product list
    setState(() {
      isRefreshing = true;
    });
  }

  void _filterShopsBySearchText(String searchText) {
    setState(() {
      _searchText = searchText.toLowerCase().trim();
    });
  }

  Future<void> _confirmDeleteShop() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to delete this shop and its associated products?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the deletion
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the deletion
              },
            ),
          ],
        );
      },
    );

    // Check if the deletion is confirmed
    if (confirmed != null && confirmed) {
      try {
        try {
          await FirebaseFirestore.instance.collection('Shops').doc(widget.shopId).delete();

          final shopImageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(widget.shopId);
          await shopImageRef.delete();

          final productsSnapshot = await FirebaseFirestore.instance
              .collection('Products')
              .where('shopId', isEqualTo: widget.shopId)
              .get();

          for (final doc in productsSnapshot.docs) {
            final productId = doc.id;
            final productImageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(productId);
            await productImageRef.delete();
            await doc.reference.delete();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Shop and associated products deleted successfully')),
          );

          Navigator.of(context).pop();
        } catch (e) {
          print('Error deleting shop, shop image, and associated products: $e');
        }

        Navigator.of(context).pop();
      } catch (e) {
        print('Error deleting shop, shop image, and associated products: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: RefreshIndicator(
          onRefresh: () async {
            // Perform manual refresh action
            setState(() {
              isRefreshing = true;
            });
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    ShopCard(shopId: widget.shopId),
                    const SizedBox(
                      height: 10.0,
                    ),
                    AddProduct(shopId: widget.shopId),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        enabled: _isSearchEnabled,
                        onChanged: (value) => _filterShopsBySearchText(value),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        style: TextStyle(color: Colors.black), // Add this line to set the text color
                      ),
                    ),
                    Text(
                      'Product List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        // Perform manual refresh action
                        setState(() {
                          isRefreshing = true;
                        });
                      },
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Products')
                            .where('shopId', isEqualTo: widget.shopId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (snapshot.data == null ||
                              snapshot.data!.docs.isEmpty) {
                            return Text('No products found.');
                          }

                          if (isRefreshing) {
                            // Reset the refreshing state after the refresh action
                            isRefreshing = false;
                          }

                          final filteredProducts = snapshot.data!.docs.where((document) {
                            final productData = document.data() as Map<String, dynamic>;
                            final productName = productData['productName'].toString().toLowerCase();
                            return productName.contains(_searchText);
                          }).toList();

                          if (filteredProducts.isEmpty) {
                            return Text('No products found matching the search criteria.');
                          }

                          return Column(
                            children: filteredProducts.map((DocumentSnapshot document) {
                              final productId = document.id;
                              final productData = document.data() as Map<String, dynamic>;

                              final productName = productData['productName'] as String? ?? '';
                              final imageUrl = productData['imageUrl'] as String? ?? '';
                              final description = productData['description'] as String? ?? '';
                              final price = productData['price'] as String? ?? '';
                              final size = productData['Size'] as String? ?? '';
                              final imageName = productData['imageName'] as String? ?? '';
                              final category = productData['category'] as String? ?? '';

                              return ProductTile(
                                // Pass the fetched data to the product tile
                                productId: productId,
                                productName: productName,
                                imageUrl: imageUrl,
                                description: description,
                                price: price,
                                size: size,
                                imageName: imageName,
                                category: category, // Pass the category value to the product tile
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: _confirmDeleteShop,
        ),
      ),
    );
  }
}
