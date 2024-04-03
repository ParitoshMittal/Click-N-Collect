import 'package:click_n_collect/Components/notificationtile.dart';
import 'package:flutter/material.dart';

class Notification_ extends StatelessWidget {
  const Notification_({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body:const  Column(
        children: [
          NotificationTile(orderid: '342425523'),
        ],
      ),
    );
  }
}
