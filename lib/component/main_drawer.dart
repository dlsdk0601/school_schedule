import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/model/favorite_school_model.dart';
import 'package:school_schedule/screen/school_schedule_screen.dart';

import '../constant/hive_constans.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
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
            child: const Padding(
              padding: EdgeInsets.all(16.0),
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

  const FavoriteSchools({
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
    final box = await Hive.openBox<FavoriteSchoolModel>(favoriteKey);

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
    return Column(
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
    );
  }

  Widget renderListView(BuildContext context) {
    if (favoriteSchools.isEmpty) {
      return const Text("- 즐겨 찾기가 없습니다.");
    }

    return Column(
      children: favoriteSchools
          .map(
            (e) => TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SchoolScheduleScreen(favoriteSchoolModel: e);
                    },
                  ),
                );
              },
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
    );
  }
}
