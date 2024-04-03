import 'package:flutter/material.dart';

import 'Order_Confirmation_Page.dart';

class PaymentOptionsPage extends StatefulWidget {
  final String address;
  final String mobileNumber;
  String paymentType;

  PaymentOptionsPage({
    required this.address,
    required this.mobileNumber,
  }) : paymentType = "";

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  void _handlePaymentTypeChange(String? value) {
    setState(() {
      widget.paymentType = value ?? ""; // Ensure a default value in case of null.
    });
  }

  void navigateToOrderConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          address: widget.address,
          mobileNumber: widget.mobileNumber,
          paymentTypes: widget.paymentType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Confirmation"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Row(
                  children: [
                    Text(
                      "Cash On Delivery",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: "Cash On Delivery",
                      groupValue: widget.paymentType,
                      onChanged: _handlePaymentTypeChange,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Row(
                  children: [
                    Text(
                      "UPI",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: "UPI",
                      groupValue: widget.paymentType,
                      onChanged: _handlePaymentTypeChange,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Row(
                  children: [
                    Text(
                      "Card",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: "Card",
                      groupValue: widget.paymentType,
                      onChanged: _handlePaymentTypeChange,
                    ),
                  ],
                ),
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
                  navigateToOrderConfirmation();
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
