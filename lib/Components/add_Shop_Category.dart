import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'mytextfield.dart';

class AddShopCategory extends StatefulWidget {
  const AddShopCategory({Key? key}) : super(key: key);

  @override
  _AddShopCategoryState createState() => _AddShopCategoryState();
}

class _AddShopCategoryState extends State<AddShopCategory> {
  bool _showForm = false;
  bool _isUploading = false;
  final TextEditingController categoryNameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImageAndSaveData() async {
    if (_imageFile == null) {
      print('No image selected');
      Fluttertoast.showToast(
        msg: 'No image selected',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      print('Category name is empty');
      Fluttertoast.showToast(
        msg: 'Category name is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageName = '$fileName.png'; // Add .png extension to the image name
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('ShopCategory/$imageName');
      final metadata = firebase_storage.SettableMetadata(contentType: 'image/png');
      final uploadTask = ref.putFile(_imageFile!, metadata);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      final shopCategoryData = {
        'text': categoryName,
        'image': imageUrl,
        'imageName': imageName, // Save the image name with .png extension
      };

      final DocumentReference docRef =
      await FirebaseFirestore.instance.collection('ShopCategory').add(shopCategoryData);

      setState(() {
        _showForm = false;
        categoryNameController.clear();
        _imageFile = null;
        _isUploading = false;
      });

      print('Data saved successfully');

      Fluttertoast.showToast(
        msg: 'Data saved successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (error) {
      setState(() {
        _isUploading = false;
      });

      print('Error saving data: $error');

      Fluttertoast.showToast(
        msg: 'Error saving data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: _showForm ? _buildForm() : _buildAddButton(),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _showForm = true;
        });
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 50,
            ),
            Text(
              'Add Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _imageFile = File(image.path);
                  });
                }
              },
              child: Center(
                child: Card(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                        ),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : Icon(Icons.add, size: 50),
                      ),
                      if (_imageFile != null)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: categoryNameController,
              hintText: 'Category Name',
              obscureText: false,
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Material(
                color: Colors.blue,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: _uploadImageAndSaveData,
                      child: Container(
                        height: 60,
                        width: 250,
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _showForm = false;
                categoryNameController.clear();
                _imageFile = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
