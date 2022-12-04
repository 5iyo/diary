import 'package:flutter/material.dart';
import 'package:my_diary_front/data.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'diaryShare.dart';

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

  late MainViewModel _mainViewModel;

  DiaryScreenshot diaryShare = DiaryScreenshot();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
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
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                      child: Screenshot(
                        controller: diaryShare.screenshotController,
                        child: ElevatedButton(
                          onPressed: () => {
                            _mainViewModel.share(DiaryInstagramShare(), diaryShare)
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text('Sign In'),
                        ),
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
                            onPressed: () => _mainViewModel.login(NaverLogin()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                            child: Image.asset(
                              'img/naver_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _mainViewModel.login(KakaoLogin()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                            child: Image.asset(
                              'img/kakao_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _mainViewModel.login(GoogleLogin()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0),
                            child: Image.asset(
                              'img/google_icon.png',
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
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
}
