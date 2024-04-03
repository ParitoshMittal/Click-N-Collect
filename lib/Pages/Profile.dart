import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Profile_Update_page.dart';
class Profile extends StatefulWidget {
  final String userId;

  const Profile({super.key, required this.userId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  String mobileNumber = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    String userId = widget.userId;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Clients')
          .doc(userId)
          .get();

      setState(() {
        name = snapshot['name'];
        email = snapshot['email'];
        mobileNumber = snapshot['mobileNumber'];
        address = snapshot['address'];
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch profile data: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.account_circle,
                  size: 175,
                  color: Colors.blue,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    email,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    mobileNumber,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileUpdate(
                        userId: widget.userId,
                        existingName: name,
                        existingEmail: email,
                        existingMobileNumber: mobileNumber,
                        existingAddress: address,
                      ),
                    ),
                  ).then((updatedData) {
                    if (updatedData != null) {
                      setState(() {
                        name = updatedData['name'];
                        email = updatedData['email'];
                        mobileNumber = updatedData['mobileNumber'];
                        address = updatedData['address'];
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(330, 50),
                ),
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}