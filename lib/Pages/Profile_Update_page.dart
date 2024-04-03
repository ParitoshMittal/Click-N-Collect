import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileUpdate extends StatefulWidget {
  final String userId;
  final String existingName;
  final String existingEmail;
  final String existingMobileNumber;
  final String existingAddress;

  const ProfileUpdate({super.key,
    required this.userId,
    required this.existingName,
    required this.existingEmail,
    required this.existingMobileNumber,
    required this.existingAddress,
  });

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existingName);
    emailController = TextEditingController(text: widget.existingEmail);
    mobileNumberController = TextEditingController(text: widget.existingMobileNumber);
    addressController = TextEditingController(text: widget.existingAddress);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void updateProfile() async {
    String userId = widget.userId;
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String mobileNumber = mobileNumberController.text.trim();
    String address = addressController.text.trim();

    try {
      await FirebaseFirestore.instance.collection('Clients').doc(userId).update({
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
        'address': address,
      });

      Fluttertoast.showToast(
        msg: 'Profile updated successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Map<String, String> updatedData = {
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
        'address': address,
      };
      Navigator.pop(context, updatedData);
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to update profile: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(330, 50),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
