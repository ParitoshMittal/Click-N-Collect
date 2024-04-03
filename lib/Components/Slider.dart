import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CSlider extends StatefulWidget {
  const CSlider({super.key});

  @override
  _CSliderState createState() => _CSliderState();
}

class _CSliderState extends State<CSlider> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final List<String> _bannerImageUrls = [];

  Future<void> getBanners() async {
    final QuerySnapshot querySnapshot =
    await _fireStore.collection('Banners').get();

    setState(() {
      _bannerImageUrls.clear();
      _bannerImageUrls.addAll(
        querySnapshot.docs.map((doc) => doc['image'] as String).toList(),
      );
    });
  }

  final CarouselController _carouselController = CarouselController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    getBanners();
    super.initState();
    // Start the automatic slide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _carouselController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 150.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            autoPlay: true, // Enable automatic sliding
            autoPlayInterval: const Duration(seconds: 3), // Set the slide interval
          ),
          items: _bannerImageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // Adjust the fit property
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
