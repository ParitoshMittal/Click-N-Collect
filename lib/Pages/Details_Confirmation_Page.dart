import 'package:click_n_collect/Components/mytextfield.dart';
import 'package:click_n_collect/Pages/orders_Details.dart';
import 'package:flutter/material.dart';
import 'payment_options_page.dart';

class DetailsConfirmationPage extends StatefulWidget {
  @override
  _DetailsConfirmationPageState createState() =>
      _DetailsConfirmationPageState();
}

class _DetailsConfirmationPageState extends State<DetailsConfirmationPage> {
  String Name = '';
  String mobileNumber = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Confirmation"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              "Customer Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10,),
            MyTextField(
              controller: nameController,
              hintText: 'Customer Name',
              obscureText: false,
            ),
            const SizedBox(height: 10,),
            const Text(
              "Mobile Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10,),
            MyTextField(
              controller: mobileNumberController,
              hintText: 'Mobile Number',
              obscureText: false,
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
                  navigateToOrderDetails();
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToOrderDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => orderDetails(Name: nameController.text, mobileNumber: mobileNumberController.text,)),
    );
  }
}
