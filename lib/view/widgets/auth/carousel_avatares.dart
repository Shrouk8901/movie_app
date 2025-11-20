import 'package:carousel_slider/carousel_slider.dart'
    show CarouselSlider, CarouselOptions, CarouselPageChangedReason;
import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/styles/app_assets.dart';

class CarouselAvatares extends StatelessWidget {
  const CarouselAvatares({super.key, required this.onPageChanged});

  final Function(int, CarouselPageChangedReason) onPageChanged;

  final List<String> avatars = const [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return CarouselSlider.builder(
      itemCount: avatars.length,
      itemBuilder: (context, index, _) => CircleAvatar(
        backgroundImage: AssetImage(avatars[index]),
        radius: screenSize.height * 0.2,
      ),
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        enlargeFactor: .5,
        viewportFraction: 0.35,
        height: screenSize.height * 0.2,
        initialPage: 0,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
