// ignore_for_file: unused_field

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomScrollImages extends StatefulWidget {
  const CustomScrollImages({
    super.key,
    required this.height,
    required this.autoPlay,
    required this.imageUrlList,
  });

  final bool autoPlay;
  final double height;
  final List<String> imageUrlList;

  @override
  State<CustomScrollImages> createState() => _CustomScrollImagesState();
}

class _CustomScrollImagesState extends State<CustomScrollImages> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              animateToClosest: true,
              height: widget.height,
              viewportFraction: 1.0,  // Ensure it takes full width
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: widget.autoPlay,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: widget.imageUrlList.map((dynamic url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
