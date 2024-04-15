import 'package:flutter/material.dart';
import 'package:school_schedule/screen/home_screen.dart';

import '../constant/colors.dart';
import 'main_drawer.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;

  const MainLayoutScreen(
      {super.key, required this.body, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext builder) {
                  return const HomeScreen();
                }));
              },
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              )),
          ...?actions
        ],
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
