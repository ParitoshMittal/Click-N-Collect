import 'package:click_n_collect/Components/mytextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddStore extends StatefulWidget {
  final VoidCallback onShopAdded;

  const AddStore({Key? key, required this.onShopAdded}) : super(key: key);

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  bool _showForm = false;
  bool _isUploading = false;
  final shopNameController = TextEditingController();
  final shopOwnerController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();
  final categoryController = TextEditingController();
  final emailController = TextEditingController();
  File? _imageFile;
  List<String> categories = [];

  Future<void> _uploadImageAndSaveData() async {
    if (_imageFile == null) {
      print('No image selected');
      return;
    }

    setState(() {
      _isUploading = true; // Set _isUploading to true before starting the upload process
    });

    // Validate input data
    if (shopNameController.text.isEmpty ||
        shopOwnerController.text.isEmpty ||
        categoryController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        openingTimeController.text.isEmpty ||
        closingTimeController.text.isEmpty) {
      setState(() {
        _isUploading = false; // Set _isUploading to false if any field is empty
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Upload the image file and get the download URL
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png'; // Add the ".png" extension
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('Shops/$fileName');
      final metadata = firebase_storage.SettableMetadata(contentType: 'image/png'); // Set the content type to 'image/png'
      final uploadTask = ref.putFile(_imageFile!, metadata);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      // Create the shop data
      final shopData = {
        'shopName': shopNameController.text,
        'shopOwner': shopOwnerController.text,
        'category': categoryController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'address': addressController.text,
        'openingTime': openingTimeController.text,
        'closingTime': closingTimeController.text,
        'imageUrl': imageUrl,
        'imageName': fileName, // Save the image name with the ".png" extension
      };

      // Save the shop data to Firestore
      final DocumentReference docRef = await FirebaseFirestore.instance.collection('Shops').add(shopData);
      final shopId = docRef.id;
      await docRef.update({'shopId': shopId});

      setState(() {
        _showForm = false;
        shopNameController.clear();
        shopOwnerController.clear();
        openingTimeController.clear();
        closingTimeController.clear();
        categoryController.clear();
        phoneNumberController.clear();
        emailController.clear();
        addressController.clear();
        _imageFile = null;
        _isUploading = false; // Set _isUploading to false when the process is completed
      });

      print('Data saved successfully');

      // Call the callback function to notify the parent widget
      widget.onShopAdded();
    } catch (error) {
      setState(() {
        _isUploading = false; // Set _isUploading to false if there's an error
      });
      Fluttertoast.showToast(
        msg: 'Error saving data: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('Error saving data: $error');
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final shopCategoryCollection = FirebaseFirestore.instance.collection('ShopCategory');
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
              'Add Store',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);

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
              controller: shopNameController,
              hintText: 'Shop Name',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: shopOwnerController,
              hintText: 'Owner Name',
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
              controller: phoneNumberController,
              hintText: 'Phone Number',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: addressController,
              hintText: 'Shop Address',
              obscureText: false,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: openingTimeController,
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
                  hintText: 'Opening Time',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                onTap: () {
                  _showTimePicker(context, openingTimeController);
                },
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: closingTimeController,
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
                  hintText: 'Closing Time',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                onTap: (){
                  _showTimePicker(context, closingTimeController);
                },
              ),
            ),
            const SizedBox(height: 10),
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
                shopNameController.clear();
                shopOwnerController.clear();
                openingTimeController.clear();
                closingTimeController.clear();
                categoryController.clear();
                phoneNumberController.clear();
                emailController.clear();
                addressController.clear();
                _imageFile = null;
              });
            },
          ),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      useRootNavigator: false,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final String formattedTime = pickedTime.format(context);
      setState(() {
        controller.text = formattedTime;
      });
    }
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
                      Navigator.pop(context);
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
