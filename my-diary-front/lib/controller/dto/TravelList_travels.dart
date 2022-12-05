
class Travels {
  final int? id;
  final String? title;
  final String? image;
  final DateTime startdate;
  final DateTime enddate;

  Travels(
      {
        this.id,
        this.title,
        this.image,
        required this.startdate,
        required this.enddate,}
      );

  factory Travels.fromJson(Map<String, dynamic> json) {
    return Travels(
      id : json["travelId"],
      title : json["travelTitle"],
      image: json["travelImage"],
      startdate : DateTime.parse(json["travelStartDate"]),
      enddate : DateTime.parse(json["travelEndDate"]),
    );
  }
}
