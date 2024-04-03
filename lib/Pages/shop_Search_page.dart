import 'package:click_n_collect/Components/Shop_Tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopSearchPage extends StatefulWidget {
  const ShopSearchPage({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  _ShopSearchPageState createState() => _ShopSearchPageState();
}

class _ShopSearchPageState extends State<ShopSearchPage> {
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

  void fetchShops(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Shops')
        .get();

    final List<Map<String, dynamic>> shops = [];
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      shops.add(data as Map<String, dynamic>);
    });

    final filteredShops = searchShops(query, shops);

    setState(() {
      filteredList = filteredShops;
    });
  }

  List<Map<String, dynamic>> searchShops(String query, List<Map<String, dynamic>> shops) {
    // Preprocess the search query by removing stop words, applying stemming, etc.
    List<String> keywords = preprocessQuery(query);

    // Create an empty result list
    List<Map<String, dynamic>> results = [];

    // Iterate through each shop
    for (Map<String, dynamic> shop in shops) {
      // Check if the shop's name or owner name contains any of the keywords
      if (containsKeywords(shop, keywords)) {
        // Add the shop to the results list
        results.add(shop);
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

  bool containsKeywords(Map<String, dynamic> shop, List<String> keywords) {
    String shopName = shop['shopName'].toString().toLowerCase();
    String ownerName = shop['ownerName'].toString().toLowerCase();

    for (String keyword in keywords) {
      if (shopName.contains(keyword) || ownerName.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  int calculateRelevanceScore(Map<String, dynamic> shop, List<String> keywords) {
    int score = 0;

    String shopName = shop['shopName'].toString().toLowerCase();
    String ownerName = shop['ownerName'].toString().toLowerCase();

    for (String keyword in keywords) {
      if (shopName.contains(keyword)) {
        // Increment the score if the keyword is found in the shop's name
        score += 2;
      }

      if (ownerName.contains(keyword)) {
        // Increment the score if the keyword is found in the owner's name
        score += 1;
      }
    }

    return score;
  }

  void filterList(String query) {
    if (query.isNotEmpty) {
      fetchShops(query);
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
                (shop) => ShopTile(
              shopName: shop['shopName'].toString(),
              imageUrl: shop['imageUrl'].toString(),
              ownerName: shop['ownerName'].toString(),
              category: shop['category'].toString(),
              shopId: shop['shopId'].toString(),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
