import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_drawer.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/school_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  List<SchoolSearchModel> schools = [];

  Future<void> fetchSchoolData(String search) async {
    try {
      final res =
          await SchoolSearchRepository.onFetch(page: page, search: search);

      setState(() {
        schools = [...schools, ...res];
      });
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("인터넷 연결이 원할하지 않습니다.")));
      }
    }
  }

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
      body: Container(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: Column(
          children: [
            SearchBar(
              onSubmitted: (String search) {
                fetchSchoolData(search);
              },
              trailing: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 28.0,
                  ),
                )
              ],
              constraints: const BoxConstraints(maxHeight: 100),
              padding: MaterialStateProperty.all(
                const EdgeInsets.fromLTRB(15, 0, 0, 0),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              hintText: "학교명을 입력하세요.",
            ),
            Expanded(
              child: ListView(
                children: schools
                    .map(
                      (e) => TextButton(
                        onPressed: () {},
                        child: Text(e.SCHUL_NM),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      )),
    );
  }
}
