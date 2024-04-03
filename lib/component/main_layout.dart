import 'package:flutter/material.dart';

import '../constant/colors.dart';
import 'main_drawer.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget body;
  final String? title;

  const MainLayoutScreen({super.key, required this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        onRegionTap: (String region) {
          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(
        title: Text(
          title ?? "시간표 마스터",
          style: const TextStyle(
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
