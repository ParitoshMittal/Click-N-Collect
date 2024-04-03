import 'package:click_n_collect/Components/Shop_Tile.dart';
import 'package:click_n_collect/services/retrieve_PastOrders.dart';
import 'package:click_n_collect/services/retrieve_PastShop.dart';
import 'package:flutter/material.dart';
import '../Components/ProductBox_.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<PastProduct> pastOrdersData = [];
  List<PastShop> pastShopsData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    retrievePastOrders().then((pastOrders) {
      setState(() {
        pastOrdersData = pastOrders;
      });
    });

    retrievePastShop().then((pastShops) {
      setState(() {
        pastShopsData = pastShops;
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
    return Material(
      child: Column(
        children: [
          Container(
            color: Colors.blue, // Set the background color of the TabBar
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Past Orders'),
                Tab(text: 'Past Shops'),
              ],
              indicatorColor: Colors.white, // Set the color of the selection indicator
              unselectedLabelColor: Colors.grey[400], // Set the color of the unselected tabs
              labelColor: Colors.white, // Set the color of the selected tab
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                pastOrdersData.isEmpty
                    ? const Center(
                  child: Text('You have no past orders yet.'),
                )
                    : ListView.builder(
                  itemCount: pastOrdersData.length,
                  itemBuilder: (context, index) {
                    PastProduct product = pastOrdersData[index];

                    return ProductBox(
                      name: product.productName,
                      image: product.imageUrl,
                      price: product.price.toString(),
                      quantity: product.size,
                      productId: product.productId,
                    );
                  },
                ),
                pastShopsData.isEmpty
                    ? const Center(
                  child: Text('You have no past shops yet.'),
                )
                    : ListView.builder(
                  itemCount: pastShopsData.length,
                  itemBuilder: (context, index) {
                    PastShop shop = pastShopsData[index];

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
