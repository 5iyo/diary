
import 'package:my_diary_front/controller/dto/Diary_images.dart';

class Diary {
  final int? id;
  final String? title;
  final DateTime? traveldate;
  final String? content;
  final String? weather;
  final String? travel;
  final List<Images>? images;
  final DateTime? created;
  final DateTime? updated;

  Diary(
      { this.id,
        this.title,
        this.traveldate,
        this.content,
        this.weather,
        this.travel,
        this.images,
        this.created,
        this.updated,
      }
      );

  factory Diary.fromJson(Map<String, dynamic> json) {

    var list = (json["images"] ?? []) as List;
    print(list.runtimeType);
    List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();

    return Diary(
      id : json["diaryId"],
      title : json["title"],
      traveldate : DateTime.parse(json["travelDate"]),
      content: json["mainText"],
      weather : json["weather"],
      travel : json["travelDestination"],
      images: imagesList,
      created: DateTime.parse(json["createDate"]),
      updated: DateTime.parse(json["lastModifiedDate"]),
    );
  }
}
