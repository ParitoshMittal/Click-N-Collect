import 'package:click_n_collect/Components/Ordertile.dart';
import 'package:flutter/material.dart';

class OrderReceiveScreen extends StatelessWidget {
  const OrderReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Placed Order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              Ordertile(date: '27/06/2023', total: '500', items: '5', time: '16:20',),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Packed Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Ordertile(date: '27/06/2023', total: '600', items: '7', time: '14:30',),
            ],
          ),
        ),
      ),
    );
  }
}
