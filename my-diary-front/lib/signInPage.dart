import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_diary_front/data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailText = '';
  var passwordText = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late DiaryStream _diaryStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _diaryStream = Provider.of<DiaryStream>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In',
            style: TextStyle(color: Colors.grey),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 50.0),
                    child: TextField(
                      controller: _emailController,
                      onChanged: (text) {
                        setState(() {
                          emailText = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 50.0),
                    child: TextField(
                      controller: _passwordController,
                      onChanged: (text) {
                        setState(() {
                          passwordText = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: ElevatedButton(
                        child: const Text('Sign In'),
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      )),
                  Padding(
                      padding:
                      const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                      child: Container(
                        height: 1.0,
                        width: 500.0,
                        color: Colors.grey,
                      )),
                  Padding(
                      padding:
                      const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            child: Image.asset(
                              'img/naver_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                            onPressed: () => _naverSignIn(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                          ),
                          ElevatedButton(
                            child: Image.asset(
                              'img/kakao_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                            onPressed: () => _kakaoSignIn(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                          ),
                          ElevatedButton(
                            child: Image.asset(
                              'img/google_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                            onPressed: () => _googleSignIn(),//=> _googleSignIn(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await account!.authentication;
    print("####AccessToken####${googleAuth.accessToken}");
    // Create a new credential
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/google/login');
    await http.post(url, body: {"accessToken" : googleAuth.accessToken}).then((value) {
      final response = jsonDecode(utf8.decode(value.bodyBytes)) as Map;
      _diaryStream.addEvent(response.toString());
      print("####Response####$response");
    });
/*    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );*/
  }

  Future _naverSignIn() async {
    // Trigger the authentication flow
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    print(res);
    if(res.accessToken == ""){
      if(res.refreshToken == "") {
        final NaverLoginResult result = await FlutterNaverLogin.logIn();
      } else {
        await FlutterNaverLogin.refreshAccessTokenWithRefreshToken();
      }
      res = await FlutterNaverLogin.currentAccessToken;
    }
    print("####AccessToken####${res.accessToken}");
    // Create a new credential
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/naver/login');
    await http.post(url, body: {"accessToken" : res.accessToken}).then((value) {
      final response = jsonDecode(utf8.decode(value.bodyBytes)) as Map;
      _diaryStream.addEvent(response.toString());
      print("####Response####$response");
    });
/*    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );*/
  }

  Future _kakaoSignIn() async {
    OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    print("####AccessToken####${token.accessToken}");
    Uri url = Uri.parse('${dotenv.get('SERVER_URI')}/kakao/login');
    await http.post(url, body: {"accessToken" : token.accessToken}).then((value) {
      final response = jsonDecode(utf8.decode(value.bodyBytes)) as Map;
      _diaryStream.addEvent(response.toString());
      print("####Response####$response");
    });
/*    String authCode = await AuthCodeClient.instance.request();
    print("response : " + authCode);
    final response = await _dio.request('/kakao/login',
        data: {'code':authCode}, options: Options(method: 'POST'));
    print(response);*/
  }
}
