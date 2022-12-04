import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/data.dart';
import 'package:provider/provider.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/custom_textarea.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late MainViewModel _mainViewModel;
  var birthDateText = '';
  var introductionText = '';
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    _birthDateController.text = _mainViewModel.diaryUser!.birthDate;
    _introductionController.text = _mainViewModel.diaryUser!.introduction;
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                      backgroundImage: const AssetImage(
                          'img/핑구.png') /*_mainViewModel.diaryUser!.image == null
                        ? const AssetImage('img/핑구.png')
                        : Image.network(_mainViewModel.diaryUser!.image!).image,*/
                  ),
                  accountName: Text("???"),
                  //Text(_mainViewModel.diaryUser!.name),
                  /*Row(children: [
                    Text("???"), //Text(_mainViewModel.diaryUser!.name),
                    Spacer(),
                    SizedBox(width: 200.0, child: CustomDatePicker()),
                  ]),*/
                  accountEmail: Text("???"),
                  //Text(_mainViewModel.diaryUser!.email),
                  decoration: BoxDecoration(color: Colors.blueGrey[400]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: CustomTextFormField(
                    hint: '',
                    funValidator: null,
                    controller: _birthDateController,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: CustomTextArea(
                      hint: '',
                      funValidator: null,
                      controller: _introductionController,
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: CustomElavatedButton(
                    text: '정보 수정',
                    funPageRoute: () {
                      // TODO : 정보 수정 http request 작성
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
