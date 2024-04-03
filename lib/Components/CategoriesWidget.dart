import 'package:flutter/material.dart';

class Category {
  final String text;
  final String imagePath;

  Category({required this.text, required this.imagePath});
}

class CategoriesWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoriesWidget({super.key, required this.categories});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  categories[index].imagePath,
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
        ),
      ),
    );
  }
}
