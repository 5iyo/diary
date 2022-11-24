
class WriteReq {
  final String? title;
  final String? date;
  final String? content;
  final String? weather;
  final String? travel;
  final List<String>? images;

  WriteReq(
    this.title,
    this.date,
    this.content,
    this.weather,
    this.travel,
    this.images,
  );

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "travelDate": date,
        "mainText": content,
        "weather": weather,
        "travelDestination": travel,
        "images": images,
      };
}
