import 'package:intl/intl.dart';

import 'DiaryList_diaries.dart';

class DiaryList {
  final String? title;
  final String? area;
  final DateTime? startdate;
  final DateTime? enddate;
  final List<Diaries>? data;

  DiaryList(
      { this.title,
        this.area,
        this.startdate,
        this.enddate,
        this.data,}
      );

  factory DiaryList.fromJson(Map<String, dynamic> json) {

    var list = (json["data"] ?? []) as List;
    print(list.runtimeType);
    List<Diaries> diariesList = list.map((i) => Diaries.fromJson(i)).toList();

    return DiaryList(
      title : json["travelTitle"],
      area : json["travelArea"],
      startdate : DateFormat("yyyy-mm-dd").parse(json["travelStartDate"]),
      enddate : DateFormat("yyyy-mm-dd").parse(json["travelEndDate"]),
      data : diariesList,
    );
  }
}
