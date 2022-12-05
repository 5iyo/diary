import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_diary_front/controller/dto/TravelListResp.dart';
import 'package:http/http.dart' as http;
import 'dto/DiaryListResp.dart';
import 'dto/DiaryList_diaries.dart';
import 'dto/TravelList_travels.dart';

const get_host = "192.168.20.2:8080";
const host = "http://192.168.20.2:8080";

class DiaryRepository {
  Future<List<Travels>> fetchTravelList(LatLng travelLatLng) async {
    var latitude;
    var longitude;

    if(travelLatLng.latitude.floor() < 100 && travelLatLng.latitude.floor() > 9) {
      latitude = (travelLatLng.latitude - 0.0001).toStringAsFixed(4);
    }
    else if (travelLatLng.latitude.floor() >= 100) {
      latitude = (travelLatLng.latitude - 0.001).toStringAsFixed(3);
    }

    if(travelLatLng.longitude.floor() < 100 && travelLatLng.longitude.floor() > 9) {
      longitude = (travelLatLng.longitude-0.0001).toStringAsFixed(4);
    }
    else if (travelLatLng.longitude.floor() >= 100) {
      longitude = (travelLatLng.longitude-0.001).toStringAsFixed(3);
    }

    print("왜 안돼");
    print(latitude);
    print(longitude);

    Map<String, String> queryParams = {
      "travelLatitude": "${latitude}",
      "travelLongitude": "${longitude}"
    }; //마커 좌표
    final response = await http.get(
      Uri.https('$get_host', 'api/travels', queryParams),
    );

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