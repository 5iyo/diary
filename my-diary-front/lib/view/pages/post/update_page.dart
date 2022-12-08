import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_front/controller/dio_update_image.dart';
import 'package:my_diary_front/controller/dto/Diary_images.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:http/http.dart' as http;
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import '../../../controller/provider/diary_update_provider.dart';
import '../../../controller/dto/DiaryResp.dart';
import '../../components/custom_date_picker.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/custom_textarea.dart';
import 'diary_list_page.dart';

String? host = dotenv.env['SERVER_URI'];

Future<void> fetchDeleteImage(int id) async {
  var url = '$host/api/diary-images/$id';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    print("이미지 삭제 성공");
  } else {
    throw Exception("이미지 삭제 실패");
  }
}

Future<Diary> fetchDiary(int id) async {
  var url = '$host/api/diaries/$id';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return Diary.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception("리스트 요청을 실패했습니다.");
  }
}

class UpdatePage extends StatefulWidget {
  final int id;
  final int travelId;

  const UpdatePage(this.id, this.travelId);

  @override
  State<UpdatePage> createState() => _UpdatePageState(id, travelId);
}

class _UpdatePageState extends State<UpdatePage> {
  DiaryUpdateProvider diaryUpdateProvider = DiaryUpdateProvider();

  final int id;
  final int travelId;

  _UpdatePageState(this.id, this.travelId);

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _content = TextEditingController();
  final _travel = TextEditingController();
  final _date = TextEditingController();

  final _valueList = ['맑음', '흐림', '약간 흐림', '비', '눈', '바람'];
  var _selectedTitle;
  var _selectedContent;
  var _selectedTravel;
  var _selectedWeather;
  var _selectedDate;

  Future<Diary>? updateresp;

  ScrollController controller = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool nextIconView = false;
  List<File> updateImage = [];
  List<Images> diaryImage = [];
  List<String> updateImagebase64 = [];

  void initState() {
    super.initState();
    updateresp = fetchDiary(id);
  }

