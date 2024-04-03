import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Save extends StatefulWidget {
  final String collectionName;
  final String documentId;

  const Save({
    Key? key,
    required this.collectionName,
    required this.documentId,
  }) : super(key: key);

  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  bool isFavorite = false;

  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String userId = user?.uid ?? '';

    return Positioned(
      bottom: 10,
      right: 10,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserServices')
            .doc(userId)
            .collection(widget.collectionName)
            .doc(widget.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          IconData iconData = Icons.favorite_border;
          Color iconColor = Colors.grey;

          if (snapshot.hasData && snapshot.data!.exists) {
            iconData = Icons.favorite;
            iconColor = Colors.red;
          }

          return FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              if (snapshot.hasData && snapshot.data!.exists) {
                // Delete the document from the collection
                await FirebaseFirestore.instance
                    .collection('UserServices')
                    .doc(userId)
                    .collection(widget.collectionName)
                    .doc(widget.documentId)
                    .delete();
              } else {
                // Create the document in the collection with the Id field
                await FirebaseFirestore.instance
                    .collection('UserServices')
                    .doc(userId)
                    .collection(widget.collectionName)
                    .doc(widget.documentId)
                    .set({
                  'Id': widget.documentId,
                  // Additional fields
                });
              }
            },
            child: Icon(
              iconData,
              color: iconColor,
            ),
          );
        },
      ),
    );
  }
}
