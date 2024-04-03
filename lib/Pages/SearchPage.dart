import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Components/ProductBox_.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  bool isSearchBarExpanded = false;
  bool isTyping = false;
  late TextEditingController searchController;
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchText);
    filterList(widget.searchText);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchProducts(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .get();

    final List<Map<String, dynamic>> products = [];
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      products.add(data as Map<String, dynamic>);
    });

    final filteredProducts = searchProducts(query, products);

    setState(() {
      filteredList = filteredProducts;
    });
  }

  List<Map<String, dynamic>> searchProducts(String query, List<Map<String, dynamic>> products) {
    // Preprocess the search query by removing stop words, applying stemming, etc.
    List<String> keywords = preprocessQuery(query);

    // Create an empty result list
    List<Map<String, dynamic>> results = [];

    // Iterate through each product
    for (Map<String, dynamic> product in products) {
      // Check if the product's name or description contains any of the keywords
      if (containsKeywords(product, keywords)) {
        // Add the product to the results list
        results.add(product);
      }
    }

    // Sort the results by relevance score
    results.sort((a, b) => calculateRelevanceScore(b, keywords) - calculateRelevanceScore(a, keywords));

    // Return the sorted results
    return results;
  }

  List<String> preprocessQuery(String query) {
    // Implement your preprocessing steps here (e.g., removing stop words, stemming, etc.)
    // Return a list of individual keywords
    return query.toLowerCase().split(' ');
  }

  bool containsKeywords(Map<String, dynamic> product, List<String> keywords) {
    String productName = product['productName'].toString().toLowerCase();
    String productDescription = product['description'].toString().toLowerCase();

    for (String keyword in keywords) {
      if (productName.contains(keyword) || productDescription.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  int calculateRelevanceScore(Map<String, dynamic> product, List<String> keywords) {
    int score = 0;

    String productName = product['productName'].toString().toLowerCase();
    String productDescription = product['description'].toString().toLowerCase();

    for (String keyword in keywords) {
      if (productName.contains(keyword)) {
        // Increment the score if the keyword is found in the product's name
        score += 2;
      }

      if (productDescription.contains(keyword)) {
        // Increment the score if the keyword is found in the product's description
        score += 1;
      }
    }

    return score;
  }

  void filterList(String query) {
    if (query.isNotEmpty) {
      fetchProducts(query);
    } else {
      setState(() {
        filteredList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    filterList('');
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
                      filterList(value);
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    // Perform search operation
                    filterList(searchController.text);
                  });
                },
              ),
            ],
          ),
        )
            : Text(widget.searchText),
        actions: [
          if (!isSearchBarExpanded)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearchBarExpanded = true;
                  searchController.text = widget.searchText; // Set the text
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: filteredList
              .map(
                (product) => ProductBox(
                  name: product['productName'].toString(),
                  image: product['imageUrl'].toString(),
                  price: product['price'].toString(),
                  quantity: product['Size'].toString(),
                  productId: product['productId'].toString(),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
