import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/dto/WriteReq.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_dropdown.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_image_picker.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/components/custom_textarea.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:my_diary_front/controller/dto/WriteResp.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const host = "http://202.31.200.143:8080";

Future <WriteResp> save(int id, String title, String date, String content, String weather, String travel, List<String> images) async{
  WriteReq writereq = WriteReq(title, date, content, weather, travel, images);
  var url = '$host/api/diaries/$id';
  final response = await http.post(Uri.parse(url),
      body : jsonEncode(writereq.toJson()));

  if(response.statusCode == 201) {
    print("작성 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return WriteResp.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception("작성 실패");
  }
}

class WritePage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _content = TextEditingController();
  final _travel = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child: CustomDatePicker(),),
                  Expanded(child: CustomDropdown(),),
                  Expanded(child: TextFormField(
                    controller: _travel,
                    decoration: InputDecoration(
                      hintText: "Travel",
                    )
                  ),)
                ],
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                  controller: _title,
                  hint: "Title",
                  funValidator: validateTitle()
              ),
              SizedBox(height: 5),
              CustomTextArea(
                  controller: _content,
                  hint: "Content",
                  funValidator: validateContent()
              ),
              ImageUploader(),
              CustomElavatedButton(
                text: "글쓰기",
                funPageRoute: () async {
                  if (_formKey.currentState!.validate()) {
                    //await save(1, "제목~", "2022-11-13", "내용~", "맑음", "구미", ["aaa", "bbb"]);
                    Get.off(()=>DiaryListPage());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

