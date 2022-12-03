import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary_front/controller/dio_travel_update.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';
import '../../../controller/dto/TravelListResp.dart';
import 'dart:async';

const get_host = "192.168.20.7:8080";
const host = "http://192.168.20.7:8080";


class TravelUpdatePage extends StatefulWidget {

  final int id;
  final String title;
  final String image;
  const TravelUpdatePage(this.id, this.title, this.image);

  @override
  State<TravelUpdatePage> createState() => _TravelUpdatePageState(id, title, image);
}

class _TravelUpdatePageState extends State<TravelUpdatePage> {

  final int id;
  final String title;
  final String image;
  _TravelUpdatePageState(this.id, this.title, this.image);

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _startdate = TextEditingController();
  final _enddate = TextEditingController();

  Future<TravelList>? travellist;
  List<File> updateImage = [];
  List<String> travelImage = [];
  List<String> base64 = [];
  final ImagePicker _picker = ImagePicker();
  ScrollController controller = ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildTravel()
      ),
    );
  }

  Widget buildTravel() {

    DioTravelUpdate dioTravelUpdate = DioTravelUpdate(id);
    String startinit = "여행 시작 날짜";
    String endinit = "여행 종료 날짜";
    _title.text = title;
    UriData data;
    Uint8List bytes;
    travelImage.add(image); //travelImage[0] = image

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Row(
            children: <Widget>[
              Expanded(child: CustomDatePicker(controller: _startdate, init: startinit, funValidator: validateDate())),
              Expanded(child: CustomDatePicker(controller: _enddate, init: endinit, funValidator: validateDate())),
            ],
          ),
          SizedBox(height: 10),
          CustomTextFormField(
              controller: _title,
              hint: " ",
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
                              child: travelImage[0] == ""
                                  ? Center(child: Text("이미지를 등록해주세요"))
                                  : ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  scrollDirection: Axis.horizontal,
                                  controller: this.controller,
                                  itemCount: 1,
                                  itemBuilder: (BuildContext context, int index) {
                                    data = Uri.parse(travelImage[0]).data!;
                                    bytes = data.contentAsBytes();
                                    return Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Container(
                                              width: 200.0,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(20.0)),
                                                clipBehavior: Clip.antiAlias,
                                                borderOnForeground: false,
                                                child: Image.memory(bytes, fit: BoxFit.cover),
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
                                                  travelImage[0] = "";
                                                });
                                              },
                                              child: Container(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  margin: EdgeInsets.all(5.0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius
                                                          .circular(30.0)
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                        Icons.close, size: 20.0,
                                                        color: Colors.white,)
                                                  )
                                              ),
                                            ),
                                          ),
                                        ]
                                    );
                                  }
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
                  color: travelImage[0] != ""
                      ? Colors.white
                      : Colors.grey,
                  icon: travelImage[0] != ""?
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
                  onPressed: travelImage[0] != ""
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

                    updateImage.add(gfile);
                    this.updateImage.isEmpty? null
                        : this.updateImage.forEach(
                            (e) => base64.add("data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                    base64.isEmpty ? base64 = travelImage : base64;
                    travelImage[0] = base64[base64.length-1];

                    return setState(() {});
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomElavatedButton(
                  text: "수정하기",
                  funPageRoute: () async {
                    if (_formKey.currentState!.validate()) {
                      dioTravelUpdate.dioTravelUpdate(_title.text, travelImage[0], _startdate.text, _enddate.text);
                      Get.off(()=>TravelListPage());
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

