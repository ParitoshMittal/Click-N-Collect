import 'package:flutter/material.dart';

import '../services/delete_Firebase_Data.dart';

class Category {
  final String imageUrl;
  final String imageName;
  final String text;
  final String documentId;

  Category({
    required this.imageUrl,
    required this.imageName,
    required this.text,
    required this.documentId,
  });
}

class CategoriesEditWidget extends StatefulWidget {
  final List<Category> categories;
  final String category;

  const CategoriesEditWidget({
    Key? key,
    required this.categories,
    required this.category,
  }) : super(key: key);

  @override
  _CategoriesEditWidgetState createState() => _CategoriesEditWidgetState();
}

class _CategoriesEditWidgetState extends State<CategoriesEditWidget> {
  List<Category> get categories => widget.categories;

  void deleteCategory(int index) {
    final category = categories[index];
    deleteImageAndDocument(category.imageName, widget.category, category.documentId);

    setState(() {
      categories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildGridItems(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    return List.generate(
      categories.length,
          (index) => Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      categories[index].imageUrl,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text(
                        categories[index].text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  child: IconButton(
                    iconSize: 18,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () => deleteCategory(index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
