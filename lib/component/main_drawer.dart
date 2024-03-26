import 'package:flutter/material.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/constant/regions.dart';

typedef OnRegionTap = void Function(String region);

class MainDrawer extends StatelessWidget {
  final String selectedRegion;
  final OnRegionTap onRegionTap;

  const MainDrawer({
    super.key,
    required this.selectedRegion,
    required this.onRegionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: lightColor,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              "지역 선택",
              style: TextStyle(
                color: whiteColor,
                fontSize: 20.0,
              ),
            ),
          ),
          ...regions.map(
            (e) => ListTile(
              tileColor: Colors.white,
              selectedColor: Colors.white,
              selectedTileColor: lightColor,
              selected: e == selectedRegion,
              title: Text(e),
              onTap: () {
                onRegionTap(e);
              },
            ),
          )
        ],
      ),
    );
  }
}
