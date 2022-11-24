
class WriteResp {
  final int id;

  WriteResp(
    {required this.id}
  );

  factory WriteResp.fromJson(Map<String, dynamic> json) {
    return WriteResp(
        id : json["id"],
    );
  }
}
