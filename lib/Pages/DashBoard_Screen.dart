import 'package:flutter/material.dart';
import 'package:click_n_collect/Pages/Stores_Edit_Screen.dart';

import '../Components/Displayed_Banners.dart';
import '../Components/Shops_List.dart';

class DashboardScreen extends StatelessWidget {
  final StoresEditScreen storesEditScreen = const StoresEditScreen();

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling even if the content is not overflowing
        child: Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height), // Set a minimum height for the container
          child: const Material(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Showed Banner',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DisplayedBanners(),
                Text(
                  'Stores List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
