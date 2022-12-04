import 'package:dio/dio.dart';
import 'dto/DiaryResp.dart';

const host = "http://192.168.20.7:8080";

class DioUpdate {

  final int id;
  const DioUpdate(this.id);

  Future<Diary> dioUpdate(String title, String date, String content, String weather,
      String travel) async {

    Dio dio = new Dio();

    try {
      Response response = await dio.patch(
          '$host/api/diaries/$id',
          data: {
            "title": title,
            "travelDate": date,
            "mainText": content,
            "weather": weather,
            "travelDestination": travel,
          }
      );
      final jsonBody = response.data;

      if (response.statusCode == 200) {
        print(jsonBody);

        return jsonBody;
      } else {
        throw Exception('일기 수정 실패');
      }
    } catch (e) {
      Exception(e);
      print(e);
      print("일기 수정 예외");
    } finally {
      dio.close();
      print("끝");
    }
    return Diary();
  }
}