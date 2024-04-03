import 'package:flutter/material.dart';
import '../Components/Ordertile.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String date='19-06-2023';
  String total='700';
  String items = '4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Orders'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Ordertile(total: total,date: date,items: items, time: '16:30',),
          ],
        ),
      ),
    );
  }
}
