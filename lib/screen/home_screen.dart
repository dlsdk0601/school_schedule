import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_drawer.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/constant/regions.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/school_repository.dart';
import 'package:school_schedule/utils/data_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  AtptOfcdcScCode? code;
  List<SchoolModel> schools = [];
  int page = 1;

  Future<void> fetchSchoolData() async {
    try {
      if (code == null) {
        return;
      }

      final res = await SchoolRepository.onFetch(page: page, code: code!);
      setState(() {
        schools = res;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("인터넷 연결이 원할하지 않습니다.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO :: 선택 시 학교 list 보여주는 로직 추가
    return Scaffold(
      drawer: MainDrawer(
        selectedRegion: region,
        onRegionTap: (String region) {
          setState(() {
            this.region = region;
            code = DataUtils.nameToCityCode(name: region);
          });

          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(
        title: const Text(
          "시간표",
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightColor,
      ),
      body: Container(
        child: Center(
          child: Text("test"),
        ),
      ),
    );
  }
}
