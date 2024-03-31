import 'package:flutter/material.dart';

import '../constant/colors.dart';
import 'main_drawer.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget body;

  const MainLayoutScreen({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        onRegionTap: (String region) {
          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(
        title: const Text(
          "시간표 마스터",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: lightColor,
      ),
      body: SafeArea(child: body),
    );
  }
}
