
class Images {
  final int? image_id;
  final String? imagefile;

  Images(
      { this.image_id,
        this.imagefile,}
      );

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      image_id : json["diaryImageId"],
      imagefile : json["imageFile"],
    );
  }
}
