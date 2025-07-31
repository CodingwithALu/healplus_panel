import 'package:healplus_panel/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    //implement build
    return Center(
      child: Lottie.asset(
        TImages.defaultLoaderAnimation,
        height: 200,
        width: 200,
      ),
    );
  }
}
