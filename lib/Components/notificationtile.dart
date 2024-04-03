import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String orderid;

  const NotificationTile({Key? key, required this.orderid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Adjust the padding as desired
          child: Row(
            children: [
              const Icon(
                Icons.receipt,
                size: 50,
                color: Colors.blue,
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Order $orderid is Packed',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Your order $orderid is packed, please collect your order',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
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
