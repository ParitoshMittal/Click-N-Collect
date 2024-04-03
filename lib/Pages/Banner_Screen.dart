import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/Displayed_Banners.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  File? image;
  bool showPreview = false;
  bool isUploading = false;
  List<String> storedBanners = [];

  @override
  void initState() {
    super.initState();
    fetchStoredBanners();
  }

  Future<void> fetchStoredBanners() async {
    try {
      final bannersRef = firebase_storage.FirebaseStorage.instance.ref('Banners');
      final bannersList = await bannersRef.listAll();

      setState(() {
        storedBanners = bannersList.items.map((item) => item.fullPath).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch stored banners: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      setState(() {
        image = imageTemporary;
        showPreview = true;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to Pick Image: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<String?> uploadImageToStorage() async {
    if (image == null) return null;

    final fileName = path.basename(image!.path);
    final destination = 'Banners/$fileName';

    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref(destination);
    await firebaseStorageRef.putFile(image!);

    return await firebaseStorageRef.getDownloadURL();
  }

  Future<void> createDocument(String imageUrl) async {
    try {
      final bannersCollection = FirebaseFirestore.instance.collection('Banners');
      await bannersCollection.add({
        'image': imageUrl,
      });

      Fluttertoast.showToast(
        msg: 'Document created successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to create document: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> uploadImage() async {
    if (image == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      final imageUrl = await uploadImageToStorage();
      if (imageUrl != null) {
        await createDocument(imageUrl);

        resetImage();
        fetchStoredBanners(); // Refresh the stored banner list
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to upload image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to upload image: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> deleteImage(String bannerPath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Banner'),
          content: const Text('Are you sure you want to delete this banner?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await firebase_storage.FirebaseStorage.instance.ref(bannerPath).delete();
                  Fluttertoast.showToast(
                    msg: 'Banner deleted successfully!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                  // Refresh the stored banner list
                  fetchStoredBanners();
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Failed to delete banner: $e',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                }
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void resetImage() {
    setState(() {
      image = null;
      showPreview = false;
    });
  }

  void resetCard() {
    resetImage();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: const Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                        child: Icon(Icons.add, size: 50),
                      ),
                      Text(
                        'Add Banner',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showPreview)
              Column(
                children: [
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Stack(
                        children: [
                          if (image != null) ...[
                            Image.file(
                              image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: resetImage,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 70,
                    width: 370,
                    child: ElevatedButton(
                      onPressed: isUploading ? null : uploadImage,
                      child: isUploading ? const CircularProgressIndicator() : const Text('Upload Image'),
                    ),
                  ),
                ],
              ),
            const Text(
              'Showed Banner',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const DisplayedBanners(),
            const Text(
              'Stored Banners',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Column(
                  children: storedBanners.map((bannerPath) {
                    return FutureBuilder(
                      future: firebase_storage.FirebaseStorage.instance.ref(bannerPath).getDownloadURL(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      iconSize: 18,
                                      icon: const Icon(
                                        Icons.upload,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        uploadIcon(context, bannerPath);
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  right: 10,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      iconSize: 18,
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Delete functionality
                                        deleteImage(bannerPath);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void uploadIcon(BuildContext context, String bannerPath) async {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Upload Banner'),
        content: const Text('Do you want to upload this banner to Click-N-Collect application?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(dialogContext).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog
              Navigator.of(dialogContext).pop();

              try {
                final imageUrl = await firebase_storage.FirebaseStorage.instance.ref(bannerPath).getDownloadURL();

                // Create a new document in the Banners collection
                final firestore = FirebaseFirestore.instance;
                await firestore.collection('Banners').add({
                  'image': imageUrl,
                });

                Fluttertoast.showToast(
                  msg: 'Banner uploaded successfully!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              } catch (e) {
                Fluttertoast.showToast(
                  msg: 'Failed to upload banner: $e',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
