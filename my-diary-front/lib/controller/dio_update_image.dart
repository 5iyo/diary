import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dto/WriteResp.dart';

String? host = dotenv.env['SERVER_URI'];

class DioUpdateImage {

  final int id;
  const DioUpdateImage(this.id);

  Future<WriteResp> dioInputImage(String image) async {

    Dio dio = new Dio();

    try {
      Response response = await dio.post(
          '$host/api/diary-images/$id',
          data: {
            "imageFile": image
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