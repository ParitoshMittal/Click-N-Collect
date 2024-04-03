import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> deleteImageAndDocument(String filepath, String categoryId, String documentId) async {
  try {
    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child(filepath);

    await imageRef.delete();
    Fluttertoast.showToast(msg: 'Image deleted successfully.');

    await FirebaseFirestore.instance.collection(categoryId).doc(documentId).delete();
    Fluttertoast.showToast(msg: 'Document deleted successfully.');
  } catch (error) {
    Fluttertoast.showToast(msg: 'Error deleting image and document: $error');
  }
}
