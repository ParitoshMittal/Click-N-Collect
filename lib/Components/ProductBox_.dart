import 'package:click_n_collect/Components/add_item_Box.dart';
import 'package:flutter/material.dart';

import '../Pages/Product_screen.dart';

class ProductBox extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String quantity;
  final String productId;

  const ProductBox({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  int itemCount = 0;

  void navigateToProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(productId: widget.productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToProductScreen, // Navigate to ProductScreen when tapped
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Adjust the value to control the roundness
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.image,
                  alignment: Alignment.center,
                  height: 125,
                  width: 125,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 3,),
                    Text(
                      'Rs. ${widget.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3,),
                    Text('Quantity: ${widget.quantity}'),
                    const SizedBox(height: 5,),
                    AddItemBox(productId: widget.productId,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