  @override
  Widget build(BuildContext context) {
    diaryUpdateProvider =
        Provider.of<DiaryUpdateProvider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: UiViewModel.buildBackgroundContainer(
            context: context,
            backgroundType: BackgroundType.write,
            child: UiViewModel.buildSizedLayout(
              context,
              FutureBuilder<Diary>(
                future: updateresp,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildDiary(snapshot);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}에러");
                  }
                  return CircularProgressIndicator();
                },
              ),
            )));
  }

  Widget buildDiary(snapshot) {
    DioUpdateImage dioUpdateImage = DioUpdateImage(id);
    _travel.text = snapshot.data!.travel;
    _title.text = snapshot.data!.title;
    _content.text = snapshot.data!.content;
    UriData? data;
    Uint8List? bytes;

    int deleteImageId;
    String inputImage;

    // for(int i=0; i<snapshot.data.images.length; i++) {
    //   diaryImage.add(snapshot.data.images[i].imagefile);
    // }

    for (int i = 0; i < snapshot.data.images.length; i++) {
      diaryImage.add(snapshot.data.images[i]);
    }

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                      child: CustomDatePicker(
                          controller: _date,
                          init: "여행 날짜 선택",
                          funValidator: validateDate())),
                  Expanded(
                      child: DropdownButton(
                    value: snapshot.data!.weather,
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
                        _selectedWeather = value!;
                      });
                    },
                  )),
                  Expanded(
                    child: TextFormField(
                      controller: _travel,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                  controller: _title, hint: " ", funValidator: validateTitle()),
              SizedBox(height: 5),
              CustomTextArea(
                  controller: _content,
                  hint: " ",
                  funValidator: validateContent()),
              snapshot.data.images[0].imagefile == " " &&
                      snapshot.data.images.length == 1
                  ? Center(child: Text("이미지를 등록해주세요"))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200.0,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  scrollDirection: Axis.horizontal,
                                  controller: this.controller,
                                  itemCount: diaryImage[0] == ""
                                      ? 0
                                      : this.diaryImage.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    diaryImage[index].imagefile == ""
                                        ? data = null
                                        : data = Uri.parse(
                                                diaryImage[index].imagefile!)
                                            .data!;
                                    data == null
                                        ? bytes = null
                                        : bytes = data!.contentAsBytes();
                                    return Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            width: 200.0,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              clipBehavior: Clip.antiAlias,
                                              borderOnForeground: false,
                                              child: bytes == null
                                                  ? null
                                                  : Image.memory(bytes!,
                                                      fit: BoxFit.cover),
                                              // Image.file(
                                              //   updateImage[index], fit: BoxFit.cover),
                                            ),
                                            padding: EdgeInsets.all(10.0),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                //diaryImage.removeWhere((element) =>  element.image_id == diaryImage[index].image_id);
                                                if (!(bytes == null)) {
                                                  diaryImage.remove(
                                                      diaryImage[index]);
                                                  if (diaryImage.length >= 2) {
                                                    nextIconView = true;
                                                    return;
                                                  }
                                                  nextIconView = false;
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                margin: EdgeInsets.all(5.0),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0)),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.close,
                                                  size: 20.0,
                                                  color: Colors.white,
                                                ))),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            !this.nextIconView
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
                          ],
                        )
                      ])),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      color:
                          diaryImage.length >= 3 ? Colors.white : Colors.grey,
                      icon: diaryImage.length >= 3
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.xmark,
                                color: Theme.of(context).colorScheme.primary,
                              ))
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.camera,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      onPressed: diaryImage.length >= 3
                          ? () => print("이미지 초과")
                          : () async {
                              bool? check = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                "카메라 또는 갤러리를 통해 업로드할 수 있습니다"),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: Text("촬영"),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                              ),
                                              ElevatedButton(
                                                child: Text("앨범"),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                              ),
                                              ElevatedButton(
                                                child: Text("취소"),
                                                onPressed: () async =>
                                                    Navigator.of(context)
                                                        .pop(null),
                                              ),
                                            ],
                                          )) ??
                                  null;
                              if (check == null) return;
                              if (check) {
                                final pickcamera = await _picker.pickImage(
                                    source: ImageSource.camera);
                                final cfile = File(pickcamera!.path.toString());
                                final stringcfile =
                                    base64Encode(cfile.readAsBytesSync());
                                updateImage.add(cfile);
                                inputImage =
                                    "data:image/png;base64,${stringcfile}";
                                updateImagebase64.add(inputImage);
                                dioUpdateImage.dioInputImage(inputImage);
                              } else {
                                final pickgallery = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                final gfile =
                                    File(pickgallery!.path.toString());
                                final stringgfile =
                                    base64Encode(gfile.readAsBytesSync());
                                updateImage.add(gfile);
                                inputImage =
                                    "data:image/png;base64,${stringgfile}";
                                updateImagebase64.add(inputImage);
                                dioUpdateImage.dioInputImage(inputImage);
                              }
                              if (updateImage.length >= 2) {
                                nextIconView = true;
                                return;
                              }
                              nextIconView = false;
                              return setState(() {});
                            },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CustomElavatedButton(
                      text: "수정하기",
                      funPageRoute: () async {
                        _title.text == null
                            ? _selectedTitle = snapshot.data.title
                            : _selectedTitle = _title.text;
                        _selectedWeather == null
                            ? _selectedWeather = snapshot.data.weather
                            : _selectedWeather;
                        _content.text == null
                            ? _selectedContent = snapshot.data.content
                            : _selectedContent = _content.text;
                        _date.text == null
                            ? _selectedDate = DateFormat('yyyy-MM-dd')
                                .format(snapshot.data!.traveldate)
                            : _selectedDate = _date.text;
                        _travel.text == null
                            ? _selectedTravel = snapshot.data.travel
                            : _selectedTravel = _travel.text;
                        if (_formKey.currentState!.validate()) {
                          await diaryUpdateProvider.update(
                              id,
                              _selectedTitle,
                              _selectedDate,
                              _selectedContent,
                              _selectedWeather,
                              _selectedTravel);
                          Get.off(() => DiaryListPage(travelId));
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void viewImage() {}

  void iconView() {
    if (controller!.offset >= controller!.position.maxScrollExtent) {
      nextIconView = false;
    } else {
      nextIconView = true;
    }
    return;
  }
}
