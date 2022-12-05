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
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:async';
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

  @override
  void initState() {
    controller = new ScrollController()..addListener((){
      setState(() {
        this.iconView();
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    diaryWriteProvider = Provider.of<DiaryWriteProvider>(context, listen: false);

    String init = "여행 날짜";

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child: CustomDatePicker(controller: _date, init: init, funValidator: validateDate())),
                  Expanded(child: DropdownButton(
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
              SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                            children : <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  child: this.userImages.isEmpty
                                      ? Center(child: Text("이미지를 등록해주세요"))
                                      : ListView.builder(
                                      padding: EdgeInsets.all(10.0),
                                      scrollDirection: Axis.horizontal,
                                      controller: this.controller,
                                      itemCount: this.userImages.length,
                                      itemBuilder: (BuildContext context, int index) => Stack(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  userBestImageIndex = index;
                                                });
                                              },
                                              child: Container(
                                                width: 200.0,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                  clipBehavior: Clip.antiAlias,
                                                  borderOnForeground: false,
                                                  child: Image.file(
                                                      this.userImages[index], fit: BoxFit.cover
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(10.0),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    userImages.remove(userImages[index]);
                                                    iconCountCheck();
                                                  });
                                                },
                                                child: Container(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    margin: EdgeInsets.all(5.0),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(30.0)
                                                    ),
                                                    child: Center(
                                                        child: Icon(Icons.close,size: 20.0,color: Colors.white,)
                                                    )
                                                ),
                                              ),
                                            ),
                                          ]
                                      )
                                  )
                              ),
                              !this.nextIconView ? Container()
                                  : Positioned(
                                top: 100.0,
                                right: 10.0,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  child: Icon(Icons.navigate_next),
                                ),
                              )
                            ]
                        ),
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
                      color: this.userImages.length >= 3
                          ? Colors.white
                          : Colors.grey,
                      icon: this.userImages.length >=3 ?
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: Theme.of(context).colorScheme.primary,
                          ))
                          : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
                          child: Icon(
                            CupertinoIcons.camera,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      onPressed: this.userImages.length >= 3
                          ? () => print("이미지 초과")
                          : () async{
                        bool? check = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("카메라 또는 갤러리를 통해 업로드할 수 있습니다"),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text("촬영"),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                                ElevatedButton(
                                  child: Text("앨범"),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                ElevatedButton(
                                  child: Text("취소"),
                                  onPressed: () async => Navigator.of(context).pop(null),
                                ),
                              ],
                            )
                        ) ?? null;
                        if(check == null) return;
                        if(check){
                          final pickcamera = await _picker.pickImage(source: ImageSource.camera);
                          final cfile = File(pickcamera!.path.toString());
                          userImages.add(cfile);
                        }
                        else{
                          final pickgallery = await _picker.pickImage(source: ImageSource.gallery);
                          final gfile = File(pickgallery!.path.toString());
                          userImages.add(gfile);
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
                        this.userImages.isEmpty? null
                            : this.userImages.forEach(
                                (e) => base64List.add("data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                        base64List.isEmpty ? base64List = [""] : base64List;
                        _travel.text == null ? " " : _travel.text;
                        if (_formKey.currentState!.validate()) {
                          await diaryWriteProvider.save(id, _title.text, _date.text, _content.text, _selectedValue, _travel.text, base64List);
                          Get.off(()=>DiaryListPage(id));
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
    );
  }

  bool nextIconView = false;

  void iconCountCheck(){
    if(this.userImages.length >= 2){
      nextIconView = true;
      return;
    }
    nextIconView = false;
    return;
  }

  void iconView(){
    if(controller!.offset >= controller!.position.maxScrollExtent){
      nextIconView = false;
    }
    else{
      nextIconView = true;
    }
    return;
  }
}

