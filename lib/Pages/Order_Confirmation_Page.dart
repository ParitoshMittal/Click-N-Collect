import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String address;
  final String mobileNumber;
  final String paymentTypes;

  const OrderConfirmationPage({super.key,
    required this.address,
    required this.mobileNumber,
    required this.paymentTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Mobile Number: $mobileNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Payment Type: $paymentTypes',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the action to confirm the order
                // For example, you can show a dialog or navigate to a thank you page
                navigateToThankYouPage(context);
              },
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToThankYouPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThankYouPage(),
      ),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Center(
        child: Text(
          'Thank you for your order!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
