import 'package:click_n_collect/Pages/Shops_Categories_edit_screen.dart';
import 'package:click_n_collect/Pages/product_Categories_edit_screen.dart';
import 'package:flutter/material.dart';

class CategoryEditScreen extends StatefulWidget {
  const CategoryEditScreen({Key? key}) : super(key: key);

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue, // Set the background color of the TabBar
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Products Category'),
                Tab(text: 'Shops Category'),
              ],
              indicatorColor: Colors.white, // Set the color of the selection indicator
              unselectedLabelColor: Colors.grey.shade300, // Set the color of the unselected tabs
              labelColor: Colors.white, // Set the color of the selected tab
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: 1, // Specify the number of items
                  itemBuilder: (context, index) {
                    return ProductCategoryEditScreen();
                  },
                ),
                ListView.builder(
                  itemCount: 1, // Specify the number of items
                  itemBuilder: (context, index) {
                    return ShopCategoryEditScreen();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
