import 'package:flutter/material.dart';
import '../Pages/Shop_screen.dart';

class ShopTile extends StatelessWidget {
  const ShopTile({
    Key? key,
    required this.shopName,
    required this.imageUrl,
    required this.ownerName,
    required this.category,
    required this.shopId,
  }) : super(key: key);

  final String shopName;
  final String imageUrl;
  final String ownerName;
  final String category;
  final String shopId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopScreen(shopId: shopId, shopName: shopName,),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: [
            SizedBox(width: 5.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Owner: $ownerName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Category: $category',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // Add more Text widgets to display additional information as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}
