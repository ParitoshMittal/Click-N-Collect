import 'package:click_n_collect/Components/add_item_Box.dart';
import 'package:click_n_collect/Components/save.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/User_Services.dart';
import 'SearchPage.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int itemCount = 0;
  late Future<DocumentSnapshot<Map<String, dynamic>>> productFuture;
  bool isSearchBarExpanded = false;
  bool isTyping = false;
  final TextEditingController searchController = TextEditingController();
  UserServices userServices = UserServices();
  late IconData iconData;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    productFuture = getProductDetails();
    iconData = Icons.favorite_border;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProductDetails() async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productId)
        .get();
    return productSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final productData = snapshot.data?.data();

        String category = '';
        if (productData?['category'] is num) {
          category = '\$${(productData?['category'] as num).toStringAsFixed(2)}';
        } else {
          category = productData?['category'] ?? '';
        }

        String size = '';
        if (productData?['Size'] is num) {
          size = '\$${(productData?['Size'] as num).toStringAsFixed(2)}';
        } else {
          size = productData?['Size'] ?? '';
        }

        String price = '';
        if (productData?['price'] is num) {
          price = '\$${(productData?['price'] as num).toStringAsFixed(2)}';
        } else {
          price = productData?['price'] ?? '';
        }

        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: isSearchBarExpanded
                  ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          isSearchBarExpanded = false;
                          searchController.clear();
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isTyping = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: isTyping,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.black,
                        onPressed: () {
                          // Perform search operation
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductSearchPage(
                                searchText: searchController.text,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: !isTyping,
                      child: IconButton(
                        icon: const Icon(Icons.mic_none),
                        color: Colors.black,
                        onPressed: () {
                          // Perform search operation
                        },
                      ),
                    ),
                    Visibility(
                      visible: !isTyping,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        color: Colors.black,
                        onPressed: () {
                          // Perform search operation
                        },
                      ),
                    ),
                  ],
                ),
              )
                  : Text(productData?['productName'] ?? 'Product Name Not Available'),
              actions: [
                if (!isSearchBarExpanded)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearchBarExpanded = true;
                      });
                    },
                  ),
              ],
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        productData?['productName'] ?? '',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image.network(
                            productData?['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Save(collectionName: 'Wishlist', documentId: widget.productId,)
                      ]
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text(
                            'Category: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text(
                            'Product Size: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            size,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Text(
                                'Price: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        AddItemBox(productId: widget.productId),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        productData?['description'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
        );
      },
    );
  }
}
