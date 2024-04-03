import 'package:click_n_collect/Components/add_item_Box.dart';
import 'package:click_n_collect/Pages/Payment_Options_Page.dart';
import 'package:flutter/material.dart';

import '../services/retrieve_Cart.dart';

class Cart {
  final String productName;
  final String imageUrl;
  final String size;
  final String price;
  final String productId;

  Cart({
    required this.productName,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.productId,
  });
}

class orderDetails extends StatefulWidget {
  final String Name;
  final String mobileNumber;

  const orderDetails({super.key, required this.Name, required this.mobileNumber});

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  List<Cart> cartItems = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _calculateTotalPrice();
  }

  void _loadCartItems() async {
    List<Cart> items = (await retrieveCart()).cast<Cart>();
    setState(() {
      cartItems = items;
    });
  }

  void _calculateTotalPrice() async {
    double total = await calculateTotalPrice();
    setState(() {
      totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Your Details',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Name:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        const Spacer(),
                        Text(widget.Name,style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Mobile:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        const Spacer(),
                        Text(widget.mobileNumber,style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Products List",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  // Show cart items here
                  for (var cartItem in cartItems)
                    Card(
                      child: Row(
                        children: [
                          Card(
                            child: Image.network(cartItem.imageUrl),
                          ),
                          Column(
                            children: [
                              Text(cartItem.productName,style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),),
                              Text(cartItem.size),
                              Row(
                                children: [
                                  Text(cartItem.price,style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  AddItemBox(productId: cartItem.productId),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      const Spacer(),
                      Text('Total Price: $totalPrice'), // Show total price here
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  navigateToPayment();
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentOptionsPage(address: widget.Name, mobileNumber: widget.mobileNumber,)),
    );
  }
}
