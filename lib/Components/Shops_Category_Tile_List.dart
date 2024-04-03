import 'package:click_n_collect/services/delete_Firebase_Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopsCategoryTileList extends StatefulWidget {
  const ShopsCategoryTileList({Key? key}) : super(key: key);

  @override
  State<ShopsCategoryTileList> createState() => _ShopsCategoryTileListState();
}

class _ShopsCategoryTileListState extends State<ShopsCategoryTileList> {
  late Stream<QuerySnapshot> categoryStream;

  @override
  void initState() {
    super.initState();
    categoryStream = FirebaseFirestore.instance.collection('ShopCategory').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> categoryData = [];
        snapshot.data!.docs.forEach((doc) {
          categoryData.add({
            'imageUrl': doc['image'],
            'text': doc['text'],
            'documentId': doc.id,
            'imageName': doc['imageName'],
          });
        });

        return Column(
          children: [
            for (var category in categoryData)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          category['imageUrl'],
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          category['text'],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text('Are you sure you want to delete this category?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteImageAndDocument('ShopCategory/${category['imageName']}', 'ShopCategory', category['documentId']);
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
