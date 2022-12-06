import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:my_diary_front/diaryShare.dart';
import 'package:dio/dio.dart';

class MainViewModel {
  final DiaryStream _stream = DiaryStream();
  SocialLogin? socialLogin;
  DiaryUser? diaryUser;

  Stream<String> getStream() {
    return _stream.getStream();
  }

  Future login(SocialLogin social) async {
    print("#######login");
    socialLogin = social;
    await social.login().then((value) {
      print(value);
      if (value != null) {
        print("####$value");
        diaryUser = DiaryUser.fromJson(jsonDecode(value));
        _stream.addEvent(value);
      }
    });
  }

  Future logout() async {
    await socialLogin?.logout();
    _stream.addEvent("");
  }

  Future share(DiarySocialShare diarySocialShare, DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    await diarySocialShare.share(diaryShare, googleMapScreenshot);
  }
}

class DiaryStream {
  final StreamController<String> _controller = StreamController();

  void addEvent(String event) {
    _controller.add(event);
  }

  Stream<String> getStream() {
    return _controller.stream;
  }
}

abstract class SocialLogin {
  Future<String?> login();

  Future logout();
}

class KakaoLogin implements SocialLogin {
  @override
  Future<String?> login() async {
    OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/kakao/login');
    final response =
        await http.post(url, body: {"accessToken": token.accessToken});
    return utf8.decode(response.bodyBytes);
  }

  @override
  Future logout() async {
    await UserApi.instance.logout();
  }
}

class NaverLogin implements SocialLogin {
  @override
  Future<String?> login() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    print("#####$res");
    if (res.accessToken == "") {
      if (res.refreshToken == "") {
        await FlutterNaverLogin.logIn();
      } else {
        await FlutterNaverLogin.refreshAccessTokenWithRefreshToken();
      }
      res = await FlutterNaverLogin.currentAccessToken;
    }
    // Create a new credential
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/naver/login');
    final response =
        await http.post(url, body: {"accessToken": res.accessToken});
    return utf8.decode(response.bodyBytes);
  }

  @override
  Future logout() async {
    await FlutterNaverLogin.logOut();
  }
}

class GoogleLogin implements SocialLogin {
  @override
  Future<String?> login() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await account!.authentication;
    // Create a new credential
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/google/login');
    final response =
        await http.post(url, body: {"accessToken": googleAuth.accessToken});
    return utf8.decode(response.bodyBytes);
  }

  @override
  Future logout() async {
    await GoogleSignIn().signOut();
  }
}

class DiaryUser {
  int id;
  DateTime createDate;
  DateTime lastModifiedDate;
  String email;
  String username;
  String? profileImage;
  String role;
  String? profileIntroduction;
  DateTime? birthDate;
  String? address;
  TravelMarkerList travels;

  DiaryUser(
      {required this.id,
      required this.createDate,
      required this.lastModifiedDate,
      required this.email,
      required this.username,
      required this.profileImage,
      required this.role,
      required this.profileIntroduction,
      required this.birthDate,
      required this.address,
      required this.travels});

  factory DiaryUser.fromJson(Map<String, dynamic> json) {
    return DiaryUser(
      id: json['id'],
      createDate: DateTime.parse(json['createDate']),
      lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
      email: json['email'],
      username: json['username'],
      profileImage: json['profileImage'],
      role: json['role'],
      profileIntroduction: json['profileIntroduction'],
      birthDate:
          json['birthDate'] == null ? null : DateTime.parse(json['birthDate']),
      address: json['address'],
      travels: TravelMarkerList.fromJson(json['travels'] as List),
    );
  }

  Future updateUserInfo(String profileIntroduction, String birthDate) async {
    Dio dio = Dio();
    String url = dotenv.get("SERVER_URI");
    print(id);
    print(profileIntroduction);
    print(birthDate);
    try {
      Response response = await dio.post('$url/user/$id',
      data: {
        "email" : email,
        "profileIntroduction" : profileIntroduction,
        "birthDate" :birthDate,
        "address" : address,
      });
      if(response.data["result"] == "SUCCESS"){
        this.profileIntroduction = profileIntroduction;
        this.birthDate = DateTime.parse(birthDate);
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
  }

  Future getTravelMarkerList() async {
    await travels.dioTravelMarkerList(id);
  }
}

class TravelMarkerList {
  List<TravelMarker>? travelMarkers;

  TravelMarkerList({this.travelMarkers});

  factory TravelMarkerList.fromJson(List list) {
    print(list.runtimeType);
    List<TravelMarker> travelMarkerList =
        list.map((e) => TravelMarker.fromJson(e)).toList();

    return TravelMarkerList(travelMarkers: travelMarkerList);
  }

  Future dioTravelMarkerList(int id) async {
    Dio dio = Dio();
    String url = dotenv.get("SERVER_URI");
    try {
      Response response =
          await dio.get('$url/api/user/$id/inquire-travels');
      if (response.statusCode == 200) {
        travelMarkers =
            TravelMarkerList.fromJson(response.data as List).travelMarkers;
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
  }
}

class TravelMarker {
  String travelTitle;
  String travelArea;
  LatLng travelLatLng;
  String travelImage;

  TravelMarker({
    required this.travelTitle,
    required this.travelArea,
    required this.travelLatLng,
    required this.travelImage,
  });

  factory TravelMarker.fromJson(Map<String, dynamic> json) {
    return TravelMarker(
        travelTitle: json['travelTitle'],
        travelArea: json['travelArea'],
        travelLatLng: LatLng(
          double.parse(json['travelLatitude']),
          double.parse(json['travelLongitude']),
        ),
        travelImage: json['travelImage']);
  }
}
