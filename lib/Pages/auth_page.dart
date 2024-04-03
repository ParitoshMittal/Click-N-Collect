import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Admin_Page.dart';
import 'Home_Page.dart';
import 'LogIn_Or_Register_Page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User? user = snapshot.data;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('Clients') // Update collection name to 'Clients'
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final bool isAdmin = snapshot.data!.get('isAdmin') ?? false;
                    if (isAdmin) {
                      // Redirect to admin page
                      return const AdminPage(); // Replace with your admin page
                    } else {
                      // Redirect to home page
                      return const HomePage();
                    }
                  } else {
                    // If user data is not available, show login/register page
                    return const LogInOrRegisterPage();
                  }
                },
              );
            }
          }
          // If user is not signed in, show login/register page
          return const LogInOrRegisterPage();
        },
      ),
    );
  }
}
