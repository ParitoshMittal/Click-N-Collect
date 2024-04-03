import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemBox extends StatefulWidget {
  final String productId;

  const AddItemBox({Key? key, required this.productId}) : super(key: key);

  @override
  State<AddItemBox> createState() => _AddItemBoxState();
}

class _AddItemBoxState extends State<AddItemBox> {
  int itemCount = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  late String userId;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    userId = user?.uid ?? '';
    _fetchItemCount();
  }

  Future<void> _fetchItemCount() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot<Map<String, dynamic>> cartSnapshot =
    await firestore
        .collection('UserServices')
        .doc(userId)
        .collection('Cart')
        .doc(widget.productId)
        .get();

    if (cartSnapshot.exists) {
      final cartData = cartSnapshot.data();
      if (cartData != null) {
        setState(() {
          itemCount = cartData['itemCount'] ?? 0;
        });
      }
    }
  }

  Future<void> _updateItemCount() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userServicesRef =
    firestore.collection('UserServices').doc(userId);
    final DocumentReference cartRef =
    userServicesRef.collection('Cart').doc(widget.productId);

    if (itemCount > 0) {
      final Map<String, dynamic> cartData = {
        'productId': widget.productId,
        'itemCount': itemCount,
      };

      await cartRef.set(cartData);
    } else {
      await cartRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 35,
          width: 105,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Colors.lightBlue,
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (itemCount > 0) {
                      itemCount--;
                      _updateItemCount();
                    }
                  });
                },
              ),
              Text('$itemCount'),
              IconButton(
                color: Colors.lightBlue,
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    itemCount++;
                    _updateItemCount();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
