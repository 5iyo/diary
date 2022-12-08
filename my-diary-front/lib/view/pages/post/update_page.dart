import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import '../../../controller/provider/diary_image_delete_provider.dart';
import '../../../controller/provider/diary_image_input_provider.dart';
import '../../../controller/provider/diary_image_provider.dart';
import '../../../controller/provider/diary_provider.dart';
import '../../../controller/provider/diary_update_provider.dart';
import '../../../controller/dto/DiaryResp.dart';
import '../../components/custom_date_picker.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/custom_textarea.dart';
import 'diary_list_page.dart';

class UpdatePage extends StatefulWidget {
  final int id;
  final int travelId;

  const UpdatePage(this.id, this.travelId, {super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState(id, travelId);
}

class _UpdatePageState extends State<UpdatePage> {
  DiaryProvider diaryProvider = DiaryProvider();
  DiaryImageProvider diaryImageProvider = DiaryImageProvider();
  DiaryUpdateProvider diaryUpdateProvider = DiaryUpdateProvider();
  DiaryImageDeleteProvider diaryImageDeleteProvider =
      DiaryImageDeleteProvider();
  DiaryImageInputProvider diaryImageInputProvider = DiaryImageInputProvider();

  final int id;
  final int travelId;

  _UpdatePageState(this.id, this.travelId);

  @override
  void didChangeDependencies() async {
    print("update page didChange");
    super.didChangeDependencies();
    DiaryProvider diaryProvider =
        Provider.of<DiaryProvider>(context, listen: false);
    setState(() {
      isAwait = true;
    });
    await diaryProvider.getdiary(id);
    diaryImageProvider =
        Provider.of<DiaryImageProvider>(context, listen: false);
    await diaryImageProvider.getdiaryImage(id);
    setState(() {
      isAwait = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _content = TextEditingController();
  final _travel = TextEditingController();
  final _date = TextEditingController();

  final _valueList = ['맑음', '흐림', '약간 흐림', '비', '눈', '바람'];
  late String _selectedTitle;
  late String _selectedContent;
  late String _selectedTravel;
  var _selectedWeather;
  late String _selectedDate;

  Future<Diary>? updateResp;

  ScrollController controller = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool nextIconView = false;
  List<File> updateImage = [];
  List<String> diaryImage = [];

  bool isAwait = false;

  @override
  void initState() {
    print("update page init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("update page build");

    diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryImageDeleteProvider =
        Provider.of<DiaryImageDeleteProvider>(context, listen: false);
    diaryImageInputProvider =
        Provider.of<DiaryImageInputProvider>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          UiViewModel.buildBackgroundContainer(
              context: context,
              backgroundType: BackgroundType.write,
              child:
                  UiViewModel.buildSizedLayout(context, Consumer<DiaryProvider>(
                builder: (context, DiaryProvider value, child) {
                  _travel.text = value.diary.travel!;
                  _title.text = value.diary.title!;
                  _content.text = value.diary.content!;

                  return buildDiary(context, value);
                },
              ))),
          isAwait ? UiViewModel.buildProgressBar() : Container(),
        ]));
  }

  Widget buildDiary(context, value) {
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
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Expanded(
                      child: DropdownButton(
                    value: value.diary.weather,
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
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Expanded(
                    child: TextFormField(
                      controller: _travel,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                  controller: _title, hint: " ", funValidator: validateTitle()),
              const SizedBox(height: 10),
              CustomTextArea(
                  controller: _content,
                  hint: " ",
                  funValidator: validateContent()),
              Consumer<DiaryImageProvider>(
                  builder: (context, DiaryImageProvider value, child) {
                UriData? data;
                Uint8List? bytes;

                String inputImage;

                diaryImage.clear();
                if(value.diaryImage.images != null){
                  for (int i = 0; i < value.diaryImage.images!.length; i++) {
                    diaryImage.add(value.diaryImage.images![i].imagefile!);
                  }
                } else {
                  diaryImage.add("");
                }
                return Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Stack(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(10.0),
                                    scrollDirection: Axis.horizontal,
                                    controller: controller,
                                    itemCount: diaryImage[0] == "" &&
                                            diaryImage.length == 1
                                        ? 0
                                        : diaryImage.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      diaryImage[index] == ""
                                          ? data = null
                                          : data = Uri.parse(diaryImage[index])
                                              .data!;
                                      data == null
                                          ? bytes = null
                                          : bytes = data!.contentAsBytes();
                                      if (bytes != null) {
                                        return Stack(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Container(
                                                width: 200.0,
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  value.getdiaryImage(id);
                                                  if (!(bytes == null)) {
                                                    setState(() {
                                                      isAwait = true;
                                                    });
                                                    await diaryImageDeleteProvider
                                                        .diaryImageDelete(value
                                                            .diaryImage
                                                            .images![index]
                                                            .image_id!);
                                                    setState(() {
                                                      isAwait = false;
                                                    });
                                                    diaryImage.remove(
                                                        diaryImage[index]);
                                                  }
                                                  value.getdiaryImage(id);
                                                },
                                                child: Container(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    alignment: Alignment.center,
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
                                          ],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                              ),
                              !nextIconView
                                  ? Container()
                                  : Positioned(
                                      top: 100.0,
                                      right: 10.0,
                                      child: Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: const Icon(Icons.navigate_next),
                                      ),
                                    )
                            ],
                          )
                        ])),
                    IconButton(
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
                                        title: const Text(
                                            "카메라 또는 갤러리를 통해 업로드할 수 있습니다"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text("촬영"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
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
                                                Navigator.of(context).pop(null),
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
                                final cFile = File(pickCamera!.path.toString());
                                final stringCFile =
                                    base64Encode(cFile.readAsBytesSync());
                                updateImage.add(cFile);
                                inputImage =
                                    "data:image/png;base64,$stringCFile";
                                diaryImage.add(inputImage);
                                await diaryImageInputProvider.imageInput(
                                    id, inputImage);
                                await value.getdiaryImage(id);
                                setState(() {
                                  isAwait = false;
                                });
                              } else {
                                setState(() {
                                  isAwait = true;
                                });
                                final pickGallery = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                final gFile =
                                    File(pickGallery!.path.toString());
                                final stringGFile =
                                    base64Encode(gFile.readAsBytesSync());
                                updateImage.add(gFile);
                                inputImage =
                                    "data:image/png;base64,$stringGFile";
                                diaryImage.add(inputImage);
                                await diaryImageInputProvider.imageInput(
                                    id, inputImage);
                                await value.getdiaryImage(id);
                                setState(() {
                                  isAwait = false;
                                });
                              }
                              if (updateImage.length >= 2) {
                                nextIconView = true;
                                return;
                              }
                              nextIconView = false;
                              return setState(() {});
                            },
                    ),
                  ],
                );
              }),
              CustomElavatedButton(
                text: "수정하기",
                funPageRoute: () async {
                  _selectedTitle = _title.text;
                  _selectedWeather ?? (_selectedWeather = value.diary.weather);
                  _selectedContent = _content.text;
                  _selectedDate = _date.text;
                  _selectedTravel = _travel.text;
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isAwait = true;
                    });
                    await diaryUpdateProvider.update(
                        id,
                        _selectedTitle,
                        _selectedDate,
                        _selectedContent,
                        _selectedWeather,
                        _selectedTravel);
                    setState(() {
                      isAwait = false;
                    });
                    Get.off(() => DiaryListPage(travelId));
                  }
                },
              ),
            ],
          ),
        ));
  }

  void viewImage() {}

  void iconView() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      nextIconView = false;
    } else {
      nextIconView = true;
    }
    return;
  }
}
