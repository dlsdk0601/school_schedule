import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/school_repository.dart';
import 'package:school_schedule/screen/school_meal_screen.dart';
import 'package:school_schedule/screen/search_class_screen.dart';

import '../component/ad_layout.dart';
import '../constant/colors.dart';

enum SEARCH_TYPE {
  SCHEDULE,
  MEAL,
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
  bool isLoading = false;
  String search = "";
  List<SchoolSearchModel> schools = [];
  SEARCH_TYPE searchType = SEARCH_TYPE.SCHEDULE;

  @override
  dispose() {
    // tabController.dispose();
    super.dispose();
  }

  Future<void> fetchSchoolData() async {
    try {
      setState(() {
        isLoading = true;
      });

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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String selectedSearchType = '시간표'; // 기본 선택값
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
      child: Column(
        children: [
          DropdownButtonHideUnderline(
              child: DropdownButton2<SEARCH_TYPE>(
            isExpanded: true,
            items: SEARCH_TYPE.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    alignment: AlignmentDirectional.center,
                    child: Text(e == SEARCH_TYPE.SCHEDULE ? "시간표" : "급식"),
                  ),
                )
                .toList(),
            value: searchType,
            onChanged: (value) {
              setState(() {
                searchType = value!;
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: whiteColor,
              ),
              elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: lightColor,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: whiteColor,
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          )),
          const SizedBox(
            height: 16.0,
          ),
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
          if (isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView(
              children: schools
                  .map(
                    (e) => TextButton(
                      onPressed: () {
                        if (searchType == SEARCH_TYPE.SCHEDULE) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return SearchClassScreen(school: e);
                          }));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return SchoolMealScreen(school: e);
                          }));
                        }
                      },
                      child: Text(e.SCHUL_NM),
                    ),
                  )
                  .toList(),
            ),
          ),
          const AdLayout()
        ],
      ),
    );
  }
}
