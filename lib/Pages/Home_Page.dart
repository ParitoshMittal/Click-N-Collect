import 'package:click_n_collect/Pages/Notification.dart';
import 'package:click_n_collect/Pages/Orders.dart';
import 'package:click_n_collect/Pages/Saved.dart';
import 'package:click_n_collect/Pages/history.dart';
import 'package:click_n_collect/Pages/shop_Search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:click_n_collect/Pages/auth_page.dart';

import 'Cart_Screen.dart';
import 'Categories_screen.dart';
import 'Contact_Us.dart';
import 'Home_Screen.dart';
import 'Profile.dart';
import 'SearchPage.dart';
import 'Stores_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSearchBarExpanded = false;
  bool isTyping = false;
  TextEditingController searchController = TextEditingController();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const StoresScreen(),
    const History(),
    CartScreen(),
  ];

  Future<void> _refreshScreen() async {
    // Add your refresh logic here
    // For example, you can fetch new data from an API or reset the state

    // Simulating a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    // After completing the refresh logic, call setState to update the UI
    setState(() {
      // Update any necessary variables or data in your state
    });
  }

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearchBarExpanded) {
          setState(() {
            isSearchBarExpanded = false;
            searchController.clear();
          });
          return false; // Prevents default back navigation
        }
        return true; // Allows default back navigation
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: isSearchBarExpanded
                ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        isSearchBarExpanded = false;
                        searchController.clear();
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isTyping = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: isTyping,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _currentIndex == 2
                                ? ShopSearchPage(searchText: searchController.text)
                                : ProductSearchPage(searchText: searchController.text),
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: !isTyping,
                    child: IconButton(
                      icon: const Icon(Icons.mic_none),
                      color: Colors.black,
                      onPressed: () {
                        // Perform search operation
                      },
                    ),
                  ),
                  Visibility(
                    visible: !isTyping,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      color: Colors.black,
                      onPressed: () {
                        // Perform search operation
                      },
                    ),
                  ),
                ],
              ),
            )
                : const Text('Click-N-Collect'),
            actions: [
              if (!isSearchBarExpanded)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchBarExpanded = true;
                    });
                  },
                ),
            ],
          ),
          drawer: isSearchBarExpanded
              ? null
              : Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      'Click-N-Collect',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'lib/image/wave 1.png',
                    width: 24,
                    height: 24,
                    color: Colors.black45,
                  ),
                  title: Text(
                    'Hello ${user?.displayName ?? 'Unknown User'}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ExpansionTile(
                  leading: const Icon(Icons.person),
                  title: const Text(
                    'My Account',
                    style: TextStyle(fontSize: 20),
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'My Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Profile(userId: user!.uid),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Image.asset(
                        'lib/image/package-box.png',
                        width: 24,
                        height: 24,
                        color: Colors.black45,
                      ),
                      title: const Text(
                        'My Orders',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Orders(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text(
                        'Saved',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Saved(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text(
                    'Notification',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Notification_(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContactUsPage(),
                      ),
                    );
                  },
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
          body: RefreshIndicator(
            onRefresh: _refreshScreen,
            child: _screens[_currentIndex],
          ),
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
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        ImageIcon(
                          AssetImage(
                            'lib/image/category.png',
                          ),
                          size: 20,
                        ),
                        SizedBox(
                          height: 1,
                        )
                      ],
                    ),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.store,
                    ),
                    label: 'Stores',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.history,
                    ),
                    label: 'Order Again',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    label: 'Basket',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
