import 'package:flutter/material.dart';
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
  SchoolSearchModel? school;

  @override
  void initState() {
    super.initState();
    school = widget.school;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("${school!.SCHUL_NM}"),
      ),
    );
  }
}
