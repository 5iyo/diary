import 'package:dio/dio.dart';

const host = "http://192.168.20.7:8080";

class DioTravelUpdate {

  final int id;
  const DioTravelUpdate(this.id);

  Future<void> dioTravelUpdate(String title, String image, String startdate, String enddate) async {

    Dio dio = new Dio();

    try {
      Response response = await dio.patch(
          '$host/api/travels/$id',
          data: {
            "travelTitle": title,
            "travelImage": image,
            "travelStartDate": startdate,
            "travelEndDate": enddate,
          }
      );
      final jsonBody = response.data;

      if (response.statusCode == 200) {
        print(jsonBody);
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
  }
}