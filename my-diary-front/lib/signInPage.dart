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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.height,
                height: (MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width) - AppBar().preferredSize.height,
                child: Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width <
                                MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height,
                        height: (MediaQuery.of(context).size.width <
                                    MediaQuery.of(context).size.height
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.height) *
                            1.331730769230769,
                        child: Card(
                          elevation: 32.0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Ink.image(
                            image: Image.asset("img/login_background.png").image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
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
                            onPressed: () => _mainViewModel.login(GoogleLogin()),
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
                      ),
                    ),
                    Spacer(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
