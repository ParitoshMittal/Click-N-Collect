import 'package:flutter/material.dart';

class OrderScreenAdmin extends StatefulWidget {
  const OrderScreenAdmin({Key? key, required this.date, required this.total, required this.items, required this.time, required this.shopName}) : super(key: key);
  final String date;
  final String total;
  final String items;
  final String time;
  final String shopName;

  @override
  State<OrderScreenAdmin> createState() => _OrderScreenAdminState();
}

class _OrderScreenAdminState extends State<OrderScreenAdmin> {
  // Define a variable to track the checkbox value
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Order ID: 2vsn4534n4n3',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Date: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Time: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.time,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs. ${widget.total}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Shop Name: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.shopName,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.items,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            ' Items',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Items List ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/click-n-collect-6d63f.appspot.com/o/Products%2F1688037005777.jpg?alt=media&token=899b7c9e-824f-4348-b9cc-8d03c45e9eeb',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bottle Art',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. 500',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Size:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '2 Bottles',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(), // Add a spacer to push the checkbox to the right
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        // Update the checkbox value
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform actions when "Packed" button is pressed
                // Example: Update the order status to "Packed"
              },
              child: const SizedBox(
                  height: 50,
                  width: 325,
                  child: Center(child: Text('Picked',style: TextStyle(fontSize: 20),))),
            ),
          ],
        ),
      ),
    );
  }
}
