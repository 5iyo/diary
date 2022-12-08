import 'package:flutter/material.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
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

  bool isAwait = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            child: UiViewModel.buildBackgroundContainer(
              context: context,
              backgroundType: BackgroundType.login,
              child: Column(
                children: [
                  const Spacer(
                    flex: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isAwait = true;
                          });
                          await _mainViewModel.login(NaverLogin());
                          setState(() {
                            isAwait = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        child: Image.asset(
                          'img/naver_icon.png',
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isAwait = true;
                          });
                          await _mainViewModel.login(KakaoLogin());
                          setState(() {
                            isAwait = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        child: Image.asset(
                          'img/kakao_icon.png',
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isAwait = true;
                          });
                          await _mainViewModel.login(GoogleLogin());
                          setState(() {
                            isAwait = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        child: Image.asset(
                          'img/google_icon.png',
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
          ),
          isAwait ? UiViewModel.buildProgressBar() : Container(),
        ]),
      ),
    );
  }
}
