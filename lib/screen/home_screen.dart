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
  AtptOfcdcScCode code = AtptOfcdcScCode.B10;
  List<SchoolModel> schools = [];
  int page = 1;

  @override
  initState() {
    super.initState();
    fetchSchoolData();
  }

  Future<void> fetchSchoolData() async {
    try {
      final res = await SchoolRepository.onFetch(page: page, code: code);

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
          fetchSchoolData();
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
        child: ListView(
          children: [
            ...schools
                .map((e) => Column(
                      children: [
                        Text(e.ATPT_OFCDC_SC_NM),
                        Text(e.DGHT_CRSE_SC_NM),
                        Text(e.LOAD_DTM),
                        Text(e.ORD_SC_NM),
                        Text(e.SCHUL_NM),
                        Text(e.SD_SCHUL_CODE),
                      ],
                    ))
                .toList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    page += 1;
                  });

                  fetchSchoolData();
                },
                child: const Center(
                  child: Text("더보기"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
