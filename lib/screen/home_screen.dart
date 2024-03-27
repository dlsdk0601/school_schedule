import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      final box = Hive.box<SchoolModel>(AtptOfcdcScCode.B10.name);

      if (box.values.isNotEmpty) {
        return;
      }

      final res = await SchoolRepository.onFetch(page: page, code: code);

      // for (int i = 0; i < res.length; i++) {
      //   final SchoolModel schoolModel = res[i];
      //   final box = Hive.box<SchoolModel>(schoolModel.code.name);
      // }

      for (SchoolModel schoolModel in res) {
        final box = Hive.box<SchoolModel>(schoolModel.code.name);
        // TODO :: 키 정하기
        box.put("test", schoolModel);
      }

      // res.map((schoolModel) => Hive.box<SchoolModel>(schoolModel.code.name).put("as", schoolModel));

      // setState(() {
      //   schools = res;
      // });
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
    return ValueListenableBuilder<Box>(
      valueListenable:
          Hive.box<SchoolModel>(AtptOfcdcScCode.B10.name).listenable(),
      builder: (context, box, widget) {
        if (box.values.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final recentSchool = box.values.toList();

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
              children: recentSchool
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
            ),
          ),
        );
      },
    );
  }
}
