import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/provider/diary_write_provider.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/components/custom_textarea.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:convert';

import 'package:provider/provider.dart';

class WritePage extends StatefulWidget {
  final int id;

  const WritePage(this.id);

  @override
  State<WritePage> createState() => _WritePageState(id);
}

class _WritePageState extends State<WritePage> {
  DiaryWriteProvider diaryWriteProvider = DiaryWriteProvider();

  final int id;

  _WritePageState(this.id);

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _content = TextEditingController();
  final _travel = TextEditingController();
  final _date = TextEditingController();

  final _valueList = ['맑음', '흐림', '약간 흐림', '비', '눈', '바람'];
  var _selectedValue = '맑음';

  List<File> userImages = [];
  List<String> base64List = [];
  int userBestImageIndex = 0;
  ScrollController controller = ScrollController();
  final ImagePicker _picker = ImagePicker();

  bool isAwait = false;

  @override
  void initState() {
    controller = ScrollController()
      ..addListener(() {
        setState(() {
          iconView();
        });
      });
    super.initState();
  }

  Widget build(BuildContext context) {
    diaryWriteProvider =
        Provider.of<DiaryWriteProvider>(context, listen: false);

    String init = "여행 날짜";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [UiViewModel.buildBackgroundContainer(
            context: context,
            backgroundType: BackgroundType.write,
            child: UiViewModel.buildSizedLayout(
              context,
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: CustomDatePicker(
                                  controller: _date,
                                  init: init,
                                  funValidator: validateDate())),
                          const Padding(padding: EdgeInsets.all(5.0)),
                          Expanded(
                              child: DropdownButton(
                            value: _selectedValue,
                            items: _valueList.map(
                              (value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          )),
                          const Padding(padding: EdgeInsets.all(5.0)),
                          Expanded(
                            child: TextFormField(
                                controller: _travel,
                                decoration: const InputDecoration(
                                  hintText: "Travel",
                                )),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                          controller: _title,
                          hint: "Title",
                          funValidator: validateTitle()),
                      SizedBox(height: 5),
                      CustomTextArea(
                          controller: _content,
                          hint: "Content",
                          funValidator: validateContent()),
                      SafeArea(
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                      child: this.userImages.isEmpty
                                          ? const Center(child: Text("이미지를 등록해주세요"))
                                          : ListView.builder(
                                              padding: const EdgeInsets.all(10.0),
                                              scrollDirection: Axis.horizontal,
                                              controller: controller,
                                              itemCount: userImages.length,
                                              itemBuilder: (BuildContext context,
                                                      int index) =>
                                                  Stack(children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          userBestImageIndex =
                                                              index;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 200.0,
                                                        padding:
                                                            const EdgeInsets.all(10.0),
                                                        child: Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0)),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          borderOnForeground: false,
                                                          child: Image.file(
                                                              userImages[
                                                                  index],
                                                              fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            userImages.remove(
                                                                userImages[index]);
                                                            iconCountCheck();
                                                          });
                                                        },
                                                        child: Container(
                                                            width: 30.0,
                                                            height: 30.0,
                                                            margin:
                                                                const EdgeInsets.all(5.0),
                                                            alignment:
                                                                Alignment.center,
                                                            decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0)),
                                                            child: const Center(
                                                                child: Icon(
                                                              Icons.close,
                                                              size: 20.0,
                                                              color: Colors.white,
                                                            ))),
                                                      ),
                                                    ),
                                                  ]))),
                                  !nextIconView
                                      ? Container()
                                      : Positioned(
                                          top: 100.0,
                                          right: 10.0,
                                          child: Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30.0)),
                                            child: Icon(Icons.navigate_next),
                                          ),
                                        )
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              color: userImages.length >= 3
                                  ? Colors.white
                                  : Colors.grey,
                              icon: userImages.length >= 3
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        CupertinoIcons.xmark,
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                      ))
                                  : Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        CupertinoIcons.camera,
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                      )),
                              onPressed: userImages.length >= 3
                                  ? () => { }
                                  : () async {
                                      bool? check = await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        "카메라 또는 갤러리를 통해 업로드할 수 있습니다"),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: const Text("촬영"),
                                                        onPressed: () =>
                                                            Navigator.of(context)
                                                                .pop(true),
                                                      ),
                                                      ElevatedButton(
                                                        child: const Text("앨범"),
                                                        onPressed: () =>
                                                            Navigator.of(context)
                                                                .pop(false),
                                                      ),
                                                      ElevatedButton(
                                                        child: const Text("취소"),
                                                        onPressed: () async =>
                                                            Navigator.of(context)
                                                                .pop(null),
                                                      ),
                                                    ],
                                                  ));
                                      if (check == null) return;
                                      if (check) {
                                        setState(() {
                                          isAwait = true;
                                        });
                                        final pickCamera = await _picker.pickImage(
                                            source: ImageSource.camera);
                                        setState(() {
                                          isAwait = false;
                                        });
                                        final cFile =
                                            File(pickCamera!.path.toString());
                                        userImages.add(cFile);
                                      } else {
                                        setState(() {
                                          isAwait = true;
                                        });
                                        final pickGallery = await _picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          isAwait = false;
                                        });
                                        final gFile =
                                            File(pickGallery!.path.toString());
                                        userImages.add(gFile);
                                      }
                                      iconCountCheck();
                                      return setState(() {});
                                    },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomElavatedButton(
                              text: "글쓰기",
                              funPageRoute: () async {
                                userImages.isEmpty
                                    ? null
                                    : userImages.forEach((e) => base64List.add(
                                        "data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                                base64List.isEmpty ? base64List = [""] : base64List;
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isAwait = true;
                                  });
                                  await diaryWriteProvider.save(
                                      id,
                                      _title.text,
                                      _date.text,
                                      _content.text,
                                      _selectedValue,
                                      _travel.text,
                                      base64List);
                                  setState(() {
                                    isAwait = false;
                                  });
                                  Get.off(() => DiaryListPage(id));
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryListPage(id)));
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),isAwait ? UiViewModel.buildProgressBar() : Container(),]
      ),
    );
  }

  bool nextIconView = false;

  void iconCountCheck() {
    if (userImages.length >= 2) {
      nextIconView = true;
      return;
    }
    nextIconView = false;
    return;
  }

  void iconView() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      nextIconView = false;
    } else {
      nextIconView = true;
    }
    return;
  }
}
