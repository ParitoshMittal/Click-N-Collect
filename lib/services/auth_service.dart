import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _clientsCollection =
  FirebaseFirestore.instance.collection('Clients');

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      // Check if the user already exists in the database
      final clientDoc = await _clientsCollection.doc(user?.uid).get();
      if (!clientDoc.exists) {
        await _clientsCollection.doc(user?.uid).set({
          'userId': user?.uid,
          'name': user?.displayName,
          'email': user?.email,
          'mobileNumber': '',
          'address': '',
          'isAdmin': false,
        });
      } else {
        // User already exists, update only specific fields if needed
        await _clientsCollection.doc(user?.uid).set(
          {
            'name': user?.displayName,
            'email': user?.email,
          },
          SetOptions(merge: true),
        );
      }

      return userCredential;
    }

    throw FirebaseAuthException(
      code: 'sign_in_canceled',
      message: 'Sign in with Google was canceled.',
    );
  }
}
