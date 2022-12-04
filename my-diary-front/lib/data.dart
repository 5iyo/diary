import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:my_diary_front/diaryShare.dart';

class MainViewModel {
  final DiaryStream _stream = DiaryStream();
  SocialLogin? socialLogin;
  DiaryUser? diaryUser;

  Stream<String> getStream() {
    return _stream.getStream();
  }

  Future login(SocialLogin social) async {
    socialLogin = social;
    await social.login().then((value) {
      if (value != null) {
        diaryUser = DiaryUser.fromJson(jsonDecode(value));
        _stream.addEvent(value);
      }
    });
  }

  Future logout() async {
    await socialLogin?.logout();
    _stream.addEvent("");
  }

  Future share(DiarySocialShare diarySocialShare, DiaryScreenshot diaryShare) async {
    await diarySocialShare.share(diaryShare);
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
  String email;
  String name;
  String role;
  String? image;
  String birthDate;
  String introduction;

  DiaryUser(
      {required this.id,
        required this.email,
        required this.name,
        required this.role,
        required this.image,
        required this.birthDate,
        required this.introduction});

  factory DiaryUser.fromJson(Map<String, dynamic> json) {
    return DiaryUser(
        id: json['id'],
        email: json['email'],
        name: json['username'],
        role: json['role'],
        image: json['profileImage'],
        birthDate: json['birthDate'] ?? "",
        introduction: json['introduction'] ?? "");
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
