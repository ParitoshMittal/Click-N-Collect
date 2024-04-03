import 'package:click_n_collect/Components/CategoriesWidget.dart';
import 'package:click_n_collect/services/delete_Firebase_Data.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String description;
  final String price;
  final String size;
  final String productId;
  final String imageName;
  final String category;

  const ProductTile({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.description,
    required this.price,
    required this.size,
    required this.productId, required this.imageName, required this.category,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      size,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rs. ${price.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 24,
                  onPressed: () => deleteImageAndDocument('Products/$imageName', 'Products', productId),
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
