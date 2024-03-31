import 'package:flutter/material.dart';

import '../constant/colors.dart';

class AdLayout extends StatelessWidget {
  final double? height;

  const AdLayout({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      color: Colors.black,
      child: const Center(
        child: Text(
          "광고 자리",
          style: TextStyle(color: whiteColor),
        ),
      ),
    );
  }
}
