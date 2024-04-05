import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/model/favorite_school_model.dart';

typedef OnRegionTap = void Function(String region);

class MainDrawer extends StatelessWidget {
  final OnRegionTap onRegionTap;

  const MainDrawer({
    super.key,
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
              "즐겨 찾기",
              style: TextStyle(
                color: whiteColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FavoriteSchools(
                    title: "시간표",
                    type: FavoriteType.SCHEDULE,
                  ),
                  FavoriteSchools(
                    title: "급식표",
                    type: FavoriteType.MEAL,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteSchools extends StatefulWidget {
  final String title;
  final FavoriteType type;

  FavoriteSchools({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<FavoriteSchools> createState() => _FavoriteSchoolsState();
}

class _FavoriteSchoolsState extends State<FavoriteSchools> {
  List<FavoriteSchoolModel> favoriteSchools = [];

  Future<void> getList() async {
    final box = await Hive.openBox<FavoriteSchoolModel>("favorites");

    List<FavoriteSchoolModel> list =
        box.values.where((element) => element.type == widget.type).toList();

    setState(() {
      favoriteSchools = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          renderListView(context),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  Widget renderListView(BuildContext context) {
    if (favoriteSchools.isEmpty) {
      return const Text("- 즐겨 찾기가 없습니다.");
    }

    return Container(
      child: Column(
        children: favoriteSchools
            .map(
              (e) => TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "sunflower",
                    ),
                  ),
                ),
                child: Text("- ${e.SCHUL_NM}"),
              ),
            )
            .toList(),
      ),
    );
  }
}
