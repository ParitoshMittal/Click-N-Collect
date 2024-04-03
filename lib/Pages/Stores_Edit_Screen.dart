import 'package:click_n_collect/services/delete_Firebase_Data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/Shop_Tile_admin.dart';
import '../Components/add_store.dart';
import 'Shops_Edit_Screen.dart';

class Shop {
  final String shopName;
  final String imageUrl;
  final String ownerName;
  final String category;
  final String shopId;
  final String imageName;

  Shop({
    required this.shopName,
    required this.imageUrl,
    required this.ownerName,
    required this.category,
    required this.shopId,
    required this.imageName,
  });
}

class StoresEditScreen extends StatelessWidget {
  const StoresEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const _StoresEditPage(),
        );
      },
    );
  }
}

class _StoresEditPage extends StatefulWidget {
  const _StoresEditPage({Key? key}) : super(key: key);

  @override
  _StoresEditPageState createState() => _StoresEditPageState();
}

class _StoresEditPageState extends State<_StoresEditPage> {
  Future<List<Shop>>? _shopsFuture;
  List<Shop> _filteredShops = [];
  String _searchText = '';
  bool _isSearchEnabled = true;

  @override
  void initState() {
    super.initState();
    _shopsFuture = _fetchShopsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AddStore(onShopAdded: _refreshShops),
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
              ),
            ),
            const Text(
              'Stores List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5,),
            StoreList(),
          ],
        ),
      ),
    );
  }

  Widget StoreList() {
    return FutureBuilder<List<Shop>>(
      future: _shopsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final shops = snapshot.data!;
          _filteredShops = _filterShops(shops, _searchText);
          return Column(
            children: _filteredShops.map((shop) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigateToShopEditScreen(shop.shopId, shop.imageName);
                    },
                    child: ShopTileAdmin(
                      shopName: shop.shopName,
                      imageUrl: shop.imageUrl,
                      ownerName: shop.ownerName,
                      category: shop.category,
                      shopId: shop.shopId,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => _showDeleteConfirmationDialog(shop),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  Future<List<Shop>> _fetchShopsFromDatabase() async {
    final snapshot = await FirebaseFirestore.instance.collection('Shops').orderBy('shopName').get();
    final List<Shop> shops = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final shop = Shop(
        shopName: data['shopName'],
        imageUrl: data['imageUrl'],
        ownerName: data['shopOwner'],
        category: data['category'],
        imageName: data['imageName'],
        shopId: doc.id,
      );
      shops.add(shop);
    }

    // Initially, display all the shops
    _filteredShops = shops;

    return shops;
  }

  List<Shop> _filterShops(List<Shop> shops, String searchText) {
    return shops.where((shop) => shop.shopName.toLowerCase().contains(searchText.toLowerCase())).toList();
  }

  void _filterShopsBySearchText(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  void _refreshShops() {
    setState(() {
      _shopsFuture = _fetchShopsFromDatabase();
    });
  }

  void _navigateToShopEditScreen(String shopId, String imageName) async {
    setState(() {
      _isSearchEnabled = false; // Disable the search field
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopsEditScreen(
          shopId: shopId,
          imageName: imageName,
        ),
      ),
    );

    _refreshShops(); // Refresh the shop list after returning
    setState(() {
      _isSearchEnabled = true; // Re-enable the search field after returning
    });
  }


  Future<void> _showDeleteConfirmationDialog(Shop shop) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Shop'),
          content: const Text('Are you sure you want to delete this shop?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true to confirm deletion
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false to cancel deletion
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Delete the shop
      await deleteImageAndDocument('Shops/${shop.imageName}', 'Shops', shop.shopId);
      _refreshShops(); // Refresh the shop list after deletion
    }
  }
}
