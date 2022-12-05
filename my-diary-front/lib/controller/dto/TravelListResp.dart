const get_host = "192.168.20.2:8080";
const host = "http://192.168.20.2:8080";

class TravelList {
  final dynamic travels;

  TravelList({this.travels});

  factory TravelList.fromJson(Map<String, dynamic> json) {
    return TravelList(
      travels : json["travels"] ?? [],
    );
  }
}
