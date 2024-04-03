import 'package:click_n_collect/Pages/Banner_Screen.dart';
import 'package:click_n_collect/Pages/Categorie_Edit_Screen.dart';
import 'package:click_n_collect/Pages/DashBoard_Screen.dart';
import 'package:click_n_collect/Pages/Orders_Receive_Screen.dart';
import 'package:click_n_collect/Pages/Stores_Edit_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 3;
  final List<Widget> _screens = [
    const BannerScreen(),
    StoresEditScreen(),
    const CategoryEditScreen(),
    const OrderReceiveScreen(),
  ];

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Admin Panel'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'LogOut',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () => signUserOut(context),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    ImageIcon(
                      AssetImage('lib/image/billboard.png',),
                      size: 20,
                    ),
                    SizedBox(height: 3,)
                  ],
                ),
                label: 'Banners',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.store,
                ),
                label: 'Stores',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    ImageIcon(
                      AssetImage('lib/image/category.png',),
                      size: 20,
                    ),
                    SizedBox(height: 3,),
                  ],
                ),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    ImageIcon(
                      AssetImage('lib/image/package-box.png',),
                      size: 20,
                    ),
                    SizedBox(height: 3,),
                  ],
                ),
                label: 'Orders',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
