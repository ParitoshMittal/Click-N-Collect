import 'package:flutter/material.dart';
import '../Pages/Shop_screen.dart';
import '../services/retrieve_PastShop.dart';

class PastShopList extends StatefulWidget {
  const PastShopList({Key? key}) : super(key: key);

  @override
  _PastShopListState createState() => _PastShopListState();
}

class _PastShopListState extends State<PastShopList> {
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
    fetchPastShops();
  }

  Future<void> fetchPastShops() async {
    List<PastShop> pastShops = await retrievePastShop();

    setState(() {
      shops = pastShops.map((pastShop) => Shop(
        shopName: pastShop.shopName,
        imageUrl: pastShop.imageUrl,
        ownerName: pastShop.ownerName,
        category: pastShop.category,
        shopId: pastShop.shopId,
      )).toList();
    });
  }

  void navigateToShopScreen(String shopId, String shopName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopScreen(shopId: shopId, shopName: shopName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        itemCount: shops.length + 1, // Add 1 for the final card
        separatorBuilder: (context, _) => const SizedBox(width: 5),
        itemBuilder: (BuildContext context, int index) {
          if (shops.isEmpty) {
            // No shops
            return Card(
              elevation: 1.5,
              child: Container(
                height: 300,
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Center(
                  child: Text(
                    "No past shops",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else if (index == shops.length) {
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
            Shop shop = shops[index];

            return GestureDetector(
              onTap: () => navigateToShopScreen(shop.shopId, shop.shopName),
              child: Card(
                elevation: 1.5,
                child: Container(
                  height: 250, // Adjust the height of the card here
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
                            shop.imageUrl,
                            width: 120,
                            height: 120, // Adjust the image size here
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          shop.shopName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          shop.category,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class Shop {
  final String shopName;
  final String imageUrl;
  final String ownerName;
  final String category;
  final String shopId;

  Shop({
    required this.shopName,
    required this.imageUrl,
    required this.ownerName,
    required this.category,
    required this.shopId,
  });
}
