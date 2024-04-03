import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userServicesCollection =
  FirebaseFirestore.instance.collection('UserServices');

  Future<void> saveValue(String collectionName, String value) async {
    try {
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';
      String documentId = value;

      await _userServicesCollection
          .doc(userId)
          .collection(collectionName)
          .doc(documentId)
          .set({'productId': value});

      print('Value saved successfully.');
    } catch (e) {
      print('Error saving value: $e');
    }
  }

  Future<List<String>> getProductIds(String collectionName) async {
    try {
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';

      QuerySnapshot querySnapshot = await _userServicesCollection
          .doc(userId)
          .collection(collectionName)
          .get();

      List<String> productIds = [];
      querySnapshot.docs.forEach((doc) {
        productIds.add(doc.id);
      });

      return productIds;
    } catch (e) {
      print('Error retrieving product IDs: $e');
      return [];
    }
  }

  Future<bool> checkIfProductIdExists(
      String collectionName, String productId) async {
    try {
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';

      DocumentSnapshot documentSnapshot = await _userServicesCollection
          .doc(userId)
          .collection(collectionName)
          .doc(productId)
          .get();

      return documentSnapshot.exists;
    } catch (e) {
      print('Error checking if product ID exists: $e');
      return false;
    }
  }

  Future<void> deleteDocumentByProductId(
      String collectionName, String productId) async {
    try {
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';

      QuerySnapshot querySnapshot = await _userServicesCollection
          .doc(userId)
          .collection(collectionName)
          .where('productId', isEqualTo: productId)
          .get();

      List<Future<void>> deleteFutures = [];
      querySnapshot.docs.forEach((doc) {
        deleteFutures.add(doc.reference.delete());
      });

      await Future.wait(deleteFutures);
      print('Document(s) with productId "$productId" deleted successfully.');
    } catch (e) {
      print('Error deleting document(s) by productId: $e');
    }
  }
}
