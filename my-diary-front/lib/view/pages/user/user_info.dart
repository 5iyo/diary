import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_front/data.dart';
import 'package:provider/provider.dart';

import 'user_info_custom/custom_elevated_button.dart';
import 'user_info_custom/custom_text_form_field.dart';
import 'user_info_custom/custom_textarea.dart';



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

  final _dateFormat = DateFormat("yyyy-MM-dd", 'ko');

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    _birthDateController.text = _mainViewModel.diaryUser!.birthDate == null
        ? ""
        : _dateFormat.format(_mainViewModel.diaryUser!.birthDate!);
    _introductionController.text =
        _mainViewModel.diaryUser!.profileIntroduction ?? "";
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
                      backgroundImage: /*const AssetImage(
                          'img/핑구.png') */_mainViewModel.diaryUser!.profileImage == null
                        ? const AssetImage('img/핑구.png')
                        : Image.network(_mainViewModel.diaryUser!.profileImage!).image,
                      ),
                  accountName:/* Text("???"),*/
                  Text(_mainViewModel.diaryUser!.username),
                  /*Row(children: [
                    Text("???"), //Text(_mainViewModel.diaryUser!.name),
                    Spacer(),
                    SizedBox(width: 200.0, child: CustomDatePicker()),
                  ]),*/
                  accountEmail: /*Text("???"),*/
                  Text(_mainViewModel.diaryUser!.email),
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
                    funPageRoute: () async {
                      await _mainViewModel.diaryUser!.updateUserInfo(
                          _introductionController.text,
                          _birthDateController.text);
                      Navigator.pop(context);
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
