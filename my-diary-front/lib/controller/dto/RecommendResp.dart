class Recommend {
  String? title;
  String? x;
  String? y;

  Recommend(
      {
        this.title,
        this.x,
        this.y}
      );

  factory Recommend.fromJson(Map<String, dynamic> json) {
    return Recommend(
        title : json["title"],
        x : json["x"],
        y : json["y"]
    );
  }
}

class RecommendResp {
  final List<Recommend>? recommendresp;

  RecommendResp({this.recommendresp});

  factory RecommendResp.fromJson(Map<String, dynamic> json) {

    var list = (json["response"] ?? []) as List;
    print(list.runtimeType);
    List<Recommend> recommendlist = list.map((i) => Recommend.fromJson(i)).toList();

    return RecommendResp(
        recommendresp : recommendlist
    );
  }
}