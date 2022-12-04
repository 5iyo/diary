import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary_front/controller/dio_travel.dart';
import 'package:my_diary_front/controller/dto/TravelResp.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';
import 'dart:async';

class TravelPage extends StatefulWidget {

  final String id;
  const TravelPage(this.id);

  @override
  State<TravelPage> createState() => _TravelPageState(id);
}

class _TravelPageState extends State<TravelPage> {

  final String id;
  _TravelPageState(this.id);

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  //final _area = TextEditingController();
  final _startdate = TextEditingController();
  final _enddate = TextEditingController();

  Future<TravelResp>? _travelresp;
  List<File> travelImage = [];
  List<String> base64 = [];
  final ImagePicker _picker = ImagePicker();
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (_travelresp == null) ? buildTravel() : buildFutureBuilder(),
      ),
    );
  }

  Widget buildTravel() {

    DioTravel dioTravel = DioTravel(id);
    String startinit = "여행 시작 날짜";
    String endinit = "여행 종료 날짜";

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Row(
            children: <Widget>[
              Expanded(child: CustomDatePicker(controller: _startdate, init: startinit, funValidator: validateDate())),
              Expanded(child: CustomDatePicker(controller: _enddate, init: endinit, funValidator: validateDate())),
              // Expanded(child: TextFormField(
              //     controller: _area,
              //     decoration: InputDecoration(
              //       hintText: "여행지",
              //     )
              // ),)
            ],
          ),
          SizedBox(height: 10),
          CustomTextFormField(
              controller: _title,
              hint: "Title",
              funValidator: validateTitle()
          ),
          SizedBox(height: 5),
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
                              child: this.travelImage.isEmpty
                                  ? Center(child: Text("이미지를 등록해주세요"))
                                  : ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  scrollDirection: Axis.horizontal,
                                  controller: this.controller,
                                  itemCount: this.travelImage.length,
                                  itemBuilder: (BuildContext context, int index) => Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            width: 200.0,
                                            child: Card(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                              clipBehavior: Clip.antiAlias,
                                              borderOnForeground: false,
                                              child: Image.file(
                                                  this.travelImage[index], fit: BoxFit.cover
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
                                                travelImage.remove(travelImage[index]);
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
                  color: this.travelImage.length >= 1
                      ? Colors.white
                      : Colors.grey,
                  icon: this.travelImage.length >= 1 ?
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
                  onPressed: this.travelImage.length >= 1
                      ? () => print("이미지 초과")
                      : () async{
                    bool? check = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("갤러리를 통해 업로드할 수 있습니다"),
                          actions: <Widget>[
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
                    final pickgallery = await _picker.pickImage(source: ImageSource.gallery);
                    final gfile = File(pickgallery!.path.toString());
                    travelImage.add(gfile);

                    return setState(() {});
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomElavatedButton(
                  text: "여행 만들기",
                  funPageRoute: () async {
                    this.travelImage.isEmpty? null
                        : this.travelImage.forEach(
                            (e) => base64.add("data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                    base64.isEmpty ? base64 = [""] : base64;
                    if (_formKey.currentState!.validate()) {
                      _travelresp = dioTravel.dioTravel(_title.text, " ", "35.8561", "129.224", base64[0], _startdate.text, _enddate.text);
                      Get.off(()=>TravelPage(id));
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  FutureBuilder<TravelResp> buildFutureBuilder() {
    return FutureBuilder<TravelResp>(
        future: _travelresp,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.id.toString());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}에러");
          }
          return const CircularProgressIndicator();
        }
    );
  }
}

