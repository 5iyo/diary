
import 'package:my_diary_front/controller/dto/Diary_images.dart';

class DiaryImage {
  final List<Images>? images;
  DiaryImage(
      {this.images,});

  factory DiaryImage.fromJson(Map<String, dynamic> json) {

    var list = (json["images"] ?? []) as List;
    print(list.runtimeType);
    List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();

    return DiaryImage(
      images: imagesList
    );
  }
}
