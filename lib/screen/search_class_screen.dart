import 'package:flutter/material.dart';
import 'package:school_schedule/component/ad_layout.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/school_model.dart';

class SearchClassScreen extends StatelessWidget {
  final SchoolSearchModel school;

  const SearchClassScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return MainLayoutScreen(
        body: SearchClassView(
      school: school,
    ));
  }
}

class SearchClassView extends StatefulWidget {
  final SchoolSearchModel school;

  const SearchClassView({super.key, required this.school});

  @override
  State<SearchClassView> createState() => _SearchClassViewState();
}

class _SearchClassViewState extends State<SearchClassView> {
  // 상수값
  final List<String> semesters = ["1", "2"];
  final List<String> elementaryGrades = ["1", "2", "3", "4", "5", "6"];
  final List<String> grades = ["1", "2", "3"];
  final List<String> classes =
      List.generate(12, (index) => (index + 1).toString());

  // 선택한 학교
  SchoolSearchModel? school;

  // 변수값
  String SEM = "";
  String GRADE = "";
  String CLASS_NM = "";

  @override
  void initState() {
    super.initState();
    school = widget.school;
  }

  Future<Map<String, DateTime>> getWeekDates() async {
    DateTime today = DateTime.now();
    int todayIndex = today.weekday;
    DateTime monday = today.subtract(Duration(days: todayIndex - 1));
    DateTime friday = monday.add(const Duration(days: 4));

    return {"monday": monday, "friday": friday};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropDownView(
                title: "학교",
                items: const [],
                onChanged: (value) {},
                hint: Text(
                  school!.SCHUL_NM,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              DropDownView(
                  title: "학기",
                  items: semesters,
                  onChanged: (value) {
                    setState(() {
                      SEM = value!;
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropDownView(
                  title: "학년",
                  items: school!.SCHUL_NM.contains("초등학교")
                      ? elementaryGrades
                      : grades,
                  onChanged: (value) {
                    setState(() {
                      GRADE = value!;
                    });
                  }),
              DropDownView(
                  title: "반",
                  items: classes,
                  onChanged: (value) {
                    setState(() {
                      CLASS_NM = value!;
                    });
                  }),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "검색",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(child: Container()),
          const AdLayout()
        ],
      ),
    );
  }
}

class DropDownView extends StatelessWidget {
  final String title;
  final List<String> items;
  final Widget? hint;
  final ValueChanged<String?> onChanged;

  const DropDownView({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: DropdownButton(
            hint: hint ?? Text(title),
            isExpanded: true,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    alignment: AlignmentDirectional.center,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
