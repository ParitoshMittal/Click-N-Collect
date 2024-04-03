import 'package:click_n_collect/Components/mytextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  final String shopId;

  const AddProduct({Key? key, required this.shopId}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _showForm = false;
  bool _isUploading = false;
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final barcodeController = TextEditingController();
  final priceController = TextEditingController();
  final productSizeController = TextEditingController();
  final categoryController = TextEditingController();
  File? _imageFile;
  List<String> categories = [];

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

    final productName = productNameController.text.trim();
    if (productName.isEmpty) {
      print('Product name is empty');
      Fluttertoast.showToast(
        msg: 'Product name is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final description = descriptionController.text.trim();
    if (description.isEmpty) {
      print('Description is empty');
      Fluttertoast.showToast(
        msg: 'Description is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final barcodeNumber = barcodeController.text.trim();
    if (barcodeNumber.isEmpty) {
      print('Barcode number is empty');
      Fluttertoast.showToast(
        msg: 'Barcode number is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final price = priceController.text.trim();
    if (price.isEmpty) {
      print('Price is empty');
      Fluttertoast.showToast(
        msg: 'Price is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final productSize = productSizeController.text.trim();
    if (productSize.isEmpty) {
      print('Product size is empty');
      Fluttertoast.showToast(
        msg: 'Product size is empty',
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
      final firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child('Products/$fileName.jpg');
      final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putFile(_imageFile!, metadata);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      final productData = {
        'productName': productName,
        'description': description,
        'barcodeNumber': barcodeNumber,
        'price': price,
        'Size': productSize,
        'imageUrl': imageUrl,
        'category': categoryController.text, // Save the selected category
        'shopId': widget.shopId,
      };

      final DocumentReference docRef =
      await FirebaseFirestore.instance.collection('Products').add(productData);
      final productId = docRef.id;
      await docRef.update({'productId': productId});

      setState(() {
        _showForm = false;
        productNameController.clear();
        descriptionController.clear();
        barcodeController.clear();
        priceController.clear();
        productSizeController.clear();
        categoryController.clear();
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
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final shopCategoryCollection = FirebaseFirestore.instance.collection('ProductCategory');
      final querySnapshot = await shopCategoryCollection.get();
      final List<String> fetchedCategories = [];

      for (final doc in querySnapshot.docs) {
        final category = doc.get('text') as String;
        fetchedCategories.add(category);
      }

      setState(() {
        categories = fetchedCategories;
      });
    } catch (error) {
      print('Error fetching categories from Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
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
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.add,
              size: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Add Product',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
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
                final ImagePicker _picker = ImagePicker();
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
                            : const Icon(Icons.add, size: 50),
                      ),
                      if (_imageFile != null)
                        IconButton(
                          icon: const Icon(
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
            const SizedBox(height: 10),
            MyTextField(
              controller: productNameController,
              hintText: 'Product Name',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: descriptionController,
              hintText: 'Description',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: barcodeController,
              hintText: 'Barcode Number',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: categoryController,
                obscureText: false,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Category',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                onTap: () {
                  _showCategoryPicker(context);
                },
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: priceController,
              hintText: 'Price',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: productSizeController,
              hintText: 'Product Size',
              obscureText: false,
            ),
            const SizedBox(height: 5),
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
                        child: const Center(
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    if (_isUploading) // Show loading indicator when uploading
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
            const SizedBox(height: 10),
          ],
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _showForm = false;
                productNameController.clear();
                descriptionController.clear();
                barcodeController.clear();
                priceController.clear();
                productSizeController.clear();
                _imageFile = null;
              });
            },
          ),
        ),
      ],
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (String category in categories)
                  ListTile(
                    title: Text(category),
                    onTap: () {
                      setState(() {
                        categoryController.text = category;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
