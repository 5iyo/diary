import 'package:intl/intl.dart';

class Diaries {
  final int? id;
  final String? title;
  final DateTime? traveldate;
  final String? travel;
  final String? weather;

  Diaries(
      { this.id,
        this.title,
        this.traveldate,
        this.travel,
        this.weather,}
      );

  factory Diaries.fromJson(Map<String, dynamic> json) {
    return Diaries(
      id : json["diaryId"],
      title : json["title"],
      traveldate : DateFormat("yyyy-mm-dd").parse(json["travelDate"]),
      travel : json["travelDestination"],
      weather : json["weather"],
    );
  }
}
