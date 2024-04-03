import 'package:click_n_collect/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/Square_Tile.dart';
import '../Components/mytextfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final mobileNumberController = TextEditingController();


  bool isLoading = false;
  bool isLoading2 = false;

  void signUp() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        if (userNameController.text.isNotEmpty) {
          if (mobileNumberController.text.isNotEmpty) {
            if (mobileNumberController.text.length == 10) { // Check if mobile number has exactly 10 digits
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );

              // Update user's display name
              User? user = userCredential.user;

              CollectionReference clientsCollection = FirebaseFirestore.instance.collection('Clients');
              await clientsCollection.doc(user?.uid).set({
                'userId': user?.uid,
                'name': userNameController.text,
                'email': emailController.text,
                'mobileNumber': mobileNumberController.text,
                'address': '',
                'isAdmin': false, // Set isAdmin to false for regular users
              });

              await user?.reload();
            } else {
              errorMessage("Please enter a valid 10-digit mobile number");
            }
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Center(
                    child: Text(
                      'Please enter your mobile number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else {
          errorMessage("Please enter a username");
        }
      } else {
        errorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      errorMessage(e.code);
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }




  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.lock,
                size: 125,
              ),
              Text(
                'Welcome to our community',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: userNameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: mobileNumberController,
                hintText: 'Mobile Number',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: signUp,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),) // Show loading indicator
                        : const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () async {
                      setState(() {
                        isLoading2 = true; // Show loading indicator
                      });
                      await AuthService().signInWithGoogle();
                      setState(() {
                        isLoading2 = false; // Hide loading indicator
                      });
                    },
                    isLoading: isLoading2,
                    imagepath: 'lib/image/google.png',
                    text: 'Google Sign Up',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'LogIn Now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
