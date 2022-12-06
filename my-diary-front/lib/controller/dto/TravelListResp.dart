class TravelList {
  final dynamic travels;

  TravelList({this.travels});

  factory TravelList.fromJson(Map<String, dynamic> json) {
    return TravelList(
      travels : json["travels"] ?? [],
    );
  }
}
