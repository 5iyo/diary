import 'package:dio/dio.dart';

import 'dto/WriteResp.dart';

const host = "http://192.168.20.7:8080";

class DioWrite {

  final int id;
  const DioWrite(this.id);

  List<String> inputImage(List<String> image) {
    return image;
  }

  Future<WriteResp> dioWrite(String title, String date, String content, String weather,
      String travel, List<String> images) async {

    Dio dio = new Dio();

    try {
      Response response = await dio.post(
          '$host/api/diaries/$id',
          data: {
            "title": title,
            "travelDate": date,
            "mainText": content,
            "weather": weather,
            "travelDestination": travel,
            "images": images,
          }
      );

      final jsonBody = response.data;

      if (response.statusCode == 201) {
        print(jsonBody);

        return jsonBody;
      } else {
        throw Exception('일기 작성 실패');
      }
    } catch (e) {
      Exception(e);
      print(e);
      print("일기 작성 예외");
    } finally {
      dio.close();
      print("끝");
    }
    return WriteResp(id: id);
  }
}