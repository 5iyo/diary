class TravelResp {
  final int? id;

  TravelResp({this.id});

  factory TravelResp.fromJson(Map<String, dynamic> json) {
    return TravelResp(
      id : json["id"],
    );
  }
}