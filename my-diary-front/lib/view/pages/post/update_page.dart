import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/util/validator_util.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/custom_textarea.dart';

class UpdatePage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _title.text = "제목";
    _content.text = "내용";

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: _title,
                hint: "Title",
                funValidator: validateTitle(),
              ),
              SizedBox(height: 10),
              CustomTextArea(
                controller: _content,
                hint: "Content",
                funValidator: validateContent(),
              ),
              CustomElavatedButton(
                text: "수정하기",
                funPageRoute: () async{
                  if (_formKey.currentState!.validate()) {
                    Get.back();
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

