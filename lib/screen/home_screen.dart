import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/school_repository.dart';
import 'package:school_schedule/screen/search_class_screen.dart';

import '../constant/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MainLayoutScreen(
      body: MainSearchBarView(),
    );
  }
}

class MainSearchBarView extends StatefulWidget {
  const MainSearchBarView({super.key});

  @override
  State<MainSearchBarView> createState() => _MainSearchBarViewState();
}

class _MainSearchBarViewState extends State<MainSearchBarView> {
  String search = "";
  List<SchoolSearchModel> schools = [];

  Future<void> fetchSchoolData() async {
    try {
      final res = await SchoolSearchRepository.onFetch(page: 1, search: search);

      setState(() {
        // 페이지네이션을 고려하지 않는다. limit 이 100 으로 고정 해놨는데, 100개가 넘는 검새 결과가 나올 경우가 없다.
        schools = res;
      });
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("인터넷 연결이 원할 하지 않습니다.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
      child: Column(
        children: [
          SearchBar(
            onSubmitted: (String search) {
              fetchSchoolData();
            },
            onChanged: (String value) {
              setState(() {
                search = value;
              });
            },
            trailing: [
              IconButton(
                onPressed: () {
                  fetchSchoolData();
                },
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
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView(
              children: schools
                  .map(
                    (e) => TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SearchClassScreen(school: e);
                        }));
                      },
                      child: Text(e.SCHUL_NM),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 100,
            color: Colors.black,
            child: const Center(
              child: Text(
                "광고 자리",
                style: TextStyle(color: whiteColor),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
