import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayedBanners extends StatefulWidget {
  const DisplayedBanners({Key? key}) : super(key: key);

  @override
  State<DisplayedBanners> createState() => _DisplayedBannersState();
}

class _DisplayedBannersState extends State<DisplayedBanners> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Banners').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<Map<String, dynamic>> banners = snapshot.data!.docs
                .map((QueryDocumentSnapshot document) {
              final String documentName = document.id;
              final String imageUrl = document.get('image') as String;
              return {'documentName': documentName, 'imageUrl': imageUrl};
            }).toList();

            return Column(
              children: banners
                  .map((Map<String, dynamic> banner) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      banner['imageUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        iconSize: 18,
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDeleteConfirmationDialog(banner['documentName']);
                        },
                      ),
                    ),
                  ),
                ],
              ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog(String documentName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: const Text('Do you want to delete this banner from Click-N-Collect Application?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteBanner(documentName);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBanner(String documentName) async {
    try {
      await FirebaseFirestore.instance
          .collection('Banners')
          .doc(documentName)
          .delete();
    } catch (error) {
      print('Error deleting banner: $error');
    }
  }
}
