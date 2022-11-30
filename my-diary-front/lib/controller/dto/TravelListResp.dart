
import 'package:my_diary_front/controller/dto/TravelList_travels.dart';

class TravelList {
  final List<Travels>? travels;

  TravelList({this.travels});

  factory TravelList.fromJson(Map<String, dynamic> json) {

    var list = (json["travels"] ?? []) as List;
    print(list.runtimeType);
    List<Travels> travelsList = list.map((i) => Travels.fromJson(i)).toList();

    return TravelList(
        travels : travelsList
    );
  }
}
