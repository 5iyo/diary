import 'package:dio/dio.dart';
import 'dto/TravelResp.dart';

const host = "http://192.168.20.7:8080";

class DioTravel {

  final String id;
  const DioTravel(this.id);

  Future<TravelResp> dioTravel(String title, String area, String latitude, String longitude,
      String image, String start, String end) async {

    Dio dio = new Dio();

    try {
      Response response = await dio.post(
          '$host/api/user/$id/travels',
          data: {
            "travelTitle" : title,
            "travelArea": area,
            "travelLatitude": latitude,
            "travelLongitude": longitude,
            "travelImage": image,
            "travelStartDate": start,
            "travelEndDate": end
          }
      );
      final jsonBody = response.data;

      if (response.statusCode == 201) {
        print(jsonBody);

        return jsonBody;
      } else {
        throw Exception('실패');
      }
    } catch (e) {
      Exception(e);
      print(e);
      print("예외");
    } finally {
      dio.close();
      print("끝");
    }
    return TravelResp();
  }
}