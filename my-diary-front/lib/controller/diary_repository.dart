import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_diary_front/controller/dto/TravelListResp.dart';
import 'package:http/http.dart' as http;
import 'dto/DiaryImageResp.dart';
import 'dto/DiaryListResp.dart';
import 'dto/DiaryList_diaries.dart';
import 'dto/DiaryResp.dart';
import 'dto/TravelList_travels.dart';

String? host = dotenv.env['SERVER_URI'];
String? get_host = dotenv.env['SERVER_NAME'];

class DiaryRepository {
  Future<List<Travels>> fetchTravelList(LatLng travelLatLng, int id) async {
    Map<String, String> queryParams = {
      "travelLatitude": "${travelLatLng.latitude}",
      "travelLongitude": "${travelLatLng.longitude}"
    }; //마커 좌표
    final response = await http.get(
      Uri.https('$get_host', 'api/user/$id/inquire-travels-list', queryParams),
    );
    print("##############${response.body}");
    if(response.statusCode == 200) {
      TravelList travelList = TravelList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> temp = travelList.travels;
      print("여행 리스트 요청 성공");
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<Travels> travels = temp.map((i) => Travels.fromJson(i)).toList();
      return travels;
    } else if(response.statusCode == 500) {
      throw Exception("여행을 추가해주세요!");
    }
    else{
      throw Exception("여행 리스트 요청을 실패했습니다.");
    }
  }

  Future<List<Diaries>> fetchDiaryList(int id) async {
    var url = '$host/api/diaries/$id/inquiry-diary-list';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      if(response.body.isEmpty) {
        return [];
      }
      DiaryList diaryList = DiaryList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> temp = diaryList.data;
      print("리스트 요청 성공");
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<Diaries> diaries = temp.map((i) => Diaries.fromJson(i)).toList();
      return diaries;
      //return DiaryList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if(response.statusCode == 500) {
      throw Exception("일기를 추가해주세요");
    }
    else{
      throw Exception("리스트 요청을 실패했습니다.");
    }
  }

  Future<Diary> fetchDiary(int id) async {
    var url = '$host/api/diaries/$id';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      print("일기 요청 성공");
      print(json.decode(utf8.decode(response.bodyBytes)));
      return Diary.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("일기 요청을 실패했습니다.");
    }
  }

  Future<DiaryImage> fetchDiaryImage(int id) async {
    var url = '$host/api/diaries/$id';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      print("일기 이미지 요청 성공");
      print(json.decode(utf8.decode(response.bodyBytes)));
      return DiaryImage.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("일기 이미지 요청을 실패했습니다.");
    }
  }

  Future<int?> fetchDeleteImage(int id) async{
    var url = '$host/api/diary-images/$id';
    final response = await http.delete(Uri.parse(url));

    if(response.statusCode == 200) {
      print("이미지 삭제 성공");
      return response.statusCode;
    } else {
      throw Exception("이미지 삭제 실패");
    }
  }

  Future<int?> dioInputImage(int id, String image) async {

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

        return response.statusCode;
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
    return 0;
  }

  Future<int?> dioTravel(String id, String title, String area, String latitude, String longitude,
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
        return response.statusCode;
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
    return 0;
  }

  Future<int?> dioWrite(int id, String title, String date, String content, String weather,
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

        return response.statusCode;
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
    return 0;
  }

  Future<int?> fetchTravelDelete(int? id) async{
    var url = '$host/api/travels/$id';
    final response = await http.delete(Uri.parse(url));

    if(response.statusCode == 200) {
      print("삭제 성공");
      return response.statusCode;
    } else {
      throw Exception("삭제 실패");
    }
  }

  Future<int?> fetchDelete(int id) async{
    var url = '$host/api/diaries/$id';
    final response = await http.delete(Uri.parse(url));

    if(response.statusCode == 200) {
      print("삭제 성공");
      return response.statusCode;
    } else {
      throw Exception("삭제 실패");
    }
  }

  Future<int?> dioTravelUpdate(int id, String title, String image, String startdate, String enddate) async {

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
        return response.statusCode;
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

  Future<int?> dioUpdate(int id, String title, String date, String content, String weather,
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

        return response.statusCode;
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