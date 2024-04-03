import 'package:flutter/material.dart';
import '../Components/ProductBox_.dart';
import '../Components/Shop_Tile.dart';
import '../services/retrieve_SavedShop.dart';
import '../services/retrieve_Wishlist.dart'; // Import the retrieveShop function

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Wishlist> wishlistData = [];
  List<SavedShop> savedShopData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    retrieveWishlist().then((wishlist) {
      setState(() {
        wishlistData = wishlist;
      });
    });

    retrieveSavedShop().then((shops) {
      setState(() {
        savedShopData = shops;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Saved'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Wishlist'),
                Tab(text: 'Saved Shops'),
              ],
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              labelColor: Colors.white,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                wishlistData.isEmpty
                    ? const Center(
                  child: Text('You haven\'t saved anything yet.'),
                )
                    : ListView.builder(
                  itemCount: wishlistData.length,
                  itemBuilder: (context, index) {
                    Wishlist product = wishlistData[index];

                    return ProductBox(
                      name: product.productName,
                      image: product.imageUrl,
                      price: product.price.toString(),
                      quantity: product.size,
                      productId: product.productId,
                    );
                  },
                ),
                savedShopData.isEmpty
                    ? const Center(
                  child: Text('You haven\'t saved any shops yet.'),
                )
                    : ListView.builder(
                  itemCount: savedShopData.length,
                  itemBuilder: (context, index) {
                    SavedShop shop = savedShopData[index];

                    return ShopTile(
                      shopName: shop.shopName,
                      imageUrl: shop.imageUrl,
                      ownerName: shop.ownerName,
                      category: shop.category.toString(),
                      shopId: shop.shopId,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
