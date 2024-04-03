import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagepath;
  final bool isLoading;
  final Function()? onTap;
  final String text;

  const SquareTile({
    Key? key,
    required this.isLoading,
    required this.imagepath,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 325,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? Center(child: const CircularProgressIndicator()) // Show loading indicator
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagepath, height: 40),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
